From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/12] Misc fixes
Date: Sat, 13 Jan 2018 10:19:18 +0100
Message-ID: <CABr-Gnf2VCmaiS8PdTX3X6BwKgp4m+-esnYSHGBpYBKsBACbgQ@mail.gmail.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2645964100641421239=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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

--===============2645964100641421239==
Content-Type: multipart/alternative; boundary="94eb2c1969a631d0300562a4e082"

--94eb2c1969a631d0300562a4e082
Content-Type: text/plain; charset="UTF-8"

Applied.
Thanks.

On Thu, Dec 7, 2017 at 7:48 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> The first patch here is just a rebased version of an earlier patch.  The
> last
> patch is fixes for commit 95d594fd6f031e59bb73d04a631b6c592fe26214
> "multipath-tools: intermittent IO error accounting to improve reliability".
> The rest of the patches are various fixes and code cleanups that I've been
> accumulating while working on removing the waiter threads. That work has
> run
> into some hiccups with corner cases, so I thought I would send these
> cleanup
> patches first, since they are generally useful, even without the waiter
> thread
> changes.
>
> Benjamin Marzinski (12):
>   multipath: add "ghost_delay" parameter
>   kpartx: don't delete partitions from partitions
>   multipath: fix hwhandler check in select_action
>   libmultipath: cleanup features handling code
>   multipathd: move helper functions to libmultipath
>   multipathd: fix device creation issues
>   multipathd: remove select_* from setup_multipath
>   libmultipath: __setup_multipath param cleanup
>   multipathd: move recovery mode code to function
>   multipathd: clean up set_no_path_retry
>   multipath: check failed path dmstate in check_path
>   multipathd: marginal path code fixes
>
>  kpartx/del-part-nodes.rules |   1 +
>  libmultipath/config.c       |   3 +
>  libmultipath/config.h       |   3 +
>  libmultipath/configure.c    |  38 +++----
>  libmultipath/defaults.h     |   1 +
>  libmultipath/devmapper.c    |   2 +-
>  libmultipath/dict.c         |  12 +++
>  libmultipath/dmparser.c     |  35 ++----
>  libmultipath/hwtable.c      |   1 +
>  libmultipath/io_err_stat.c  |  12 +--
>  libmultipath/propsel.c      |  21 +++-
>  libmultipath/propsel.h      |   1 +
>  libmultipath/structs.c      |  17 ---
>  libmultipath/structs.h      |  10 +-
>  libmultipath/structs_vec.c  | 256 +++++++++++++++++++++++++-----
> --------------
>  libmultipath/structs_vec.h  |  12 ++-
>  multipath/multipath.conf.5  |  21 +++-
>  multipathd/cli_handlers.c   |  34 +++---
>  multipathd/main.c           | 134 +++++++++--------------
>  multipathd/main.h           |   1 -
>  20 files changed, 322 insertions(+), 293 deletions(-)
>
> --
> 2.7.4
>
>

--94eb2c1969a631d0300562a4e082
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Thu, Dec 7, 2017 at 7:48 PM, Benjamin Ma=
rzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">The first patch here is just a rebased version of an earlier =
patch.=C2=A0 The last<br>
patch is fixes for commit 95d594fd6f031e59bb73d04a631b6c<wbr>592fe26214<br>
&quot;multipath-tools: intermittent IO error accounting to improve reliabil=
ity&quot;.<br>
The rest of the patches are various fixes and code cleanups that I&#39;ve b=
een<br>
accumulating while working on removing the waiter threads. That work has ru=
n<br>
into some hiccups with corner cases, so I thought I would send these cleanu=
p<br>
patches first, since they are generally useful, even without the waiter thr=
ead<br>
changes.<br>
<br>
Benjamin Marzinski (12):<br>
=C2=A0 multipath: add &quot;ghost_delay&quot; parameter<br>
=C2=A0 kpartx: don&#39;t delete partitions from partitions<br>
=C2=A0 multipath: fix hwhandler check in select_action<br>
=C2=A0 libmultipath: cleanup features handling code<br>
=C2=A0 multipathd: move helper functions to libmultipath<br>
=C2=A0 multipathd: fix device creation issues<br>
=C2=A0 multipathd: remove select_* from setup_multipath<br>
=C2=A0 libmultipath: __setup_multipath param cleanup<br>
=C2=A0 multipathd: move recovery mode code to function<br>
=C2=A0 multipathd: clean up set_no_path_retry<br>
=C2=A0 multipath: check failed path dmstate in check_path<br>
=C2=A0 multipathd: marginal path code fixes<br>
<br>
=C2=A0kpartx/del-part-nodes.rules |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 |=C2=A0 38 +++----<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 |=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 12 +++<b=
r>
=C2=A0libmultipath/dmparser.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 35 ++----<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/io_err_stat.c=C2=A0 |=C2=A0 12 +--<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 21 +++-<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 17 ---<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 10 +-<br>
=C2=A0libmultipath/structs_vec.c=C2=A0 | 256 +++++++++++++++++++++++++-----=
<wbr>--------------<br>
=C2=A0libmultipath/structs_vec.h=C2=A0 |=C2=A0 12 ++-<br>
=C2=A0multipath/multipath.conf.5=C2=A0 |=C2=A0 21 +++-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0|=C2=A0 34 +++---<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 134 +++++=
++++--------------<br>
=C2=A0multipathd/main.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A01 -<br>
=C2=A020 files changed, 322 insertions(+), 293 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1969a631d0300562a4e082--


--===============2645964100641421239==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2645964100641421239==--
