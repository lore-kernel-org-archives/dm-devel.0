From: James.Smart@Emulex.Com
Subject: RE: How about shortening SCSI timeout value dynamically?
Date: Tue, 13 Sep 2005 10:37:20 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F45B2@xbl3.ma.emulex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1995754362=="
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
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

--===============1995754362==
content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C5B870.A5D28928"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5B870.A5D28928
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: quoted-printable

> Is there a critical reason to leave the SCSI timeout at 30 seconds ?
=20
Yes,  On busy arrays (lots of queued command), even 30 seconds is not =
sufficient. Our testing on heavily loaded arrays
says i/o timeouts should actually be in the 60 second range. These =
measurements were on standard single-path
configs. You could argue that multipath configs make the queuing worse.  =
Also, background array tasks, such as
driver rebuilds, etc will increase the normal i/o execution times.
=20
This said, smart administrators should be monitoring i/o load, adjusting =
queue depths, etc so that things aren't in the
range of 30 seconds. However, with multipathing in the mix, this becomes =
a much more difficult task for the admin.
=20
Please note: it is bad to assume what the command execution time latency =
is based simply on having physical
connectivity.
=20
My personal opinion is that you really want a "cancel i/o" interface. =
This way, at least when you get notified of
the loss of connectivity, you can cancel the remaining i/o's and =
failover quicker. I would assume, in much the same way
as the generic status codes are being handled, the block layer can be =
expanded to add this interface (and call the
SCSI abort handler, which already exists).
=20
-- james
-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]On =
Behalf Of gauri@etri.re.kr
Sent: Monday, September 12, 2005 10:52 PM
To: dm-devel@redhat.com
Subject: [dm-devel] How about shortening SCSI timeout value dynamically?


Under the multipath environment, when the path is determined to fail, we =
have to wait 30 seconds because of the SCSI command default timeout(30 =
seconds). If the multiple paths are alive, I think it is more efficient =
to short the SCSI command timeout. Then we can shorten the delay of =
failover.
Is there any critical reason to remain SCSI timeout as a 30 seconds?
=20
What do you think about my this?

------_=_NextPart_001_01C5B870.A5D28928
Content-Type: text/html;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML xmlns=3D"http://www.w3.org/TR/REC-html40" xmlns:o =3D=20
"urn:schemas-microsoft-com:office:office" xmlns:w =3D=20
"urn:schemas-microsoft-com:office:word"><HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dks_c_5601-1987">


<META content=3DWord.Document name=3DProgId>
<META content=3D"MSHTML 6.00.2800.1515" name=3DGENERATOR>
<META content=3D"Microsoft Word 11" name=3DOriginator><LINK=20
href=3D"cid:filelist.xml@01C5B859.8FF44E40" rel=3DFile-List><!--[if gte =
mso 9]><xml>
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
<STYLE>@font-face {
	font-family: =B9=D9=C5=C1;
}
@font-face {
	font-family: =B1=BC=B8=B2;
}
@font-face {
	font-family: Century Gothic;
}
@font-face {
	font-family: @=B1=BC=B8=B2;
}
@font-face {
	font-family: @=B9=D9=C5=C1;
}
@page  {mso-page-border-surround-header: no; =
mso-page-border-surround-footer: no; }
@page Section1 {size: 595.3pt 841.9pt; margin: 99.25pt 3.0cm 3.0cm =
3.0cm; mso-header-margin: 42.55pt; mso-footer-margin: 49.6pt; =
mso-paper-source: 0; layout-grid: 18.0pt; }
P.MsoNormal {
	TEXT-JUSTIFY: inter-ideograph; FONT-SIZE: 9pt; MARGIN: 0cm 0cm 0pt; =
FONT-FAMILY: =B1=BC=B8=B2; TEXT-ALIGN: justify; mso-bidi-font-family: =
"Times New Roman"; mso-style-parent: ""; mso-pagination: none
}
LI.MsoNormal {
	TEXT-JUSTIFY: inter-ideograph; FONT-SIZE: 9pt; MARGIN: 0cm 0cm 0pt; =
FONT-FAMILY: =B1=BC=B8=B2; TEXT-ALIGN: justify; mso-bidi-font-family: =
"Times New Roman"; mso-style-parent: ""; mso-pagination: none
}
DIV.MsoNormal {
	TEXT-JUSTIFY: inter-ideograph; FONT-SIZE: 9pt; MARGIN: 0cm 0cm 0pt; =
FONT-FAMILY: =B1=BC=B8=B2; TEXT-ALIGN: justify; mso-bidi-font-family: =
"Times New Roman"; mso-style-parent: ""; mso-pagination: none
}
A:link {
	COLOR: blue; TEXT-DECORATION: underline; text-underline: single
}
SPAN.MsoHyperlink {
	COLOR: blue; TEXT-DECORATION: underline; text-underline: single
}
A:visited {
	COLOR: purple; TEXT-DECORATION: underline; text-underline: single
}
SPAN.MsoHyperlinkFollowed {
	COLOR: purple; TEXT-DECORATION: underline; text-underline: single
}
P {
	FONT-SIZE: 12pt; MARGIN-LEFT: 0cm; MARGIN-RIGHT: 0cm; FONT-FAMILY: =
=B1=BC=B8=B2; mso-bidi-font-family: =B1=BC=B8=B2; mso-pagination: =
widow-orphan; mso-margin-top-alt: auto; mso-margin-bottom-alt: auto
}
P.patch {
	FONT-SIZE: 8pt; MARGIN: 0cm 0cm 0pt; LINE-HEIGHT: 8pt; FONT-FAMILY: =
"Century Gothic"; mso-bidi-font-family: "Times New Roman"; =
mso-pagination: widow-orphan; mso-style-name: "patch =C4=DA=B5=E5"; =
mso-bidi-font-size: 12.0pt; mso-fareast-font-family: "Century Gothic"; =
mso-fareast-language: EN-US
}
LI.patch {
	FONT-SIZE: 8pt; MARGIN: 0cm 0cm 0pt; LINE-HEIGHT: 8pt; FONT-FAMILY: =
"Century Gothic"; mso-bidi-font-family: "Times New Roman"; =
mso-pagination: widow-orphan; mso-style-name: "patch =C4=DA=B5=E5"; =
mso-bidi-font-size: 12.0pt; mso-fareast-font-family: "Century Gothic"; =
mso-fareast-language: EN-US
}
DIV.patch {
	FONT-SIZE: 8pt; MARGIN: 0cm 0cm 0pt; LINE-HEIGHT: 8pt; FONT-FAMILY: =
"Century Gothic"; mso-bidi-font-family: "Times New Roman"; =
mso-pagination: widow-orphan; mso-style-name: "patch =C4=DA=B5=E5"; =
mso-bidi-font-size: 12.0pt; mso-fareast-font-family: "Century Gothic"; =
mso-fareast-language: EN-US
}
SPAN.EmailStyle18 {
	COLOR: windowtext; FONT-FAMILY: =B1=BC=B8=B2; mso-hansi-font-family: =
Arial; mso-bidi-font-family: Arial; mso-bidi-font-size: 10.0pt; =
mso-fareast-font-family: =B1=BC=B8=B2; mso-style-type: personal-compose; =
mso-style-noshow: yes; mso-ansi-font-size: 10.0pt; =
mso-ascii-font-family: =B1=BC=B8=B2
}
SPAN.SpellE {
	mso-style-name: ""; mso-spl-e: yes
}
SPAN.GramE {
	mso-style-name: ""; mso-gram-e: yes
}
DIV.Section1 {
	page: Section1
}
</STYLE>
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
<![endif]--></HEAD>
<BODY lang=3DKO style=3D"tab-interval: 40.0pt" vLink=3Dpurple =
link=3Dblue>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>&gt;=20
Is there a critical reason to leave the SCSI timeout at 30 seconds=20
?</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2>Yes,&nbsp; On busy arrays (lots of queued command), even 30 =
seconds is=20
not sufficient. Our testing on heavily loaded arrays</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>says=20
i/o timeouts should actually be in the 60 second range. These=20
measurements&nbsp;were on standard single-path</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2>configs. You could argue that multipath configs make the =
queuing=20
worse.&nbsp; Also, background array tasks, such as</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>driver=20
rebuilds, etc </FONT></SPAN><SPAN class=3D099082714-13092005><FONT =
face=3DArial=20
color=3D#0000ff size=3D2>will increase the normal i/o execution=20
times.</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>This=20
said, smart administrators should be monitoring i/o load, adjusting =
queue=20
depths, etc so that things aren't in the</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>range=20
of 30 seconds. However, with multipathing in the mix, this becomes a =
much more=20
difficult task for the admin.</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>Please=20
note: it is bad to assume what the command execution time latency is =
based=20
simply on having physical</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2>connectivity.</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>My=20
personal opinion is that you really want a "cancel i/o" interface. This =
way, at=20
least when you get notified of</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>the=20
loss of connectivity, you can cancel the remaining i/o's and failover =
quicker. I=20
would assume, in much the same way</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>as the=20
generic status codes are being handled, the block layer can be expanded =
to add=20
this interface (and call the</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>SCSI=20
abort handler, which already exists).</FONT></SPAN></DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =

size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D099082714-13092005><FONT face=3DArial color=3D#0000ff =
size=3D2>--=20
james</FONT></SPAN></DIV>
<BLOCKQUOTE dir=3Dltr=20
style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #0000ff 2px =
solid; MARGIN-RIGHT: 0px">
  <DIV class=3DOutlookMessageHeader dir=3Dltr align=3Dleft><FONT =
face=3DTahoma=20
  size=3D2>-----Original Message-----<BR><B>From:</B> =
dm-devel-bounces@redhat.com=20
  [mailto:dm-devel-bounces@redhat.com]<B>On Behalf Of=20
  </B>gauri@etri.re.kr<BR><B>Sent:</B> Monday, September 12, 2005 10:52=20
  PM<BR><B>To:</B> dm-devel@redhat.com<BR><B>Subject:</B> [dm-devel] How =
about=20
  shortening SCSI timeout value dynamically?<BR><BR></FONT></DIV>
  <DIV class=3DSection1 style=3D"LAYOUT-GRID:  18pt none">
  <P class=3DMsoNormal><FONT face=3D=B1=BC=B8=B2 size=3D2><SPAN =
lang=3DEN-US=20
  style=3D"FONT-SIZE: 10pt; mso-hansi-font-family: Arial; =
mso-bidi-font-family: Arial">Under=20
  the <SPAN class=3DSpellE>multipath</SPAN> environment, when the path =
is=20
  determined to fail, we have to wait 30 seconds because of the SCSI =
command=20
  default <SPAN class=3DGramE>timeout(</SPAN>30 seconds). If the =
multiple paths=20
  are alive, I think it is more efficient to short the SCSI command =
timeout.=20
  Then we can shorten the delay of =
failover.<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D=B1=BC=B8=B2 size=3D2><SPAN =
lang=3DEN-US=20
  style=3D"FONT-SIZE: 10pt; mso-hansi-font-family: Arial; =
mso-bidi-font-family: Arial">Is=20
  there any critical reason to remain SCSI timeout <SPAN =
class=3DGramE>as a</SPAN>=20
  30 seconds?<o:p></o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D=B1=BC=B8=B2 size=3D2><SPAN =
lang=3DEN-US=20
  style=3D"FONT-SIZE: 10pt; mso-hansi-font-family: Arial; =
mso-bidi-font-family: Arial"><o:p>&nbsp;</o:p></SPAN></FONT></P>
  <P class=3DMsoNormal><FONT face=3D=B1=BC=B8=B2 size=3D2><SPAN =
lang=3DEN-US=20
  style=3D"FONT-SIZE: 10pt; mso-hansi-font-family: Arial; =
mso-bidi-font-family: Arial">What=20
  do you think about my=20
this?<o:p></o:p></SPAN></FONT></P></DIV></BLOCKQUOTE></BODY></HTML>

------_=_NextPart_001_01C5B870.A5D28928--


--===============1995754362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1995754362==--
