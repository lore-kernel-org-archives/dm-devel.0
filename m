From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 00/12] fixes for kpartx -d
Date: Thu, 18 May 2017 00:25:18 +0200
Message-ID: <CABr-GnfFt=cfUzrUPXvGZ3TNyGP5ixCukrPWztXd28nW49N5Uw@mail.gmail.com>
References: <20170515153722.11508-1-mwilck@suse.com>
	<20170517170610.GQ22856@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8165308467340145249=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517170610.GQ22856@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============8165308467340145249==
Content-Type: multipart/alternative; boundary="001a113cf13c6195a5054fbfc32b"

--001a113cf13c6195a5054fbfc32b
Content-Type: text/plain; charset="UTF-8"

The set is merged, thanks.

On Wed, May 17, 2017 at 7:06 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Mon, May 15, 2017 at 05:37:10PM +0200, Martin Wilck wrote:
>
> ACK for the set
>
> -Ben
>
> > Working on a bug report about kpartx not properly removing
> > partitions for loop devices, I realized a number of glitches
> > and improperly handled corner cases in the kpartx code for
> > deleting partitions. Some mappings are not deleted although
> > they should be, and others are deleted although that is clearly
> > wrong.
> >
> > This patch series fixes the issues I found. The series starts
> > with a test program demonstrating the problems. The program
> > succeeds only after all patches of this series are applied.
> >
> > Here is my summary of what I think how kpartx should behave:
> >
> >   1) kpartx should delete all mappings it created beforehand.
> >   2) kpartx should handle partitions on dm devices and other devices
> >      (e.g. loop devices) equally well.
> >   3) kpartx should only delete "partitions", which are single-target
> >      linear mappings into a block device. Other maps should not be
> touched.
> >   4) kpartx should only delete mappings it created itself beforehand.
> >      In particular, it shouldn't delete LVM LVs, even if they are fully
> >      contained in the block device at hand and thus look like partitions
> >      in the first place. (For historical compatibility reasons, allow
> >      such mappings to be deleted with the -f/--force flag).
> >   5) DM map names may be changed, thus kpartx shouldn't rely on them to
> >      check whether a mapping is a partition of a particular device. It is
> >      legal for a partition of /dev/loop0 to be named "loop0".
> >
> > One patch has an obvious libdevmapper equivalent and is therefore
> > included (08/12) although this series is otherwise focused only on
> kpartx.
> > Patch 04/12 would also have a libdevmapper equivalent, but I haven't
> > included it because it would conflict with Ben's previously posted
> > patch "libmultipath: fix partition detection".
> >
> > The patches are based on Christophe's tree; Christophe, if you prefer,
> > I can rebase them on top of Ben's late submissions.
> >
> > Feedback is welcome.
> >
> > Changes wrt v1:
> > - Test program (01/12): improved cleanup, and used "kpartx -s" rather
> than waiting.
> > - At Ben's suggestion, removed "no_partitions" support rather than
> fixing it.
> > - Previous 04/12 split into two patches (04+05/12), improving and
> separating
> >   out the part that would similarly apply to libmultipath (see above).
> > - New UUID format in patch 09/12 since the previous one wasn't
> well-received;
> >   the "-kpartx-" part was superfluous, as partition UUIDs start with
> "part%s-" anyway.
> > - Added the trivial fix 12/12.
> >
> > Martin Wilck (12):
> >   kpartx: test-kpartx: new unit test program
> >   kpartx: remove "no_partitions" support
> >   kpartx: remove is_loop_device
> >   kpartx: relax and improve UUID check in dm_compare_uuid
> >   kpartx: dm_remove_partmaps: support non-dm devices
> >   kpartx: dm_devn: return error for non-existent device
> >   kpartx: don't treat multi-linear mappings as partitions
> >   libmultipath: don't treat multi-linear mappings as partitions
> >   kpartx: use partition UUID for non-DM devices
> >   kpartx: use absolute path for regular files
> >   kpartx: find_loop_by_file: use sysfs
> >   kpartx: include sys/sysmacros.h
> >
> >  kpartx/devmapper.c       |  80 ++++++---------
> >  kpartx/devmapper.h       |   2 +-
> >  kpartx/kpartx.c          |  50 ++++++++--
> >  kpartx/lopart.c          |  75 ++++++--------
> >  kpartx/lopart.h          |   1 -
> >  kpartx/sysmacros.h       |   9 --
> >  kpartx/test-kpartx       | 254 ++++++++++++++++++++++++++++++
> +++++++++++++++++
> >  libmultipath/devmapper.c |  15 +--
> >  8 files changed, 371 insertions(+), 115 deletions(-)
> >  delete mode 100644 kpartx/sysmacros.h
> >  create mode 100755 kpartx/test-kpartx
> >
> > --
> > 2.12.2
>

--001a113cf13c6195a5054fbfc32b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The set is merged, thanks.</div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, May 17, 2017 at 7:06 PM, Benjamin M=
arzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" targe=
t=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Mon, May 15, 2017 at 05:37:10PM +0200, Martin Wilck wrote:=
<br>
<br>
ACK for the set<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Working on a bug report about kpartx not properly removing<br>
&gt; partitions for loop devices, I realized a number of glitches<br>
&gt; and improperly handled corner cases in the kpartx code for<br>
&gt; deleting partitions. Some mappings are not deleted although<br>
&gt; they should be, and others are deleted although that is clearly<br>
&gt; wrong.<br>
&gt;<br>
&gt; This patch series fixes the issues I found. The series starts<br>
&gt; with a test program demonstrating the problems. The program<br>
&gt; succeeds only after all patches of this series are applied.<br>
&gt;<br>
&gt; Here is my summary of what I think how kpartx should behave:<br>
&gt;<br>
&gt;=C2=A0 =C2=A01) kpartx should delete all mappings it created beforehand=
.<br>
&gt;=C2=A0 =C2=A02) kpartx should handle partitions on dm devices and other=
 devices<br>
&gt;=C2=A0 =C2=A0 =C2=A0 (e.g. loop devices) equally well.<br>
&gt;=C2=A0 =C2=A03) kpartx should only delete &quot;partitions&quot;, which=
 are single-target<br>
&gt;=C2=A0 =C2=A0 =C2=A0 linear mappings into a block device. Other maps sh=
ould not be touched.<br>
&gt;=C2=A0 =C2=A04) kpartx should only delete mappings it created itself be=
forehand.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 In particular, it shouldn&#39;t delete LVM LVs, ev=
en if they are fully<br>
&gt;=C2=A0 =C2=A0 =C2=A0 contained in the block device at hand and thus loo=
k like partitions<br>
&gt;=C2=A0 =C2=A0 =C2=A0 in the first place. (For historical compatibility =
reasons, allow<br>
&gt;=C2=A0 =C2=A0 =C2=A0 such mappings to be deleted with the -f/--force fl=
ag).<br>
&gt;=C2=A0 =C2=A05) DM map names may be changed, thus kpartx shouldn&#39;t =
rely on them to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 check whether a mapping is a partition of a partic=
ular device. It is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 legal for a partition of /dev/loop0 to be named &q=
uot;loop0&quot;.<br>
&gt;<br>
&gt; One patch has an obvious libdevmapper equivalent and is therefore<br>
&gt; included (08/12) although this series is otherwise focused only on kpa=
rtx.<br>
&gt; Patch 04/12 would also have a libdevmapper equivalent, but I haven&#39=
;t<br>
&gt; included it because it would conflict with Ben&#39;s previously posted=
<br>
&gt; patch &quot;libmultipath: fix partition detection&quot;.<br>
&gt;<br>
&gt; The patches are based on Christophe&#39;s tree; Christophe, if you pre=
fer,<br>
&gt; I can rebase them on top of Ben&#39;s late submissions.<br>
&gt;<br>
&gt; Feedback is welcome.<br>
&gt;<br>
&gt; Changes wrt v1:<br>
&gt; - Test program (01/12): improved cleanup, and used &quot;kpartx -s&quo=
t; rather than waiting.<br>
&gt; - At Ben&#39;s suggestion, removed &quot;no_partitions&quot; support r=
ather than fixing it.<br>
&gt; - Previous 04/12 split into two patches (04+05/12), improving and sepa=
rating<br>
&gt;=C2=A0 =C2=A0out the part that would similarly apply to libmultipath (s=
ee above).<br>
&gt; - New UUID format in patch 09/12 since the previous one wasn&#39;t wel=
l-received;<br>
&gt;=C2=A0 =C2=A0the &quot;-kpartx-&quot; part was superfluous, as partitio=
n UUIDs start with &quot;part%s-&quot; anyway.<br>
&gt; - Added the trivial fix 12/12.<br>
&gt;<br>
&gt; Martin Wilck (12):<br>
&gt;=C2=A0 =C2=A0kpartx: test-kpartx: new unit test program<br>
&gt;=C2=A0 =C2=A0kpartx: remove &quot;no_partitions&quot; support<br>
&gt;=C2=A0 =C2=A0kpartx: remove is_loop_device<br>
&gt;=C2=A0 =C2=A0kpartx: relax and improve UUID check in dm_compare_uuid<br=
>
&gt;=C2=A0 =C2=A0kpartx: dm_remove_partmaps: support non-dm devices<br>
&gt;=C2=A0 =C2=A0kpartx: dm_devn: return error for non-existent device<br>
&gt;=C2=A0 =C2=A0kpartx: don&#39;t treat multi-linear mappings as partition=
s<br>
&gt;=C2=A0 =C2=A0libmultipath: don&#39;t treat multi-linear mappings as par=
titions<br>
&gt;=C2=A0 =C2=A0kpartx: use partition UUID for non-DM devices<br>
&gt;=C2=A0 =C2=A0kpartx: use absolute path for regular files<br>
&gt;=C2=A0 =C2=A0kpartx: find_loop_by_file: use sysfs<br>
&gt;=C2=A0 =C2=A0kpartx: include sys/sysmacros.h<br>
&gt;<br>
&gt;=C2=A0 kpartx/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 80 ++++++--=
-------<br>
&gt;=C2=A0 kpartx/devmapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<=
br>
&gt;=C2=A0 kpartx/kpartx.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 50 +++=
+++++--<br>
&gt;=C2=A0 kpartx/lopart.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 75 +++=
+++--------<br>
&gt;=C2=A0 kpartx/lopart.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0=
1 -<br>
&gt;=C2=A0 kpartx/sysmacros.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A09 --<=
br>
&gt;=C2=A0 kpartx/test-kpartx=C2=A0 =C2=A0 =C2=A0 =C2=A0| 254 +++++++++++++=
+++++++++++++++++<wbr>+++++++++++++++++<br>
&gt;=C2=A0 libmultipath/devmapper.c |=C2=A0 15 +--<br>
&gt;=C2=A0 8 files changed, 371 insertions(+), 115 deletions(-)<br>
&gt;=C2=A0 delete mode 100644 kpartx/sysmacros.h<br>
&gt;=C2=A0 create mode 100755 kpartx/test-kpartx<br>
&gt;<br>
&gt; --<br>
&gt; 2.12.2<br>
</div></div></blockquote></div><br></div>

--001a113cf13c6195a5054fbfc32b--


--===============8165308467340145249==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8165308467340145249==--
