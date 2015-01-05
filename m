From: Doug Dumitru <doug@easyco.com>
Subject: Re: DM limits setup
Date: Mon, 5 Jan 2015 15:32:18 -0800
Message-ID: <CAFx4rwSvuTHyL9qZ_A+7-utm1-+yyd=kAnpAKAkS+pxeMHVDSw@mail.gmail.com>
References: <CAFx4rwQudUhVH4rgJYb+uHPe17PKJHYQRsxbUpwr5h_1r2B8+w@mail.gmail.com>
	<20150105102151.GC11818@debian>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6893388930467565311=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150105102151.GC11818@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Doug Dumitru <doug@easyco.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6893388930467565311==
Content-Type: multipart/alternative; boundary=f46d043c7edce8bd18050bf01907

--f46d043c7edce8bd18050bf01907
Content-Type: text/plain; charset=UTF-8

Thank you Mr. Thornber.  This example should work for me.

My dm-validate.ko module is functional, but a bit crude for general use.
It has a few "issues":

1)  It is only currently tested on x86_64, although it will likely work on
32-bit intel with only a couple of KMAPs added.

2)  It uses "load DS:" games to read and write to file space from the
kernel (this is where the hashes are stored).  I suspect this is
nonsensical for some arches.

3)  There is no attempt to "sync" the hash "database" so crashes always
result in out of sync tests.  My testing is mostly with SSDs and SSD
arrays, so speed is an issue.

If you would like a copy, please point me at "contribution" guidelines for
device mapper target contributions.


On Mon, Jan 5, 2015 at 2:21 AM, Joe Thornber <thornber@redhat.com> wrote:

> On Wed, Dec 31, 2014 at 02:10:52PM -0800, Doug Dumitru wrote:
> > Hello all,
> >
> > I have a test dm target module that I use to validate storage subsystems
> > for data accuracy.  It basically builds weak hashes for every sector of a
> > device when written, and validates these hashes when the sector is read
> > back.  Ugly memory usage, but it is just a test tool.
> >
> > I can deploy this with an iterator target and it will take on the limits
> of
> > the device underneath, or I can skip the iterator target and get limits
> at
> > 2048 sectors.  What I would like to do is set the limit manually.  I know
> > this is "really bad program design", but again, this is a test tool and
> not
> > anything for production use.
> >
> > Can anyone point me at an example of where the limits are setup
> explicitly.
>
> Hi Doug,
>
> This sounds like a useful target for testing, any chance you could
> post it here when you finish it please?
>
> dm-thin does lots of tweaking of limits, so that's probably the best one
> to look at:
>
>
> https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-thin.c#L3707
>
> - Joe
>



-- 
Doug Dumitru
EasyCo LLC

--f46d043c7edce8bd18050bf01907
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Thank you Mr. Thornber.=C2=A0 This exam=
ple should work for me.<br><br>My dm-validate.ko module is functional, but =
a bit crude for general use.=C2=A0 It has a few &quot;issues&quot;:<br><br>=
</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif;font-size:small">1)=C2=A0 It is only currently tested on x86_64, al=
though it will likely work on 32-bit intel with only a couple of KMAPs adde=
d.<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif;font-size:small">2)=C2=A0 It uses &quot;load DS:&quot; ga=
mes to read and write to file space from the kernel (this is where the hash=
es are stored).=C2=A0 I suspect this is nonsensical for some arches.<br><br=
></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;font-size:small">3)=C2=A0 There is no attempt to &quot;sync&quot; =
the hash &quot;database&quot; so crashes always result in out of sync tests=
.=C2=A0 My testing is mostly with SSDs and SSD arrays, so speed is an issue=
.<br><br>If you would like a copy, please point me at &quot;contribution&qu=
ot; guidelines for device mapper target contributions.<br><br></div></div><=
div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Jan 5, 201=
5 at 2:21 AM, Joe Thornber <span dir=3D"ltr">&lt;<a href=3D"mailto:thornber=
@redhat.com" target=3D"_blank">thornber@redhat.com</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On =
Wed, Dec 31, 2014 at 02:10:52PM -0800, Doug Dumitru wrote:<br>
&gt; Hello all,<br>
&gt;<br>
&gt; I have a test dm target module that I use to validate storage subsyste=
ms<br>
&gt; for data accuracy.=C2=A0 It basically builds weak hashes for every sec=
tor of a<br>
&gt; device when written, and validates these hashes when the sector is rea=
d<br>
&gt; back.=C2=A0 Ugly memory usage, but it is just a test tool.<br>
&gt;<br>
&gt; I can deploy this with an iterator target and it will take on the limi=
ts of<br>
&gt; the device underneath, or I can skip the iterator target and get limit=
s at<br>
&gt; 2048 sectors.=C2=A0 What I would like to do is set the limit manually.=
=C2=A0 I know<br>
&gt; this is &quot;really bad program design&quot;, but again, this is a te=
st tool and not<br>
&gt; anything for production use.<br>
&gt;<br>
&gt; Can anyone point me at an example of where the limits are setup explic=
itly.<br>
<br>
</div></div>Hi Doug,<br>
<br>
This sounds like a useful target for testing, any chance you could<br>
post it here when you finish it please?<br>
<br>
dm-thin does lots of tweaking of limits, so that&#39;s probably the best on=
e to look at:<br>
<br>
<a href=3D"https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/=
dm-thin.c#L3707" target=3D"_blank">https://github.com/jthornber/linux-2.6/b=
lob/thin-dev/drivers/md/dm-thin.c#L3707</a><br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
- Joe<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--f46d043c7edce8bd18050bf01907--


--===============6893388930467565311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6893388930467565311==--
