<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:vt="http://viaf.org/viaf/terms#"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:void="http://rdfs.org/ns/void#"
            xmlns:ns1="http://viaf.org/viaf/terms#"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
           exclude-result-prefixes="vt foaf owl rdf void ns1 xs"
version="1.0" type="text" >

<xsl:output method="xml" encoding="UTF-8" />

<xsl:param name="viafrversion" />
<xsl:param name="now" />
<xsl:variable name="viafUpdate" select="/ns1:VIAFCluster/ns1:creationtime" />
<xsl:variable name="isocodes">AF,AL,DZ,AS,AD,AO,AI,AQ,AG,AR,AM,AW,AU,AT,AZ,
BS,BH,BD,BB,BY,BE,BZ,BJ,BM,BT,BO,BQ,BA,BW,BV,BR,IO,BN,BG,BF,BI,KH,CM,CA,CV,
KY,CF,TD,CL,CN,CX,CC,CO,KM,CG,CD,CK,CR,HR,CU,CW,CY,CZ,CI,DK,DJ,DM,DO,EC,EG,
SV,GQ,ER,EE,ET,FK,FO,FJ,FI,FR,GF,PF,TF,GA,GM,GE,DE,GH,GI,GR,GL,GD,GP,GU,GT,
GG,GN,GW,GY,HT,HM,VA,HN,HK,HU,IS,IN,ID,IR,IQ,IE,IM,IL,IT,JM,JP,JE,JO,KZ,KE,
KI,KP,KR,KW,KG,LA,LV,LB,LS,LR,LY,LI,LT,LU,MO,MK,MG,MW,MY,MV,ML,MT,MH,MQ,MR,
MU,YT,MX,FM,MD,MC,MN,ME,MS,MA,MZ,MM,NA,NR,NP,NL,NC,NZ,NI,NE,NG,NU,NF,MP,NO,
OM,PK,PW,PS,PA,PG,PY,PE,PH,PN,PL,PT,PR,QA,RO,RU,RW,RE,BL,SH,KN,LC,MF,PM,VC,
WS,SM,ST,SA,SN,RS,SC,SL,SG,SX,SK,SI,SB,SO,ZA,GS,SS,ES,LK,SD,SR,SJ,SZ,SE,CH,
SY,TW,TJ,TZ,TH,TL,TG,TK,TO,TT,TN,TR,TM,TC,TV,UG,UA,AE,GB,US,UM,UY,UZ,VU,VE,
VN,VG,VI,WF,EH,YE,ZM,ZW,AX
</xsl:variable>

<xsl:template match="ns1:VIAFCluster">
<xsl:variable name="viafID" select="ns1:viafID" />
<xsl:variable name="nameType" select="ns1:nameType" />
<xsl:variable name="name" select="ns1:mainHeadings[1]/ns1:data[1]/ns1:text" />
<xsl:variable name="affiliations" select="count(ns1:x500s/ns1:x500/ns1:datafield[@tag='510'])" />
<xsl:variable name="sourceCount" select="count(ns1:sources/ns1:source)" />
<xsl:variable name="gender" >
    <xsl:choose>
    <xsl:when test="ns1:fixed/ns1:gender='a'">female</xsl:when>
    <xsl:when test="ns1:fixed/ns1:gender='b'">male</xsl:when>
    <xsl:otherwise />
    </xsl:choose>
</xsl:variable>
<xsl:variable name="birthDate" select="ns1:birthDate" />
<xsl:variable name="deathDate" select="ns1:deathDate" />
<xsl:variable name="dateType" select="ns1:dateType" />
<xsl:variable name="uniqueISBNs" select="ns1:ISBNs/@unique" />
<xsl:variable name="titleCount" select="count(ns1:titles/ns1:work)" />
<xsl:variable name="coauthorsPersonal" select="count(ns1:coauthors/ns1:data[@tag='950'])" />
<xsl:variable name="coauthorsCorp" select="count(ns1:coauthors/ns1:data[@tag='951'])" />
<xsl:variable name="nationalities"><xsl:call-template name="make-list">
    <xsl:with-param name="nodes" 
        select="ns1:nationalityOfEntity/ns1:data/ns1:text[string-length(.) = 2 and contains($isocodes,.)]" />
</xsl:call-template></xsl:variable>
<summary>
    <xsl:attribute name="viafid"><xsl:value-of select="$viafID" /></xsl:attribute>
    <xsl:attribute name="viafrVersion"><xsl:value-of select="$viafrversion" /></xsl:attribute>
    <xsl:attribute name="processDate"><xsl:value-of select="$now" /></xsl:attribute>
    <row>
        <viafID ct="character"><xsl:value-of select="$viafID" /></viafID>
        <viafType ct="character"><xsl:value-of select="$nameType" /></viafType>
        <name ct="character"><xsl:value-of select="$name" /></name>
        <gender ct="character"><xsl:value-of select="$gender" /></gender>
        <birthDate ct="character"><xsl:value-of select="$birthDate" /></birthDate>
        <deathDate ct="character"><xsl:value-of select="$deathDate" /></deathDate>
        <dateType ct="character"><xsl:value-of select="$dateType" /></dateType>
        <nationalities ct="character"><xsl:value-of select="$nationalities" /></nationalities>
        <affiliations ct="integer"><xsl:value-of select="$affiliations" /></affiliations>
        <sourceCount ct="integer"><xsl:value-of select="$sourceCount" /></sourceCount>
        <uniqueISBNs ct="integer"><xsl:value-of select="$uniqueISBNs" /></uniqueISBNs>
        <coauthorsPersonal ct="integer"><xsl:value-of select="$coauthorsPersonal" /></coauthorsPersonal>
        <coauthorsCorp ct="integer"><xsl:value-of select="$coauthorsCorp" /></coauthorsCorp>
        <viaf-update ct="POSIXct"><xsl:value-of select="$viafUpdate" /></viaf-update>
        <accessed ct="POSIXct"><xsl:value-of select="$now" /></accessed>
    </row>
</summary>
</xsl:template>

<xsl:template name="make-list">
    <xsl:param name="nodes" />
    <xsl:for-each select="$nodes" >
    <xsl:value-of select="." />
    <xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>
</xsl:template>



</xsl:stylesheet>
