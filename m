From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Subject: Re: [3.10.7] Reproductible soft lockup,
	recover but freeze even the mouse
Date: Fri, 13 Sep 2013 09:26:46 +0200
Message-ID: <CAE2SPAazLJQ_fW+cJJ9hkhSXp_DaqQPJ=SbgZBJbrsDBjbn5kw@mail.gmail.com>
References: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com>
	<20130909194826.74d5df39@notabene.brown>
	<CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7911660084857015555=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAE2SPAbAderJBX7cHxDLVdX5KF2uOqnLT9Pbim+90wXwNHh=6g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============7911660084857015555==
Content-Type: multipart/alternative; boundary=001a1133659ce848f604e63ec6e0

--001a1133659ce848f604e63ec6e0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le 9 sept. 2013 12:48, "Bastien ROUCARIES" <roucaries.bastien@gmail.com> a
=C3=A9crit :
>
> On Mon, Sep 9, 2013 at 11:48 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES
> > <roucaries.bastien@gmail.com> wrote:
> >
> >> Hi,
> >>
> >> I experiment a soft lockup. during 20 s I have no mouse, could not
> >> switch back to console and so on.
> >>
> >> I achieve to get a backtrace by echo 15 >
> >> /proc/sys/kernel/hung_task_timeout_secs
> >>
> >> Seems file system related (hdd led is on).

Do you need some trace ? It is fairly reproducible.

Bastien


> >>
> >> My filesystems are ext4 over raid0 so add some cc
> >
> > Appears to be "dm" raid0 rather than "md" raid0 - so not my area.
> > May help to include dm-devel@redhat.com, and maybe include a
description of
> > the dm configuration.  e.g. "dmsetup table" output.
>
> dmsetup  table
> VOL-ROOT: 0 195305472 linear 9:1 2048
> VOL-HOME: 0 1562501120 linear 9:1 195307520
>
> >
> > NeilBrown

--001a1133659ce848f604e63ec6e0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
Le 9 sept. 2013 12:48, &quot;Bastien ROUCARIES&quot; &lt;<a href=3D"mailto:=
roucaries.bastien@gmail.com">roucaries.bastien@gmail.com</a>&gt; a =C3=A9cr=
it=C2=A0:<br>
&gt;<br>
&gt; On Mon, Sep 9, 2013 at 11:48 AM, NeilBrown &lt;<a href=3D"mailto:neilb=
@suse.de">neilb@suse.de</a>&gt; wrote:<br>
&gt; &gt; On Mon, 9 Sep 2013 10:58:12 +0200 Bastien ROUCARIES<br>
&gt; &gt; &lt;<a href=3D"mailto:roucaries.bastien@gmail.com">roucaries.bast=
ien@gmail.com</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt;&gt; Hi,<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; I experiment a soft lockup. during 20 s I have no mouse, coul=
d not<br>
&gt; &gt;&gt; switch back to console and so on.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; I achieve to get a backtrace by echo 15 &gt;<br>
&gt; &gt;&gt; /proc/sys/kernel/hung_task_timeout_secs<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Seems file system related (hdd led is on).<br></p>
<p dir=3D"ltr">Do you need some trace ? It is fairly reproducible.</p>
<p dir=3D"ltr">Bastien<br><br><br></p>
<p dir=3D"ltr">&gt; &gt;&gt;<br>
&gt; &gt;&gt; My filesystems are ext4 over raid0 so add some cc<br>
&gt; &gt;<br>
&gt; &gt; Appears to be &quot;dm&quot; raid0 rather than &quot;md&quot; rai=
d0 - so not my area.<br>
&gt; &gt; May help to include <a href=3D"mailto:dm-devel@redhat.com">dm-dev=
el@redhat.com</a>, and maybe include a description of<br>
&gt; &gt; the dm configuration. =C2=A0e.g. &quot;dmsetup table&quot; output=
.<br>
&gt;<br>
&gt; dmsetup =C2=A0table<br>
&gt; VOL-ROOT: 0 195305472 linear 9:1 2048<br>
&gt; VOL-HOME: 0 1562501120 linear 9:1 195307520<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; NeilBrown<br>
</p>

--001a1133659ce848f604e63ec6e0--


--===============7911660084857015555==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7911660084857015555==--
