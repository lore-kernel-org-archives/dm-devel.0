From: Kirill Cherkashin <kcherkashin@amadeus.com>
Subject: rdac mode on SLES10SP1
Date: Tue, 11 Sep 2007 09:54:13 +0200
Message-ID: <OF7370E75F.A98D07BF-ONC1257353.002B4C4D-C1257353.002B6A87@amadeus.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1583113921=="
Return-path: <dm-devel-bounces@redhat.com>
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

This is a multipart message in MIME format.
--===============1583113921==
Content-Type: multipart/alternative;
	boundary="=_alternative 002B6A5BC1257353_="

This is a multipart message in MIME format.
--=_alternative 002B6A5BC1257353_=
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,


Could you advise me on next matter.
We have DS4800 connected to SLES10&9. At the moment we're using 'native'=20
IBM  rdac driver but we're going to soon jump to Linux mpio.
According to Novell's support site in SP1(with kernel 2.6.16)  MPIO would=20
be supported by in rdac mode.=20

patches.fixes/dm-mpath-rdac.patch: dm-multipath hardware handler for=20
LSI/Engenio RDAC (FATE 300540).

http://www.novell.com/support/search.do?cmd=3DdisplayKC&docType=3Dkc&extern=
alId=3Dhttp--supportnovellcom-techcenter-sdb-en-2005-04-slesmultipathinghtm=
l&sliceId=3D&dialogID=3D43714828&stateId=3D1%200%203744908

However, here I found  that it should happened only with 2.6.23 kernel.

http://marc.info/?l=3Ddm-devel&m=3D118729146220962&w=3D2

If you are using it in rdac mode, then you have to wait.
> Any idea when that should be? Or are there any kernel patches=20
Usually they are released within 2-3 months of the last release. 2.6.22
was released on Jul 8th. So, it should be somewhere between Sep 8th and
Oct 8th=20

Could someone clarify the situation. Support  SLES10SP1 already rdac mode=20
or I should wait until SUSE new release ?

Regards,

Kirill=20



IMPORTANT  -  CONFIDENTIALITY  NOTICE  - This e-mail is intended only for=20
the use of the individual or entity shown above as addressees. It may=20
contain information which is privileged, confidential or otherwise=20
protected from disclosure under applicable laws.  If the reader of this=20
transmission is not the intended recipient, you are hereby notified that=20
any dissemination, printing, distribution, copying, disclosure or the=20
taking of any action in reliance on the contents of this information is=20
strictly prohibited.  If you have received this transmission in error,=20
please immediately notify us by reply e-mail or using the address below=20
and delete the message and any attachments from your system.=20

Amadeus Data Processing GmbH=20
Gesch=E4ftsf=FChrer: Eberhard Haag=20
Sitz der Gesellschaft: Erding=20
HR M=FCnchen 48 199=20
Berghamer Strasse 6=20
85435 Erding=20
Germany



IMPORTANT  -  CONFIDENTIALITY  NOTICE  - This e-mail is intended only for=20
the use of the individual or entity shown above as addressees. It may=20
contain information which is privileged, confidential or otherwise=20
protected from disclosure under applicable laws.  If the reader of this=20
transmission is not the intended recipient, you are hereby notified that=20
any dissemination, printing, distribution, copying, disclosure or the=20
taking of any action in reliance on the contents of this information is=20
strictly prohibited.  If you have received this transmission in error,=20
please immediately notify us by reply e-mail or using the address below=20
and delete the message and any attachments from your system.=20

Amadeus Data Processing GmbH=20
Gesch=E4ftsf=FChrer: Eberhard Haag=20
Sitz der Gesellschaft: Erding=20
HR M=FCnchen 48 199=20
Berghamer Strasse 6=20
85435 Erding=20
Germany
--=_alternative 002B6A5BC1257353_=
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable


<br><font size=3D3>Hello,</font>
<br>
<br>
<br><font size=3D3>Could you advise me on next matter.</font>
<br><font size=3D3>We have DS4800 connected to SLES10&amp;9. At the moment
we're using 'native' IBM &nbsp;rdac driver but we're going to soon jump
to Linux mpio.</font>
<br><font size=3D3>According to Novell's support site in SP1(with kernel
2.6.16) &nbsp;MPIO would be supported by in rdac mode. </font>
<br>
<br><font size=3D3>patches.fixes/dm-mpath-rdac.patch: dm-multipath hardware
handler for LSI/Engenio RDAC (FATE 300540).</font>
<br>
<br><font size=3D3>http://www.novell.com/support/search.do?cmd=3DdisplayKC&=
amp;docType=3Dkc&amp;externalId=3Dhttp--supportnovellcom-techcenter-sdb-en-=
2005-04-slesmultipathinghtml&amp;sliceId=3D&amp;dialogID=3D43714828&amp;sta=
teId=3D1%200%203744908</font>
<br>
<br><font size=3D3>However, here I found &nbsp;that it should happened only
with 2.6.23 kernel.</font>
<br>
<br><font size=3D2 face=3D"Courier New">http://marc.info/?l=3Ddm-devel&amp;=
m=3D118729146220962&amp;w=3D2</font>
<br>
<br><font size=3D2 face=3D"Arial"><b>If you are using it in rdac mode, then
you have to wait.</b></font>
<br><font size=3D2 face=3D"Arial"><b>&gt; Any idea when that should be? Or
are there any kernel patches </b></font>
<br><font size=3D2 face=3D"Arial"><b>Usually they are released within 2-3 m=
onths
of the last release. 2.6.22</b></font>
<br><font size=3D2 face=3D"Arial"><b>was released on Jul 8th. So, it should
be somewhere between Sep 8th and</b></font>
<br><font size=3D2 face=3D"Arial"><b>Oct 8th </b></font>
<br>
<br><font size=3D3>Could someone clarify the situation. Support &nbsp;SLES1=
0SP1
already rdac mode or I should wait until SUSE new release ?</font>
<br>
<br><font size=3D3>Regards,</font>
<br>
<br><font size=3D3>Kirill &nbsp;<br>
<br>
<br>
<br>
IMPORTANT &nbsp;- &nbsp;CONFIDENTIALITY &nbsp;NOTICE &nbsp;- This e-mail
is intended only for the use of the individual or entity shown above as
addressees. It may contain information which is privileged, confidential
or otherwise protected from disclosure under applicable laws. &nbsp;If
the reader of this transmission is not the intended recipient, you are
hereby notified that any dissemination, printing, distribution, copying,
disclosure or the taking of any action in reliance on the contents of this
information is strictly prohibited. &nbsp;If you have received this transmi=
ssion
in error, please immediately notify us by reply e-mail or using the address
below and delete the message and any attachments from your system. <br>
<br>
Amadeus Data Processing GmbH <br>
Gesch=E4ftsf=FChrer: Eberhard Haag <br>
Sitz der Gesellschaft: Erding <br>
HR M=FCnchen 48 199 <br>
Berghamer Strasse 6 <br>
85435 Erding <br>
Germany<br>
<br>
<br>
<br>
IMPORTANT &nbsp;- &nbsp;CONFIDENTIALITY &nbsp;NOTICE &nbsp;- This e-mail
is intended only for the use of the individual or entity shown above as
addressees. It may contain information which is privileged, confidential
or otherwise protected from disclosure under applicable laws. &nbsp;If
the reader of this transmission is not the intended recipient, you are
hereby notified that any dissemination, printing, distribution, copying,
disclosure or the taking of any action in reliance on the contents of this
information is strictly prohibited. &nbsp;If you have received this transmi=
ssion
in error, please immediately notify us by reply e-mail or using the address
below and delete the message and any attachments from your system. <br>
<br>
Amadeus Data Processing GmbH <br>
Gesch=E4ftsf=FChrer: Eberhard Haag <br>
Sitz der Gesellschaft: Erding <br>
HR M=FCnchen 48 199 <br>
Berghamer Strasse 6 <br>
85435 Erding <br>
Germany</font>
--=_alternative 002B6A5BC1257353_=--


--===============1583113921==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1583113921==--
