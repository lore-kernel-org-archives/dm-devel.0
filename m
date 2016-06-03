From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/7] multpath patch sync
Date: Fri, 3 Jun 2016 09:01:00 +0200
Message-ID: <CABr-GnfV+0EmZTd3nOe-gAjacqO+oY+fp7b0+=BEmAjvBM_Row@mail.gmail.com>
References: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0057646017945141244=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0057646017945141244==
Content-Type: multipart/alternative; boundary=001a1141069e14565005345a4926

--001a1141069e14565005345a4926
Content-Type: text/plain; charset=UTF-8

The patchset is merged, except patch 3 and 4, pending review and comments.

Patch is rebased, being broken by the json config patch merged ealier. I
verified this json config uses the locked handler.

Thanks.

On Wed, Jun 1, 2016 at 1:16 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> This series is a resend of my previous "handler fixes" patch, along with
> some
> bug fixes, a new default configuration, and a new attempt to make multipath
> able to skip kpartx handling on devices.
>
> Benjamin Marzinski (7):
>   multipathd: handler fixes
>   libmultipath: remove calls to dm_udev_complete
>   libmultipath: add skip_kpartx option
>   kpartx.rules: respect skip_kpartx flag
>   multipath: validate devmap names
>   libmultipath: add Huawei Storage default config
>   kpartx: fix dos partition rollover error
>
>  kpartx/devmapper.c         | 20 +++------------
>  kpartx/dos.c               |  2 +-
>  kpartx/kpartx.rules        |  2 ++
>  libmultipath/alias.c       |  8 ++++++
>  libmultipath/alias.h       |  1 +
>  libmultipath/config.c      |  2 ++
>  libmultipath/config.h      |  3 +++
>  libmultipath/configure.c   |  5 ++--
>  libmultipath/defaults.h    |  1 +
>  libmultipath/devmapper.c   | 62
> +++++++++++++++++++++++++---------------------
>  libmultipath/devmapper.h   |  8 +++++-
>  libmultipath/dict.c        | 13 ++++++++++
>  libmultipath/hwtable.c     |  9 +++++++
>  libmultipath/propsel.c     | 18 ++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     |  7 ++++++
>  multipath/main.c           |  7 +++++-
>  multipath/multipath.conf.5 | 12 +++++++++
>  multipathd/cli.c           |  2 +-
>  multipathd/cli_handlers.c  |  4 ++-
>  multipathd/main.c          |  4 +--
>  21 files changed, 138 insertions(+), 53 deletions(-)
>
> --
> 1.8.3.1
>
>

--001a1141069e14565005345a4926
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The patchset is merged, except patch 3 and 4, pending revi=
ew and comments.<div><br></div><div>Patch is rebased, being broken by the j=
son config patch merged ealier. I verified this json config uses the locked=
 handler.</div><div><br></div><div>Thanks.</div></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Wed, Jun 1, 2016 at 1:16 AM, Benjam=
in Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" t=
arget=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">This series is a resend of my previous &quot;handler fixe=
s&quot; patch, along with some<br>
bug fixes, a new default configuration, and a new attempt to make multipath=
<br>
able to skip kpartx handling on devices.<br>
<br>
Benjamin Marzinski (7):<br>
=C2=A0 multipathd: handler fixes<br>
=C2=A0 libmultipath: remove calls to dm_udev_complete<br>
=C2=A0 libmultipath: add skip_kpartx option<br>
=C2=A0 kpartx.rules: respect skip_kpartx flag<br>
=C2=A0 multipath: validate devmap names<br>
=C2=A0 libmultipath: add Huawei Storage default config<br>
=C2=A0 kpartx: fix dos partition rollover error<br>
<br>
=C2=A0kpartx/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 20 +++---------=
---<br>
=C2=A0kpartx/dos.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 2 +-<br>
=C2=A0kpartx/kpartx.rules=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 ++<br>
=C2=A0libmultipath/alias.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 8 ++++++<br>
=C2=A0libmultipath/alias.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 ++<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +++<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0|=C2=A0 5 ++--<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0| 62 +++++++++++++++++++++++++--=
-------------------<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0|=C2=A0 8 +++++-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 ++++++++++<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 9 +++++++<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0| 18 ++++++++++++++<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 7 ++++++<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 7 ++=
+++-<br>
=C2=A0multipath/multipath.conf.5 | 12 +++++++++<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-=
<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 |=C2=A0 4 ++-<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 +--<br>
=C2=A021 files changed, 138 insertions(+), 53 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1141069e14565005345a4926--


--===============0057646017945141244==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0057646017945141244==--
