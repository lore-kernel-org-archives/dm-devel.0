From: <Shyam_Iyer@Dell.com>
Subject: RE: [patch]: [multipath-tool] Add check for removeddevice
	in rdac checker
Date: Tue, 28 Oct 2008 15:11:08 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CA01B6255E@blrx3m10.blr.amer.dell.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BFA6@AUSX3MPC128.aus.amer.dell.com>
	<20081027170113.GA6167@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0117728593=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20081027170113.GA6167@mars.virtualiron.com>
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

--===============0117728593==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C938E1.4DB59014"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C938E1.4DB59014
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Konrad Wrote:
> On Mon, Oct 27, 2008 at 10:11:28AM -0500, Yanqing_Liu@Dell.com wrote:
> > Hi,
> >
> > This patch adds a check for removed device in rdac checker. After
> > volume access inquiry returns, the checker will check the peripheral
> > qualifier field to see if the device is deleted/unmapped. If so,
mark
> > path as failed.

> How does multipathd behaves when this fix is not in? Does it still
mark the path down? I would presume so, but it would take longer (the
default SCSI timeout value?)

Absolutely. But that would also be after some IOs on the failed path and
the device being marked offline. Instead if the controller device is
intelligent to support a feature to know if the path is down through an
inquiry then it is worth marking the path down earlier.=20

Thanks for reviewing.

-Shyam Iyer.


------_=_NextPart_001_01C938E1.4DB59014
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2900.3429" name=3DGENERATOR></HEAD>
<BODY>
<P><FONT size=3D2>Konrad Wrote:<BR>&gt; On Mon, Oct 27, 2008 at =
10:11:28AM -0500,=20
Yanqing_Liu@Dell.com wrote:<BR>&gt; &gt; Hi,<BR>&gt; &gt;<BR>&gt; &gt; =
This=20
patch adds a check for removed device in rdac checker. After<BR>&gt; =
&gt; volume=20
access inquiry returns, the checker will check the peripheral<BR>&gt; =
&gt;=20
qualifier field to see if the device is deleted/unmapped. If so, =
mark<BR>&gt;=20
&gt; path as failed.<BR><BR>&gt; How does multipathd behaves when this =
fix is=20
not in? Does it still mark the path down? I would presume so, but it =
would take=20
longer (the default SCSI timeout value?)<BR><BR>Absolutely.&nbsp;But =
that would=20
also be after some IOs on the failed path and the device being marked =
offline.=20
Instead if the controller device is intelligent to support a feature to =
know if=20
the path is down through an inquiry then it is worth marking&nbsp;the =
path down=20
earlier. </FONT></P>
<P><FONT size=3D2>Thanks for reviewing.</FONT></P>
<P><FONT size=3D2>-Shyam Iyer.</FONT></P></BODY></HTML>

------_=_NextPart_001_01C938E1.4DB59014--


--===============0117728593==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0117728593==--
