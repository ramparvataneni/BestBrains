<!--- Application.cfc for BB application
Does nothing other than setting up session and application scope --->
<cfcomponent
	hint=		"application cfc for bb application"
	output=		"false"
	>

	<cfset This.name = "bb">
	<cfset This.Sessionmanagement="true">
	<cfset This.Sessiontimeout="#createtimespan(0,0,60,0)#">
	<cfset This.applicationtimeout="#createtimespan(0,0,0,0)#">
	<cfset This.bbDataSource="BestBrainsDev">

</cfcomponent>
<!---	Application.cfc
------------------------------------------------------------------------------->
