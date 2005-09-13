From: =?ks_c_5601-1987?B?sejA57+t?= <gauri@etri.re.kr>
Subject: How about shortening SCSI timeout value dynamically?
Date: Tue, 13 Sep 2005 11:52:05 +0900
Message-ID: <4C86297B4AC6554B8BA018F0806590CE5E9123@email1>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0751633128=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0751633128==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C5B80E.5A65ACC3"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5B80E.5A65ACC3
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: quoted-printable

Under the multipath environment, when the path is determined to fail, we =
have to wait 30 seconds because of the SCSI command default timeout(30 =
seconds). If the multiple paths are alive, I think it is more efficient =
to short the SCSI command timeout. Then we can shorten the delay of =
failover.
Is there any critical reason to remain SCSI timeout as a 30 seconds?
=20
What do you think about my this?

------_=_NextPart_001_01C5B80E.5A65ACC3
Content-Type: text/html;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dks_c_5601-1987">
<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 11">
<meta name=3DOriginator content=3D"Microsoft Word 11">
<link rel=3DFile-List href=3D"cid:filelist.xml@01C5B859.8FF44E40">
<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:DoNotRelyOnCSS/>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:DontDisplayPageBoundaries/>
  <w:SpellingState>Clean</w:SpellingState>
  <w:GrammarState>Clean</w:GrammarState>
  <w:DocumentKind>DocumentEmail</w:DocumentKind>
  <w:EnvelopeVis/>
  =
<w:DisplayHorizontalDrawingGridEvery>0</w:DisplayHorizontalDrawingGridEve=
ry>
  =
<w:DisplayVerticalDrawingGridEvery>2</w:DisplayVerticalDrawingGridEvery>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:Compatibility>
   <w:SpaceForUL/>
   <w:BalanceSingleByteDoubleByteWidth/>
   <w:DoNotLeaveBackslashAlone/>
   <w:ULTrailSpace/>
   <w:DoNotExpandShiftReturn/>
   <w:AdjustLineHeightInTable/>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:UseWord2002TableStyleRules/>
   <w:UseFELayout/>
  </w:Compatibility>
  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>
 </w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=3D"false" LatentStyleCount=3D"156">
 </w:LatentStyles>
</xml><![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:=B9=D9=C5=C1;
	panose-1:2 3 6 0 0 1 1 1 1 1;
	mso-font-alt:Batang;
	mso-font-charset:129;
	mso-generic-font-family:roman;
	mso-font-pitch:variable;
	mso-font-signature:-1342176593 1775729915 48 0 524447 0;}
@font-face
	{font-family:=B1=BC=B8=B2;
	panose-1:2 11 6 0 0 1 1 1 1 1;
	mso-font-alt:Gulim;
	mso-font-charset:129;
	mso-generic-font-family:modern;
	mso-font-pitch:variable;
	mso-font-signature:-1342176593 1775729915 48 0 524447 0;}
@font-face
	{font-family:"Century Gothic";
	panose-1:2 11 5 2 2 2 2 2 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:647 0 0 0 159 0;}
@font-face
	{font-family:"\@=B1=BC=B8=B2";
	panose-1:2 11 6 0 0 1 1 1 1 1;
	mso-font-charset:129;
	mso-generic-font-family:modern;
	mso-font-pitch:variable;
	mso-font-signature:-1342176593 1775729915 48 0 524447 0;}
@font-face
	{font-family:"\@=B9=D9=C5=C1";
	panose-1:2 3 6 0 0 1 1 1 1 1;
	mso-font-charset:129;
	mso-generic-font-family:roman;
	mso-font-pitch:variable;
	mso-font-signature:-1342176593 1775729915 48 0 524447 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	mso-pagination:none;
	text-autospace:none;
	word-break:break-hangul;
	font-size:9.0pt;
	font-family:=B1=BC=B8=B2;
	mso-bidi-font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;
	text-underline:single;}
p
	{mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:=B1=BC=B8=B2;
	mso-bidi-font-family:=B1=BC=B8=B2;}
p.patch, li.patch, div.patch
	{mso-style-name:"patch =C4=DA=B5=E5";
	margin:0cm;
	margin-bottom:.0001pt;
	line-height:8.0pt;
	mso-pagination:widow-orphan;
	text-autospace:none;
	word-break:break-hangul;
	font-size:8.0pt;
	mso-bidi-font-size:12.0pt;
	font-family:"Century Gothic";
	mso-fareast-font-family:"Century Gothic";
	mso-bidi-font-family:"Times New Roman";
	mso-fareast-language:EN-US;}
span.EmailStyle18
	{mso-style-type:personal-compose;
	mso-style-noshow:yes;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:=B1=BC=B8=B2;
	mso-ascii-font-family:=B1=BC=B8=B2;
	mso-fareast-font-family:=B1=BC=B8=B2;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:windowtext;}
span.SpellE
	{mso-style-name:"";
	mso-spl-e:yes;}
span.GramE
	{mso-style-name:"";
	mso-gram-e:yes;}
 /* Page Definitions */
 @page
	{mso-page-border-surround-header:no;
	mso-page-border-surround-footer:no;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:99.25pt 3.0cm 3.0cm 3.0cm;
	mso-header-margin:42.55pt;
	mso-footer-margin:49.6pt;
	mso-paper-source:0;
	layout-grid:18.0pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */=20
 table.MsoNormalTable
	{mso-style-name:"=C7=A5=C1=D8 =C7=A5";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin:0cm;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-ansi-language:#0400;
	mso-fareast-language:#0400;
	mso-bidi-language:#0400;}
</style>
<![endif]-->
</head>

<body lang=3DKO link=3Dblue vlink=3Dpurple =
style=3D'tab-interval:40.0pt'>

<div class=3DSection1 style=3D'layout-grid:18.0pt'>

<p class=3DMsoNormal><font size=3D2 face=3D=B1=BC=B8=B2><span =
lang=3DEN-US style=3D'font-size:10.0pt;
mso-hansi-font-family:Arial;mso-bidi-font-family:Arial'>Under the <span
class=3DSpellE>multipath</span> environment, when the path is determined =
to fail,
we have to wait 30 seconds because of the SCSI command default <span
class=3DGramE>timeout(</span>30 seconds). If the multiple paths are =
alive, I
think it is more efficient to short the SCSI command timeout. Then we =
can
shorten the delay of failover.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D=B1=BC=B8=B2><span =
lang=3DEN-US style=3D'font-size:10.0pt;
mso-hansi-font-family:Arial;mso-bidi-font-family:Arial'>Is there any =
critical
reason to remain SCSI timeout <span class=3DGramE>as a</span> 30 =
seconds?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D=B1=BC=B8=B2><span =
lang=3DEN-US style=3D'font-size:10.0pt;
mso-hansi-font-family:Arial;mso-bidi-font-family:Arial'><o:p>&nbsp;</o:p>=
</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D=B1=BC=B8=B2><span =
lang=3DEN-US style=3D'font-size:10.0pt;
mso-hansi-font-family:Arial;mso-bidi-font-family:Arial'>What do you =
think about
my this?<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C5B80E.5A65ACC3--


--===============0751633128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0751633128==--
