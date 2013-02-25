From: Devin <delldudedevin@gmail.com>
Subject: Re: Multipath / iSCSI issues
Date: Sun, 24 Feb 2013 19:07:24 -0700
Message-ID: <CAEctU6pWmJwJbZd0F+FDTM3YyOrogF4jYav=_hFRcyELqzDVfg@mail.gmail.com>
References: <CAEctU6r9dnVnaMFgzO+8g0ktJ2VFTCaN47NiR5F4QH16_iX53g@mail.gmail.com>
	<512AA728.7040507@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5144029766239862452=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <512AA728.7040507@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5144029766239862452==
Content-Type: multipart/alternative; boundary=bcaec54eea708b44ed04d68300ea

--bcaec54eea708b44ed04d68300ea
Content-Type: text/plain; charset=ISO-8859-1

I am using the iscsi tools that is included with Oracle
(iscsi-initiator-utils-6.2.0.872-13.0.1.el5).

The values I have in my iscsid.conf are:
node.session.timeo.replacement_timeout = 15
node.conn[0].timeo.noop_out_timeout = 1
node.conn[0].timeo.noop_out_interval = 1

{i have previously changed the settings from the values based upon some
feedback I got from a tech guy but that didn't seem to make much
difference}.

In regards to the scsi command timeout it appears to be set to 60.

# cat /sys/block/sdw/device/timeout
60

So is my thinking correct that I will want to have the SCSI devices to
timeout more quickly like 1 second versus the 60 seconds? If so where would
i make this change in regards to the disks???

Thanks much.

Devin Acosta


On Sun, Feb 24, 2013 at 4:50 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 02/24/2013 01:15 PM, Devin wrote:
> >
> > I am running Oracle Enterprise Linux 5.8 (which is really just Redhat).
> > I am using Multipath and I have LUNS presented to me via iSCSI from a
> > Hitachi SAN. I have the NICS bonded using the Linux bonding driver and
> > using Active-Backup mode. I notice that when I loose a switch or
> > connection to one of the switches that multipath freezes for at least 60
> > seconds before it starts to respond again. Also it appears that IO being
> > generated freezes until multipath responds again, this pause up to 60
> > seconds is causing my Oracle instances to crash.
> >
> > I have not been able to easily find what settings i could possibly
> > change to make it fail to a new path faster. It almost seems like it's
> > taking multipath a bit to fail all IO to a new path that is working.
> >
> > Is there any information that might be useful for me that I can check on
> > either the multipath side or the iSCSI side to see what is causing the
> > issue???
> >
>
> What iscsi driver are you using? If you are using software iscsi that
> comes with OEL 5.8 what are our node.session.timeo.replacement_timeout,
> .timeo.noop_out_timeout and .timeo.noop_out_interval. And what is your
> scsi command timeout. You can see that by doing:
>
> cat /sys/block/sdX/device/timeout
>
>
>

--bcaec54eea708b44ed04d68300ea
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div style>I am using the iscsi tools that is included=
 with Oracle (iscsi-initiator-utils-6.2.0.872-13.0.1.el5).=A0</div><div sty=
le><br></div><div style>The values I have in my iscsid.conf are:</div><div =
style>
node.session.timeo.replacement_timeout =3D 15<br></div><div style><div>node=
.conn[0].timeo.noop_out_timeout =3D 1</div><div><div>node.conn[0].timeo.noo=
p_out_interval =3D 1</div></div><div><br></div><div style>{i have previousl=
y changed the settings from the values based upon some feedback I got from =
a tech guy but that didn&#39;t seem to make much difference}.</div>
<div style><br></div><div style>In regards to the scsi command timeout it a=
ppears to be set to 60.</div><div style><div><br></div><div># cat /sys/bloc=
k/sdw/device/timeout=A0</div><div>60</div><div><br></div><div style>So is m=
y thinking correct that I will want to have the SCSI devices to timeout mor=
e quickly like 1 second versus the 60 seconds? If so where would i make thi=
s change in regards to the disks???</div>
<div style><br></div><div style>Thanks much.</div><div style><br></div><div=
 style>Devin Acosta</div></div></div></div><div class=3D"gmail_extra"><br><=
br><div class=3D"gmail_quote">On Sun, Feb 24, 2013 at 4:50 PM, Mike Christi=
e <span dir=3D"ltr">&lt;<a href=3D"mailto:michaelc@cs.wisc.edu" target=3D"_=
blank">michaelc@cs.wisc.edu</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 0=
2/24/2013 01:15 PM, Devin wrote:<br>
&gt;<br>
&gt; I am running Oracle Enterprise Linux 5.8 (which is really just Redhat)=
.<br>
&gt; I am using Multipath and I have LUNS presented to me via iSCSI from a<=
br>
&gt; Hitachi SAN. I have the NICS bonded using the Linux bonding driver and=
<br>
&gt; using Active-Backup mode. I notice that when I loose a switch or<br>
&gt; connection to one of the switches that multipath freezes for at least =
60<br>
&gt; seconds before it starts to respond again. Also it appears that IO bei=
ng<br>
&gt; generated freezes until multipath responds again, this pause up to 60<=
br>
&gt; seconds is causing my Oracle instances to crash.<br>
&gt;<br>
&gt; I have not been able to easily find what settings i could possibly<br>
&gt; change to make it fail to a new path faster. It almost seems like it&#=
39;s<br>
&gt; taking multipath a bit to fail all IO to a new path that is working.<b=
r>
&gt;<br>
&gt; Is there any information that might be useful for me that I can check =
on<br>
&gt; either the multipath side or the iSCSI side to see what is causing the=
<br>
&gt; issue???<br>
&gt;<br>
<br>
</div></div>What iscsi driver are you using? If you are using software iscs=
i that<br>
comes with OEL 5.8 what are our node.session.timeo.replacement_timeout,<br>
.timeo.noop_out_timeout and .timeo.noop_out_interval. And what is your<br>
scsi command timeout. You can see that by doing:<br>
<br>
cat /sys/block/sdX/device/timeout<br>
<br>
<br>
</blockquote></div><br></div>

--bcaec54eea708b44ed04d68300ea--


--===============5144029766239862452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5144029766239862452==--
