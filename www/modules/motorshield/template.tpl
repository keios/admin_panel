<script>
	$(function() {
		$( "#accordion" ).accordion({ fillSpace: false, autoHeight: false, navigation: false, create: function( event, ui ) {init{module_name}();} });
	});

	var voltage_timer;

	function init{module_name}(){
		if (voltage_timer) clearTimeout(voltage_timer);
		voltage_timer = setTimeout("update_voltage()", 100);
	}


	function update_voltage() {
		$.get("modules/{module_name}/updatevoltage.php?" + Math.random(), function(response, status, xhr) {
			if (status == "success") {
				if (response)
					$("#voltage").html(response + "V");
			}
			if (voltage_timer) clearTimeout(voltage_timer);
			voltage_timer = setTimeout("update_voltage()", 3000);
		});
	}

</script>

<script>

	$(".contype1").click(function(){
		var con = $(this).attr("con");
		var num = $(this).attr("num");
		var text = "Мотор J" + con + " " + num;
		$("#action").html(text);
	});

	$(".contype1").mouseover(function(){
		var con = $(this).attr("con");
		var num = $(this).attr("num");
		var text = "Мотор J" + con + " " + num;
		$("#action").html(text);
	});

	$(".contype1").mouseout(function(){
		//$("#action").html("");
	});


	/* servos group*/

	$(".contype17").click(function(){
		var con = $(this).attr("con");
		var num = $(this).attr("num");

		if ($(this).hasClass("whiteback")) {
			$(this).removeClass("whiteback");
		} else {
			$(this).addClass("whiteback");
		}

		var result = "";

		$(".contype17").each(function(i, elem) {

			if ($(this).hasClass("whiteback")) {

        			result += $(elem).attr("num") + " ";
			}
			if (result) {
				$("#servos").css("display", "block");
				$("#servolist").html(result);
			} else {
				$("#servos").css("display", "none");
			}
		});

	});

	$(".servosliders" ).each(function() {
		$(this).empty().slider({
			value: 90,
			min: 0,
			max: 180,
			animate: true,
			orientation: "horizontal"
		});
		var num = $(this).attr("num");
		$(this).attr("id", "servoslider" + num);
	});

	$(".servosliders").on("slidestop", function( event, ui ) {
		var num = parseInt($(this).attr("num"));
		$("#j17_" + num).removeClass("whiteback");
		var position = $(this).slider("option", "value");
		set_servo(num, position);
	});

	$(".servosliders").on("slide", function( event, ui ) {
		var num = parseInt($(this).attr("num"));
		$("#j17_" + num).addClass("whiteback");
	});

	function set_servo(num, position) {
		var minval = $("#servomin").val();
		var maxval = $("#servomax").val();
		$.post("modules/{module_name}/set.php?" + Math.random(), {action: 1, num: num, pos: position, minval: minval, maxval: maxval}, function(response, status, xhr) {
		});
	}


	/* unipolar group*/

	$(".unipolarslider" ).each(function() {
		$(this).empty().slider({
			value: 0,
			min: 0,
			max: 4095,
			animate: true,
			orientation: "horizontal"
		});
		var num = $(this).attr("num");
		$(this).attr("id", "servoslider" + num);
	});

	$(".unipolarslider").on("slidestop", function( event, ui ) {
		var num = parseInt($(this).attr("num"));
		$("#j16_" + num).removeClass("whiteback");
		var position = $(this).slider("option", "value");
		set_unimotor(num, position);
	});

	$(".unipolarslider").on("slide", function( event, ui ) {
		var num = parseInt($(this).attr("num"));
		$("#j16_" + num).addClass("whiteback");
	});

	function set_unimotor (num, position) {
		$.post("modules/{module_name}/set.php?" + Math.random(), {action: 2, num: num, pos: position}, function(response, status, xhr) {
		});
	}


	/* bipolar group*/

	$(".bipolarslider" ).each(function() {
		$(this).empty().slider({
			value: 0,
			min: 0,
			max: 4095,
			animate: true,
			orientation: "horizontal"
		});
		var num = $(this).attr("num");
		$(this).attr("id", "bipolarslider" + num);
	});

	$(".bipolarslider").on("slidestop", function( event, ui ) {
		var num = parseInt($(this).attr("num"));
		$("#j1_" + num).removeClass("whiteback");
		var position = $(this).slider("option", "value");
		set_bimotor(num, position);
	});

	$(".bipolarslider").on("slide", function( event, ui ) {
		var num = parseInt($(this).attr("num"));
		$("#j1_" + num).addClass("whiteback");
	});

	function set_bimotor (num, position) {
		var period = $("#pwm_period").val();
		$.post("modules/{module_name}/setbipolar.php?" + Math.random(), {action: 2, num: num, value: position, period: period}, function(response, status, xhr) {
		});
	}

	$(".directions > a").click(function(){
		var num = $(this).attr("num");
		var pin = $(this).attr("pin");
		var value = 0;

		if ($(this).hasClass("active")) {
			$(this).removeClass("active");
			value = 0;
		}
		else {
			$(this).addClass("active");
			value = 1;
		}

		$.post("modules/{module_name}/setbipolar.php?" + Math.random(), {action: 1, num: num, pin: pin, value: value}, function(response, status, xhr) {
		});

		return false;
	});



	/* common for motorshield settings */

	function set_freq(freq) {
		var divider = Math.round(25000000 / (4096 * freq)) -1;
		$("#divider").val(divider);
		set_divider(divider);
	}

	function set_divider(divider) {
		divider = parseInt(divider); 
		var freq = parseInt(25000000 / (divider + 1) / 4096);
		$("#freq").val(freq);
		$.post("modules/{module_name}/setdivider.php?" + Math.random(), {divider: divider}, function(response, status, xhr) {
		});
	}

	function set_addr(addr) {
		$.post("modules/{module_name}/setaddr.php?" + Math.random(), {addr: addr}, function(response, status, xhr) {
		});
	}

	function set_init() {
		$.post("modules/{module_name}/setinit.php?" + Math.random(), null, function(response, status, xhr) {
		});
	}

	function set_servo_min(value) {
		$.post("modules/{module_name}/setservolimits.php?" + Math.random(), {action: 1, value: value}, function(response, status, xhr) {
		});
	}

	function set_servo_max(value) {
		$.post("modules/{module_name}/setservolimits.php?" + Math.random(), {action: 2, value: value}, function(response, status, xhr) {
		});
	}



</script>


<style>

.contype1 { position: absolute; width: 10px; height: 30px; }
.contype1:hover { border: 2px solid #ffffff; }

.contype2 { position: absolute; width: 85px; height: 11px; }
.contype2:hover { border: 2px solid #ffffff; }

.contype3 { position: absolute; width: 46px; height: 11px; }
.contype3:hover { border: 2px solid #ffffff; }

.contype4 { position: absolute; width: 27px; height: 11px; }
.contype4:hover { border: 2px solid #ffffff; }

.contype6 { position: absolute; width: 10px; height: 45px; }
.contype6:hover { border: 2px solid #ffffff; }

.contype7 { position: absolute; width: 10px; height: 45px; }
.contype7:hover { border: 2px solid #ffffff; }

.contype8 { position: absolute; width: 10px; height: 45px; }
.contype8:hover { border: 2px solid #ffffff; }

.contype9 { position: absolute; width: 10px; height: 45px; }
.contype9:hover { border: 2px solid #ffffff; }

.contype10 { position: absolute; width: 10px; height: 45px; }
.contype10:hover { border: 2px solid #ffffff; }

.contype11 { position: absolute; width: 10px; height: 45px; }
.contype11:hover { border: 2px solid #ffffff; }

.contype12 { position: absolute; width: 10px; height: 45px; }
.contype12:hover { border: 2px solid #ffffff; }

.contype13 { position: absolute; width: 10px; height: 45px; }
.contype13:hover { border: 2px solid #ffffff; }

.contype14 { position: absolute; width: 10px; height: 45px; }
.contype14:hover { border: 2px solid #ffffff; }

.contype15 { position: absolute; width: 10px; height: 45px; }
.contype15:hover { border: 2px solid #ffffff; }

.contype16 { position: absolute; width: 10px; height: 30px; }
.contype16:hover { border: 2px solid #ffffff; }

.contype17 { position: absolute; width: 10px; height: 47px; }
.contype17:hover { border: 2px solid #ffffff; }
.servosliders { width: 200px; }

#voltage { position: absolute; width: 50px; color: #ff0000; font-size: 1.4em; }

.whiteback { border: 2px solid #ffffff; }

.directions a {
  text-decoration: none;
  color: #7c7c7c;
}

.directions a.active{
  color: #ffffff;
}

.directions {
  line-height: 11px;
}


</style>

<div id="accordion" style="margin:0; padding:0;">

	<h3><a href="#">Макет платы</a></h3>
	<div>

		<div style="clear: right; float: left; margin-right: 50px; width: 200px;">
			<div><span class="bluetitle">Двуполярные выходы</span></div>
			<p><div class="bipolarslider" num=8></div></p>
			<p><div class="bipolarslider" num=7></div></p>
			<p><div class="bipolarslider" num=6></div></p>
			<p><div class="bipolarslider" num=5></div></p>
			<p><div class="bipolarslider" num=4></div></p>
			<p><div class="bipolarslider" num=3></div></p>
			<p><div class="bipolarslider" num=2></div></p>
			<p><div class="bipolarslider" num=1></div></p>
		</div>
		<div style="clear: right; float: left; margin-right: 50px; width: 100px;">
			<div><span class="bluetitle">Направление</span></div>
			<p class="directions"> <a href="#" id="dir8_1" num="8" pin="1" title="пин направления 1 для мотора 8">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir8_1" num="8" pin="2" title="пин направления 2 для мотора 8">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir7_1" num="7" pin="1" title="пин направления 1 для мотора 7">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir7_1" num="7" pin="2" title="пин направления 2 для мотора 7">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir6_1" num="6" pin="1" title="пин направления 1 для мотора 6">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir6_1" num="6" pin="2" title="пин направления 2 для мотора 6">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir5_1" num="5" pin="1" title="пин направления 1 для мотора 5">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir5_1" num="5" pin="2" title="пин направления 2 для мотора 5">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir4_1" num="4" pin="1" title="пин направления 1 для мотора 4">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir4_1" num="4" pin="2" title="пин направления 2 для мотора 4">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir3_1" num="3" pin="1" title="пин направления 1 для мотора 3">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir3_1" num="3" pin="2" title="пин направления 2 для мотора 3">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir2_1" num="2" pin="1" title="пин направления 1 для мотора 2">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir2_1" num="2" pin="2" title="пин направления 2 для мотора 2"">пин 2</a> </p>
			<p class="directions"> <a href="#" id="dir1_1" num="1" pin="1" title="пин направления 1 для мотора 1">пин 1</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="#" id="dir1_1" num="1" pin="2" title="пин направления 2 для мотора 1">пин 2</a> </p>
		</div>
		<div style="clear: right; float: left; margin-right: 50px; width: 100px;">
			<div><span class="bluetitle">Настройки</span></div>

			<p>период</p>
			<p><input title="период для PWM материнской платы" type="text" value="1190" id="pwm_period" style="background: transparent; width: 50px; border: 1px solid #7c7c7c; color: #ffffff;"></p>
			
		</div>

		<div style="clear: both;"></div>

		<p></p>

		<div style="position: relative; clear: right; float: left; width: 500px; margin-right: 20px;">
			<img src="modules/{module_name}/motorshield.png" style="box-shadow:0px 0px 15px #555555;">

			<!-- J1 PINS -->
			<div class="contype1" id="j1_8" con="1" num="8" style="top:4px; left:53px;" title="мотор 8"></div>
			<div class="contype1" id="j1_7" con="1" num="7" style="top:4px; left:71px;" title="мотор 7"></div>
			<div class="contype1" id="j1_6" con="1" num="6" style="top:4px; left:89px;" title="мотор 6"></div>
			<div class="contype1" id="j1_5" con="1" num="5" style="top:4px; left:107px;" title="мотор 5"></div>
			<div class="contype1" id="j1_4" con="1" num="4" style="top:4px; left:125px;" title="мотор 4"></div>
			<div class="contype1" id="j1_3" con="1" num="3" style="top:4px; left:144px;" title="мотор 3"></div>
			<div class="contype1" id="j1_2" con="1" num="2" style="top:4px; left:162px;" title="мотор 2"></div>
			<div class="contype1" id="j1_1" con="1" num="1" style="top:4px; left:179px;" title="мvотор 1"></div>

			<!-- J2 PINS -->
			<div class="contype2" id="j2_1" con="2" num="1" style="top:3px; left:360px;" title="Ethernet"></div>

			<!-- J3 PINS -->
			<div class="contype3" id="j3_1" con="3" num="1" style="top:21px; left:360px;" title="UART"></div>

			<!-- J4 PINS -->
			<div class="contype4" id="j4_1" con="4" num="1" style="top:21px; left:415px;" title="RESET"></div>

			<!-- J6 PINS -->
			<div class="contype6" id="j6_1" con="6" num="1" style="top:216px; left:459px;" title="выбор питания для серв"></div>

			<!-- J7 PINS -->
			<div class="contype7" id="j7_1" con="7" num="1" style="top:216px; left:478px;" title="выбор питания для серв"></div>

			<!-- J8 PINS -->
			<div class="contype8" id="j8_1" con="8" num="1" style="top:180px; left:367px;" title="выбор питания для моторов 7 и 8"></div>

			<!-- J9 PINS -->
			<div class="contype9" id="j9_1" con="9" num="1" style="top:180px; left:386px;" title="выбор питания для моторов 5 и 6"></div>

			<!-- J10 PINS -->
			<div class="contype10" id="j10_1" con="10" num="1" style="top:180px; left:404px;" title="выбор питания для моторов 3 и 4"></div>

			<!-- J11 PINS -->
			<div class="contype11" id="j11_1" con="11" num="1" style="top:180px; left:423px;" title="выбор питания для моторов 1 и 2"></div>

			<!-- J12 PINS -->
			<div class="contype12" id="j12_1" con="12" num="1" style="top:252px; left:367px;" title="выбор питания для однополярых выходов 7 и 8"></div>

			<!-- J13 PINS -->
			<div class="contype13" id="j13_1" con="13" num="1" style="top:252px; left:386px;" title="выбор питания для однополярых выходов 5 и 6"></div>

			<!-- J14 PINS -->
			<div class="contype14" id="j14_1" con="14" num="1" style="top:252px; left:404px;" title="выбор питания для однополярых выходов 3 и 4"></div>

			<!-- J15 PINS -->
			<div class="contype15" id="j15_1" con="15" num="1" style="top:252px; left:423px;" title="выбор питания для однополярых выходов 1 и 2"></div>

			<!-- J16 PINS -->
			<div class="contype16" id="j16_8" con="16" num="8" style="top:360px; left:61px;" title="однополярный 8"></div>
			<div class="contype16" id="j16_7" con="16" num="7" style="top:360px; left:79px;" title="однополярный 7"></div>
			<div class="contype16" id="j16_6" con="16" num="6" style="top:360px; left:97px;" title="однополярный 6"></div>
			<div class="contype16" id="j16_5" con="16" num="5" style="top:360px; left:115px;" title="однополярный 5"></div>
			<div class="contype16" id="j16_4" con="16" num="4" style="top:360px; left:133px;" title="однополярный 4"></div>
			<div class="contype16" id="j16_3" con="16" num="3" style="top:360px; left:151px;" title="однополярный 3"></div>
			<div class="contype16" id="j16_2" con="16" num="2" style="top:360px; left:169px;" title="однополярный 2"></div>
			<div class="contype16" id="j16_1" con="16" num="1" style="top:360px; left:187px;" title="однополярный 1"></div>

			<!-- J17 PINS -->
			<div class="contype17" id="j17_8" con="17" num="8" style="top:360px; left:225px;" title="серво 8"></div>
			<div class="contype17" id="j17_7" con="17" num="7" style="top:360px; left:243px;" title="серво 7"></div>
			<div class="contype17" id="j17_6" con="17" num="6" style="top:360px; left:261px;" title="серво 6"></div>
			<div class="contype17" id="j17_5" con="17" num="5" style="top:360px; left:279px;" title="серво 5"></div>
			<div class="contype17" id="j17_4" con="17" num="4" style="top:360px; left:296px;" title="серво 4"></div>
			<div class="contype17" id="j17_3" con="17" num="3" style="top:360px; left:315px;" title="серво 3"></div>
			<div class="contype17" id="j17_2" con="17" num="2" style="top:360px; left:332px;" title="серво 2"></div>
			<div class="contype17" id="j17_1" con="17" num="1" style="top:360px; left:350px;" title="серво 1"></div>

			<!-- Voltage -->
			<div id="voltage" style="top:115px; left:365px;" title="Внешнее напряжение"></div>

		</div>
		<div style="width: 100%;">
			<span class="bluetitle">Настройки</span>
			<p>адрес i2c</p>
			<p><input title="адрес i2c (hex)" type="text" value="{addr}" id="addr" onchange='set_addr($(this).val()); return false;'  style="background: transparent; width: 30px; border: 1px solid #7c7c7c; color: #ffffff;"></p>

			<p>делитель</p>
			<p><input title="делитель частоты" type="text" value="{divider}" id="divider" onchange='set_divider($(this).val()); return false;'  style="background: transparent; width: 30px; border: 1px solid #7c7c7c; color: #ffffff;"></p>

			<p>частота</p>
			<p><input title="частота, Hz" type="text" value="{freq}" id="freq" onchange='set_freq($(this).val()); return false;'  style="background: transparent; width: 30px; border: 1px solid #7c7c7c; color: #ffffff;"></p>

			<p><a href="#" onclick="set_init(); return false;" title="инициализировать pwm чип">инит</a></p>

		</div>
		<div style="clear: both;"></div>

		<p></p>

		<div style="clear: right; float: left; margin-right: 50px; width: 200px;">
			<div><span class="bluetitle">Однополярные выходы</span></div>
			<p><div class="unipolarslider" num=8></div></p>
			<p><div class="unipolarslider" num=7></div></p>
			<p><div class="unipolarslider" num=6></div></p>
			<p><div class="unipolarslider" num=5></div></p>
			<p><div class="unipolarslider" num=4></div></p>
			<p><div class="unipolarslider" num=3></div></p>
			<p><div class="unipolarslider" num=2></div></p>
			<p><div class="unipolarslider" num=1></div></p>
		</div>
		<div style="clear: right; float: left; margin-right: 50px; width: 200px;">
			<div><span class="bluetitle">Сервы</span> <span style="float: right;"><a href="#" onclick='set_servo(-1, -1); return false;'>выключить все</a></span></div>
			<p><div class="servosliders" num=8></div></p>
			<p><div class="servosliders" num=7></div></p>
			<p><div class="servosliders" num=6></div></p>
			<p><div class="servosliders" num=5></div></p>
			<p><div class="servosliders" num=4></div></p>
			<p><div class="servosliders" num=3></div></p>
			<p><div class="servosliders" num=2></div></p>
			<p><div class="servosliders" num=1></div></p>

			<p>
				<span class="bluetitle">min</span> <input title="минимальное положение сервы (в миллисекундах)" type="text" value="{servomin}" id="servomin" onchange='set_servo_min($(this).val()); return false;'  style="background: transparent; width: 30px; border: 1px solid #7c7c7c; color: #ffffff;"> 
				<span style="margin-left: 40px;"></span>
				<span class="bluetitle">max</span> <input title="максимальное положение сервы (в миллисекундах)" type="text" value="{servomax}" id="servomax" onchange='set_servo_max($(this).val()); return false;'  style="background: transparent; width: 30px; border: 1px solid #7c7c7c; color: #ffffff;"> 
			</p>
		</div>
		<div style="clear: both;"></div>

	</div>


</div>