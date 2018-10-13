From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/8] various multipath-tools patches
Date: Sat, 13 Oct 2018 10:48:28 +0200
Message-ID: <CABr-GnccAS+-rX0wRd6tXxUGmu+3MkOOzEmkq9=tHoWaSPxyfA@mail.gmail.com>
References: <20181010200506.15796-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2854485570660695850=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010200506.15796-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2854485570660695850==
Content-Type: multipart/alternative; boundary="0000000000003e0618057818450a"

--0000000000003e0618057818450a
Content-Type: text/plain; charset="UTF-8"

Martin,

The 01 to 06 patchs of this set are now merged.

Thanks,
Christophe.

On Wed, Oct 10, 2018 at 10:05 PM Martin Wilck <mwilck@suse.com> wrote:

> Hi Christophe,
>
> this series contains some patches I had on my list for
> some time,  plus some stuff that came up during the discussion
> about Ben's last large patch series.
>
> This goes on top of the "[PATCH 0/6] More misc multipath patches"
> series that Ben sent today.
>
> Regards,
> Martin
>
> Martin Wilck (8):
>   test-kpartx: add test for invocation on image file
>   libmultipath: scsi_ioctl_pathinfo doesn't fail
>   libmultipath: cciss_ioctl_pathinfo doesn't fail
>   multipath.rules: add comment about DM_MULTIPATH_DEVICE_PATH=2
>   multipath.8: man page update
>   libmultipath: test code for "zombie" TUR threads
>   libmultipath: handle TUR threads that can't be cancelled
>   multipathd: handle repeated udev retrigger failure
>
>  kpartx/test-kpartx          |  24 +++-
>  libmultipath/checkers/tur.c |  69 ++++++++-
>  libmultipath/discovery.c    |  33 ++---
>  multipath/multipath.8       | 273 ++++++++++++++++++++++--------------
>  multipath/multipath.rules   |   4 +
>  multipathd/main.c           |  32 +++--
>  6 files changed, 297 insertions(+), 138 deletions(-)
>
> --
> 2.19.0
>
>

--0000000000003e0618057818450a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Martin,<div><br></div><div>The 01 to 06 patchs of this set=
 are now merged.</div><div><br></div><div>Thanks,</div><div>Christophe.</di=
v></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Oct 10, 201=
8 at 10:05 PM Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@su=
se.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Christophe=
,<br>
<br>
this series contains some patches I had on my list for<br>
some time,=C2=A0 plus some stuff that came up during the discussion<br>
about Ben&#39;s last large patch series.<br>
<br>
This goes on top of the &quot;[PATCH 0/6] More misc multipath patches&quot;=
<br>
series that Ben sent today.<br>
<br>
Regards,<br>
Martin<br>
<br>
Martin Wilck (8):<br>
=C2=A0 test-kpartx: add test for invocation on image file<br>
=C2=A0 libmultipath: scsi_ioctl_pathinfo doesn&#39;t fail<br>
=C2=A0 libmultipath: cciss_ioctl_pathinfo doesn&#39;t fail<br>
=C2=A0 multipath.rules: add comment about DM_MULTIPATH_DEVICE_PATH=3D2<br>
=C2=A0 multipath.8: man page update<br>
=C2=A0 libmultipath: test code for &quot;zombie&quot; TUR threads<br>
=C2=A0 libmultipath: handle TUR threads that can&#39;t be cancelled<br>
=C2=A0 multipathd: handle repeated udev retrigger failure<br>
<br>
=C2=A0kpartx/test-kpartx=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 24 +++-<=
br>
=C2=A0libmultipath/checkers/tur.c |=C2=A0 69 ++++++++-<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 |=C2=A0 33 ++---<br>
=C2=A0multipath/multipath.8=C2=A0 =C2=A0 =C2=A0 =C2=A0| 273 +++++++++++++++=
+++++++--------------<br>
=C2=A0multipath/multipath.rules=C2=A0 =C2=A0|=C2=A0 =C2=A04 +<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 32 =
+++--<br>
=C2=A06 files changed, 297 insertions(+), 138 deletions(-)<br>
<br>
-- <br>
2.19.0<br>
<br>
</blockquote></div>

--0000000000003e0618057818450a--


--===============2854485570660695850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2854485570660695850==--
