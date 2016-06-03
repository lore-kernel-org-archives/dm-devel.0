From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipathd: Add 'sysfs' prioritizer
Date: Fri, 3 Jun 2016 09:24:21 +0200
Message-ID: <CABr-Gnd2357TS3UY4DtMqGc0DihRo-CU4hgQ1U9fS5p90=K_NQ@mail.gmail.com>
References: <1463998828-28133-1-git-send-email-hare@suse.de>
	<20160531223414.00004376@localhost> <57512C55.2010008@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5309792012153721432=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57512C55.2010008@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

--===============5309792012153721432==
Content-Type: multipart/alternative; boundary=001a1142b8bc8c510e05345a9c80

--001a1142b8bc8c510e05345a9c80
Content-Type: text/plain; charset=UTF-8

I was waiting to see your response to Ben's comment about the pref bit
default values and tunable.

On Fri, Jun 3, 2016 at 9:05 AM, Hannes Reinecke <hare@suse.de> wrote:

>
>
> On 05/31/2016 10:34 PM, Sebastian Herbszt wrote:
> > Hannes Reinecke wrote:
> >> Recent kernels have an 'access_state' attribute which allows
> >> us to read the asymmetric access state directly from sysfs.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  libmultipath/discovery.c           | 33 +++++++++++++++++++++++++++++
> >>  libmultipath/discovery.h           |  2 ++
> >>  libmultipath/prio.h                |  1 +
> >>  libmultipath/prioritizers/Makefile |  3 ++-
> >>  libmultipath/prioritizers/sysfs.c  | 43
> ++++++++++++++++++++++++++++++++++++++
> >>  libmultipath/propsel.c             |  6 +++++-
> >>  multipath/multipath.conf.5         | 14 ++++++++++++-
> >>  7 files changed, 99 insertions(+), 3 deletions(-)
> >>  create mode 100644 libmultipath/prioritizers/sysfs.c
> >
> > How about just adding this to the alua prioritizer?
> > This new feature could then depend on a "sysfs" argument.
> >
> No. The 'sysfs' prioritizer is using the abstract kernel sysfs
> interface, for which every device handler provides the information.
> So in theory it's independent on the underlying device handler.
>
> However, only the ALUA device handler has been reworked to provide
> up-to-date information; for the other device handlers there is a
> risk of the sysfs information is getting out-of-date.
>
> Hence I've restricted the 'detect_prioritizer' algorithm to select
> 'sysfs' only if an ALUA system is present.
> But this doesn't imply in any way that the 'sysfs' prioritizer can be
> used only for ALUA systems.
>
> Christophe, what about merging the patch?
>
> Cheers,
>
> Hannes
>

--001a1142b8bc8c510e05345a9c80
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I was waiting to see your response to Ben&#39;s comment ab=
out the pref bit default values and tunable.</div><div class=3D"gmail_extra=
"><br><div class=3D"gmail_quote">On Fri, Jun 3, 2016 at 9:05 AM, Hannes Rei=
necke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blan=
k">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><sp=
an class=3D""><br>
<br>
On 05/31/2016 10:34 PM, Sebastian Herbszt wrote:<br>
&gt; Hannes Reinecke wrote:<br>
&gt;&gt; Recent kernels have an &#39;access_state&#39; attribute which allo=
ws<br>
&gt;&gt; us to read the asymmetric access state directly from sysfs.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de"=
>hare@suse.de</a>&gt;<br>
&gt;&gt; ---<br>
&gt;&gt;=C2=A0 libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 33 +++++++++++++++++++++++++++++<br>
&gt;&gt;=C2=A0 libmultipath/discovery.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 2 ++<br>
&gt;&gt;=C2=A0 libmultipath/prio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
&gt;&gt;=C2=A0 libmultipath/prioritizers/Makefile |=C2=A0 3 ++-<br>
&gt;&gt;=C2=A0 libmultipath/prioritizers/sysfs.c=C2=A0 | 43 +++++++++++++++=
+++++++++++++++++++++++<br>
&gt;&gt;=C2=A0 libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 6 +++++-<br>
&gt;&gt;=C2=A0 multipath/multipath.conf.5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| 14 ++++++++++++-<br>
&gt;&gt;=C2=A0 7 files changed, 99 insertions(+), 3 deletions(-)<br>
&gt;&gt;=C2=A0 create mode 100644 libmultipath/prioritizers/sysfs.c<br>
&gt;<br>
&gt; How about just adding this to the alua prioritizer?<br>
&gt; This new feature could then depend on a &quot;sysfs&quot; argument.<br=
>
&gt;<br>
</span>No. The &#39;sysfs&#39; prioritizer is using the abstract kernel sys=
fs<br>
interface, for which every device handler provides the information.<br>
So in theory it&#39;s independent on the underlying device handler.<br>
<br>
However, only the ALUA device handler has been reworked to provide<br>
up-to-date information; for the other device handlers there is a<br>
risk of the sysfs information is getting out-of-date.<br>
<br>
Hence I&#39;ve restricted the &#39;detect_prioritizer&#39; algorithm to sel=
ect<br>
&#39;sysfs&#39; only if an ALUA system is present.<br>
But this doesn&#39;t imply in any way that the &#39;sysfs&#39; prioritizer =
can be<br>
used only for ALUA systems.<br>
<br>
Christophe, what about merging the patch?<br>
<br>
Cheers,<br>
<br>
Hannes<br>
</blockquote></div><br></div>

--001a1142b8bc8c510e05345a9c80--


--===============5309792012153721432==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5309792012153721432==--
