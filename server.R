testing123 <- c('>My Fasta header','GCGATGATCGTAGT')

function(input, output) {

  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    req(input$pvButton)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.table(input$file1$datapath,
                         header = FALSE,
                         sep = '\t')
        names(df)<- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','VALUES')
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    #return(head(df))
    return(df)
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(

    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
		  paste("Modified", "fa", sep = ".")
	  },

    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      # Write to a file specified by the 'file' argument
      write.table(testing123, file, sep = "\t",col.names=FALSE,row.names = FALSE,quote=FALSE)
    }
  )
}
