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
            <xd:p><xd:b>Created on:</xd:b> Nov 18, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> joeytakeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="div[@type='chapter']">
        <xsl:processing-instruction name="include">href="chapter<xsl:value-of select="@n"/>.xml"</xsl:processing-instruction>
        <xsl:result-document href="chapter{@n}.xml">
            <xsl:copy-of select="."/>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>