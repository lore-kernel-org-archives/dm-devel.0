From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 0/7] misc patches
Date: Mon, 27 Feb 2017 07:09:55 +0100
Message-ID: <CABr-GnfE17v8A9FUicXJ80V+QHBCVp9uJURj0QS-Ny1ttpbN+Q@mail.gmail.com>
References: <1487125017-22049-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1462706858145221547=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487125017-22049-1-git-send-email-bmarzins@redhat.com>
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

--===============1462706858145221547==
Content-Type: multipart/alternative; boundary=f403043792ccabdd7905497ced10

--f403043792ccabdd7905497ced10
Content-Type: text/plain; charset=UTF-8

Hi Ben,

can you rebase the set, starting from 2/7 ?
1/7 is already merged.

Thanks,
Christophe.

On Wed, Feb 15, 2017 at 3:16 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Here's a couple of minor features bugfixes and cleanups. The biggest
> change is that the detect_checker option now sets the checker for
> devices with detected ALUA to TUR. Also, udev wasn't correctly
> disabling rules for multipath devices that lost their last usable
> path through a table reload. This was causing lvmetad some problems
> on failing multipath devices.
>
> Differences from v2:
>
> libmultipath: add detect_checker option
> ----------------------------------------
> I've removed is_alua, and now just use the paths tpgs variable to
> check if the path is in ALUA mode.
>
> Benjamin Marzinski (7):
>   kpartx: don't keep creating recursive partitions
>   libmultipath: add detect_checker option
>   libmultipath: cleanup orphan device states
>   multipathd: don't update priority of failed paths
>   multipathd: add messages on delayed path addition
>   multipathd: allow resetting stats
>   fix udev rules for failed multipath devices
>
>  kpartx/dos.c                          |  2 +-
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
>  21 files changed, 206 insertions(+), 37 deletions(-)
>
> --
> 1.8.3.1
>
>

--f403043792ccabdd7905497ced10
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Ben,<div><br></div><div>can you rebase the set, startin=
g from 2/7 ?</div><div>1/7 is already merged.</div><div><br></div><div>Than=
ks,</div><div>Christophe.</div></div><div class=3D"gmail_extra"><br><div cl=
ass=3D"gmail_quote">On Wed, Feb 15, 2017 at 3:16 AM, Benjamin Marzinski <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank"=
>bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Here&#39;s a couple of minor features bugfixes and cleanups. The biggest<=
br>
change is that the detect_checker option now sets the checker for<br>
devices with detected ALUA to TUR. Also, udev wasn&#39;t correctly<br>
disabling rules for multipath devices that lost their last usable<br>
path through a table reload. This was causing lvmetad some problems<br>
on failing multipath devices.<br>
<br>
Differences from v2:<br>
<br>
libmultipath: add detect_checker option<br>
------------------------------<wbr>----------<br>
I&#39;ve removed is_alua, and now just use the paths tpgs variable to<br>
check if the path is in ALUA mode.<br>
<br>
Benjamin Marzinski (7):<br>
=C2=A0 kpartx: don&#39;t keep creating recursive partitions<br>
=C2=A0 libmultipath: add detect_checker option<br>
=C2=A0 libmultipath: cleanup orphan device states<br>
=C2=A0 multipathd: don&#39;t update priority of failed paths<br>
=C2=A0 multipathd: add messages on delayed path addition<br>
=C2=A0 multipathd: allow resetting stats<br>
=C2=A0 fix udev rules for failed multipath devices<br>
<br>
=C2=A0kpartx/dos.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +-<br>
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
=C2=A021 files changed, 206 insertions(+), 37 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--f403043792ccabdd7905497ced10--


--===============1462706858145221547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1462706858145221547==--
