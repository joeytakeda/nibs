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
            <xd:p><xd:b>Created on:</xd:b> January 19, 2020</xd:p>
            <xd:p><xd:b>Author:</xd:b> joeytakeda</xd:p>
            <xd:p>This stylesheet cleans up some of the encoding,g etting rid of a number of features
            that I have decided are not editorially necessary. These are features like lbs, and fws, which 
            are not part of the editorialr remit.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:output indent="true" suppress-indentation="p seg"/>
    <xsl:template match="p[following-sibling::*[1]/self::pb]">
        <xsl:variable name="nextP" select="following-sibling::p[1]"/>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        <xsl:if test="matches($nextP/text()[1],'^\s*[a-z]')">
            <xsl:copy-of select="following-sibling::pb[1]"/>
            <xsl:text> </xsl:text>
            <xsl:sequence select="$nextP/node()"/>
        </xsl:if>    
        </xsl:copy>
        
    </xsl:template>
    
    <xsl:template match="pb[following-sibling::*[1]/self::p[matches(text()[1],'^\s*[a-z]')]]"/>
    
    <xsl:template match="p[preceding-sibling::*[1]/self::pb]">
        <xsl:if test="not(matches(text()[1],'^\s*[a-z]'))">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <!--Clean up any lingering problems-->
    <xsl:template match="lb"/>
    
    
    
    <!--Automatic stutter tagging where possible-->
   <!-- <xsl:template match="text()[not(ancestor::seg[@type='stutter'])]">
        <xsl:analyze-string select="." regex="(([A-Za-z]+-[A-Za-z]+-?)+)">
            <xsl:matching-substring>
                <seg type="stutter">
                    <xsl:value-of select="."/>
                </seg>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
        
        
    </xsl:template>
    -->
</xsl:stylesheet>