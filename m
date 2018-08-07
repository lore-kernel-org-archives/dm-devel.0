From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 00/32] Misc Multipath patches
Date: Tue, 7 Aug 2018 08:50:03 -0500
Message-ID: <20180807135003.GY31378@octiron.msp.redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<CABr-Gne47W-99Ji9qKi-X7iREdpOybWtfSs++7cFS-bOihN-ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-Gne47W-99Ji9qKi-X7iREdpOybWtfSs++7cFS-bOihN-ZA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Tue, Aug 07, 2018 at 03:39:55PM +0200, Christophe Varoqui wrote:
>    Hi,
>    The backlog is merged, mostly.
>    Ben, your latest aggregated patchset is merged up to 15/32 included,
>    pending consensus about tur locking with Bart.
>    Would you rather have a release tag at this point or can it wait the m=
erge
>    of your pending patches ?

I'd prefer to wait for a resolution on all of my patches.
Thanks.

-Ben

>    Thanks,
>    Christophe.
>    On Wed, Aug 1, 2018 at 10:57 PM Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      This batch of patches is a resend of my previous 10 patches, as well
>      as new patches mostly found by running coverity.
> =

>      patches 0001-0010 are identical to my previous patchset
>      patches 0012-0015 & 0021-0032 are minor issues found by coverity.
>      =A0 =A0 =A0 =A0 Not all of them are bugs that could actually occur i=
n practice,
>      =A0 =A0 =A0 =A0 but they are simple and hopefully non-controversial =
changes.
>      patches 0016-0020 are a number of fixes to the tur checker.These are
>      =A0 =A0 =A0 =A0 the ones that should get the most attention.
> =

>      Also, I would love to have a 0.7.8 tagged release.
> =

>      Benjamin Marzinski (32):
>      =A0 libmultipath: remove last of rbd code
>      =A0 libmultipath: fix detect alua corner case
>      =A0 multipath: fix setting conf->version
>      =A0 mpathpersist: add --param-alltgpt option
>      =A0 libmutipath: remove unused IDE bus type
>      =A0 multipathd: add new protocol path wildcard
>      =A0 libmultipath: add "protocol" blacklist option.
>      =A0 libmultipath: remove _filter_* blacklist functions
>      =A0 multipath tests: change to work with old make versions
>      =A0 multipath tests: add blacklist tests
>      =A0 mpathpersist: add missing --param-rk usage info
>      =A0 kpartx: minor fixes to make coverity happy
>      =A0 kpartx: Fix memory leak of uuid found by coverity
>      =A0 kpartx: fix bad dm_devn return
>      =A0 kpartx: remove duplicated gpt validation check
>      =A0 libmultipath: fix tur checker timeout
>      =A0 libmultipath: fix tur checker double locking
>      =A0 libmultipath: fix tur memory misuse
>      =A0 libmultipath: cleanup tur locking
>      =A0 libmultipath: fix tur checker timeout issue
>      =A0 libmultipath: fix set_int error path
>      =A0 libmultipath: fix length issues in get_vpd_sgio
>      =A0 libmultipath: _install_keyword cleanup
>      =A0 libmultipath: remove unused code
>      =A0 libmultipath: fix memory issue in path_latency prio
>      =A0 libmultipath: fix null dereference int alloc_path_group
>      =A0 libmutipath: don't use malformed uevents
>      =A0 multipath: fix max array size in print_cmd_valid
>      =A0 multipathd: function return value tweaks
>      =A0 multipathd: minor fixes
>      =A0 multipathd: remove useless check and fix format
>      =A0 multipathd: fix memory leak on error in configure
> =

>      =A0kpartx/dasd.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 |=A0 =A05 +-
>      =A0kpartx/del-part-nodes.rules=A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 =A02 =
+-
>      =A0kpartx/devmapper.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
|=A0 15 +-
>      =A0kpartx/gpt.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0|=A0 10 -
>      =A0libmpathpersist/mpath_persist.c=A0 =A0 =A0 =A0 =A0 |=A0 10 +-
>      =A0libmultipath/blacklist.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| 177 =
+++++------
>      =A0libmultipath/blacklist.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0 =
=A05 +-
>      =A0libmultipath/checkers/tur.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 | 165 ++++=
------
>      =A0libmultipath/config.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0=
 15 +
>      =A0libmultipath/config.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0=
 =A02 +
>      =A0libmultipath/configure.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0 =
=A02 +-
>      =A0libmultipath/devmapper.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0 =
=A06 +-
>      =A0libmultipath/dict.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
=A0 19 +-
>      =A0libmultipath/discovery.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0 1=
9 +-
>      =A0libmultipath/parser.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0=
 12 +-
>      =A0libmultipath/print.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=
=A0 82 ++++-
>      =A0libmultipath/print.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=
=A0 =A02 +
>      =A0libmultipath/prioritizers/path_latency.c |=A0 =A03 +-
>      =A0libmultipath/propsel.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0=
 =A04 +-
>      =A0libmultipath/structs.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0=
 =A02 +-
>      =A0libmultipath/structs.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0=
 =A02 -
>      =A0libmultipath/uevent.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0=
 =A06 +
>      =A0mpathpersist/main.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
=A0 12 +-
>      =A0mpathpersist/main.h=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
=A0 =A01 +
>      =A0mpathpersist/mpathpersist.8=A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 =A04 +
>      =A0multipath/main.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0|=A0 =A02 +-
>      =A0multipath/multipath.conf.5=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0 24 =
+-
>      =A0multipathd/cli_handlers.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 11 =
+-
>      =A0multipathd/main.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
|=A0 26 +-
>      =A0tests/Makefile=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0|=A0 =A06 +-
>      =A0tests/blacklist.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
| 512
>      +++++++++++++++++++++++++++++++
>      =A031 files changed, 889 insertions(+), 274 deletions(-)
>      =A0create mode 100644 tests/blacklist.c
> =

>      --
>      2.7.4
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
