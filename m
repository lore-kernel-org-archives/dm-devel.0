From: "Paul Cote" <paul.cote@incipient.com>
Subject: performance considerations with IO schedulers and DM
	multipathing
Date: Tue, 27 Nov 2007 15:47:48 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8CDD@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0842111142=="
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

--===============0842111142==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C83136.C511BD34"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C83136.C511BD34
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
=20
Is there any advantage to one specific IO scheduler (below) that may
improve IO performance / throughput when running with a round-robin
failover policy? Has anyone done testing with this ... and willing to
share results?
=20
thanks,
Paul
=20
*	Completely Fair Queuing-elevator=3Dcfq (default)=20
*	Deadline-elevator=3Ddeadline=20
*	NOOP-elevator=3Dnoop=20
*	Anticipatory-elevator=3Das=20

=20


------_=_NextPart_001_01C83136.C511BD34
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE id=3DridTitle>Message</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<STYLE>BODY {
	MARGIN-TOP: 25px; FONT-SIZE: 10pt; MARGIN-LEFT: 25px; COLOR: #000000; =
FONT-FAMILY: Arial, Helvetica
}
P.msoNormal {
	MARGIN-TOP: 0px; FONT-SIZE: 10pt; MARGIN-LEFT: 0px; COLOR: #ffffcc; =
FONT-FAMILY: Helvetica, "Times New Roman"
}
LI.msoNormal {
	MARGIN-TOP: 0px; FONT-SIZE: 10pt; MARGIN-LEFT: 0px; COLOR: #ffffcc; =
FONT-FAMILY: Helvetica, "Times New Roman"
}
</STYLE>

<META content=3D"MSHTML 6.00.2800.1126" name=3DGENERATOR></HEAD>
<BODY id=3DridBody background=3D"">
<DIV><SPAN class=3D627494220-27112007>Hi,</SPAN></DIV>
<DIV><SPAN class=3D627494220-27112007></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D627494220-27112007>Is there any advantage to one =
specific IO=20
scheduler (below) that may improve IO performance / throughput when =
running with=20
a round-robin failover policy?&nbsp;Has anyone done testing with this =
... and=20
willing to share results?</SPAN></DIV>
<DIV><SPAN class=3D627494220-27112007></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D627494220-27112007>thanks,</SPAN></DIV>
<DIV><SPAN class=3D627494220-27112007>Paul</SPAN></DIV>
<DIV>&nbsp;</DIV>
<LI>Completely Fair Queuing&#8212;elevator=3Dcfq (default)=20
<LI>Deadline&#8212;elevator=3Ddeadline=20
<LI>NOOP&#8212;elevator=3Dnoop=20
<LI>Anticipatory&#8212;elevator=3Das </LI>
<P>&nbsp;</P></BODY></HTML>
=00
------_=_NextPart_001_01C83136.C511BD34--


--===============0842111142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0842111142==--
