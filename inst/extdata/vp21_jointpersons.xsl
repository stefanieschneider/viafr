<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:v="http://viaf.org/viaf/terms#"
            xmlns:mx="http://www.loc.gov/MARC21/slim"
           xmlns:srw="http://www.loc.gov/zing/srw/"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
           exclude-result-prefixes="v mx srw xs xsl"
version="1.0" type="text" >

<xsl:output method="xml" encoding="UTF-8" />

<xsl:param name="viafrversion" />
<xsl:param name="now" />
<xsl:param name="viafID" />
<xsl:param name="viafType" />

<xsl:template match="mx:datafield[@tag='950']" >
<xsl:param name="source" />
<xsl:param name="sourceid" />
<xsl:param name="update" />
<row>
    <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
    <viafType ct="character"><xsl:value-of select="$viafType" /></viafType>
    <source ct="character"><xsl:value-of select="$source" /></source>
    <sourceID ct="character"><xsl:value-of select="$sourceid" /></sourceID>
    <nameType ct="character">Personal</nameType>
    <normName ct="character"><xsl:value-of select="mx:subfield[@code='a']" /></normName>
    <dispName ct="character">
        <xsl:apply-templates select="mx:subfield[@code='A']" />
    </dispName>
    <source.update ct="POSIXct"><xsl:value-of select="$update" /></source.update>
    <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
</row>
</xsl:template>

<xsl:template match="mx:subfield[@code='A']" >
<xsl:value-of select="text()" />
    <xsl:apply-templates select="following-sibling::mx:subfield" />
</xsl:template>

<xsl:template match="mx:subfield[@code='d']" ><xsl:text> </xsl:text><xsl:value-of select="text()" /></xsl:template>
<xsl:template match="mx:subfield[@code='b']" ><xsl:text>, </xsl:text><xsl:value-of select="text()" /></xsl:template>
<xsl:template match="mx:subfield[@code='c']" ><xsl:text> </xsl:text><xsl:value-of select="text()" /></xsl:template>
<xsl:template match="mx:subfield[@code='f']" ><xsl:text> </xsl:text><xsl:value-of select="text()" /></xsl:template>
<xsl:template match="mx:subfield[@code='9']" />

<!--
<xsl:template match="mx:datafield[@tag='950']" >
<xsl:param name="source" />
<xsl:param name="sourceid" />
<xsl:param name="update" />
<row>
    <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
    <viafType ct="character"><xsl:value-of select="$viafType" /></viafType>
    <source ct="character"><xsl:value-of select="$source" /></source>
    <sourceID ct="character"><xsl:value-of select="$sourceid" /></sourceID>
    <nameType ct="character">Personal</nameType>
    <normName ct="character"><xsl:value-of select="mx:subfield[@code='a']" /></normName>
    <dispName ct="character">
        <xsl:value-of select="mx:subfield[@code='A']" />
        <xsl:if test="mx:subfield[@code='b']">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="mx:subfield[@code='b']" />
        </xsl:if>
        <xsl:if test="mx:subfield[@code='f']">
        <xsl:text> </xsl:text>
        <xsl:value-of select="mx:subfield[@code='f']" />
        </xsl:if>
        <xsl:if test="mx:subfield[@code='d']">
        <xsl:text> </xsl:text>
        <xsl:value-of select="mx:subfield[@code='d']" />
        </xsl:if>
    </dispName>
    <viaf.update ct="POSIXct"><xsl:value-of select="$update" /></viaf.update>
    <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
</row>
</xsl:template>
-->

<xsl:template match="mx:record">
    <xsl:variable name="source">
        <xsl:value-of select="mx:controlfield[@tag='003']" />
    </xsl:variable>
    <xsl:variable name="sourceid">
        <xsl:value-of select="mx:controlfield[@tag='001']" />
    </xsl:variable>
    <!-- Examples of time stamps
        BIBSYS 20240223071421.0
        BLBNB  20010713131114.5
        BNF    20240105
        CAOONL 20200415000000.0
        DNB    20210710062609.0
        ISNI   20240119162648.0
        J9U    20231116102332.0
        NDL    20240213095107.0
        NII    20230615104740.0
        RERO   20190129160218.0
        SUDOC  202403011641.3
        WKP    20240321001053.0
    -->
    <xsl:variable name="update">
        <xsl:variable name="rd" >
        <xsl:choose>
            <xsl:when test="$source != 'BNF'" >
                <xsl:value-of select="mx:controlfield[@tag='005']" />
            </xsl:when>
            <xsl:when test="mx:datafield[@tag='100']"><!--<<xsl:text>20240501</xsl:text>-->
                <xsl:value-of select="mx:datafield[@tag='100']/mx:subfield[1]" />
            </xsl:when>
            <xsl:otherwise><xsl:text>20240101</xsl:text></xsl:otherwise>
        </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="substring($rd, 1,4)" />
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($rd, 5,2)" />
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($rd, 7,2)" />
        <xsl:choose>
            <xsl:when test="string-length($rd) = 16">
                <xsl:value-of select="substring($rd, 9,2)" />
                <xsl:text>:</xsl:text>
                <xsl:value-of select="substring($rd, 11,2)" />
                <xsl:text>:</xsl:text>
                <xsl:value-of select="substring($rd, 13,2)" />
                </xsl:when>
            <xsl:when test="string-length($rd) = 14">
                <xsl:value-of select="substring($rd, 9,2)" />
                <xsl:text>:</xsl:text>
                <xsl:value-of select="substring($rd, 11,2)" />
                <xsl:text>:00</xsl:text>
                <!--<xsl:value-of select="substring($rd, 14)" />-->
                </xsl:when>
            <xsl:otherwise><xsl:text> 00:00:00</xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <jointpersons>
        <xsl:attribute name="viafid"><xsl:value-of select="$viafID" /></xsl:attribute>
        <xsl:attribute name="viafrVersion"><xsl:value-of select="$viafrversion" /></xsl:attribute>
        <xsl:attribute name="accessed"><xsl:value-of select="$now" /></xsl:attribute>
        <xsl:apply-templates select="mx:datafield[@tag='950']" >
            <xsl:with-param name="source" select="$source" />
            <xsl:with-param name="sourceid" select="$sourceid" />
            <xsl:with-param name="update" select="$update" />
        </xsl:apply-templates>
    </jointpersons>
</xsl:template>

<xsl:template match="mx:leader" />
<xsl:template match="mx:controlfield" />
<xsl:template match="mx:datafield" />
<xsl:template match="mx:subfield" />

</xsl:stylesheet>