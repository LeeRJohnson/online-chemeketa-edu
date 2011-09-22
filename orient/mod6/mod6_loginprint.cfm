<!--- Add if this is in a popup window --->
<cfif IsDefined("URL.popup") AND URL.popup IS "Yes">
 	<div style="margin:1em;">
		<span class="normal" style="text-align:left;border:1px solid gray;" id="print" onclick="window.print()">Click Here To Print This Page</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="normal" style="text-align:right;border:1px solid gray;width:46%;" id="close" onclick="self.close()">Close this Window</span>
		<p></p>
	</div>
	<hr />
</cfif>
<!--- END Add if this is in a popup window --->
<div class="indent">
	<h1 id="top">Logging In To Your Class</h1>
	
	<div> 
		<p><img src="../mod6/images/step01.gif" width="100" height="27" alt="step 1" /><br />
		To log on to your class for the very first time, go to <strong>http://online.chemeketa.edu/</strong></p>
		<p>Choose the top button or the bottom button depending on if you registered through Chemeketa or through a different college.<br />
	    <img src="../mod6/images/logon1.png" width="219" height="114" align="baseline" alt="Image of Login Page" /> 
	    </p>
	</div>
	
	<hr class="leftmost" />
	
	<div > 
		<p><img src="../mod6/images/step02.gif" width="100" height="27" alt="step 2" /><br />
		The Term select screen defaults to the current term, so click the &quot;Go&quot; button.<br />
		<img src="../mod6/images/logon2.png" alt="Choose term" width="660" height="105" /></p>
	</div>
	
	<hr class="leftmost" />
	
	<div>
		<p><img src="../mod6/images/step03.gif" width="100" height="27" alt="step 3" /><br />
		On the <strong>List of Classes</strong> screen, you continue on to your class by clicking the &quot;Go to Class&quot; link in the left column. Use the row of lettered links to quickly scroll to your class. For example, if you are taking WR121, click on the <span style="color:blue;text-decoration:underline;">W</span>.</p>
		<p><img src="../mod6/images/logon3.png" width="593" height="448" alt="list of classes screen" /></p>
	</div>
	
	<hr class="leftmost" />
	
	<div>
		<img src="images/step04.gif" width="100" height="27" alt="step 5">
		<p>View information about the class...<br />
		<img src="../mod6/images/logon4.png" width="451" height="370" alt="Class information screen" /><br />
		Most class information pages will look similar to this, with a link to the Elearn system.</p>
		<hr class="leftmost">
		<p>For an eLearn class...<br />
		<img src="../mod6/images/logon5.png" width="481" height="363" alt="Elearn login screen" /><br />
		This user name and password is assigned to you by the college.<br />The previous screen will explain what it is.</p>
	</div>
	
	<hr class="leftmost" />
	      
	<p align="center"><img src="images/congrats.gif" width="346" height="49" alt="Congratulations" /></p>
	      
	<p>Once you have successfully entered your class, you do not need to follow these steps each time. Now that you know where your class is, you can use the favorites you made to get there quicker. Be sure to return to <a href="http://online.chemeketa.edu/" target="_blank">Chemeketa Online</a> periodically for information and support.</p>
	      
	<!--- Add if this is in a popup window --->
	<cfif IsDefined("URL.popup") AND URL.popup IS "Yes">
		<p align="right"><span class="normal" style="text-align:right;border:1px solid gray;width:46%;" id="close" onclick="self.close()">Close this Window</span></p>
	</cfif>
	<!--- END Add if this is in a popup window --->
</div>
<cfinclude template="../_footer.cfm">