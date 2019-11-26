library(seqinr)
library(stringr)

function(input, output) {
  #Format as a table preview of the vcf file
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
  
  #Show reference fasta sequence in selected range
  output$value2 <- renderText({
    req(input$file1)
    req(input$file2)
    req(input$startBase)
    req(input$endBase)
    
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
    
    last <- nrow(df)
    
    tryCatch(
      {
        df2 <- read.fasta(input$file2$datapath, as.string=TRUE)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    test<-df2[[1]]
    myString <-gsub(" ","",test, fixed=FALSE)
    myString2 <-substr(myString, input$startBase,input$endBase)
    return(myString2)
  })
  
  #Show alt fasta sequence in selected range
  output$value3 <- renderText({
    req(input$file1)
    req(input$file2)
    req(input$startBase)
    req(input$endBase)
    
    tryCatch(
      {
        df2 <- read.fasta(input$file2$datapath, as.string=TRUE)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
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
    
    last <- nrow(df)
    test<-df2[[1]]
    myString <-gsub(" ","",test, fixed=FALSE)
    myString2 <-substr(myString, input$startBase,input$endBase)

    for (i in 1:last){
      pos<-df[i,2]-as.numeric(input$startBase)+1
      substr(myString2, pos, pos) <- as.character(df[i,5])
    }
    
    return(myString2)

    
  })
  
  thedata <- renderText({
    req(input$file1)
    req(input$file2)
    req(input$startBase)
    req(input$endBase)
    
    tryCatch(
      {
        df2 <- read.fasta(input$file2$datapath, as.string=TRUE)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
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

    last <- nrow(df)
    test<-df2[[1]]
    myString <-gsub(" ","",test, fixed=FALSE)
    myString2 <-substr(myString, input$startBase,input$endBase)
    
    for (i in 1:last){
      pos<-df[i,2]-as.numeric(input$startBase)+1
      substr(myString2, pos, pos) <- as.character(df[i,5])
    }
    
    return(myString2)
    
    
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
      write.table(thedata(), file, sep = "\t",col.names=">Modified_FASTA",row.names = FALSE,quote=FALSE)
    }
  )
}
