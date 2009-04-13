From: Larry Dickson <ldickson@cuttedge.com>
Subject: Re: SMP-aware kcryptd?
Date: Mon, 13 Apr 2009 11:33:49 -0800
Message-ID: <1c748a490904131233g53876794wa920e1dc267218ff@mail.gmail.com>
References: <49E3410D.9040500@wpkg.org> <49E37824.8010100@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1941653614=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E37824.8010100@redhat.com>
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
Cc: dm-crypt@saout.de
List-Id: dm-devel.ids

--===============1941653614==
Content-Type: multipart/alternative; boundary=0016364179372a996a046774cbd5

--0016364179372a996a046774cbd5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 4/13/09, Milan Broz <mbroz@redhat.com> wrote:
>
> Tomasz Chmielewski wrote:
> > Currently, the trend with CPUs is to add more cores rather than increase
> > the speed of a single core.
> >
> > This does not scale very well with certain things in the Linux kernel.
> > One of them is kcryptd.
> >
> >
> > A system able to deliver data with a speed of ~200 MB/s from a RAID
> > array, will be only able to deliver a fraction of it (i.e. ~40 MB/s in
> > my case) when reads are being done from a dm-crypt device.
> >
> > This is because kcryptd is not SMP-aware: it performs all calculations
> > on a single logical CPU only.
> >
> > Are there any plans to change it?
>
> Yes, I think I already commented this in some thread,
> there are basically 2 possible approaches:
>
> 1) create several "encryption" threads in dm-crypt (e.g. per CPU core) or
> 2) parallelize async crypto requests processing (in crypto layer)
>
> I have some patches for 1) but the result is not what I expected
> - performance highly depends on write pattern for example.
> In short, the code need more thought.


This is a golden opportunity. So many times, code (e.g. barriers) that still
may "need more thought" has been rushed into production, leaving headaches
that apparently last forever. I think this is a chance to get everyone in at
the design stage. Can you publish a short sketch of the proposed design
approaches for 1) and 2), with their advantages and drawbacks?

Larry Dickson
Cutting Edge Networked Storage

(I tried to parallelize sector encryption _vs_ whole bio request encryption,
> and there are still some problem with both. Also barriers and reordering
> of requests can be problem here.)
>
> Another problem with 1) is what happens when there is hw acceleration -
> multiple threads are useful only if main cpu runs encryption,
> for hw & async crypto requests it can cause problems.
>
> The crypto driver is completely transparent - dm-crypt have no idea
> if encryption runs on main cpu or in an accelerator hw
> (=> solution 2) is more generic).
>
> Anyway, it is not highest priority currently... but still in slow progress.
> (but I guess high speed SSDs will increase priority for this too,
> currently it is real problem only for RAID arrays:-)
>
> Milan
> --
> mbroz@redhat.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--0016364179372a996a046774cbd5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br>
<div><span class=3D"gmail_quote">On 4/13/09, <b class=3D"gmail_sendername">=
Milan Broz</b> &lt;<a href=3D"mailto:mbroz@redhat.com">mbroz@redhat.com</a>=
&gt; wrote:</span>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Tomasz Chmielewski wrote:<br>&gt=
; Currently, the trend with CPUs is to add more cores rather than increase<=
br>
&gt; the speed of a single core.<br>&gt;<br>&gt; This does not scale very w=
ell with certain things in the Linux kernel.<br>&gt; One of them is kcryptd=
.<br>&gt;<br>&gt;<br>&gt; A system able to deliver data with a speed of ~20=
0 MB/s from a RAID<br>
&gt; array, will be only able to deliver a fraction of it (i.e. ~40 MB/s in=
<br>&gt; my case) when reads are being done from a dm-crypt device.<br>&gt;=
<br>&gt; This is because kcryptd is not SMP-aware: it performs all calculat=
ions<br>
&gt; on a single logical CPU only.<br>&gt;<br>&gt; Are there any plans to c=
hange it?<br><br>Yes, I think I already commented this in some thread,<br>t=
here are basically 2 possible approaches:<br><br>1) create several &quot;en=
cryption&quot; threads in dm-crypt (e.g. per CPU core) or<br>
2) parallelize async crypto requests processing (in crypto layer)<br><br>I =
have some patches for 1) but the result is not what I expected<br>- perform=
ance highly depends on write pattern for example.<br>In short, the code nee=
d more thought.</blockquote>

<div>=A0</div>
<div>This is a golden opportunity. So many times, code (e.g. barriers) that=
 still may &quot;need more thought&quot; has been rushed into production, l=
eaving headaches that apparently last forever. I think this is a chance to =
get everyone in at the design stage. Can you publish a short sketch of the =
proposed design approaches for 1) and 2), with their advantages and drawbac=
ks?</div>

<div>=A0</div>
<div>Larry Dickson</div>
<div>Cutting Edge Networked Storage</div><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">(I tried to parallelize sector e=
ncryption _vs_ whole bio request encryption,<br>and there are still some pr=
oblem with both. Also barriers and reordering<br>
of requests can be problem here.)<br><br>Another problem with 1) is what ha=
ppens when there is hw acceleration -<br>multiple threads are useful only i=
f main cpu runs encryption,<br>for hw &amp; async crypto requests it can ca=
use problems.<br>
<br>The crypto driver is completely transparent - dm-crypt have no idea<br>=
if encryption runs on main cpu or in an accelerator hw<br>(=3D&gt; solution=
 2) is more generic).<br><br>Anyway, it is not highest priority currently..=
. but still in slow progress.<br>
(but I guess high speed SSDs will increase priority for this too,<br>curren=
tly it is real problem only for RAID arrays:-)<br><br>Milan<br>--<br><a hre=
f=3D"mailto:mbroz@redhat.com">mbroz@redhat.com</a><br><br>--<br>dm-devel ma=
iling list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href=
=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.co=
m/mailman/listinfo/dm-devel</a><br></blockquote></div><br>

--0016364179372a996a046774cbd5--


--===============1941653614==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1941653614==--
