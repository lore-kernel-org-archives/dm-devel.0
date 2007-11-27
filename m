From: "Stefan Bader" <sbader3@googlemail.com>
Subject: Re: performance considerations with IO schedulers and DM
	multipathing
Date: Tue, 27 Nov 2007 22:42:19 +0100
Message-ID: <5201e28f0711271342s25dedae6j617f89c1d229b6c7@mail.gmail.com>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8CDD@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1315172280=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <940B4FF1F5958E4F96FC83C055A2F2611B8CDD@exch-2003.incipient.waltham>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1315172280==
Content-Type: multipart/alternative;
	boundary="----=_Part_4458_32569747.1196199744930"

------=_Part_4458_32569747.1196199744930
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Paul,

the device-mapper target itself doe not use any queue and so there is no
scheduler used at all. Only the real devices that are used as paths will be
using a scheduler. Whether there might be a performance gain by changing
these, I do not know.

Stefan

2007/11/27, Paul Cote <paul.cote@incipient.com>:
>
>  Hi,
>
> Is there any advantage to one specific IO scheduler (below) that may
> improve IO performance / throughput when running with a round-robin failo=
ver
> policy? Has anyone done testing with this ... and willing to share result=
s?
>
> thanks,
> Paul
>
> Completely Fair Queuing=97elevator=3Dcfq (default)
> Deadline=97elevator=3Ddeadline
> NOOP=97elevator=3Dnoop
> Anticipatory=97elevator=3Das
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_4458_32569747.1196199744930
Content-Type: text/html; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Paul,<br><br>the device-mapper target itself doe not use any queue and s=
o there is no scheduler used at all. Only the real devices that are used as=
 paths will be using a scheduler. Whether there might be a performance gain=
 by changing these, I do not know.
<br><br>Stefan<br><br><div><span class=3D"gmail_quote">2007/11/27, Paul Cot=
e &lt;<a href=3D"mailto:paul.cote@incipient.com">paul.cote@incipient.com</a=
>&gt;:</span><blockquote class=3D"gmail_quote" style=3D"border-left: 1px so=
lid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">






<div>
<div><span>Hi,</span></div>
<div><span></span>&nbsp;</div>
<div><span>Is there any advantage to one specific IO=20
scheduler (below) that may improve IO performance / throughput when running=
 with=20
a round-robin failover policy?&nbsp;Has anyone done testing with this ... a=
nd=20
willing to share results?</span></div>
<div><span></span>&nbsp;</div>
<div><span>thanks,</span></div>
<div><span>Paul</span></div>
<div>&nbsp;</div>
<li>Completely Fair Queuing=97elevator=3Dcfq (default)=20
</li><li>Deadline=97elevator=3Ddeadline=20
</li><li>NOOP=97elevator=3Dnoop=20
</li><li>Anticipatory=97elevator=3Das </li>
<p>&nbsp;</p></div>
 <br>--<br>dm-devel mailing list<br><a onclick=3D"return top.js.OpenExtLink=
(window,event,this)" href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.co=
m</a><br><a onclick=3D"return top.js.OpenExtLink(window,event,this)" href=
=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_blank">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></div>=
<br>

------=_Part_4458_32569747.1196199744930--


--===============1315172280==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1315172280==--
