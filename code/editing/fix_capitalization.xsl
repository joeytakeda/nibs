<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Sep 14, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> joeytakeda</xd:p>
            <xd:p>This stylesheet, which is a simple identity transform,
            takes the capitals found in headings and in hi tags and editorially
            regularizes them.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!--This is an identity transform-->
    <xsl:mode name="#default" on-no-match="shallow-copy"/>
    
    <xsl:template match="div[@type='chapter']/head">
        <xsl:copy>
            <xsl:value-
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>