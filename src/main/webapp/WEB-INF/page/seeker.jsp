<%@ page language="java" import="java.util.*,com.qcq.wifi_monitor.entity.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
//
List<Info>infos=(List<Info>)request.getAttribute("infos");
List<Seeker> seekers =(List<Seeker>)request.getAttribute("seekers");
//每个seeker对应的信息，下标与 seekers 一一对应
List<List<Info>> listInfos=(List<List<Info>>)request.getAttribute("listInfos");
int seeker_id=(int)request.getAttribute("seeker_id");
%>


<!DOCTYPE HTML>
<html>
   <link rel="stylesheet" href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
    	<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
	<script src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=3.0&ak=4IU3oIAMpZhfWZsMu7xzqBBAf6vMHcoa"></script>
	<head>
	<title>main page</title>
		<style type="text/css">
    html,body{
    	margin:0;
    	padding:0;
    }
    #dituContent{
        margin-top:0;
    	float:left;
    }
    a{
	  text-decoration:none;
	}
	a:hover{
	  text-decoration:none;
	}
	#box{
	   width:100%;
	   height:87px;
	   background-color:#F8F8F8;
       cursor:pointer;
    }
    #strogle{
       position:absolute;
       z-index:1000;
       left:50px;
       top:100px;
    }
    #nowTimeShow{
       position:absolute;
       z-index:1000;
       left:150px;
       top:100px;
       width:100px;
       height:40px;
       background-color:gray;
       border-radius:5px;
       text-align:center;
       opacity:0.8;
    }
     #seekersearch{
         position:absolute;
         left:1250px;
         top:45px;
         width:350px;
         height:40px;
    }
    #SearchEnd{
         position:absolute;
         left:1250px;
         top:10px;
         width:200px;
         height:20px;
         border:0;
    }
    #macinfos{
        position:absolute;
        z-index:1000;
        left:85%;
        top:96px;
        width:13%;
        height:150px;
        opacity:0.6;
        border-radius:5px;
        background-color:black;
        display:none;
    }
    .nav{
         font-size:25px;    
		 margin-top:36px;
		 margin-left:0;
	 }
    </style>
	<script type="text/javascript">
		    function pathfly(mac){
	           var params = {};
			   params.mac = mac;
		     $.ajax({
			   			type:"post",
			   			url:"/pathCount",
			   			data:params,
			   			success:function(data){
			   			    var longth=data;
			   			    if(longth==0){
			   			        alert("该MAC无路径！");
			   			    }else{
			   			        window.location="/path"+"?mac="+mac; 
			   			    }         
			   			},
			   			error:function(){
			   				alert("error...");
			   			}
			   		});
		    }
		    function linkpathfly(mac){
		                var params = {};
				        params.mac = mac; 
		                $.ajax({
					   			type:"post",
					   			url:"/pathCount",
					   			data:params,
					   			success:function(data){
					   			    var longth=data;
					   			    if(longth==0){
					   			        alert("该MAC无路径！");
					   			    }else{
					   			        window.location="/linkPath?mac="+mac;
					   			    }         
					   			},
					   			error:function(){
					   				alert("error...");
					   			}
					   		});
		    }
		    function timefly(time) {
                var params = {};
                params.minute = time;
                $.ajax({
                    url: "/setMinute",
                    type: "Post",
                    data: params,
                    success: function (resp) {
                        location.reload();
                    },
                    error: function (jqXHR, textstatus) {
                        alert(textstatus);
                    }
                });
            }
            function therssi(id,rssi){
                var params = {};
                params.id = id;
                params.rssi = rssi;
                $.ajax({
                    url:"/seeker_count",
                    type:"Post",
                    data:params,
                    success:function(data){
                        var rssilength=data;
                        if(rssilength==0){
                            alert("该强度无信号！");
                        }else{
                            window.location="/seeker?id="+id+"&rssi="+rssi;
                        }
                    },
                    error:function(jqXHR,textstatus){
                        alert(textstatus);
                    }
                });
            }
	</script>
	</head>
	<body>
	<div id="box">
	<nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
    <div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="index?minute=6000">人群观测</a></li>
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown">
                                                            轨迹跟踪
                    <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                <%int m=0;
                  for(int i=0;i<seekers.size();i++){ 
                  if(m>=9) break;
                   for(int j=0;j<listInfos.get(i).size();j++){
                       m++;
                        if(m>=9) break;%>
                      <li> <a id="<%=listInfos.get(i).get(j).getMac() %>" onclick="pathfly(this.id)"><%=listInfos.get(i).get(j).getMac() %></a></li>
                 <% } }%>
                </ul>
            </li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                                               折线路径
                    <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    <%int c=0;
                      for(int i=0;i<seekers.size();i++){ 
                          if(c>=9) break;
                          for(int j=0;j<listInfos.get(i).size();j++){
                                c++;
                                if(c>=9) break;%>
                      <li><a id="<%=listInfos.get(i).get(j).getMac() %>" onclick="linkpathfly(this.id)"><%=listInfos.get(i).get(j).getMac() %></a></li>
                   <% } }%>
                </ul>
            </li>
            <li class="dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown">
                                                                时间选取
                    <b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    <li><a onclick="timefly(5)" >最近五分钟</a></li>
                    <li><a onclick="timefly(60)" >最近一小时</a></li>
                    <li><a onclick="timefly(1440)" >最近一天</a></li>
                    <li><a onclick="timefly(4320)" >最近三天</a></li>
                    <li><a onclick="timefly(525600)" >所有</a></li>
                </ul>
            </li>
        </ul>
    </div>
    </div>
   </nav>
  </div>
  <div id="strogle">	
  <div class="dropdown">
		   <button type="button" class="btn dropdown-toggle" id="dropdownMenu1" 
					data-toggle="dropdown">
				       信号强度
				<span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
				<li role="presentation">
					<a role="menuitem" tabindex="-1" onclick="therssi('<%=seeker_id%>',-14)">14</a>
				</li>
				<li role="presentation">
					<a role="menuitem" tabindex="-1" onclick="therssi('<%=seeker_id%>',-43)">43</a>
				</li>
                <li role="presentation">
                    <a role="menuitem" tabindex="-1" onclick="therssi('<%=seeker_id%>',-72)">72</a>
				</li>
				<li role="presentation">
					<a role="menuitem" tabindex="-1" onclick="therssi('<%=seeker_id%>',-101)">101</a>
				</li>
				<li role="presentation">
					<a role="menuitem" tabindex="-1" onclick="therssi('<%=seeker_id%>',-130)">130</a>
				</li>
			</ul>
		</div>
		</div>
		 <div id="nowTimeShow">
     		 <h4 id="nowtime" style="margin-top:10%;color:white;"></h4>
		  </div>
		  <script type="text/javascript">
		      function time(){
			       $.ajax({
			            url:"/getMinute",
			            type:"Post",
			            async:false,
			            data:{},
			            success:function(data){
			                    var nowTime=data;
			                    var now=document.getElementById("nowtime");
			                    if(nowTime==5){
			                          now.innerHTML="最近五分钟";          
			                    }else if(nowTime==60){
			                          now.innerHTML="最近一小时";
			                    }else if(nowTime==1440){
			                          now.innerHTML="最近一天";
			                    }else if(nowTime==4320){
			                          now.innerHTML="最近三天";
			                    }else if(nowTime==525600){
			                          now.innerHTML="所有";
			                    }
				            },
			            error:function(jqXHR,textstatus){
			                alert(textstatus);
			            }
			        });
		    }
		    time();
		  </script>
		<div id="SearchEnd">
		     <h4 id="searchend" style="margin-left:15px;color:red;"></h4>
		</div>
		<div id="seekersearch">
		   <div class="input-group col-md-6" >  
               <input type="text" class="form-control" style="width:150px;"id="search" placeholder="请输入mac名" / >  
               <input type="hidden" id="seekerid" value="<%=seeker_id%>">
		       <span class="input-group-btn">  
		             <button class="btn btn-info btn-search" onclick="searchmac()">搜索mac</button>  
		             <button class="btn btn-info btn-search" style="margin-left:3px" onclick="createMap()">显示所有mac</button>  
		       </span>  
		   </div> 
		</div>
		 <div id="macinfos">
		        <h4 id="infomac" style="margin-left:20%;margin-top:15%;color:white;"></h4>
		        <h4 id="inforssi" style="margin-left:20%;color:white;"></h4>
		        <h4 id="infomacid" style="margin-left:20%;color:white;"></h4>
		 </div>
	<div style="width:1608px;height:775px;border:gray solid 0px;" id="dituContent"></div> 
</body>
<script type="text/javascript">
	function getJsonLength(jsonData){  
		    var jsonLength = 0;  
		    for(var item in jsonData){    
		        jsonLength++;    
		    }  	  
		    return jsonLength;  
	}  
    function searchmac(){
             var params = {};
             var mac = document.getElementById("search").value;
             var seekerid = document.getElementById("seekerid").value;
             params.mac=mac;
             params.seeker_id=seekerid;
                $.ajax({
                    url:"/getLocationAndRssi",
                    type:"Post",
                    data:params,
                    success:function(data){
                        var rssidata={};
                        rssidata=data;
                        if(getJsonLength(rssidata)==0){
                            document.getElementById("searchend").innerHTML="该mac无信号！"
                        }else{
                            createMap_search(rssidata.x,rssidata.y,rssidata.rssi,mac,seekerid);
                        }
                    },
                    error:function(jqXHR,textstatus){
                        alert(textstatus);
                    }
                });
            }
</script>
<script type="text/javascript">
    //创建和初始化地图函数：
    function initMap(){
        createMap();//创建地图
        setMapEvent();//设置地图事件
        addMapControl();//向地图添加控件
    }
    
    //创建地图函数：
    function createMap(){
        var mp = new BMap.Map("dituContent");//在百度地图容器中创建一个地图
        <%for(int i=0;i<seekers.size();++i) {%>
        <%if(seekers.get(i).getId()==seeker_id){%>
        var point = new BMap.Point(<%=seekers.get(i).getX()%>,<%=seekers.get(i).getY()%>);//定义一个中心点坐标
        <%}}%>
        mp.centerAndZoom(point,18);//设定地图的中心点和坐标并将地图显示在地图容器中
        mp.enableScrollWheelZoom();
        function ComplexCustomOverlay(point){
          this._point = point;
          
        }
    　　 // 继承API的BMap.Overlay  
        ComplexCustomOverlay.prototype = new BMap.Overlay();
        //初始化自定义覆盖物
        // 实现初始化方法  
        ComplexCustomOverlay.prototype.initialize = function(map){
          // 保存map对象实例 
          this._map = map;
          // 创建div元素，作为自定义覆盖物的容器  
          var div = this._div = document.createElement("div");
          div.style.position = "absolute";
          div.style.zIndex = BMap.Overlay.getZIndex(this._point.lat);//聚合功能?
          // 可以根据参数设置元素外观
          div.style.height = "8px";
          div.style.width="8px";
          var arrow = this._arrow = document.createElement("img");
          arrow.src = "http://www.yantiansf.cn/mapImage/1.gif";
          arrow.style.width = "8px";
          arrow.style.height = "8px";
          arrow.style.top = "5px";
          arrow.style.left = "10px";
          div.appendChild(arrow);
         
    　                    // 将div添加到覆盖物容器中  
          mp.getPanes().labelPane.appendChild(div);//getPanes(),返回值:MapPane,返回地图覆盖物容器列表  labelPane呢???
          // 需要将div元素作为方法的返回值，当调用该覆盖物的show、  
          // hide方法，或者对覆盖物进行移除时，API都将操作此元素。
          return div;
          
        }
        
        //绘制覆盖物
        // 实现绘制方法
        ComplexCustomOverlay.prototype.draw = function(){
          var map = this._map;
          var pixel = map.pointToOverlayPixel(this._point);
          this._div.style.left = pixel.x - parseInt(this._arrow.style.left) + "px";
          this._div.style.top  = pixel.y - 30 + "px";
        }
       
            
       
        //自定义覆盖物添加事件方法
        ComplexCustomOverlay.prototype.addEventListener = function(event,fun){
            this._div['on'+event] = fun;
        }
         <%for(int i=0;i<seekers.size();++i) {%>
         <%if(seekers.get(i).getId()==seeker_id){%>
        <% double X = seekers.get(i).getX(); %>
        <% double Y = seekers.get(i).getY(); %>
        <% int ID = seekers.get(i).getId(); %>
        var point=new BMap.Point(<%=X%>,<%=Y%>)
        var start = new BMap.Marker(point);
        var opts = {
	      width : 40,     // 信息窗口宽度
	      height: 100,     // 信息窗口高度
	      title : " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;探针ID:<%=seekers.get(i).getId()%>  " , // 信息窗口标题     
	    }
	    var infoWindow = new BMap.InfoWindow("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前:<%=infos.size()%>个信号 <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经度:<%=X%><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;纬度:<%=Y%>", opts);  // 创建信息窗口对象 
	    setmouse(start,infoWindow);
        mp.addOverlay(start);
        var circle = new BMap.Circle(point,250,{strokeColor:"blue", strokeWeight:2, strokeOpacity:0.5});
        mp.addOverlay(circle);
        <%for(int j=0;j<infos.size();j++){%>
          var angle=Math.random()*360;
          var myCompOverlay = new ComplexCustomOverlay(new BMap.Point(<%=X%>-0.000017*<%=infos.get(j).getRssi()%>*Math.cos(angle),<%=Y%>-0.000017*<%=infos.get(j).getRssi()%>*Math.sin(angle)));
          mp.addOverlay(myCompOverlay);
          myCompOverlay.addEventListener("click", function(){
             pathfly('<%=infos.get(j).getMac()%>');
          })   
          myCompOverlay.addEventListener("mouseover", function(e){
                document.getElementById("infomac").innerHTML="mac:<%=infos.get(j).getMac()%>";
                document.getElementById("inforssi").innerHTML="信号强度:<%=infos.get(j).getRssi()%>";
                document.getElementById("infomacid").innerHTML="seekerID:<%=seeker_id%>";
                document.getElementById("macinfos").style.display="block";
          }) 
          myCompOverlay.addEventListener("mouseout", function(e){
               document.getElementById("macinfos").style.display="none";
          })  
        <%}%>
	    window.map = mp;
	   <%}}%>
	    function setmouse(marcks,infoWindow){
	      marcks.addEventListener("mouseover", function(e){          
	          openInfo(infoWindow,e);
	      });
	      marcks.addEventListener("mouseout", function(e){          
	          closeInfo(infoWindow,e);
	      });
	    }
	    function openInfo(content,e){
		var p = e.target;
		var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
		mp.openInfoWindow(content,point); //开启信息窗口
		window.map=mp;
	   }
	   function closeInfo(content,e){
		var p = e.target;
		var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
		mp.closeInfoWindow(content,point); //关闭信息窗口
		window.map=mp;
	   }
	 }
	 //创建search地图函数：
    function createMap_search(X,Y,rssi,mac,seekerid){
        var mp = new BMap.Map("dituContent");//在百度地图容器中创建一个地图
        var point = new BMap.Point(X,Y);//定义一个中心点坐标
        mp.centerAndZoom(point,18);//设定地图的中心点和坐标并将地图显示在地图容器中
        mp.enableScrollWheelZoom();
        function ComplexCustomOverlay(point){
          this._point = point;
          
        }
    　　 // 继承API的BMap.Overlay  
        ComplexCustomOverlay.prototype = new BMap.Overlay();
        //初始化自定义覆盖物
        // 实现初始化方法  
        ComplexCustomOverlay.prototype.initialize = function(map){
          // 保存map对象实例 
          this._map = map;
          // 创建div元素，作为自定义覆盖物的容器  
          var div = this._div = document.createElement("div");
          div.style.position = "absolute";
          div.style.zIndex = BMap.Overlay.getZIndex(this._point.lat);//聚合功能?
          // 可以根据参数设置元素外观
          div.style.height = "8px";
          div.style.width="8px";
          var arrow = this._arrow = document.createElement("img");
          arrow.src = "http://www.yantiansf.cn/mapImage/1.gif";
          arrow.style.width = "8px";
          arrow.style.height = "8px";
          arrow.style.top = "5px";
          arrow.style.left = "10px";
          div.appendChild(arrow);
         
    　                    // 将div添加到覆盖物容器中  
          mp.getPanes().labelPane.appendChild(div);//getPanes(),返回值:MapPane,返回地图覆盖物容器列表  labelPane呢???
          // 需要将div元素作为方法的返回值，当调用该覆盖物的show、  
          // hide方法，或者对覆盖物进行移除时，API都将操作此元素。
          return div;
          
        }
        
        //绘制覆盖物
        // 实现绘制方法
        ComplexCustomOverlay.prototype.draw = function(){
          var map = this._map;
          var pixel = map.pointToOverlayPixel(this._point);
          this._div.style.left = pixel.x - parseInt(this._arrow.style.left) + "px";
          this._div.style.top  = pixel.y - 30 + "px";
        }
       
            
       
        //自定义覆盖物添加事件方法
        ComplexCustomOverlay.prototype.addEventListener = function(event,fun){
            this._div['on'+event] = fun;
        }
        var point=new BMap.Point(X,Y)
        var start = new BMap.Marker(point);
        var opts = {
	      width : 40,     // 信息窗口宽度
	      height: 100,     // 信息窗口高度
	      title : " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;探针ID:"+seekerid , // 信息窗口标题     
	    }
	    var infoWindow = new BMap.InfoWindow("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前:1个信号 <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经度:"+X+"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;纬度:"+Y, opts);  // 创建信息窗口对象 
	    setmouse(start,infoWindow);
        mp.addOverlay(start);
        var circle = new BMap.Circle(point,250,{strokeColor:"blue", strokeWeight:2, strokeOpacity:0.5});
        mp.addOverlay(circle);
        var angle=Math.random()*360;
        var myCompOverlay = new ComplexCustomOverlay(new BMap.Point(X-0.000017*rssi*Math.cos(angle),Y-0.000017*rssi*Math.sin(angle)));
        mp.addOverlay(myCompOverlay);
          myCompOverlay.addEventListener("click", function(){
             pathfly(mac);
          })   
          myCompOverlay.addEventListener("mouseover", function(e){
                document.getElementById("infomac").innerHTML="mac:"+mac;
                document.getElementById("inforssi").innerHTML="信号强度:"+rssi;
                document.getElementById("infomacid").innerHTML="seekerID:"+seekerid;
                document.getElementById("macinfos").style.display="block";
          }) 
          myCompOverlay.addEventListener("mouseout", function(e){
               document.getElementById("macinfos").style.display="none";
          })  
	    window.map = mp;
	    function setmouse(marcks,infoWindow){
	      marcks.addEventListener("mouseover", function(e){          
	          openInfo(infoWindow,e);
	      });
	      marcks.addEventListener("mouseout", function(e){          
	          closeInfo(infoWindow,e);
	      });
	    }
	    function openInfo(content,e){
		var p = e.target;
		var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
		mp.openInfoWindow(content,point); //开启信息窗口
		window.map=mp;
	   }
	   function closeInfo(content,e){
		var p = e.target;
		var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
		mp.closeInfoWindow(content,point); //关闭信息窗口
		window.map=mp;
	   }
	 }
	
    //地图事件设置函数：
    function setMapEvent(){
        map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
        map.enableScrollWheelZoom();//启用地图滚轮放大缩小
        map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
        map.enableKeyboard();//启用键盘上下左右键移动地图
    }
    
    //地图控件添加函数：
    function addMapControl(){
        //向地图中添加缩放控件
    var ctrl_nav = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_ZOOM});
    map.addControl(ctrl_nav);
        //向地图中添加缩略图控件
    var ctrl_ove = new BMap.OverviewMapControl({anchor:BMAP_ANCHOR_BOTTOM_RIGHT,isOpen:1});
    map.addControl(ctrl_ove);
        //向地图中添加比例尺控件
    var ctrl_sca = new BMap.ScaleControl({anchor:BMAP_ANCHOR_BOTTOM_LEFT});
    map.addControl(ctrl_sca);
    }
    
    initMap();//创建和初始化地图
</script>
</html>