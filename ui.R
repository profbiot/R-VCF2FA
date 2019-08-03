library(shiny)
library(seqinr)
library(stringr)

#Define UI functions for file input tools
VCF_UI <- function(id) {
  ns = NS(id)
  
  list(
    textOutput(ns("output_area")), 
    fileInput("file1", "Choose VCF File",
              multiple = FALSE,
              accept = ".vcf")
  )
}

fasta_UI <- function(id) {
  ns = NS(id)
  
  list(
    textOutput(ns("output_area")), 
    fileInput("file2", "Choose Reference FASTA File",
              multiple = FALSE,
              accept = c(".fa",".fasta"))
  )
}

# Define UI for VCF to FASTA App
# Sidebar panel for user interaction (upload/download)
# Main panel to preview data/results

fluidPage(
  # App title ----
  titlePanel("VCF to FASTA Processing"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      VCF_UI("test1"),
      actionButton("pvButton", "Preview vcf file"),
      # Horizontal line, provides spacing
      tags$hr(),
      # Input: Select a file ----
      fasta_UI("test2"),
      # Horizontal line, provides spacing
      tags$b("Download modified FASTA file\n"),
      tags$hr(),
      downloadButton('downloadData', 'Download')
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Preview Original FASTA 
      h4("FASTA sequence sliced from first variant to last variant"),
      div(style="width:500px;",verbatimTextOutput("value2")),

      # Output: Preview Modified FASTA
      h4("Alternative FASTA sequence, variants capitalized"),
      div(style="width:500px;",verbatimTextOutput("value3")),

      # Output: Preview VCF file
      h4("Preview Data from VCF File"),
      tableOutput("contents")
    )
  )
) 

