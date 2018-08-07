From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/32] Misc Multipath patches
Date: Tue, 7 Aug 2018 15:39:55 +0200
Message-ID: <CABr-Gne47W-99Ji9qKi-X7iREdpOybWtfSs++7cFS-bOihN-ZA@mail.gmail.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3032531339399375704=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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

--===============3032531339399375704==
Content-Type: multipart/alternative; boundary="00000000000028a1f50572d88896"

--00000000000028a1f50572d88896
Content-Type: text/plain; charset="UTF-8"

Hi,

The backlog is merged, mostly.

Ben, your latest aggregated patchset is merged up to 15/32 included,
pending consensus about tur locking with Bart.
Would you rather have a release tag at this point or can it wait the merge
of your pending patches ?

Thanks,
Christophe.


On Wed, Aug 1, 2018 at 10:57 PM Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> This batch of patches is a resend of my previous 10 patches, as well
> as new patches mostly found by running coverity.
>
> patches 0001-0010 are identical to my previous patchset
> patches 0012-0015 & 0021-0032 are minor issues found by coverity.
>         Not all of them are bugs that could actually occur in practice,
>         but they are simple and hopefully non-controversial changes.
> patches 0016-0020 are a number of fixes to the tur checker.These are
>         the ones that should get the most attention.
>
> Also, I would love to have a 0.7.8 tagged release.
>
> Benjamin Marzinski (32):
>   libmultipath: remove last of rbd code
>   libmultipath: fix detect alua corner case
>   multipath: fix setting conf->version
>   mpathpersist: add --param-alltgpt option
>   libmutipath: remove unused IDE bus type
>   multipathd: add new protocol path wildcard
>   libmultipath: add "protocol" blacklist option.
>   libmultipath: remove _filter_* blacklist functions
>   multipath tests: change to work with old make versions
>   multipath tests: add blacklist tests
>   mpathpersist: add missing --param-rk usage info
>   kpartx: minor fixes to make coverity happy
>   kpartx: Fix memory leak of uuid found by coverity
>   kpartx: fix bad dm_devn return
>   kpartx: remove duplicated gpt validation check
>   libmultipath: fix tur checker timeout
>   libmultipath: fix tur checker double locking
>   libmultipath: fix tur memory misuse
>   libmultipath: cleanup tur locking
>   libmultipath: fix tur checker timeout issue
>   libmultipath: fix set_int error path
>   libmultipath: fix length issues in get_vpd_sgio
>   libmultipath: _install_keyword cleanup
>   libmultipath: remove unused code
>   libmultipath: fix memory issue in path_latency prio
>   libmultipath: fix null dereference int alloc_path_group
>   libmutipath: don't use malformed uevents
>   multipath: fix max array size in print_cmd_valid
>   multipathd: function return value tweaks
>   multipathd: minor fixes
>   multipathd: remove useless check and fix format
>   multipathd: fix memory leak on error in configure
>
>  kpartx/dasd.c                            |   5 +-
>  kpartx/del-part-nodes.rules              |   2 +-
>  kpartx/devmapper.c                       |  15 +-
>  kpartx/gpt.c                             |  10 -
>  libmpathpersist/mpath_persist.c          |  10 +-
>  libmultipath/blacklist.c                 | 177 +++++------
>  libmultipath/blacklist.h                 |   5 +-
>  libmultipath/checkers/tur.c              | 165 ++++------
>  libmultipath/config.c                    |  15 +
>  libmultipath/config.h                    |   2 +
>  libmultipath/configure.c                 |   2 +-
>  libmultipath/devmapper.c                 |   6 +-
>  libmultipath/dict.c                      |  19 +-
>  libmultipath/discovery.c                 |  19 +-
>  libmultipath/parser.c                    |  12 +-
>  libmultipath/print.c                     |  82 ++++-
>  libmultipath/print.h                     |   2 +
>  libmultipath/prioritizers/path_latency.c |   3 +-
>  libmultipath/propsel.c                   |   4 +-
>  libmultipath/structs.c                   |   2 +-
>  libmultipath/structs.h                   |   2 -
>  libmultipath/uevent.c                    |   6 +
>  mpathpersist/main.c                      |  12 +-
>  mpathpersist/main.h                      |   1 +
>  mpathpersist/mpathpersist.8              |   4 +
>  multipath/main.c                         |   2 +-
>  multipath/multipath.conf.5               |  24 +-
>  multipathd/cli_handlers.c                |  11 +-
>  multipathd/main.c                        |  26 +-
>  tests/Makefile                           |   6 +-
>  tests/blacklist.c                        | 512
> +++++++++++++++++++++++++++++++
>  31 files changed, 889 insertions(+), 274 deletions(-)
>  create mode 100644 tests/blacklist.c
>
> --
> 2.7.4
>
>

--00000000000028a1f50572d88896
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>The backlog is merged, mostly.</div=
><div><br></div><div>Ben, your latest aggregated patchset is merged up to 1=
5/32 included, pending consensus about tur locking with Bart.</div><div>Wou=
ld you rather have a release tag at this point or can it wait the merge of =
your pending patches ?<br></div><div><br></div><div>Thanks,</div><div>Chris=
tophe.</div><div><br></div></div><br><div class=3D"gmail_quote"><div dir=3D=
"ltr">On Wed, Aug 1, 2018 at 10:57 PM Benjamin Marzinski &lt;<a href=3D"mai=
lto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">This batch of patches is a resend of my previous 1=
0 patches, as well<br>
as new patches mostly found by running coverity.<br>
<br>
patches 0001-0010 are identical to my previous patchset<br>
patches 0012-0015 &amp; 0021-0032 are minor issues found by coverity.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Not all of them are bugs that could actually oc=
cur in practice,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 but they are simple and hopefully non-controver=
sial changes.<br>
patches 0016-0020 are a number of fixes to the tur checker.These are<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 the ones that should get the most attention.<br=
>
<br>
Also, I would love to have a 0.7.8 tagged release.<br>
<br>
Benjamin Marzinski (32):<br>
=C2=A0 libmultipath: remove last of rbd code<br>
=C2=A0 libmultipath: fix detect alua corner case<br>
=C2=A0 multipath: fix setting conf-&gt;version<br>
=C2=A0 mpathpersist: add --param-alltgpt option<br>
=C2=A0 libmutipath: remove unused IDE bus type<br>
=C2=A0 multipathd: add new protocol path wildcard<br>
=C2=A0 libmultipath: add &quot;protocol&quot; blacklist option.<br>
=C2=A0 libmultipath: remove _filter_* blacklist functions<br>
=C2=A0 multipath tests: change to work with old make versions<br>
=C2=A0 multipath tests: add blacklist tests<br>
=C2=A0 mpathpersist: add missing --param-rk usage info<br>
=C2=A0 kpartx: minor fixes to make coverity happy<br>
=C2=A0 kpartx: Fix memory leak of uuid found by coverity<br>
=C2=A0 kpartx: fix bad dm_devn return<br>
=C2=A0 kpartx: remove duplicated gpt validation check<br>
=C2=A0 libmultipath: fix tur checker timeout<br>
=C2=A0 libmultipath: fix tur checker double locking<br>
=C2=A0 libmultipath: fix tur memory misuse<br>
=C2=A0 libmultipath: cleanup tur locking<br>
=C2=A0 libmultipath: fix tur checker timeout issue<br>
=C2=A0 libmultipath: fix set_int error path<br>
=C2=A0 libmultipath: fix length issues in get_vpd_sgio<br>
=C2=A0 libmultipath: _install_keyword cleanup<br>
=C2=A0 libmultipath: remove unused code<br>
=C2=A0 libmultipath: fix memory issue in path_latency prio<br>
=C2=A0 libmultipath: fix null dereference int alloc_path_group<br>
=C2=A0 libmutipath: don&#39;t use malformed uevents<br>
=C2=A0 multipath: fix max array size in print_cmd_valid<br>
=C2=A0 multipathd: function return value tweaks<br>
=C2=A0 multipathd: minor fixes<br>
=C2=A0 multipathd: remove useless check and fix format<br>
=C2=A0 multipathd: fix memory leak on error in configure<br>
<br>
=C2=A0kpartx/dasd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A05 +-<br>
=C2=A0kpartx/del-part-nodes.rules=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 =C2=A02 +-<br>
=C2=A0kpartx/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 15 +-<br>
=C2=A0kpartx/gpt.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 10 -<br>
=C2=A0libmpathpersist/mpath_persist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 10 +-<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0| 177 +++++------<br>
=C2=A0libmultipath/blacklist.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
=C2=A0libmultipath/checkers/tur.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 | 165 ++++------<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 15 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A02 +<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A06 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 19 +-<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 19 +-<br>
=C2=A0libmultipath/parser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 12 +-<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 82 ++++-<br>
=C2=A0libmultipath/print.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +<br>
=C2=A0libmultipath/prioritizers/path_latency.c |=C2=A0 =C2=A03 +-<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 -<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A06 +<br>
=C2=A0mpathpersist/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 12 +-<br>
=C2=A0mpathpersist/main.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0mpathpersist/mpathpersist.8=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 =C2=A04 +<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0multipath/multipath.conf.5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 24 +-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 11 +-<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 26 +-<br>
=C2=A0tests/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A06 +-<br>
=C2=A0tests/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 512 +++++++++++++++++++++++++++++++<br>
=C2=A031 files changed, 889 insertions(+), 274 deletions(-)<br>
=C2=A0create mode 100644 tests/blacklist.c<br>
<br>
-- <br>
2.7.4<br>
<br>
</blockquote></div>

--00000000000028a1f50572d88896--


--===============3032531339399375704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3032531339399375704==--
