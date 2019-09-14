<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns="http://tei-c.org/ns/1.0"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 13, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> Joey Takeda</xd:p>
            <xd:p>This stylesheet convert the tesseract HOCR (html-OCR) format into a standardized TEI
            format.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!--We're outputting the XHTML-ish to TEI-->
    <xsl:output method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//body"/>
    </xsl:template>
    
    <xsl:template match="body">
        <TEI xml:id="HisRoyalNibs">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>His Royal Nibs</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>TBA</p>
                    </publicationStmt>
                    <sourceDesc>TBA</sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:apply-templates/>
                </body>
            </text>
   
        </TEI>
    </xsl:template>
    
    <!--Each page is a <div> but we want to flatten that in the TEI output,
        so create a self-closing <pb/> milestone and process its contents-->
    <xsl:template match="div[@class='ocr_page']">
        <!--We started at page 7-->
        <pb n="{count(preceding::div[@type='ocr_page']) + 7}"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--Just process the inner contents of the ocr-area-->
    <xsl:template match="div[@class='ocr_carea']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--Now we're in an interesting situation where the first para is almost always the header
        and the last is always the page number-->
    
    <!--TO DO: Fix this: the templates have to be a bit smarter at detecting what precisely is going on here.
        
        It might be better to do this in a few passes:
        1) Get rid of the spans completely and normalize spacing
        2) Then, determine various structural components using string match (i.e. if something matches ^\s*\[\s*\d+\s*\]\s*$
        then it's a page number. If something matches HIS ROYAL NIBS,
        then it's a heading. And then we can also determine chapter headings, and then use that heading to create a better structure overall.
        
        The overall goal will be to create a number of analytic outputs for the digital edition, including various speech prefixes and other textual tools (perhaps a Bechdel test type interface, et cetera) in order to create a full edition.
        
        I also need to discuss with MC what sort of project this could be: it could, on the one hand, be an edition built outside of the WEA constraints (since there are many for that archive) but that I then contribute a "santized" version that elimainates much of the dense encoding. It would also need to then receive the texts from the WEA; perhaps part of the project could then be a crosswalk from this structure to the WEA's?-->
        
        -->
    <xsl:template match="p[@class='ocr_par']">
        <xsl:if test="string-join(descendant::text(),'') => normalize-space() => string-length() gt 0">
            <xsl:variable name="thisPara" select="."/>
            <xsl:variable name="thisBlock" select="parent::div"/>
            <xsl:variable name="thisParaIsFirstPara" select="empty($thisBlock/preceding-sibling::div)" as="xs:boolean"/>
            <xsl:variable name="thisParaIsLastPara" select="empty($thisBlock/following-sibling::div)" as="xs:boolean"/>
            <xsl:element name="{if ($thisParaIsFirstPara or $thisParaIsLastPara) then 'fw' else 'p'}">
                <xsl:if test="$thisParaIsFirstPara or $thisParaIsLastPara">
                    <xsl:attribute name="type" select="if ($thisParaIsFirstPara) then 'header' else 'pageNum'"/>               
                </xsl:if>
                
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
     
    </xsl:template>
    <xsl:template match="p/text()"/>
    
    <xsl:template match="span[@class='ocr_line']">
        <xsl:if test="exists(preceding-sibling::span[@class='ocr_line'])"><xsl:text>&#x9;&#x9;&#x9;&#xA;</xsl:text><lb/></xsl:if><xsl:value-of select="string-join(span/text(),' ')"/>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>