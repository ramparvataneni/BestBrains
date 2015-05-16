<cfcomponent displayname="class" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get classs" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stClassData = StructNew() />
            <cfset init() />
            
            <cfquery name="getClasses" datasource="#this.sDatasourceName#">
                SELECT c.classId, t.teacherId, CONCAT(t.firstname, " ", t.lastname) as Teacher, c.day, c.startTime, c.startAmPm, c.endTime,
                CONCAT(s3.firstname," ", s3.lastname) as FullName, s3.studentId,
                CONCAT(CONCAT(CONCAT(s1.subjectName, ", ",s2.subjectName)," - ", CONCAT(CONCAT(t.firstname, " ", t.lastname), " - ", 
                CONCAT(CONCAT(c.day, " ", c.startTime), " ", c.startAmPm), "-", CONCAT(c.endTime, " ", c.endAmPm)))) as class,
                CONCAT(CONCAT(c.startTime, " ", c.startAmPm), "-", CONCAT(c.endTime, " ", c.endAmPm)) as classTime, c.classSubject1,
                c.classSubject2, s1.subjectName as subject1, s2.subjectName as subject2,
                c.endAmPm, c.roomNumber, c.locationId, CONCAT(s1.subjectName, ", ",s2.subjectName) as classSubject,
                sp1.packetId as mathPacketId, CONCAT(sl1.levelName,"-",sp1.packetName) as subject1Packet, 
                sp2.packetId as englishPacketId, CONCAT(sl2.levelName,"-", sp2.packetName) as subject2Packet 
                FROM class c INNER JOIN teacher t ON c.teacherId = t.teacherId
                INNER JOIN Subject s1 ON c.classSubject1 = s1.subjectId
                LEFT JOIN Subject s2 ON c.classSubject2 = s2.subjectId
                LEFT JOIN Student s3 ON (s3.class1Id = c.classId OR s3.class2Id = c.classId)
                LEFT JOIN WeekPacket sp1 ON sp1.PacketId = s3.mathPacketId
                LEFT JOIN SubjectLevel sl1 ON sp1.levelId = sl1.levelId
                LEFT JOIN WeekPacket sp2 ON sp2.PacketId = s3.englishPacketId
                LEFT JOIN SubjectLevel sl2 ON sp2.levelId = sl2.levelId
                
                WHERE 1 = 1
                <cfif local.stData.stUserData.locationId neq "" and local.stData.stUserData.locationId neq 0 and not local.stData.stUserData.allLocations>
                    AND c.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
                order by c.classId
            </cfquery>
            
            <!---<cfset local.stClass = queryNew(classId, teacherId, teacher, day, startTime, startAmPm, endTime, fullName, studentId, class, classTime,
                   classSubject1, classSubject2, subject1, subject2, endAmPm, roomNumber, locatioinId, classSubject) />--->
            <cfset local.ClassArray = ArrayNew( 1 ) />
            
            <cfoutput query="getClasses" group="classId">
                <cfset temp = ArrayAppend( LOCAL.ClassArray, StructNew() )/>
                <cfset local.ClassArrayIndex = ArrayLen( LOCAL.ClassArray ) />
                
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'CLASSID' ] = classId />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'TEACHERID' ] = teacherId />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'TEACHER' ] = teacher />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'DAY' ] = day />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'STARTTIME' ] = startTime />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'STARTAMPM' ] = startAmPm />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'ENDTIME' ] = endTime />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'ENDAMPM' ] = endAmPm />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'CLASS' ] = class />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'CLASSTIME' ] = classTime />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'CLASSSUBJECT1' ] = classSubject1 />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'CLASSSUBJECT2' ] = classSubject2 />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'SUBJECT1' ] = Subject1 />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'SUBJECT2' ] = Subject2 />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'ROOMNUMBER' ] = roomNumber />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'LOCATIONID' ] = locationID />
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'CLASSSUBJECT' ] = classSubject />
                <cfset local.StudentArray = ArrayNew( 1 ) />
                
                <cfoutput>
                    <cfset temp = ArrayAppend( LOCAL.StudentArray, StructNew() )/>
                    <cfset local.StudentArrayIndex = ArrayLen( LOCAL.StudentArray ) />
                    
                    <cfset LOCAL.StudentArray[ LOCAL.StudentArrayIndex ][ 'STUDENTID' ] = studentId />
                    <cfset LOCAL.StudentArray[ LOCAL.StudentArrayIndex ][ 'FULLNAME' ] = fullName />
                    <cfset LOCAL.StudentArray[ LOCAL.StudentArrayIndex ][ 'SUBJECT1PACKET' ] = subject1Packet />
                    <cfset LOCAL.StudentArray[ LOCAL.StudentArrayIndex ][ 'SUBJECT2PACKET' ] = subject2Packet />
                </cfoutput>
                
                <cfset LOCAL.ClassArray[ LOCAL.ClassArrayIndex ][ 'Students' ] = local.StudentArray />          
            
            </cfoutput>
            
            <cfset local.stClassData = local.ClassArray />
            <!---<cfset local.stClassData = QueryToStruct(getClasses) />--->
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stClassData />
    </cffunction>
    
    <cffunction name="create" access="remote" output="true" returnformat="json"  hint="I am a function that create class" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            
            <cfset init() />
            
            <cfquery name="insertClass" datasource="#this.sDatasourceName#">
                INSERT INTO Class
                (teacherId, day, startTime, endTime, startAmPm, endAmPm, locationId, classSubject1, classSubject2, roomNumber)
                values
                (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.teacherId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.day#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startTime#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endTime#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startAmPm#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endAmPm#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.locationId#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classsubject1#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classsubject2#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.roomNumber#" />)
            </cfquery>
            
            <cfset local.stClassData =  read(local.stUserData) />
                      
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false" returnformat="json" hint="I am a function that update class" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="updateClass" datasource="#this.sDatasourceName#">
                UPDATE Class
                SET teacherId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.teacherId#" />,
                    day = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.day#" />,
                    startTime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startTime#" />,
                    endTime = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endTime#" />,
                    startAmPm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.startAmPm#" />,
                    endAmPm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.endAmPm#" />,
                    locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.locationId#" />,
                    classSubject1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classsubject1#" />,
                    classSubject2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classsubject2#" />,
                    roomNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stClassData.roomNumber#" />
                WHERE classId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />
            </cfquery>
            
            <cfset local.stClassData =  read(local.stUserData) />
              
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false" returnformat="json" hint="I am a function that delete/archive class" >
        
        <cftry>
            <cfset local.stClassData = CheckJsonBody( getHttpRequestData().content ).stClass />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="deleteClass" datasource="#this.sDatasourceName#">
                DELETE FROM class
                WHERE classId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stClassData.classId#" />
            </cfquery>
            
            <cfset local.stClassData =  read(local.stUserData) />
                 
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false /> 
            </cfcatch>
        </cftry>
            
        <cfreturn local.stClassData />
    </cffunction>
    
    
    
</cfcomponent>