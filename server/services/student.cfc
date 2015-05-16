<cfcomponent displayname="student" output="false" extends="Base">
    
    <cffunction name="read" access="remote" output="false" returnformat="json" hint="I am a function that get students" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stStudentData = StructNew() />
            <cfset init() />
            
            <cfquery name="getStudents" datasource="#this.sDatasourceName#">
                SELECT s.studentId, s.firstName, s.lastName, s.middleName, CONCAT(s.firstname," ", s.lastname) as FullName, 
                s.address1, s.address2, s.city, s.stateId, s.zipcode, s.email, s.phone, 
                CONCAT(CONCAT("(", SUBSTRING(s.phone,1,3), ") "), SUBSTRING(s.phone,4,3), CONCAT("-", SUBSTRING(s.phone,7,4))) as formattedPhone,
                s.active,  case when s.active = 1 then 'Active' else 'Inactive' end as status, l.locationId, l.location, 
                g.gradeId, g.gradeName, s.school, s.paymentMethodId, s.enrollmentDate, s.comments
                FROM student s INNER JOIN location l ON s.locationId = l.locationId
                LEFT JOIN grade g ON g.gradeId = s.gradeId
                LEFT JOIN PaymentMethod p ON p.paymentMethodID = s.paymentMethodId
                WHERE 1 = 1
                <cfif local.stData.stUserData.locationId neq "" and local.stData.stUserData.locationId neq 0 and not local.stData.stUserData.allLocations>
                    AND s.locationId = <cfqueryparam value="#local.stData.stUserData.locationId#" cfsqltype="cf_sql_integer" />
                </cfif>
                <cfif structKeyExists(local.stData, "stSearchParams") and local.stData.stSearchParams.filterText neq "">
                    AND s.active = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
                </cfif>
            </cfquery>
            <cfset local.stStudentData = QueryToStruct(getStudents) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stStudentData />
    </cffunction>
            
    <cffunction name="getStudentData" access="remote" output="false" returnformat="json" hint="I am a function that get students" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stStudent = StructNew() />
            <cfset init() />
            
            <cfquery name="getStudentSubjects" datasource="#this.sDatasourceName#">
                SELECT s.subjectid, ss.subjectID as studentSubjectId, ss.studentId, ss.packetId, s.subjectName, l.levelId
                FROM subject s LEFT JOIN studentsubject ss ON s.subjectId = ss.subjectId 
                AND ss.studentId = <cfqueryparam value="#local.stData.studentId#" cfsqltype="cf_sql_integer" />
                LEFT JOIN WeekPacket p ON ss.packetId = p.packetId
                LEFT JOIN SubjectLevel l ON l.levelId = p.levelId;
            </cfquery>
            
            <cfset local.stStudent.stStudentSubjects = QueryToStruct(getStudentSubjects) />
            
            <cfquery name="getStudentClasses" datasource="#this.sDatasourceName#">
                SELECT classId
                FROM StudentClass
                WHERE 1 = 1
                AND studentId = <cfqueryparam value="#local.stData.studentId#" cfsqltype="cf_sql_integer" />
            </cfquery>
            
            <cfif getStudentClasses.recordcount lte 0>
                <cfset temp = QueryAddRow(getStudentClasses) /> 
                <cfset Temp = QuerySetCell(getStudentClasses, "classId", 0) />
            </cfif>
            <cfif getStudentClasses.recordcount eq 1>
                <cfset temp = QueryAddRow(getStudentClasses) /> 
                <cfset Temp = QuerySetCell(getStudentClasses, "classId", 0) />
            </cfif>
            
            <cfset local.stStudent.stStudentClasses = QueryToStruct(getStudentClasses) />
            <!---
            <cfset local.stStudent.stStudentClasses = structNew() />
        
            <cfoutput query="getStudentClasses">
                <cfif currentrow eq 1>
                    <cfset local.stStudent.stStudentClasses.class1Id = classId />
                <cfelseif currentrow eq 2>
                    <cfset local.stStudent.stStudentClasses.class2Id = classId />
                </cfif>
                
            </cfoutput>
            --->
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stStudent />
    </cffunction>
            
    <cffunction name="excelStudentLog" access="remote" output="false" returnformat="plain" hint="I am a function to generate all student log as excel" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stStudentLog = StructNew() />
            <cfset local.noOfWeeks = 5 />
            <cfset init() />
            
            <!--- Create new spreadsheet --->
            <cfset local.sObj=SpreadsheetNew()>
                
            <cfset lSubjectList = "Math, English, Abacus, GK" /> 
            
            <cfset local.lSubjectRow = "" />
            <cfset local.lDateRow = "" />
                
            <cfset local.lSubjectRow = listAppend(local.lSubjectRow, " ") />
            <cfset local.lDateRow = listAppend(local.lDateRow, " ") />
                
            <cfquery name="getClasses" datasource="#this.sDatasourceName#">
                SELECT classHistoryId, classDate FROM BestBrainsDev.ClassHistory
                ORDER BY ClassDate DESC LIMIT 5;
            </cfquery>      
                
            <cfloop list="#lSubjectList#" index="x">
                
                <cfoutput query="getClasses">
                    <cfset local.lSubjectRow = listAppend(local.lSubjectRow, "#x#") />
                    <cfset local.lDateRow = listAppend(local.lDateRow, "#dateformat(classDate,'mmm dd')#") />
                </cfoutput>
                
            </cfloop>
                
            <cfset local.lDateRow = listAppend(local.lDateRow, "comments") />
                
            <!--- Create header row --->
            <cfset SpreadsheetAddRow(local.sObj, "#local.lSubjectRow#")>
            <cfset SpreadsheetAddRow(local.sObj, "#local.lDateRow#")>
                
            <cfquery name="getStudentLog" datasource="#this.sDatasourceName#">
                SELECT s.studentId, CONCAT(s.lastname, " ", s.firstname) as fullname, ch.classDate, sch.attendance, 
                sb.subjectId, sb.subjectName, ssh.currentPacketId, ssh.comments, CONCAT(l.levelName, "-", p.packetName) as Packet 
                FROM Student s
                INNER JOIN studentclasshistory sch ON s.studentId = sch.studentId
                INNER JOIN ClassHistory ch ON ch.classhistoryId = sch.classHistoryId
                INNER JOIN studentsubjecthistory ssh ON sch.studentClassHistoryId = ssh.studentClassHistoryId
                INNER JOIN subject sb ON ssh.subjectId = sb.subjectId
                INNER JOIN WeekPacket p ON ssh.currentPacketId = p.packetId
                INNER JOIN SubjectLevel l ON l.levelId = p.levelId
                INNER JOIN Class c ON c.classId = ch.classId
                WHERE 1 = 1
                AND c.locationId = <cfqueryparam value="#local.stData.locationId#" cfsqltype="cf_sql_integer" />
                ORDER BY s.studentId, ssh.subjectId, ch.classDate desc
            </cfquery>
                
            <cfoutput query="getStudentLog" group="studentId">
                <cfset local.lStudentRow = "" />
                <cfset local.lComments = "" />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, "#fullName#") />
                
                <cfoutput group="classDate">
                    <cfoutput>
                        <cfset local.lStudentRow = listAppend(local.lStudentRow, "#packet#") />
                        <cfset local.lComments = listAppend(local.lComments, comments, "-") />
                    </cfoutput>
                </cfoutput>
                <cfset local.lStudentRow = listAppend(local.lStudentRow, " ") />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, " ") />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, " ") />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, " ") />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, " ") />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, " ") />
                <cfset local.lStudentRow = listAppend(local.lStudentRow, "#local.lComments#") />
                <!--- Add data row --->
                <cfset SpreadsheetAddRow(local.sObj, "#local.lStudentRow#")>
            </cfoutput>
  
            <cfset local.theDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "excels/"  />
            <cfset local.logFile = "studentLog_" & dateFormat(now(), 'mm-dd-yyyy') & ".xls" />
            <cfset local.theFile = local.theDir & local.logFile />

            <cfspreadsheet action="write"
                name="sObj"
                filename="#local.theFile#"
                overwrite="true">
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
            </cfcatch>
        </cftry>
                
        <cfreturn local.logFile />
    </cffunction>
            
    <cffunction name="generateStudentLog" access="remote" output="false" returnformat="json" hint="I am a function to generate student log" >
        
        <cftry>
            <cfset local.stData = CheckJsonBody( getHttpRequestData().content ) />
            <cfset local.stStudentLog = StructNew() />
            <cfset init() />
            
            <cfquery name="getStudentLog" datasource="#this.sDatasourceName#">
                SELECT s.studentId, CONCAT(s.lastname, " ", s.firstname) as fullname, ch.classDate, sch.attendance, 
                sb.subjectId, sb.subjectName, ssh.currentPacketId, ssh.comments, CONCAT(l.levelName, "-", p.packetName) as Packet 
                FROM Student s
                INNER JOIN studentclasshistory sch ON s.studentId = sch.studentId
                INNER JOIN ClassHistory ch ON ch.classhistoryId = sch.classHistoryId
                INNER JOIN studentsubjecthistory ssh ON sch.studentClassHistoryId = ssh.studentClassHistoryId
                INNER JOIN subject sb ON ssh.subjectId = sb.subjectId
                INNER JOIN WeekPacket p ON ssh.currentPacketId = p.packetId
                INNER JOIN SubjectLevel l ON l.levelId = p.levelId
                INNER JOIN Class c ON c.classId = ch.classId
                WHERE 1 = 1
                AND s.studentId = <cfqueryparam value="#local.stData.studentId#" cfsqltype="cf_sql_integer" />
                ORDER BY ssh.subjectId, ch.classDate desc
            </cfquery>
            
            <cfset local.logArray = ArrayNew( 1 ) />
            
            <cfoutput query="getStudentLog" group="studentId">
                <cfset temp = ArrayAppend( local.logArray, StructNew() )/>
                <cfset local.logArrayIndex = ArrayLen( local.logArray ) />
                
                <cfset local.logArray[ local.logArrayIndex ][ 'Name' ] = fullName />
                
                <cfset local.lComments = "" />
                <cfset local.dateArray = ArrayNew( 1 ) />
                
                <cfoutput group="classDate">
                    <cfset temp = ArrayAppend( local.dateArray, StructNew() )/>
                    <cfset local.dateArrayIndex = ArrayLen( local.dateArray ) />
                    
                    <cfset local.dateArray[ local.dateArrayIndex ][ 'Date' ] = classDate />
                    
                    <cfset local.SubjectArray = ArrayNew( 1 ) />

                    <cfset lSubjectList = "Math, English, Abacus, GK" />

                    <cfoutput>
                        <cfset local.dateArray[ local.dateArrayIndex ][ 'subject' ] = subjectName />
                        <cfset local.dateArray[ local.dateArrayIndex ][ 'packet' ] = packet />
                        <cfset local.dateArray[ local.dateArrayIndex ][ 'comments' ] = comments />
            
                        <cfset local.lComments = listAppend(local.lComments, comments) />
                        <!---
                        <cfset temp = ArrayAppend( local.SubjectArray, StructNew() )/>
                        <cfset local.SubjectArrayIndex = ArrayLen( local.SubjectArray ) />

                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'subjectId' ] = subjectId />
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'levelId' ] = levelId />
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packetId' ] = packetId />
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packet' ] = packet />
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'packetName' ] = packetName/>
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'subjectName' ] = subjectName />
                        <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'comments' ] = "" />
                        <cfif midTerm eq 1>
                            <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'midterm' ] = true />
                        <cfelse>
                            <cfset local.SubjectArray[ local.SubjectArrayIndex ][ 'midterm' ] = false />
                        </cfif>
                        --->
                    </cfoutput>
                    
                    <cfset local.logArray[ local.logArrayIndex ][ 'Dates' ] = local.dateArray />
                    <cfset local.logArray[ local.logArrayIndex ][ 'Comments' ] = local.lComments />
                
                </cfoutput>
                           
                
                
                <!---<cfset local.materialArray[ local.materialArrayIndex ][ 'Subjects' ] = local.SubjectArray />--->

            </cfoutput>
            <cfset local.stStudentLog = local.logArray />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
        <cfreturn local.stStudentLog />
    </cffunction>
    
    <cffunction name="create" access="remote" output="false"  returnformat="json"  return hint="I am a function that create students" >
        
        <cftry>
            <cfset local.stStudentData = CheckJsonBody( getHttpRequestData().content ).stStudent />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="insertStudent" datasource="#this.sDatasourceName#" result="insertResult">
                INSERT INTO Student
                (firstName, lastName, middleName, address1, address2, city, stateId, zipcode, email, phone, active, locationId, gradeId, school,
                 paymentMethodId, enrollmentDate, comments)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.firstName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.lastName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.middleName#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.address1#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.address2#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.city#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stateId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.zipcode#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.email#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.phone#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.active#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.locationId#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.gradeId#" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.school#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.paymentMethodId#" />,
                <cfqueryparam cfsqltype="cf_sql_datetime" value="2015-03-18 00:00:00" />,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.comments#" />
                <!---,
                <cfqueryparam cfsqltype="cf_sql_datetime" value="#local.stStudentData.EnrollmentDate#" />--->
                )
            </cfquery>
            <cfset local.studentId = insertResult["GENERATEDKEY"] />
            
            <!--- insert subjects --->
            <cfloop from="1" to="#arrayLen(local.stStudentData.stStudentSubjects)#" index="i"> 
                <cfif local.stStudentData.stStudentSubjects[i].studentsubjectId neq 0
                      AND local.stStudentData.stStudentSubjects[i].studentsubjectId neq "">
                    <cfquery name="insertStudentSubject" datasource="#this.sDatasourceName#">
                        INSERT INTO StudentSubject (studentId, subjectId, packetId)
                        values
                        (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.studentId#" />,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentSubjects[i].studentsubjectId#" />,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentSubjects[i].packetId#" />
                        )
                    </cfquery>
                </cfif>
            </cfloop>
            
            <!--- insert Classes --->
            <cfloop from="1" to="#arrayLen(local.stStudentData.stStudentClasses)#" index="i">
                <cfif local.stStudentData.stStudentClasses[i].classId neq 0 AND local.stStudentData.stStudentClasses[i].classId neq "">
                    <cfquery name="insertClass" datasource="#this.sDatasourceName#">
                        INSERT INTO StudentClass (studentId, classId)
                        values
                        (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.studentId#" />,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentClasses[i].classId#" />
                        )
                    </cfquery>
                </cfif>
            </cfloop>

            <cfset local.stStudentData =  read(local.stUserData) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stStudentData />
    </cffunction>
    
    <cffunction name="update" access="remote" output="false" returnformat="json"  hint="I am a function that update students" >
        
        <cftry>
            <cfset local.stStudentData = CheckJsonBody( getHttpRequestData().content ).stStudent  />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="updateStudent" datasource="#this.sDatasourceName#">
                UPDATE Student
                SET locationId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.locationId#" />,
                    firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.firstName#" />,
                    lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.lastName#" />,
                    middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.middleName#" />,
                    address1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.address1#" />,
                    address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.address2#" />,
                    stateId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stateId#" />,
                    city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.city#" />,
                    zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.zipcode#" />,
                    email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.email#" />,
                    phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.phone#" />,
                    active = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.active#" />,
                    gradeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.gradeId#" />,
                    school = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.school#" />,
                    paymentMethodId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.paymentMethodId#" />,
                    comments = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.stStudentData.comments#" /> <!--- ,
                    enrollmentDate = <cfqueryparam cfsqltype="cf_sql_datetime" value="#local.stStudentData.EnrollmentDate#" />--->
                WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" />
            </cfquery>
            
            <!--- update subjects --->
            <cfquery name="getSubject" datasource="#this.sDatasourceName#">
                SELECT subjectId
                FROM StudentSubject
                WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" /> 
            </cfquery>
            
            <cfset local.lOldSubjects = valueList(getSubject.subjectId) />
            <cfset local.lNewSubjects = "" />
            
            <cfloop from="1" to="#arrayLen(local.stStudentData.stStudentSubjects)#" index="i"> 
                <cfif local.stStudentData.stStudentSubjects[i].studentsubjectId neq 0
                      AND local.stStudentData.stStudentSubjects[i].studentsubjectId neq "">
                    <cfset local.lNewSubjects = listAppend(local.lNewSubjects, local.stStudentData.stStudentSubjects[i].studentsubjectId) /> 
                    <cfif listFind(local.lOldSubjects, local.stStudentData.stStudentSubjects[i].studentsubjectId)  gt 0>
                        <cfquery name="updateStudentSubject" datasource="#this.sDatasourceName#">
                            UPDATE StudentSubject SET
                            packetId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentSubjects[i].packetId#" />
                            WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" /> 
                            AND subjectId = <cfqueryparam cfsqltype="cf_sql_integer"
                            value="#local.stStudentData.stStudentSubjects[i].studentsubjectId#"/>
                        </cfquery>
                    <cfelse>
                        <cfquery name="insertStudentSubject" datasource="#this.sDatasourceName#">
                            INSERT INTO StudentSubject (studentId, subjectId, packetId)
                            values
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentSubjects[i].studentsubjectId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentSubjects[i].packetId#" />
                            )
                        </cfquery>
                    </cfif>
                </cfif>
            </cfloop>
                
            <cfif listLen(local.lNewSubjects) gt 0>
                <cfquery name="deleteSubject" datasource="#this.sDatasourceName#">
                    DELETE FROM StudentSubject
                    WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" />
                    AND subjectID not in (<cfqueryparam value="#local.lNewSubjects#" cfsqltype="cf_sql_integer" list="true" />)
                </cfquery>      
            </cfif>
                        
            <!--- update Classes --->
            <cfquery name="getClass" datasource="#this.sDatasourceName#">
                SELECT classId
                FROM StudentClass
                WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" /> 
            </cfquery>
                
            <cfset local.lOldClasses = valueList(getClass.classId) />
            <cfset local.lNewClasses = "" />
            
            <cfloop from="1" to="#arrayLen(local.stStudentData.stStudentClasses)#" index="i">
                <cfif local.stStudentData.stStudentClasses[i].classId neq 0 AND local.stStudentData.stStudentClasses[i].classId neq "">
                    <cfset local.lNewClasses = listAppend(local.lNewClasses, local.stStudentData.stStudentClasses[i].classId) />
                    <cfif listFind(local.lOldClasses, local.stStudentData.stStudentClasses[i].classId)  gt 0>
                        
                    <cfelse>
                        <cfquery name="insertClass" datasource="#this.sDatasourceName#">
                            INSERT INTO StudentClass (studentId, classId)
                            values
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" />,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.stStudentClasses[i].classId#" />
                            )
                        </cfquery>
                    </cfif>
                </cfif>
            </cfloop>
            
            <cfif listLen(local.lNewClasses) gt 0>
                <cfquery name="deleteClass" datasource="#this.sDatasourceName#">
                    DELETE FROM StudentClass
                    WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" />
                    AND classID not in (<cfqueryparam value="#local.lNewClasses#" cfsqltype="cf_sql_integer" list="true" />)
                </cfquery>    
            </cfif>
                    
            <cfset local.stStudentData =  read(local.stUserData) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stStudentData />
    </cffunction>
        
    <cffunction name="delete" access="remote" output="false" returnformat="json"  hint="I am a function that delete/archive student" >
        
        <cftry>
            <cfset local.stStudentData = CheckJsonBody( getHttpRequestData().content ).stStudent  />
            <cfset local.stUserData = CheckJsonBody( getHttpRequestData().content ).stUserData />
            <cfset init() />
            
            <cfquery name="deleteStudent" datasource="#this.sDatasourceName#">
                UPDATE Student 
                SET active = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
                WHERE studentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.stStudentData.studentId#" />
            </cfquery>
            
            <cfset local.stStudentData =  read(local.stUserData) />
            
            <cfcatch type="any">
                <cfdump var="#cfcatch#">
                <cfabort>
                <cfreturn false />
            </cfcatch>
        </cftry>
            
        <cfreturn local.stStudentData />
    </cffunction>
    
    
    
</cfcomponent>