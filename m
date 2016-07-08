From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/5] Makefiles housekeeping II
Date: Fri, 8 Jul 2016 09:16:12 +0200
Message-ID: <CABr-Gnccm_uvdVFkWK2XonVqm_QPTYSxW+TAYBzT4r=NEmfqKQ@mail.gmail.com>
References: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3567704787250916501=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3567704787250916501==
Content-Type: multipart/alternative; boundary=001a113fb59ce404bd05371a9392

--001a113fb59ce404bd05371a9392
Content-Type: text/plain; charset=UTF-8

Merged patches 1, 2 and 3 of this set.

I postponed merging the patches adding fullpath links in libs. Are you sure
it is best practice to use fullpaths there ?

Thanks.

On Fri, Jul 1, 2016 at 7:17 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
> Xose Vazquez Perez (5):
>   multipath-tools: replace rm with a variable in makefiles
>   multipath-tools: replace install with its variable in makefiles
>   multipath-tools: replace ln with a variable in makefiles
>   multipath-tools: link libmpathcmd.so with full path
>   multipath-tools: add a link for libmultipath.so
>
>  Makefile.inc                       |  2 ++
>  kpartx/Makefile                    | 12 ++++++------
>  libmpathcmd/Makefile               | 12 ++++++------
>  libmpathpersist/Makefile           | 28 ++++++++++++++--------------
>  libmultipath/Makefile              |  8 +++++---
>  libmultipath/checkers/Makefile     |  4 ++--
>  libmultipath/prioritizers/Makefile |  4 ++--
>  mpathpersist/Makefile              | 16 ++++++++--------
>  multipath/Makefile                 | 12 ++++++------
>  multipathd/Makefile                | 10 +++++-----
>  10 files changed, 56 insertions(+), 52 deletions(-)
>
> --
> 2.7.4
>
>

--001a113fb59ce404bd05371a9392
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged patches 1, 2 and 3 of this set.<div><br></div><div>=
I postponed merging the patches adding fullpath links in libs. Are you sure=
 it is best practice to use fullpaths there ?</div><div><br></div><div>Than=
ks.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On=
 Fri, Jul 1, 2016 at 7:17 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.=
com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Cc: Christophe =
Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com">christophe.va=
roqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
<br>
Xose Vazquez Perez (5):<br>
=C2=A0 multipath-tools: replace rm with a variable in makefiles<br>
=C2=A0 multipath-tools: replace install with its variable in makefiles<br>
=C2=A0 multipath-tools: replace ln with a variable in makefiles<br>
=C2=A0 multipath-tools: link libmpathcmd.so with full path<br>
=C2=A0 multipath-tools: add a link for libmultipath.so<br>
<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 2 ++<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 | 12 ++++++------<br>
=C2=A0libmpathcmd/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 12 ++++++------<br>
=C2=A0libmpathpersist/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 28=
 ++++++++++++++--------------<br>
=C2=A0libmultipath/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 |=C2=A0 8 +++++---<br>
=C2=A0libmultipath/checkers/Makefile=C2=A0 =C2=A0 =C2=A0|=C2=A0 4 ++--<br>
=C2=A0libmultipath/prioritizers/Makefile |=C2=A0 4 ++--<br>
=C2=A0mpathpersist/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 | 16 ++++++++--------<br>
=C2=A0multipath/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 12 ++++++------<br>
=C2=A0multipathd/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 | 10 +++++-----<br>
=C2=A010 files changed, 56 insertions(+), 52 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a113fb59ce404bd05371a9392--


--===============3567704787250916501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3567704787250916501==--
