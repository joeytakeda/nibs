<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:jt="https://github.com/joeytakeda"
    exclude-result-prefixes="#all"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Oct 10, 2019</xd:p>
            <xd:p><xd:b>Author:</xd:b> joeytakeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    

    <xsl:variable name="path" select="replace(document-uri(.),'HisRoyalNibs.xml','')"/>
    <xsl:variable name="doc" select="."/>
    
    <xsl:variable name="glossary" select="document($path || 'glossary.xml')"/>
    
    <xsl:variable name="bibliography" select="document($path || 'bibliography.xml')"/>
    
    <xsl:variable name="places" select="document($path || 'places.xml')"/>
    
    <xsl:template match="TEI">
        <xsl:call-template name="makeRobots"/>
        <xsl:call-template name="createIndex"/>
        <xsl:call-template name="createChapters"/>
    </xsl:template>
    
    <xsl:template name="makeRobots">
        <xsl:result-document href="site/robots.txt" method="text">
            User-agent: * 
            Disallow: /
        </xsl:result-document>
    </xsl:template>
    
    <xsl:variable name="toc">
        <tei:list>
            <xsl:for-each select="//processing-instruction('include')/jt:getChapter(.)">
                <tei:item>
                    <tei:ref target="chapter{@n}.html">Chapter <xsl:value-of select="@n"/></tei:ref>
                </tei:item>
            </xsl:for-each>
        </tei:list>
        
    </xsl:variable>
    
    
    
    
    <xsl:template name="createIndex">
        <xsl:result-document href="site/index.html">
            <html id="index">
                <head>
                    <title>His Royal Nibs: A Critical Digital Edition</title>
                    <xsl:call-template name="addHeaderElements"/>
                    <script src="js/typewriter.js"/>
                </head>
                <body>
                    <main>
                        <header>
                            <div id="heading-box">
                                <div id="heading-card">
                                    <h1>
                                        <span id="title">His Royal Nibs</span>
                                        <span id="attribution">By</span>
                                        <span id="byline">Winnifred Eaton</span>
                                    </h1>
                                </div>
                            </div>
                        </header>
                        <section>
                            <h2>Chapters</h2>
                            <ul id="index-toc">
                                <xsl:for-each select="//processing-instruction('include')/jt:getChapter(.)">
                                    <li>
                                        <a href="chapter{@n}.html">
                                            <div class="ch-num">
                                                <span class="num"><xsl:value-of select="@n"/></span>
                                            </div>
                                            <div class="snippet">
                                                <xsl:apply-templates select="p[1]" mode="snippet"/>
                                            </div>
                                        </a></li>
                                </xsl:for-each>
                            </ul>
                        </section>
                        
                    </main>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template name="createChapters">
        <xsl:apply-templates select="//processing-instruction('include')/jt:getChapter(.)" mode="html"/>
    </xsl:template>
    
    <xsl:template match="div[@type='chapter']" mode="html">
        <xsl:variable name="chapterNumber" select="@n"/>
        <xsl:result-document href="site/chapter{$chapterNumber}.html">
            <html id="chapter{$chapterNumber}">
                <head>
                    <title>Chapter <xsl:value-of select="$chapterNumber"/></title>
                    <xsl:call-template name="addHeaderElements"/>
                </head>
                <body>
                    <xsl:call-template name="makeChaptersToc"/>
                    <main>
                        <article>
                            <xsl:apply-templates mode="#current"/>
                        </article>
                        <div id="appendix">
                            <xsl:call-template name="createAnnotations"/>
                        </div>
                        <div id="popup">
                            <div id="popup_controls">
                                <span id="prevAnn">Previous</span>
                                <span id="nextAnn">Next</span>
                                <span id="popup_closer">X</span>
                            </div>
                            <div id="popup_content"></div>
                        </div>
                    </main>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template name="makeChaptersToc">
        <aside id="toc">
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="search.html">Search</a></li>
                <li><a href="introduction.html">Critical Introduction</a></li>
                <li><a href="digital-text.html">Note on the Digital Text</a></li>
                <li>The Text
                    <ul>
                        <xsl:apply-templates select="$doc//processing-instruction('include')/jt:getChapter(.)" mode="toc"/>
                    </ul>
                </li>
                <li><a href="appendix.html">Appendices</a></li>
            </ul>
        </aside>
    </xsl:template>
    
    <xsl:template match="div[@type='chapter']" mode="toc">
        <li><a href="chapter{@n}.html">Chapter <xsl:value-of select="@n"/></a></li>
    </xsl:template>
    
    <!--Snippet mode-->
    
    <xsl:template match="note | fw | pb | br | pc" mode="snippet"/>
    
    <xsl:template match="term | placeName | p" mode="snippet">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template name="createAnnotations">
        <xsl:if test="descendant::note">
            <section id="notes">
                <h2>Notes</h2>
                <xsl:apply-templates select="descendant::note[@type='editorial']" mode="appendix"/>
            </section>
        </xsl:if>
        
        <xsl:if test="descendant::term[@ref]">
            <section id="glossary">
                <h2>Glossary</h2>
                <xsl:for-each select="distinct-values(descendant::term/@ref)">
                    <xsl:variable name="termId" select="substring-after(.,'gls:')"/>
                    <xsl:apply-templates select="document($path || 'glossary.xml')//item[@xml:id=$termId]" mode="appendix"/>
                </xsl:for-each>
            </section>
        </xsl:if>
        
        <xsl:if test="descendant::placeName[@ref]">
            <section id="places">
                <h2>Places</h2>
                <xsl:for-each select="distinct-values(descendant::placeName/@ref)">
                    <xsl:variable name="placeId" select="substring-after(.,'plc:')"/>
                    <xsl:apply-templates select="$places//place[@xml:id=$placeId]" mode="appendix"/>
                </xsl:for-each>
            </section>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="item[parent::list[@type='glossary']]" mode="appendix">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="list[@type='glossary']/item/label" mode="appendix">
        <h3>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </h3>
    </xsl:template>
    
    <xsl:template match="list[@type='glossary']/item/gloss[@source]" mode="appendix">
        <xsl:variable name="thisSource" select="substring-after(@source,'bibl:')"/>
        <div>
            <xsl:call-template name="processAtts"/>
            <span class="abbr"><xsl:value-of select="$bibliography//bibl[@xml:id=$thisSource]/@n"/></span>
            <div class="content">
                <xsl:apply-templates mode="html"/>
            </div>
        </div>
    </xsl:template>
    
    
    <xsl:template match="place" mode="appendix">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:if test="location/geo">
                <xsl:variable name="geo" select="location/geo/normalize-space(.)"/>
                <xsl:attribute name="data-lat" select="normalize-space(tokenize($geo,',')[1])"/>
                <xsl:attribute name="data-lon" select="normalize-space(tokenize($geo,',')[2])"/>
            </xsl:if>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="placeName" mode="appendix">
        <h3>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="html"/>
        </h3>
    </xsl:template>
    
    <xsl:template match="place/location[geo]" mode="appendix">
        <div class="map"></div>
    </xsl:template>
   
   
   <xsl:template match="linkGrp[ptr]" mode="appendix">
       <div>
           <xsl:call-template name="processAtts"/>
           <h4>See also:</h4>
           <ul>
               <xsl:for-each select="ptr">
                   <li>
                       <xsl:apply-templates select="." mode="#current"/>
                   </li>
               </xsl:for-each>
           </ul>
       </div>
   </xsl:template>
    
    <xsl:template match="ptr" mode="appendix html">
        <a href="{@target}">
            <xsl:value-of select="if (@n) then @n else @target"/>
        </a>
    </xsl:template>
     
 
    
    <xsl:template match="note[@type='editorial']" mode="appendix">
        <div class="noteContainer">
            <span class="noteNum"></span>
            <div>
                <xsl:call-template name="processAtts">
                    <xsl:with-param name="id" select="'note_'||jt:getNoteNum(.)"/>
                </xsl:call-template>
                <xsl:apply-templates mode="#current"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="head" mode="html">
        <h2>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </h2>
    </xsl:template>
    
    <xsl:template match="p | fw" mode="html">
        <div>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="term | placeName" mode="html">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="term[@ref] | placeName[@ref]" mode="html">
        <a href="#{substring-after(@ref,':')}">
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </a>
    </xsl:template>
   
   <xsl:template match="text()[following-sibling::node()[1][self::pc]]" mode="html">
       <xsl:value-of select="replace(.,'\s+$','')"/>
   </xsl:template>
    
    <xsl:template match="text()[preceding-sibling::node()[1][self::pc]]" mode="html">
        <xsl:value-of select="replace(.,'^\s+','')"/>
    </xsl:template>
   
    <xsl:template match="note[@type='editorial']" mode="html">
        <a class="noteMarker" href="#note_{jt:getNoteNum(.)}"><xsl:value-of select="jt:getNoteNum(.)"/></a>
    </xsl:template>
    
    <xsl:template match="note[@type='questionForMC']" mode="html">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="seg" mode="html">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
   
   <xsl:template match="choice[sic and corr]" mode="html">
       <span>
           <xsl:call-template name="processAtts"/>
           <xsl:apply-templates select="node()[not(self::sic)]" mode="#current"/>
       </span>
   </xsl:template>
    
    <xsl:template match="pc" mode="html">
        <span>
            <xsl:call-template name="processAtts"/>
        </span>
    </xsl:template>
    
    <xsl:template match="pb" mode="html">
        <hr>
            <xsl:call-template name="processAtts"/>
        </hr>
    </xsl:template>
    
    <xsl:template match="said | q | soCalled | title[@level='a'] | quote" mode="snippet html">
        <span>
            <xsl:call-template name="processAtts"/>
            <xsl:value-of select="jt:getOQ(.)"/>
            <xsl:apply-templates mode="#current"/>
            <xsl:value-of select="jt:getCQ(.)"/>
        </span>   
    </xsl:template>
    
    
    <xsl:function name="jt:getChapter" as="element(div)">
        <xsl:param name="pi"/>
        <xsl:variable name="dq">"</xsl:variable>
        <xsl:variable name="whatChapter" select="translate($pi, $dq, '') => substring-after('href=')" as="xs:string"/>
        <xsl:message><xsl:value-of select="$pi"/></xsl:message>
        <xsl:message expand-text="yes">{$whatChapter}</xsl:message>
        <xsl:sequence select="document(($path || '/' || $whatChapter))/div"/>
    </xsl:function>
   
    
    <xsl:template match="lb" mode="html">
        <br>
            <xsl:call-template name="processAtts"/>
        </br>
    </xsl:template>
    
  
    
    <!--**************************************************************
       *                                                            * 
       *                   ATTRIBUTES                               *
       *                                                            *
       **************************************************************-->
    
    <xsl:template match="@xml:id" mode="html">
        <xsl:attribute name="id" select="."/>
    </xsl:template>
    
    <xsl:template match="@xml:lang" mode="html">
        <xsl:attribute name="lang" select="."/>
    </xsl:template>
    
    <xsl:template match="@rendition" mode="html">
        <xsl:param name="classes" as="xs:string*" tunnel="yes"/>
        <xsl:variable name="theseVals" select="translate(.,'#','')"/>
        <xsl:attribute name="class" select="string-join(($classes,$theseVals),' ')"/>
    </xsl:template>
    
    <!--Just copy out style-->
    <xsl:template match="@style" mode="html">
        <xsl:attribute name="style" select="."/>
    </xsl:template>
    
    
    <!--By default, delete all attributes from being processed
    as text.-->
    <xsl:template match="@*" priority="-1" mode="html"/>
    
    <xsl:template name="processAtts">
        <xsl:param name="classes" as="xs:string*"/>
        <xsl:param name="id" as="xs:string?"/>
        
        <!--First, create the data-el attribute-->
        <xsl:attribute name="data-el" select="local-name(.)"/>
        
        <!--Now fork and give some warnings (if desired)-->
        <xsl:choose>
            <!--If the class parameter is supplied-->
            <xsl:when test="not(empty($classes))">
                <xsl:choose>
                    <!--They'll be added if there's a rendition declared, so leave it-->
                    <xsl:when test="@rendition"/>
                    <!--Otherwise, create a class attribute-->
                    <xsl:otherwise>
                        <xsl:attribute name="class" select="$classes"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!--If the id parameter is supplied-->
            <xsl:when test="not(empty($id) or normalize-space($id)='')">
               
                <!--Break right away if the @xml:id is badly formed-->
                <xsl:if test="matches(normalize-space($id),'^\d+|:|\s+')">
                    <xsl:message terminate="yes">BAD ID: <xsl:value-of select="$id"/></xsl:message>
                </xsl:if>
                <!--If it's fine, then see if there's already an @xml:id on this object-->
                <xsl:choose>
                    <xsl:when test="not(@xml:id)">
                        <!--If there isn't an xml:id, then create an @id-->
                        <xsl:attribute name="id" select="normalize-space($id)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        
                        <xsl:message>ERROR: Element <xsl:value-of select="local-name(.)"/> already has declared id <xsl:value-of select="@xml:id"/>. Added
                            <xsl:value-of select="$id"/> will have no effect.</xsl:message>
                        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        
        <!--Iterate through each @attribute and add it as a data-att-->
        <xsl:for-each select="@*[not(local-name()=('xml:id','id','lang','xml:lang','style','rendition','rend'))]">
            <xsl:attribute name="{concat('data-',local-name())}" select="."/>
        </xsl:for-each>
        
        <!--And now apply templates to the attributes in mode tei-->
        <xsl:apply-templates select="@*" mode="html">
            <xsl:with-param name="classes" select="$classes" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template name="addHeaderElements">
        <!--META TAGS WILL GO HERE AT SOME TIME-->
        <link rel="stylesheet" href="css/reset.css"/>
        <link rel="stylesheet" href="css/fonts.css"/>
        <link rel="stylesheet" href="css/hrn.css"/>
        <xsl:if test="descendant::placeName[@ref]">
            <link rel="stylesheet" href="css/leaflet.css"/>
            <script src="js/leaflet.js"/>
        </xsl:if>
        <script src="js/hrn.js"/>
    </xsl:template>
    
    
    
    <xsl:function name="jt:getNoteNum" as="xs:integer">
        <xsl:param name="note" as="element(note)"/>
        <xsl:variable name="thisChapter" select="$note/ancestor::div[@type='chapter'][1]" as="element(div)"/>
        <xsl:value-of select="count($note/preceding::note[@type='editorial'][ancestor::*[. is $thisChapter]]) + 1"/>
    </xsl:function>
    
    <xsl:function name="jt:getOQ">
        <xsl:param name="el"/>
        <xsl:variable name="nestCount" select="count($el/ancestor::said | $el/ancestor::q | $el/ancestor::soCalled | $el/ancestor::title[@level='a'])" as="xs:integer"/>
        <xsl:variable name="isEven" select="$nestCount mod 2 = 0" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$isEven"><xsl:text>“</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>‘</xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="jt:getCQ">
        <xsl:param name="el"/>
        <xsl:variable name="nestCount" select="count($el/ancestor::said | $el/ancestor::q | $el/ancestor::soCalled | $el/ancestor::title[@level='a'])" as="xs:integer"/>
        <xsl:variable name="isEven" select="$nestCount mod 2 = 0" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$isEven"><xsl:text>”</xsl:text></xsl:when>
            <xsl:otherwise>’</xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
</xsl:stylesheet>