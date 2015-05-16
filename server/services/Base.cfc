/*     Author                                   Date                                   Action  [change log]
------------------------------------------------------------------------------------------------------------------
Ram Parvatini							01/20/2015			Added CheckJsonBody function to capture httprequest and convert into CF accessible data

*/

//Global initialization Page.
component displayname="Base"    {

				//----------------------------------------------------------------------------------------------------------//
				//-- Constructor Functions.--------------------------------------------------------------------------------//
				//----------------------------------------------------------------------------------------------------------//


				public function init( string sDatasourceName = "BestBrainsDev")
				{
				this.sDatasourceName = arguments.sDatasourceName;
				return this;
				}


			public function QueryToStruct( query Query,
			                                numeric Row = 0){

					// Determine the indexes that we will need to loop over.
					// To do so, check to see if we are working with a given row,
					// or the whole record set.
					if (ARGUMENTS.Row){

					// We are only looping over one row.
					LOCAL.FromIndex = ARGUMENTS.Row;
					LOCAL.ToIndex = ARGUMENTS.Row;

					} else {

					// We are looping over the entire query.
					LOCAL.FromIndex = 1;
					LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

					}

					// Get the list of columns as an array and the column count.
					LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
					LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

					// Create an array to keep all the objects.
					LOCAL.DataArray = ArrayNew( 1 );

					// Loop over the rows to create a structure for each row.
					for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

					// Create a new structure for this row.
					ArrayAppend( LOCAL.DataArray, StructNew() );

					// Get the index of the current data array object.
					LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

					// Loop over the columns to set the structure values.
					for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

					// Get the column value.
					LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

					// Set column value into the structure.
					LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

					}

					}


					// At this point, we have an array of structure objects that
					// represent the rows in the query over the indexes that we
					// wanted to convert. If we did not want to convert a specific
					// record, return the array. If we wanted to convert a single
					// row, then return the just that STRUCTURE, not the array.
					if (ARGUMENTS.Row){

					// Return the first array item.
					return( LOCAL.DataArray[ 1 ] );

					} else {

					// Return the entire array.
					return( LOCAL.DataArray );

					}
			}

			// Ram Parvatini 01/20/2015
			// ======================================================================================
			// CheckJsonBody()
			// Make sure the request is posted with parameters in the request body
			// ======================================================================================
			private any function CheckJsonBody() {
				local.requestBody = toString( getHttpRequestData().content );

				// Double-check to make sure it's a JSON value.
				if(!isJSON(local.requestBody))	{
					local.response =
						{ bSuccess= false
						, tData   = {}
						, aErrors = ["BadDataFormat: Data format was not JSON: '#local.requestBody#'"]
						};
				
					abort;
				}else{
					// Return the structure -- name-value pairs, such as
					return deserializeJson( local.requestBody );
				}
			}

}