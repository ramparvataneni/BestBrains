<cfcomponent displayname="packet" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get packets" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stPacketData = StructNew() />
            <cfset init() />
            
            <cfquery name="getPackets" datasource="#this.sDatasourceName#">
                SELECT p.packetId, l.levelId, s.subjectName, CONCAT(l.levelName, " ", p.packetName) as Packet, s.subjectId 
                FROM WeekPacket p INNER JOIN SubjectLevel l on p.levelId = l.levelId
                inner join subject s on l.subjectId = s.subjectId
                WHERE 1 = 1
                order by s.subjectId, l.levelId, p.packetId
            </cfquery>
            <cfset local.stPacketData = QueryToStruct(getPackets) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stPacketData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="false"  hint="I am a function that create packets" >
        
        <cftry>
            <cfset local.stPacketData = CheckJsonBody( getHttpRequestData().content ) />
            
            <cfquery name="getPackets" datasource="#this.sDatasourceName#">
                SELECT * FROM WeekPacket
                WHERE 1 = 1
                <cfif local.stData.locationId neq "" and local.stData.locationId neq 0>
                    AND locationId = <cfqueryparam value="#local.stData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
                <cfif structKeyExists(local.stData, "searchParams") and local.stData.searchParams neq "">
                    AND active = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
                </cfif>
            </cfquery>      
            
            <cfcatch type="any"></cfcatch>
        </cftry>
            
        <cfreturn local.stPacketData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false"  hint="I am a function that update packets" >
        
        <cftry>
            <cfset local.stPacketData = CheckJsonBody( getHttpRequestData().content ) />
            
            <cfquery name="getPackets" datasource="#this.sDatasourceName#">
                SELECT * FROM packet
                WHERE 1 = 1
                <cfif local.stData.locationId neq "" and local.stData.locationId neq 0>
                    AND locationId = <cfqueryparam value="#local.stData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
                <cfif structKeyExists(local.stData, "searchParams") and local.stData.searchParams neq "">
                    AND active = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
                </cfif>
            </cfquery>
            
            
            
            <cfcatch type="any"></cfcatch>
        </cftry>
            
        <cfreturn local.stPacketData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false"  hint="I am a function that delete/archive packet" >
        
        <cftry>
            <cfset local.stPacketData = CheckJsonBody( getHttpRequestData().content ) />
            
            <cfquery name="getPackets" datasource="#this.sDatasourceName#">
                SELECT * FROM packet
                WHERE 1 = 1
                <cfif local.stData.locationId neq "" and local.stData.locationId neq 0>
                    AND locationId = <cfqueryparam value="#local.stData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
                <cfif structKeyExists(local.stData, "searchParams") and local.stData.searchParams neq "">
                    AND active = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
                </cfif>
            </cfquery>
            
            
            
            <cfcatch type="any"></cfcatch>
        </cftry>
            
        <cfreturn local.stPacketData />
    </cffunction>
    
    
    
</cfcomponent>