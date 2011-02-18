From: devicemapper niko <devicemapper.niko@gmail.com>
Subject: Re: timestamp for shared snapshot
Date: Fri, 18 Feb 2011 17:18:40 +0800
Message-ID: <AANLkTi=bHgEayu3um=0gK6bdTMJzA+GPRTkfd9qUtXcT@mail.gmail.com>
References: <AANLkTinLFoOQ-mbPMAHQ0RCObyrWH0jMP4qQ0wsC4uaU@mail.gmail.com>
	<20110216143641.GA28595@redhat.com>
	<20110216175544.GB28729@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8874939560170537414=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110216175544.GB28729@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8874939560170537414==
Content-Type: multipart/alternative; boundary=20cf303f6c7ef9bd97049c8aff01

--20cf303f6c7ef9bd97049c8aff01
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Feb 17, 2011 at 1:55 AM, Alasdair G Kergon <agk@redhat.com> wrote:

> > > Is it possible to add timestamp and comment for each snapshots ?
>
> Good idea - as a userspace lvm2 feature, yes.
>
> We currently store creation details for each VG.
> I agree we should also store such details for each LV.
> This should be optional, but default to enabled.
> (People short of space can perhaps turn it off, discarding any existing
> details.)
>
> Storing a comment is perhaps an extension to tag support that's been
> discussed,
> to allow longer tags with a wider character set.
>
U mean saving the snapshots  timestamp infomation in VGDA?
It's not good i think. hundreds of snaps may be tagged but not attached
using dmsetup create command.
saving attached snaps infomation in VGDA is more reasonable


> > It should be noted that the above shared snapshot work is unlikely to
> > make it upstream (portions of it likely will, for instance the lvm2
> > userspace changes).  A new shared snapshot implementation is in
> > development.
>
> Different snapshot implementations are optimised for different types of
> usage.
> Each one involves choosing between different trade-offs.  We're unlikely
> ever
> to have one solution that is optimal for everyone.
>
> In that spirit, I hope to be submitting more than one shared snapshot
> implementation upstream, including *both* of the ones referred to in this
> message.  But I want the interfaces used by these implementations to be
> basically compatible so that the same userspace tools can make use of them.
>
> Alasdair
>
>

--20cf303f6c7ef9bd97049c8aff01
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Thu, Feb 17, 2011 at 1:55 AM, Alasdair G Kerg=
on <span dir=3D"ltr">&lt;<a href=3D"mailto:agk@redhat.com">agk@redhat.com</=
a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">&gt; &gt; Is it possible to add timestamp and comment for=
 each snapshots ?<br><br></div>Good idea - as a userspace lvm2 feature, yes=
.<br><br>We currently store creation details for each VG.<br>I agree we sho=
uld also store such details for each LV.<br>
This should be optional, but default to enabled.<br>(People short of space =
can perhaps turn it off, discarding any existing<br>details.)<br><br>Storin=
g a comment is perhaps an extension to tag support that&#39;s been discusse=
d,<br>
to allow longer tags with a wider character set.<br></blockquote>
<div>U mean saving the snapshots=A0 timestamp infomation in VGDA?</div>
<div>It&#39;s not good i think. hundreds of snaps may be tagged but not=A0a=
ttached using dmsetup create command.</div>
<div>saving attached snaps infomation in VGDA is more reasonable</div>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">&gt; It should be noted that the=
 above shared snapshot work is unlikely to<br>&gt; make it upstream (portio=
ns of it likely will, for instance the lvm2<br>
&gt; userspace changes). =A0A new shared snapshot implementation is in<br>&=
gt; development.<br><br>Different snapshot implementations are optimised fo=
r different types of usage.<br>Each one involves choosing between different=
 trade-offs. =A0We&#39;re unlikely ever<br>
to have one solution that is optimal for everyone.<br><br>In that spirit, I=
 hope to be submitting more than one shared snapshot<br>implementation upst=
ream, including *both* of the ones referred to in this<br>message. =A0But I=
 want the interfaces used by these implementations to be<br>
basically compatible so that the same userspace tools can make use of them.=
<br><font color=3D"#888888"><br>Alasdair<br><br></font></blockquote></div><=
br>

--20cf303f6c7ef9bd97049c8aff01--


--===============8874939560170537414==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8874939560170537414==--
