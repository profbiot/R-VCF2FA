library(shiny)

#Define two UI functions for file input tools for vcf and fasta formats
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
              accept = c(".fa",".fasta",".fna"))
  )
}

# Define UI for VCF to FASTA App
# Sidebar panel for user interaction (upload/download)
# Main panel to preview data/results

fluidPage(
  # Include css style sheet
  includeCSS("styles.css"),
  
  # App title ----
  titlePanel(h1("Endicott College Bioinformatics: VCF2FA"), "Shiny App for Unit 1 Project"),
  tags$hr(),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a vcf file ----
      VCF_UI("test1"),
      actionButton("pvButton", h6("Preview vcf file")),
      # Horizontal line, provides spacing
      tags$hr(),
      # Input: Select a file ----
      fasta_UI("test2"),
      # Horizontal line, provides spacing
      tags$b("Select range for output FASTA file\n"),
      textInput(inputId="startBase", "Enter first base of gene or region of interest"),
      textInput(inputId="endBase", "Enter last base of gene or region of interest"),
      tags$b("Download modified FASTA file\n"),
      # Horizontal line, provides spacing
      tags$hr(),
      downloadButton('downloadData', 'Download')
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Preview Original FASTA 
      h4("FASTA sequence sliced from first base to last base"),
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

