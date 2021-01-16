<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

    <xsl:output method="html"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="java:java.util.Date.new(number(/doc/timestamp))"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="employee">
        <xsl:copy>
            <id>
		    <xsl:value-of select="java:java.util.Date.new(number(/doc/timestamp))"/>
            </id>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
