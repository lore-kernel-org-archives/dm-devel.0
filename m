From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 00/19] Misc Multipath patches
Date: Tue, 9 Oct 2018 11:13:06 -0500
Message-ID: <20181009161306.GI3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<CABr-GneyGf+Ks8ZkaFoReYuvSXvpfPwaXgg7eVFNoFCh84RwpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GneyGf+Ks8ZkaFoReYuvSXvpfPwaXgg7eVFNoFCh84RwpA@mail.gmail.com>
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

On Sun, Oct 07, 2018 at 10:36:41AM +0200, Christophe Varoqui wrote:

I'll send a v4, hopefully today.

-Ben

>    Hi Ben,
>    this v3 patchset is ready for merge or do you plan a v4 ?
>    Thanks,
>    Christophe
>    On Sat, Sep 22, 2018 at 1:05 AM Benjamin Marzinski
>    <[1]bmarzins@redhat.com> wrote:
> =

>      This batch of patches is a resend of the non-merged pathes from my l=
ast
>      set, along with 2 new ones. It would be really great if we could get
>      a version bug after the outstanding commits go it.
> =

>      Patches 0001-0005 are a number of fixes to the tur checker.These are
>      =A0 =A0 =A0 =A0 the ones that should get the most attention.
>      Patches 0006-0017 are minor issues found by coverity.
>      =A0 =A0 =A0 =A0 Not all of them are bugs that could actually occur i=
n practice,
>      =A0 =A0 =A0 =A0 but they are simple and hopefully non-controversial =
changes.
>      Patches 0018-0019 are new and related to changing path wwids
> =

>      Changes in v3
>      =A0 =A0 =A0 =A0 added patches 0018-0019
> =

>      Changes in v2
>      =A0 =A0 =A0 =A0 0002-libmultipath-fix-tur-checker-double-locking.pat=
ch now sets
>      =A0 =A0 =A0 =A0 ct->devt when initially creating the tur_checker_con=
text, while
>      =A0 =A0 =A0 =A0 that structure is still only referenced by a local v=
ariable.
>      =A0 =A0 =A0 =A0 After that, ct->devt is only ever read. This should =
remove any
>      =A0 =A0 =A0 =A0 issues with it needing locking.
> =

>      Benjamin Marzinski (19):
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
>      =A0 libmultipath: Don't blank intialized paths
>      =A0 libmultipath: Fixup updating paths
> =

>      =A0libmultipath/checkers/tur.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 | 168
>      +++++++++++--------------------
>      =A0libmultipath/dict.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=
=A0 =A05 +-
>      =A0libmultipath/discovery.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0 1=
8 ++--
>      =A0libmultipath/parser.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0=
 12 ++-
>      =A0libmultipath/print.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=
=A0 =A08 --
>      =A0libmultipath/prioritizers/path_latency.c |=A0 =A03 +-
>      =A0libmultipath/structs.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|=A0=
 =A02 +-
>      =A0libmultipath/uevent.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0=
 =A06 ++
>      =A0multipath/main.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0|=A0 =A02 +-
>      =A0multipathd/cli_handlers.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=A0 11 =
+-
>      =A0multipathd/main.c=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
|=A0 50 +++++----
>      =A011 files changed, 131 insertions(+), 154 deletions(-)
> =

>      --
>      2.7.4
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
