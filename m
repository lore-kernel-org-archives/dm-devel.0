From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v4 0/6] misc patches
Date: Mon, 27 Feb 2017 21:46:24 +0100
Message-ID: <CABr-GnfCWcdApURvQK0dBFxPfRghjPP=4tRhr0Wn=w0io_8gdg@mail.gmail.com>
References: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8546877922674227305=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
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

--===============8546877922674227305==
Content-Type: multipart/alternative; boundary=94eb2c0932a63c11520549892cca

--94eb2c0932a63c11520549892cca
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Mon, Feb 27, 2017 at 7:26 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Here's a couple of minor features bugfixes and cleanups. The biggest
> change is that the detect_checker option now sets the checker for
> devices with detected ALUA to TUR. Also, udev wasn't correctly
> disabling rules for multipath devices that lost their last usable
> path through a table reload. This was causing lvmetad some problems
> on failing multipath devices.
>
> Differences from v3:
> Rebased patches
>
> Benjamin Marzinski (6):
>   libmultipath: add detect_checker option
>   libmultipath: cleanup orphan device states
>   multipathd: don't update priority of failed paths
>   multipathd: add messages on delayed path addition
>   multipathd: allow resetting stats
>   fix udev rules for failed multipath devices
>
>  libmultipath/config.c                 |  3 ++
>  libmultipath/config.h                 |  2 ++
>  libmultipath/defaults.h               |  1 +
>  libmultipath/devmapper.c              |  3 +-
>  libmultipath/devmapper.h              |  6 ++++
>  libmultipath/dict.c                   | 10 ++++++
>  libmultipath/discovery.c              | 28 +++++++++++++--
>  libmultipath/hwtable.c                |  1 +
>  libmultipath/print.c                  |  4 +--
>  libmultipath/prioritizers/alua_spc3.h |  1 +
>  libmultipath/propsel.c                | 31 ++++++++++------
>  libmultipath/propsel.h                |  1 +
>  libmultipath/structs.c                |  2 ++
>  libmultipath/structs.h                |  7 ++++
>  multipath/11-dm-mpath.rules           | 67 ++++++++++++++++++++++++------
> -----
>  multipath/multipath.conf.5            | 18 ++++++++++
>  multipathd/cli.c                      |  2 ++
>  multipathd/cli_handlers.c             | 44 +++++++++++++++++++++++
>  multipathd/cli_handlers.h             |  2 ++
>  multipathd/main.c                     |  8 ++++-
>  20 files changed, 205 insertions(+), 36 deletions(-)
>
> --
> 1.8.3.1
>
>

--94eb2c0932a63c11520549892cca
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Feb 27, 2017 at 7:26 PM, Benjamin M=
arzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" targe=
t=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">Here&#39;s a couple of minor features bugfixes and cleanups. =
The biggest<br>
change is that the detect_checker option now sets the checker for<br>
devices with detected ALUA to TUR. Also, udev wasn&#39;t correctly<br>
disabling rules for multipath devices that lost their last usable<br>
path through a table reload. This was causing lvmetad some problems<br>
on failing multipath devices.<br>
<br>
Differences from v3:<br>
Rebased patches<br>
<br>
Benjamin Marzinski (6):<br>
=C2=A0 libmultipath: add detect_checker option<br>
=C2=A0 libmultipath: cleanup orphan device states<br>
=C2=A0 multipathd: don&#39;t update priority of failed paths<br>
=C2=A0 multipathd: add messages on delayed path addition<br>
=C2=A0 multipathd: allow resetting stats<br>
=C2=A0 fix udev rules for failed multipath devices<br>
<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 3 ++<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 2 ++<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 3 +-<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 6 ++++<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0| 10 ++++++<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 28 +++++++++++++--<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 4 +--<br>
=C2=A0libmultipath/prioritizers/<wbr>alua_spc3.h |=C2=A0 1 +<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | 31 ++++++++++------<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 2 ++<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 7 ++++<br>
=C2=A0multipath/11-dm-mpath.rules=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
 67 ++++++++++++++++++++++++------<wbr>-----<br>
=C2=A0multipath/multipath.conf.5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
 18 ++++++++++<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 ++<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0| 44 +++++++++++++++++++++++<br>
=C2=A0multipathd/cli_handlers.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 2 ++<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 8 ++++-<br>
=C2=A020 files changed, 205 insertions(+), 36 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c0932a63c11520549892cca--


--===============8546877922674227305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8546877922674227305==--
