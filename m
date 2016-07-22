From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/3] sysfs prioritizer
Date: Fri, 22 Jul 2016 11:44:01 +0200
Message-ID: <CABr-Gnfxpra=oriKQSmqjc+WLNHc1Z+7k30TCvA2FhD0NU-9wA@mail.gmail.com>
References: <1468565337-5178-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4279678895724952360=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468565337-5178-1-git-send-email-hare@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4279678895724952360==
Content-Type: multipart/alternative; boundary=001a1140211e44565405383646c8

--001a1140211e44565405383646c8
Content-Type: text/plain; charset=UTF-8

Finally merged.
Thanks.

On Fri, Jul 15, 2016 at 8:48 AM, Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
>
> this is a resend of a previous patchset for adding a 'sysfs'
> prioritizer. This prioritizer uses the sysfs attributes
> 'access_state' and 'exclusive_pref_bit' to generate the
> path priority.
> Priority values are identical to those from the 'alua'
> prioritizer.
>
> Note: the mentioned sysfs attributes are filled in by
> every device handler, but only the 'alua' handler has
> enough logic to keep them up-to-date.
> So use with caution for other device handlers.
>
> Hannes Reinecke (3):
>   libmultipath: call get_vpd_uid() if no uid_attribute is set
>   alua prioritizer: Fix typo 'perf'
>   multipathd: Add 'sysfs' prioritizer
>
>  libmultipath/discovery.c           | 36 ++++++++++++++++++++++
>  libmultipath/discovery.h           |  2 ++
>  libmultipath/prio.h                |  1 +
>  libmultipath/prioritizers/Makefile |  3 +-
>  libmultipath/prioritizers/alua.c   |  8 ++---
>  libmultipath/prioritizers/sysfs.c  | 61
> ++++++++++++++++++++++++++++++++++++++
>  libmultipath/propsel.c             |  6 +++-
>  multipath/multipath.conf.5         | 19 ++++++++++--
>  8 files changed, 127 insertions(+), 9 deletions(-)
>  create mode 100644 libmultipath/prioritizers/sysfs.c
>
> --
> 2.6.6
>
>

--001a1140211e44565405383646c8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Finally merged.<div>Thanks.</div></div><div class=3D"gmail=
_extra"><br><div class=3D"gmail_quote">On Fri, Jul 15, 2016 at 8:48 AM, Han=
nes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=
=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">Hi all,<br>
<br>
this is a resend of a previous patchset for adding a &#39;sysfs&#39;<br>
prioritizer. This prioritizer uses the sysfs attributes<br>
&#39;access_state&#39; and &#39;exclusive_pref_bit&#39; to generate the<br>
path priority.<br>
Priority values are identical to those from the &#39;alua&#39;<br>
prioritizer.<br>
<br>
Note: the mentioned sysfs attributes are filled in by<br>
every device handler, but only the &#39;alua&#39; handler has<br>
enough logic to keep them up-to-date.<br>
So use with caution for other device handlers.<br>
<br>
Hannes Reinecke (3):<br>
=C2=A0 libmultipath: call get_vpd_uid() if no uid_attribute is set<br>
=C2=A0 alua prioritizer: Fix typo &#39;perf&#39;<br>
=C2=A0 multipathd: Add &#39;sysfs&#39; prioritizer<br>
<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 36=
 ++++++++++++++++++++++<br>
=C2=A0libmultipath/discovery.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 2 ++<br>
=C2=A0libmultipath/prio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/prioritizers/Makefile |=C2=A0 3 +-<br>
=C2=A0libmultipath/prioritizers/alua.c=C2=A0 =C2=A0|=C2=A0 8 ++---<br>
=C2=A0libmultipath/prioritizers/sysfs.c=C2=A0 | 61 ++++++++++++++++++++++++=
++++++++++++++<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 6 +++-<br>
=C2=A0multipath/multipath.conf.5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 19 ++++=
++++++--<br>
=C2=A08 files changed, 127 insertions(+), 9 deletions(-)<br>
=C2=A0create mode 100644 libmultipath/prioritizers/sysfs.c<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.6.6<br>
<br>
</font></span></blockquote></div><br></div>

--001a1140211e44565405383646c8--


--===============4279678895724952360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4279678895724952360==--
