From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 09:58:00 -0400
Message-ID: <7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7725656226562490350=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============7725656226562490350==
Content-Type: multipart/alternative; boundary=00c09f8017914217aa048227bc52

--00c09f8017914217aa048227bc52
Content-Type: text/plain; charset=ISO-8859-1

Hey Kay,

On Fri, Mar 19, 2010 at 9:43 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, Mar 19, 2010 at 14:24, Peter Rajnoha <prajnoha@redhat.com> wrote:
> > On 03/19/2010 10:24 AM, Kay Sievers wrote:
> >> No, that's what "change" is for, and we already have these "change"
> >> events for dm. Udev does not care if the device is ready or not, it
> >> synchronizes /sys and /dev, and that works just fine with "change"
> >> events.
> >
> > CHANGE events, not quite... We can't even rely on these.
> >
> > Just to mention, there's also a CHANGE event generated when
> > read-only flag is set for a device (this is not managed by
> > device-mapper of course). This one is generated even before
> > the actual CHANGE event that is generated when DM device is
> > ready to be used.
>
> Sure, but as mentioned earlier, these events are just expected to
> fail, and update the current udev state, if they can't retrieve the
> needed information or find out that the device in not usable.
>

I think the problem is the that fact that 3rd party user space
opens the device before it is ready (e.g. just after ADD but before
the first CHANGE) makes things fall over.

This short-coming is what needs to get fixed, I think - it's very
fragile this way and since any random user / package can add
rules to open the device on add events, said user / package can
make device-mapper fail. Which doesn't exactly strike me
as robust behavior.

While Alasdair may believe this is "silly" or because someone
is "confused", this can and will happen because our current
user-base love to fiddle around with udev rules to the extent
that various 3rd party packages will ship a lot of them.

     David

--00c09f8017914217aa048227bc52
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hey Kay,</div><div><br></div>On Fri, Mar 19, 2010 at 9:43 AM, Kay Siev=
ers <span dir=3D"ltr">&lt;<a href=3D"mailto:kay.sievers@vrfy.org">kay.sieve=
rs@vrfy.org</a>&gt;</span> wrote:<br><div class=3D"gmail_quote"><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex;">
<div class=3D"im">On Fri, Mar 19, 2010 at 14:24, Peter Rajnoha &lt;<a href=
=3D"mailto:prajnoha@redhat.com">prajnoha@redhat.com</a>&gt; wrote:<br>
&gt; On 03/19/2010 10:24 AM, Kay Sievers wrote:<br>
&gt;&gt; No, that&#39;s what &quot;change&quot; is for, and we already have=
 these &quot;change&quot;<br>
&gt;&gt; events for dm. Udev does not care if the device is ready or not, i=
t<br>
&gt;&gt; synchronizes /sys and /dev, and that works just fine with &quot;ch=
ange&quot;<br>
&gt;&gt; events.<br>
&gt;<br>
&gt; CHANGE events, not quite... We can&#39;t even rely on these.<br>
&gt;<br>
&gt; Just to mention, there&#39;s also a CHANGE event generated when<br>
&gt; read-only flag is set for a device (this is not managed by<br>
&gt; device-mapper of course). This one is generated even before<br>
&gt; the actual CHANGE event that is generated when DM device is<br>
&gt; ready to be used.<br>
<br>
</div>Sure, but as mentioned earlier, these events are just expected to<br>
fail, and update the current udev state, if they can&#39;t retrieve the<br>
needed information or find out that the device in not usable.<br></blockquo=
te><div><br></div><div>I think the problem is the that fact that 3rd party =
user space</div><div>opens the device before it is ready (e.g. just after A=
DD but before</div>
<div>the first CHANGE) makes things fall over.</div><div><br></div><div>Thi=
s short-coming is=A0what=A0needs to get fixed, I think - it&#39;s very</div=
><div>fragile this way and=A0since any random=A0user / package can add</div=
><div>
rules to open the=A0device on add events, said user / package can</div><div=
>make device-mapper=A0fail. Which doesn&#39;t exactly strike me</div><div>a=
s robust behavior.</div><div><br></div><div>While Alasdair may believe this=
 is=A0&quot;silly&quot; or because someone</div>
<div>is &quot;confused&quot;, this can and will=A0happen because our curren=
t</div><div>user-base love to fiddle around=A0with udev rules to the extent=
</div><div>that various 3rd party packages will ship a lot of them.</div><d=
iv>
<br></div><div>=A0=A0 =A0 David</div><div><br></div></div>

--00c09f8017914217aa048227bc52--


--===============7725656226562490350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7725656226562490350==--
