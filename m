From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/3] more multipath config options
Date: Sun, 20 Nov 2016 10:25:46 +0100
Message-ID: <CABr-Gnfp1cTAtU+yhw0g29yY0-mzyTTSv=jnvF14NRyqt6MLhA@mail.gmail.com>
References: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7708037957118764865=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
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

--===============7708037957118764865==
Content-Type: multipart/alternative; boundary=001a11408046cddfd70541b81f27

--001a11408046cddfd70541b81f27
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Fri, Nov 11, 2016 at 11:58 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Here are two new mutipath config options, and the documentation for
> disable_changed_wwids.
>
> Benjamin Marzinski (3):
>   document "disable_changed_wwids" config parameter
>   allow multipath to retry removes of in-use devices
>   add "max_sectors_kb" config parameter
>
>  libmultipath/config.c      |  3 +++
>  libmultipath/config.h      |  4 ++++
>  libmultipath/configure.c   |  2 ++
>  libmultipath/defaults.h    |  1 +
>  libmultipath/devmapper.c   | 38 ++++++++++++++++++++------------------
>  libmultipath/devmapper.h   |  4 ++--
>  libmultipath/dict.c        | 17 +++++++++++++++++
>  libmultipath/discovery.c   | 23 +++++++++++++++++++++++
>  libmultipath/discovery.h   |  1 +
>  libmultipath/propsel.c     | 16 ++++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     |  6 ++++++
>  multipath/main.c           | 17 ++++++++++++-----
>  multipath/multipath.8      |  7 +++++++
>  multipath/multipath.conf.5 | 35 +++++++++++++++++++++++++++++++++++
>  15 files changed, 150 insertions(+), 25 deletions(-)
>
> --
> 1.8.3.1
>
>

--001a11408046cddfd70541b81f27
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Fri, Nov 11, 2016 at 11:58 PM, Benjamin =
Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" targ=
et=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex">Here are two new mutipath config options, and the documentat=
ion for<br>
disable_changed_wwids.<br>
<br>
Benjamin Marzinski (3):<br>
=C2=A0 document &quot;disable_changed_wwids&quot; config parameter<br>
=C2=A0 allow multipath to retry removes of in-use devices<br>
=C2=A0 add &quot;max_sectors_kb&quot; config parameter<br>
<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +++<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 ++++<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0|=C2=A0 2 ++<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0| 38 ++++++++++++++++++++-------=
---<wbr>--------<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0|=C2=A0 4 ++--<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 17 +++++++++++++++++=
<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0| 23 +++++++++++++++++++++++<br>
=C2=A0libmultipath/discovery.h=C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0| 16 ++++++++++++++++<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 6 ++++++<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 17 +++++++=
+++++-----<br>
=C2=A0multipath/multipath.8=C2=A0 =C2=A0 =C2=A0 |=C2=A0 7 +++++++<br>
=C2=A0multipath/multipath.conf.5 | 35 ++++++++++++++++++++++++++++++<wbr>++=
+++<br>
=C2=A015 files changed, 150 insertions(+), 25 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a11408046cddfd70541b81f27--


--===============7708037957118764865==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7708037957118764865==--
