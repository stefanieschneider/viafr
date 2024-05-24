<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:void="http://rdfs.org/ns/void#"
            xmlns:ns1="http://www.loc.gov/zing/srw/"
            xmlns:ns2="http://viaf.org/viaf/terms#"
            xmlns:ns4="http://www.loc.gov/zing/cql/xcql/"
           xmlns:xsd="http://www.w3.org/2001/XMLSchema"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
           exclude-result-prefixes="foaf owl rdf void ns1 xsi"
version="1.0" type="text" >

<xsl:output method="xml" encoding="UTF-8" />

<xsl:param name="viafrversion" />
<xsl:param name="now" />

<xsl:template match="searchRetrieveResponse" >
    <xsl:apply-templates select="ns1:records/ns1:record/ns1:recordData/ns2:VIAFCluster" />
</xsl:template>

<xsl:template match="ns1:version" />
<xsl:template match="ns1:numberOfRecords" />
<xsl:template match="ns1:resultSetIdleTime" />
<xsl:template match="ns1:recordSchema" />
<xsl:template match="ns1:recordPacking" />
<xsl:template match="ns1:recordPosition" />
<xsl:template match="ns1:extraResponseData" />
<xsl:template match="ns1:echoedSearchRetrieveRequest" />

<xsl:template match="ns2:VIAFCluster">
<xsl:variable name="viafID" select="ns2:viafID" />
<xsl:variable name="viafType" select="ns2:nameType" />
<xsl:variable name="viafUpdate" select="ns2:creationtime" />
<names>
    <xsl:attribute name="viafid"><xsl:value-of select="$viafID" /></xsl:attribute>
    <xsl:attribute name="viafrVersion"><xsl:value-of select="$viafrversion" /></xsl:attribute>
    <xsl:attribute name="processDate"><xsl:value-of select="$now" /></xsl:attribute>
    <xsl:apply-templates select="ns2:mainHeadings/ns2:mainHeadingEl">
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="'TRUE'" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
    </xsl:apply-templates>
    <xsl:apply-templates select="ns2:x400s/ns2:x400">
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="'FALSE'" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
    </xsl:apply-templates>
    <!-- NDL puts maiden names in x500 -->
    <xsl:if test="ns2:x500s/ns2:x500/ns2:sources/ns2:s = 'NDL'" >
        <xsl:apply-templates select="ns2:x500s/ns2:x500" mode="NDL" >
            <xsl:with-param name="viafID" select="$viafID" />
            <xsl:with-param name="viafType" select="$viafType" />
            <xsl:with-param name="preferred" select="'FALSE'" />
            <xsl:with-param name="viafUpdate" select="$viafUpdate" />
        </xsl:apply-templates>
    </xsl:if>
</names>
</xsl:template>

<xsl:template match="ns2:x500s/ns2:x500" mode="NDL" >
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="preferred"/>
    <xsl:param name="viafUpdate"/>
    <xsl:variable name="normName" ><xsl:value-of select="ns2:datafield/ns2:normalized" /></xsl:variable>
    <xsl:variable name="dispName" >
        <xsl:apply-templates select="ns2:datafield[@tag='500']" mode="naming" />
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns2:datafield/@tag" />
    </xsl:variable>
    <xsl:apply-templates select="ns2:sources/ns2:s" mode="naming" >
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="$preferred" />
        <xsl:with-param name="tag" select="$tag" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
        <xsl:with-param name="normName" select="$normName" />
        <xsl:with-param name="dispName" select="$dispName" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns2:x400s/ns2:x400">
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="preferred"/>
    <xsl:param name="viafUpdate"/>
    <xsl:variable name="normName" ><xsl:value-of select="ns2:datafield/ns2:normalized" /></xsl:variable>
    <xsl:variable name="dispName" >
        <xsl:apply-templates select="ns2:datafield[@tag='400']" mode="naming" />
        <xsl:apply-templates select="ns2:datafield[@tag='100']" mode="naming" />
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns2:datafield/@tag" />
    </xsl:variable>
    <xsl:apply-templates select="ns2:sources/ns2:s" mode="naming" >
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="$preferred" />
        <xsl:with-param name="tag" select="$tag" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
        <xsl:with-param name="normName" select="$normName" />
        <xsl:with-param name="dispName" select="$dispName" />
    </xsl:apply-templates>
</xsl:template>


<xsl:template match="ns2:mainHeadings/ns2:mainHeadingEl">
    <xsl:param name="viafID"/>
    <xsl:param name="viafType" />
    <xsl:param name="preferred"/>
    <xsl:param name="viafUpdate"/>
    <xsl:variable name="normName" ><xsl:value-of select="ns2:datafield/ns2:normalized" /></xsl:variable>
    <xsl:variable name="dispName" >
        <xsl:apply-templates select="ns2:datafield" mode="naming" />
    </xsl:variable>
    <xsl:variable name="tag" >
        <xsl:value-of select="ns2:datafield/@tag" />
    </xsl:variable>
    <xsl:apply-templates select="ns2:sources/ns2:s" mode="naming" >
        <xsl:with-param name="viafID" select="$viafID" />
        <xsl:with-param name="viafType" select="$viafType" />
        <xsl:with-param name="preferred" select="$preferred" />
        <xsl:with-param name="tag" select="$tag" />
        <xsl:with-param name="viafUpdate" select="$viafUpdate" />
        <xsl:with-param name="normName" select="$normName" />
        <xsl:with-param name="dispName" select="$dispName" />
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="ns2:sources/ns2:s" mode="naming" >
        <xsl:param name="viafID" />
        <xsl:param name="viafType" />
        <xsl:param name="preferred" />
        <xsl:param name="tag"  />
        <xsl:param name="viafUpdate" />
        <xsl:param name="normName" />
        <xsl:param name="dispName" />
    <row>
    <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
    <viafType ct="character"><xsl:value-of select="$viafType" /></viafType>
    <preferred ct="logical"><xsl:value-of select="$preferred" /></preferred>
    <tag ct="character"><xsl:value-of select="$tag" /></tag>
    <dispName ct="character"><xsl:value-of select="$dispName" /></dispName>
    <!--<normName ct="character"><xsl:value-of select="$normName" /></normName>-->
    <source ct="character"><xsl:value-of select="." /></source>
    <!--<sourceid ct="character"><xsl:apply-templates select="following-sibling::ns2:sid[1]" /></sourceid>-->
    <viaf-update ct="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
    <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
    </row>
</xsl:template>

<xsl:template match="ns2:datafield[@tag='510']" mode="naming" />

<xsl:template match="ns2:datafield[@dtype='MARC21' and @tag='100']" mode="naming" >
    <xsl:apply-templates select="ns2:subfield" />
</xsl:template>

<xsl:template match="ns2:datafield[@dtype='MARC21' and @tag='400']" mode="naming" >
    <xsl:apply-templates select="ns2:subfield" />
</xsl:template>

<xsl:template match="ns2:datafield[@dtype='MARC21' and @tag='700']" mode="naming" >
    <xsl:apply-templates select="ns2:subfield" />
</xsl:template>

<xsl:template match="ns2:datafield[@dtype='UNIMARC' and @tag='200']" mode="naming" >
    <xsl:apply-templates select="ns2:subfield" />
</xsl:template>

<xsl:template match="ns2:subfield[@code='a']" ><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns2:subfield[@code='b']" ><xsl:text>, </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns2:subfield[@code='c']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns2:subfield[@code='d']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns2:subfield[@code='f']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns2:subfield[@code='q']" ><xsl:text> </xsl:text><xsl:value-of select="." /></xsl:template>
<xsl:template match="ns2:subfield[@code='7']" />
<xsl:template match="ns2:subfield[@code='8']" />
<xsl:template match="ns2:subfield[@code='9']" />



</xsl:stylesheet>