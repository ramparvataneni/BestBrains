<cfcomponent displayname="role" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get role" >
        
        <cftry>
            <cfset local.stRoleData = StructNew() />
            <cfset init() />
            
            <cfquery name="getRoles" datasource="#this.sDatasourceName#">
                SELECT roleId, roleName, description
                FROM Role
            </cfquery>
            
            <cfset local.stRoleData = QueryToStruct(getRoles) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stRoleData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="true" returnformat="json" hint="I am a function that create role" >
        
        <cftry>
            <cfset local.stRoleData = CheckJsonBody( getHttpRequestData().content ).stRole />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="insertRole" datasource="#this.sDatasourceName#">
                INSERT INTO Role
                (roleName, description)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stRoleData.roleName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stRoleData.description#" />)
            </cfquery>
            
            <cfset local.stRoleData = read(local.stUserData) />
                      
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stRoleData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false" returnformat="json" hint="I am a function that update role" >
        
        <cftry>
            <cfset local.stRoleData = CheckJsonBody( getHttpRequestData().content ).stRole />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="updateRole" datasource="#this.sDatasourceName#">
                UPDATE Role
                SET roleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stRoleData.roleName#" />,
                    description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stRoleData.description#" />
                WHERE roleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stRoleData.roleId#" />
            </cfquery>
            
            <cfset local.stRoleData = read(local.stUserData) />
              
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stRoleData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false" returnformat="json" hint="I am a function that delete role" >
        
        <cftry>
            <cfset local.stRoleData = CheckJsonBody( getHttpRequestData().content ).stRole />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="deleteRole" datasource="#this.sDatasourceName#">
                DELETE FROM Role
                WHERE roleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stRoleData.roleId#" />
            </cfquery>
            
            <cfset local.stRoleData = read(local.stUserData) />
                 
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stRoleData />
    </cffunction>
    
    
    
</cfcomponent>