<cfcomponent displayname="payment" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get payment methods" >
        
        <cftry>
            <cfset local.stPaymentData = StructNew() />
            <cfset init() />
            
            <cfquery name="getPaymentMethods" datasource="#this.sDatasourceName#">
                SELECT paymentMethodId, paymentMethod, description
                FROM PaymentMethod 
            </cfquery>
            <cfset local.stPaymentData = QueryToStruct(getPaymentMethods) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stPaymentData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="true"  hint="I am a function that create levels" >
        
        <cftry>
            <cfset local.stLevelData = CheckJsonBody( getHttpRequestData().content ).stLevel />
            <cfset init() />
            
            <cfquery name="insertLevel" datasource="#this.sDatasourceName#">
                INSERT INTO Level
                (levelName, description, subjectId)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLevelData.levelName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLevelData.description#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLevelData.subjectId#" />)
            </cfquery>
                      
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stLevelData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false"  hint="I am a function that update Level" >
        
        <cftry>
            <cfset local.stLevelData = CheckJsonBody( getHttpRequestData().content ).stLevel />
            <cfset init() />
            
            <cfquery name="updateLevel" datasource="#this.sDatasourceName#">
                UPDATE subjectLevel
                SET subjectId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLevelData.subjetId#" />,
                    levelName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLevelData.levelName#" />,
                    description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stLevelData.description#" />
                WHERE levelId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLevelData.levelId#" />
            </cfquery>
              
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stLevelData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false"  hint="I am a function that delete/archive level" >
        
        <cftry>
            <cfset local.stLevelData = CheckJsonBody( getHttpRequestData().content ).stLevel />
            <cfset init() />
            
            <cfquery name="deleteLevel" datasource="#this.sDatasourceName#">
                DELETE FROM subjectLevel
                WHERE levelId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stLevelData.levelId#" />
            </cfquery>
                 
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stLevelData />
    </cffunction>
    
    
    
</cfcomponent>