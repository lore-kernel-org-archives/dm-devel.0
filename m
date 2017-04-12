From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/9] misc cleanups and bugfixes
Date: Wed, 12 Apr 2017 09:36:19 +0200
Message-ID: <CABr-GnfW5t_CCdziuDi=xdAB1xQSfn4fhBSXpyMzv=Qy-YDf9Q@mail.gmail.com>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8404703549172721653=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
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

--===============8404703549172721653==
Content-Type: multipart/alternative; boundary=001a114753aeb3efc7054cf343aa

--001a114753aeb3efc7054cf343aa
Content-Type: text/plain; charset=UTF-8

Merged,
thanks.

On Fri, Apr 7, 2017 at 8:16 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> These patches are all just small cleanup and bugfixes.
>
> Benjamin Marzinski (9):
>   libdmmp: minor Makefile cleanup
>   multipath-tools: remove incdir from Makefiles
>   libdmmp: don't disconnect from multipathd twice
>   multipathd: don't call strlen on NULL variables
>   libdmmp: move libdmmp.pc install location
>   multipathd: drop lock before calling uev_add_path
>   multipathd: allow devices to switch from RW to RO
>   libmultipath: don't set max_sectors_kb on reloads
>   multipath: fix segfault with disable_changed_wwids
>
>  Makefile.inc             |  3 +--
>  libdmmp/Makefile         | 18 +++++++--------
>  libdmmp/libdmmp.c        |  1 -
>  libdmmp/test/Makefile    |  2 +-
>  libmpathcmd/Makefile     |  6 ++---
>  libmpathpersist/Makefile |  6 ++---
>  libmultipath/configure.c | 60 ++++++++++++++++++++++++++++++
> ++++++++++++++++--
>  libmultipath/devmapper.c |  9 ++++----
>  libmultipath/discovery.c | 23 -------------------
>  libmultipath/discovery.h |  1 -
>  libmultipath/structs.h   |  1 +
>  multipathd/main.c        | 21 ++++++++++++-----
>  12 files changed, 96 insertions(+), 55 deletions(-)
>
> --
> 1.8.3.1
>
>

--001a114753aeb3efc7054cf343aa
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Apr 7, 2017 at 8:16 AM, Benjamin Mar=
zinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">These patches are all just small cleanup and bugfixes.<br>
<br>
Benjamin Marzinski (9):<br>
=C2=A0 libdmmp: minor Makefile cleanup<br>
=C2=A0 multipath-tools: remove incdir from Makefiles<br>
=C2=A0 libdmmp: don&#39;t disconnect from multipathd twice<br>
=C2=A0 multipathd: don&#39;t call strlen on NULL variables<br>
=C2=A0 libdmmp: move libdmmp.pc install location<br>
=C2=A0 multipathd: drop lock before calling uev_add_path<br>
=C2=A0 multipathd: allow devices to switch from RW to RO<br>
=C2=A0 libmultipath: don&#39;t set max_sectors_kb on reloads<br>
=C2=A0 multipath: fix segfault with disable_changed_wwids<br>
<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 3=
 +--<br>
=C2=A0libdmmp/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 18 +++++++-------=
-<br>
=C2=A0libdmmp/libdmmp.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 -<br>
=C2=A0libdmmp/test/Makefile=C2=A0 =C2=A0 |=C2=A0 2 +-<br>
=C2=A0libmpathcmd/Makefile=C2=A0 =C2=A0 =C2=A0|=C2=A0 6 ++---<br>
=C2=A0libmpathpersist/Makefile |=C2=A0 6 ++---<br>
=C2=A0libmultipath/configure.c | 60 ++++++++++++++++++++++++++++++<wbr>++++=
++++++++++++--<br>
=C2=A0libmultipath/devmapper.c |=C2=A0 9 ++++----<br>
=C2=A0libmultipath/discovery.c | 23 -------------------<br>
=C2=A0libmultipath/discovery.h |=C2=A0 1 -<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 21 ++++++++++++-----<b=
r>
=C2=A012 files changed, 96 insertions(+), 55 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a114753aeb3efc7054cf343aa--


--===============8404703549172721653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8404703549172721653==--
