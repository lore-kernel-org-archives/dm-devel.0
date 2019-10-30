From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 00/72] multipath-tools: cleanup and
	warning enablement
Date: Wed, 30 Oct 2019 09:59:49 -0500
Message-ID: <20191030145949.GP25414@octiron.msp.redhat.com>
References: <20191024150556.19575-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191024150556.19575-1-martin.wilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Oct 24, 2019 at 03:06:08PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>

ACK for all the patches except 16
"libmultipath: make path_discovery() pthread_cancel()-safe"

-Ben

>=20
> Hi Christophe, hi Ben, hi Bart,
>=20
> here is a series with cleanup patches and minor fixes for multipath-tools=
.
> Sorry about the number of patches, I hope this way the series will be eas=
ier
> to review. There are lots of obvious, short hunks. In terms of LoC, most
> of the changes are in a new unit test, in the NVMe code update, and in
> a (necessary) indentation change in the VPD code.
>=20
> Patch 01-14 are part of a recent effort to go over the multipath-tools
> code, re-review, and modernize the code a bit. Part of that is adding "co=
nst"
> qualifiers to function arguments, as I did before. I happened to start wi=
th
> "alias.c", for alphabetic reasons. Other parts of the code will hopefully
> follow.
>=20
> 15-20 are misc fixes for stuff I came across while working on the
> "-Wclobbered" flag (see below).
>=20
> The rest of the series is an attempt to get rid of the disablement of
> warnings that we had so far in multipath-tools. I believe we agree that
> warning-free code is a good thing and that disabling warnings should be
> avoided if possible. My goal was to be able to set "-Werror" and compile
> successfully with all currently relevant compilers.
>=20
> Patch 21-42 fix issues with -Wunused-parameter and finally enable that
> warning. -Wno-unused-parameter is only kept in place for
> libmultipath/dict.c and multipathd/cli-handlers.c, which basically consis=
t
> only of implementations of certain prototypes where many functions don't
> use every argument, and hundreds of "unused" attributes would pollute the
> code too much. Patch 53-58 fix issues with "-Wsign-compare". This was
> actually a good excercise, because I was forced to think twice which
> signedness was correct for certain variables and expressions. Patch 59-64
> fix some warnings that are issued by clang with our current warning setti=
ngs
> (in particular, -Wformat-literal).
>=20
> Patch 65 is an update of our nvme code from nvme-cli 1.9. Patch 66-71
> contain some make file fixes and cleanups, and adaptations for older
> compilers. Finally, Patch 71 enables -Werror, and patch 72 tests for
> "-Wno-clobbered", which clang doesn't support.
>=20
> I can proudly say that multipath-tools now compiles without warnings or
> errors with -Werror and with a large set of compilers. I tested gcc 4.8,
> 7, 8, 9 and clang 3.9, 6, 7, and 8.
>=20
> The only "-Wno" option that now remains is "-Wclobbered". I have put
> considerable work into trying to eliminate that as well. The result
> can be examined in the "Wclobbered" branch of my github fork:
> https://github.com/mwilck/multipath-tools/commits/Wclobbered
> (yes, that's another 37 patches on top of this already long series).
>=20
> I have pondered this back and forth whether to submit that part of the
> series, too. All the -Wclobbered warnings are caused by pthread_cleanup_p=
ush()
> calls, of which our code has a lot, and which glibc implements using a
> sigsetjmp() call. These warnings are arguably a false positives, and
> a bug of either gcc, glibc, or both
> (see e.g. https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D61118).=20
>=20
> Eliminating these warnings is possible, but it requires a lot of changes
> in the code. Some of them are actually beneficial for readability, but
> others are rather not. Some are outright mysterious (e.g.
> https://github.com/mwilck/multipath-tools/commit/bb53d666777f072e60372979=
eed51752db03cec4),
> and finding the workarounds was trial-and error work. Also, there are
> variations between gcc versions.
>=20
> The bottom line is, while I feel sorry about the vain effort=20
> I put into this, my personal opinion is that silencing just this single
> warning isn't worth that big amount of changes.
>=20
> Reviews and opinions welcome.
>=20
> Regards
> Martin
>=20
> Changes in v2:
>   45/72: The way I handled snprintf() was wrong. Fix it, and use
>          safe_sn?printf() to hide cast ugliness (Bart van Assche)
>=20
>   All other patches remain unchanged, not resending them.
>=20
> Martin Wilck (72):
>   multipath tests: move condlog test wrappers to separate file
>   multipath tests: add tests for alias handling
>   libmultipath: alias.c: constify function arguments
>   libmultipath: alias.c: use strlcpy(), and 2 minor fixes
>   libmultipath: format_devname: avoid buffer overflow
>   libmultipath: scan_devname: fix int overflow detection
>   libmultipath: lookup_binding(): don't rely on int overflow
>   libmultipath: rlookup_binding(): removed unused parameter
>   libmultipath: allocate_binding(): error out for id=3D0
>   libmultipath: allocate_binding(): detect line overflow
>   multipath tests: alias: add tests for allocate_binding()
>   multipath tests: alias: add format/scan test
>   libmultipath: alias.c: prepare for cancel-safe allocation
>   multipath tests: use -lpthread for alias test
>   libmultipath: path_discovery: handle libudev errors
>   libmultipath: make path_discovery() pthread_cancel()-safe
>   libmultipath: uevent_listen(): fix poll() retval check
>   libmultipath: replace_wwids(): fix possible fd leak
>   libmultipath: remove_wwids(): fix possible leaks
>   libmultipath: _init_foreign(): fix possible memory leak
>   libmultipath: process_config_dir(): remove unused argument
>   libmultipath: mark unused arguments in partmap functions
>   libmultipath: scsi_ioctl_pathinfo(): remove unused argument
>   multipath-tools: mark unused params in signal and cleanup handlers
>   libmultipath: get_ana_info(): remove unused parameter
>   libmultipath: mark unused params in getprio() methods
>   libmultipath: hp_sw: remove usused argument in do_inq()
>   libmultipath: checkers: mark unused arguments in methods
>   multipathd: stop_waiter_thread(): removed unused parameter
>   multipath tools: mark unused arguments in thread routines
>   kpartx: gpt: remove unused arg in read_lastoddsector()
>   kpartx: mark unused arguments in ptreader methods
>   libmultipath: mark missing arguments in functions matching prototypes
>   libmultipath: get_pgpolicy_name(): use "len" parameter
>   libmultipath: snprint_multipath_map_json(): remove unused argument
>   multipath: delegate_to_multipathd: mark unused arguments
>   libmultipath: use -Wno-unused-parameter for dict.c
>   multipathd: use -Wno-unused-parameter for cli_handlers.c
>   libmpathpersist: remove unused "noisy" argument in various functions
>   libmpathpersist: fix copy-paste error in mpath_format_readresv()
>   multipath-tools tests: add -Wno-unused-parameter
>   multipath-tools: Makefile.inc: remove -Wno-unused-parameter
>   libmultipath: dev_loss_tmo is unsigned
>   libmultipath: trivial changes for -Wsign-compare
>   libmultipath: fix -Wsign-compare warnings with snprintf()
>   libmultipath: parse_vpd_pg83(): sanitize indentation
>   libmultipath: parse_vpd_pg83(): fix -Wsign-compare warnings
>   libmultipath: print: use unsigned int for "width" field
>   libmultipath: vector_for_each_slot: fix -Wsign-compare warnings
>   libmultipath: set_int(): add error check and set_uint()
>   libmultipath: make "checkint" unsigned
>   libmultipath: use unsigned blksize in directio context
>   libmultipath, kpartx: byteorder: always use unsigned types
>   libmpathcmd: fix -Wsign-compare warnings
>   libmpathpersist: fix -Wsign-compare warnings
>   kpartx: use unsigned arguments in dm_devn() and dm_prereq()
>   kpartx: use unsigned int for "ns" argument of ptreader
>   multipath-tools: Makefile.inc: enable -Wsign-compare
>   libdmmp: fix clang -Wformat-nonliteral warnings
>   libmultipath: fix clang -Wformat-literal warnings
>   multipath tests: blacklist: remove always-true condition
>   multipath tests: hwtable: fix strncat() invocation
>   multipath tests: fix -Wformat-literal warning
>   multipath tests: util: fix clang strlcpy warnings
>   libmultipath: nvme: update to nvme-cli v1.9
>   multipath-tools: Makefile.inc: fix TEST_CC_OPTION
>   multipath-tools: Makefile.inc: use -Wp,... for compiling only
>   multipath-tools: Makefile: use proper directory recursion
>   multipath tests: Makefile: fix "clean" target
>   multipath tests: Makefile: avoid gcc 4.8 missing initializers failure
>   multipath-tools: Makefile.inc: enable -Werror
>   multipath-tools: Makefile.inc: test for -Wno-clobbered support
>=20
>  Makefile                                 |  38 +-
>  Makefile.inc                             |  15 +-
>  kpartx/bsd.c                             |   4 +-
>  kpartx/dasd.c                            |   3 +-
>  kpartx/devmapper.c                       |  13 +-
>  kpartx/devmapper.h                       |   7 +-
>  kpartx/dos.c                             |   4 +-
>  kpartx/gpt.c                             |  15 +-
>  kpartx/gpt.h                             |   2 +-
>  kpartx/kpartx.h                          |  20 +-
>  kpartx/mac.c                             |   5 +-
>  kpartx/ps3.c                             |   5 +-
>  kpartx/solaris.c                         |   4 +-
>  kpartx/sun.c                             |   4 +-
>  kpartx/unixware.c                        |   4 +-
>  libdmmp/libdmmp_private.h                |   8 +-
>  libmpathcmd/mpath_cmd.c                  |   5 +-
>  libmpathpersist/mpath_persist.c          |   3 +-
>  libmpathpersist/mpath_pr_ioctl.c         |  40 +-
>  libmultipath/Makefile                    |   5 +
>  libmultipath/alias.c                     | 134 ++--
>  libmultipath/alias.h                     |  12 +-
>  libmultipath/byteorder.h                 |  12 +-
>  libmultipath/checkers/cciss_tur.c        |   4 +-
>  libmultipath/checkers/directio.c         |   2 +-
>  libmultipath/checkers/hp_sw.c            |   8 +-
>  libmultipath/checkers/rdac.c             |   2 +-
>  libmultipath/checkers/readsector0.c      |   4 +-
>  libmultipath/config.c                    |   4 +-
>  libmultipath/config.h                    |   4 +-
>  libmultipath/defaults.h                  |   4 +-
>  libmultipath/devmapper.c                 |  10 +-
>  libmultipath/dict.c                      |  52 +-
>  libmultipath/discovery.c                 | 284 +++++----
>  libmultipath/discovery.h                 |   2 +-
>  libmultipath/dm-generic.c                |   6 +-
>  libmultipath/file.c                      |   5 +-
>  libmultipath/foreign.c                   |  20 +-
>  libmultipath/foreign/nvme.c              |  26 +-
>  libmultipath/generic.c                   |   2 +-
>  libmultipath/io_err_stat.c               |  10 +-
>  libmultipath/log.h                       |   3 +-
>  libmultipath/log_pthread.c               |   2 +-
>  libmultipath/log_pthread.h               |   3 +-
>  libmultipath/nvme/linux/nvme.h           | 136 ++++-
>  libmultipath/nvme/nvme-ioctl.c           | 229 ++++---
>  libmultipath/nvme/nvme-ioctl.h           |  31 +-
>  libmultipath/nvme/nvme.h                 | 121 +++-
>  libmultipath/parser.c                    |   2 +-
>  libmultipath/pgpolicies.c                |   2 +-
>  libmultipath/print.c                     |  14 +-
>  libmultipath/print.h                     |   8 +-
>  libmultipath/prioritizers/alua_rtpg.c    |   2 +-
>  libmultipath/prioritizers/ana.c          |  14 +-
>  libmultipath/prioritizers/const.c        |   4 +-
>  libmultipath/prioritizers/datacore.c     |   3 +-
>  libmultipath/prioritizers/emc.c          |   3 +-
>  libmultipath/prioritizers/hds.c          |   3 +-
>  libmultipath/prioritizers/hp_sw.c        |   3 +-
>  libmultipath/prioritizers/iet.c          |   3 +-
>  libmultipath/prioritizers/ontap.c        |   3 +-
>  libmultipath/prioritizers/random.c       |   4 +-
>  libmultipath/prioritizers/rdac.c         |   3 +-
>  libmultipath/prioritizers/sysfs.c        |   3 +-
>  libmultipath/prioritizers/weightedpath.c |   3 +-
>  libmultipath/structs.c                   |   4 +-
>  libmultipath/structs.h                   |   3 +-
>  libmultipath/structs_vec.c               |   2 +-
>  libmultipath/sysfs.c                     |  13 +-
>  libmultipath/time-util.c                 |   6 +-
>  libmultipath/uevent.c                    |   5 +-
>  libmultipath/util.c                      |   7 +-
>  libmultipath/util.h                      |  15 +-
>  libmultipath/uxsock.c                    |   3 +-
>  libmultipath/vector.h                    |   4 +-
>  libmultipath/wwids.c                     |  40 +-
>  mpathpersist/main.c                      |   2 +-
>  multipath/main.c                         |  11 +-
>  multipathd/Makefile                      |   3 +
>  multipathd/cli_handlers.c                |   2 +-
>  multipathd/dmevents.c                    |   4 +-
>  multipathd/main.c                        |  36 +-
>  multipathd/pidfile.c                     |   2 +-
>  multipathd/waiter.c                      |   2 +-
>  multipathd/waiter.h                      |   2 +-
>  tests/Makefile                           |  19 +-
>  tests/alias.c                            | 744 +++++++++++++++++++++++
>  tests/blacklist.c                        |  22 +-
>  tests/hwtable.c                          |   2 +-
>  tests/test-log.c                         |  27 +
>  tests/test-log.h                         |   7 +
>  tests/util.c                             |  16 +-
>  92 files changed, 1818 insertions(+), 598 deletions(-)
>  create mode 100644 tests/alias.c
>  create mode 100644 tests/test-log.c
>  create mode 100644 tests/test-log.h
>=20
> --=20
> 2.23.0
