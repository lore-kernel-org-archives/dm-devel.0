From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/30] multipath-tools: gcc9, VPD parsing,
 and get_uid fixes
Date: Fri, 21 Jun 2019 14:26:45 -0500
Message-ID: <20190621192645.GM3251@octiron.msp.redhat.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jun 07, 2019 at 03:05:22PM +0200, Martin Wilck wrote:
> Hi Christophe, hi Ben,

ACK for everything, except my nitpicks for patches 5 and 7. I don't know
how much we care about patch 5 temporarily breaking compilation, but it
no one else is bothered by it, I would be fine with simply tacking on a
patch at the end to fix my issues with patch 7.

-Ben
 
> This series started out with me trying to fix a couple  of warnings
> emitted by gcc 9, and grew substantially while I encountered other
> issues. Most of this series, except patch 25ff, are cleanups, corner
> case fixes, and unit tests.
> 
> The parts of the series with user visible impact are 25, 26, and 29.
> Patch 25/30 implements an earlier idea of mine
> (https://www.redhat.com/archives/dm-devel/2019-April/msg00005.html).
> The idea for patch 29/30 has been discussed before, too
> (https://www.redhat.com/archives/dm-devel/2019-March/msg00201.html)
> The fix for uid_attrs (26/30) occured to me while I was working on the get_uid()
> code path.
> 
> Patch 1/30 up to 8/30 are more or less straightforward fixes for gcc
> warnings related to string operations. See
> https://developers.redhat.com/blog/2018/05/24/detecting-string-truncation-with-gcc-8/
> (not sure why it says gcc 8 there, I'm seeing these warnings with gcc9
> only). Most of the gcc warnings have been "solved" by replacing strncpy()
> calls with strlcpy(). That has the disadvantage that the compiler's static
> checking, which caused the warnings in the first place, is now simply
> disabled. Yet in those places where I did the replacement, I reckon that
> strlcpy() semantics is what we actually want. Most of the time, we try to
> ensure that "wwid" fields are properly 0-terminated. The previous code
> attempted to do this using constructs like
> 
>   strncpy(x->wwid, y->wwid, WWID_SIZE - 1)
> 
> relying on x[WWID_SIZE-1] being 0 already. gcc 9 doesn't appreciate this
> style, and I tend to agree.
> 
> This lead me to check the code paths where wwid fields are originally set,
> resulting in patch 9/30 and the series from 14/30 to 24/30. In particular the
> VPD parsing code was full of small mistakes if the possibility of buffer
> overflow is taken into account (unlikely to hurt in practice, as our default
> WWID_SIZE is large enough to hold almost every WWID). In order not to break
> stuff, I added unit test code (10-13). The tests, in turn, made me find some
> more minor problems in the VPD parsing code (patches 14, 18, 21, 22, 24).
> 
> Reviews and comments welcome.
> 
> Regards,
> Martin
> 
> Martin Wilck (30):
>   kpartx: dasd: fix -Waddress-of-packed-member warning from gcc9
>   libmultipath: fix gcc -Wstringop-truncation warning in set_value()
>   libmultipath: remove 'space' argument to merge_words()
>   libmultipath: fix -Wstringop-overflow warning in merge_words()
>   multipath-tools: fix more gcc 9 -Wstringop-truncation warnings
>   multipath-tools: Fix more strncpy(X, Y, size - 1) calls
>   libmpathcmd: use target length in strncpy() call
>   libmultipath: inline set_default()
>   libmultipath: add size argument to dm_get_uuid()
>   multipath-tools tests: omit timestamp in log messages
>   tests/hwtable: decrease log verbosity
>   multipath-tools tests: add strlcpy() tests
>   multipath-tools tests: add test for VPD parsing
>   libmultipath: fix parsing of VPD 83 type 1 (T10 vendor ID)
>   libmultipath: Fix buffer overflow in parse_vpd_pg80()
>   libmultipath: fix possible WWID overflow in parse_vpd_pg83()
>   libmultipath: fix another WWID overflow in parse_vpd_pg83()
>   libmultipath: fix parsing of SCSI name string, iqn format
>   libmultipath: add consistent WWID overflow logging in parse_vpd_pg83
>   libmultipath: parse_vpd_pg83: common code for SCSI string parsing
>   libmultipath: allow zero-padded SCSI names in parse_vpd_pg83()
>   libmultipath: fix parsing of non-space-terminated T10 ID
>   libmultipath: parse_vpd_pg80: fix overflow output
>   libmultipath: parse_vpd_pg80: fix whitespace handling
>   libmultipath: get_uid: straighten the fallback logic
>   libmultipath: fix has_uid_fallback() logic
>   libmultipath: fix memory leak with "uid_attrs" config option
>   multipath-tools tests: add test for uid_attrs parsing
>   libmultipath: more cautious blacklisting by missing property
>   multipath.conf.5: Improve documentation of WWID determination
> 
>  kpartx/dasd.h                   |   2 +-
>  libmpathcmd/mpath_cmd.c         |   2 +-
>  libmpathpersist/mpath_persist.c |  10 +-
>  libmultipath/blacklist.c        |  26 +-
>  libmultipath/blacklist.h        |   2 +-
>  libmultipath/config.c           |  51 ++-
>  libmultipath/config.h           |   6 +-
>  libmultipath/configure.c        |  17 +-
>  libmultipath/debug.c            |   1 +
>  libmultipath/defaults.c         |  17 -
>  libmultipath/defaults.h         |  10 +-
>  libmultipath/devmapper.c        |  28 +-
>  libmultipath/devmapper.h        |   2 +-
>  libmultipath/dict.c             |  36 +-
>  libmultipath/discovery.c        | 162 ++++---
>  libmultipath/dmparser.c         |  51 +--
>  libmultipath/hwtable.c          |   2 +-
>  libmultipath/parser.c           |  20 +-
>  libmultipath/prio.c             |   3 +-
>  libmultipath/propsel.c          |   4 +-
>  libmultipath/structs_vec.c      |   3 +-
>  libmultipath/uevent.c           |   5 +-
>  libmultipath/util.c             |  44 +-
>  libmultipath/util.h             |   1 -
>  libmultipath/uxsock.c           |   2 +-
>  libmultipath/wwids.c            |   3 +-
>  multipath/multipath.conf.5      |  56 ++-
>  multipathd/main.c               |   2 +-
>  multipathd/waiter.c             |   3 +-
>  tests/Makefile                  |   4 +-
>  tests/blacklist.c               |  39 +-
>  tests/globals.c                 |   3 +-
>  tests/hwtable.c                 |   6 +-
>  tests/uevent.c                  |  27 ++
>  tests/util.c                    | 142 ++++++
>  tests/vpd.c                     | 790 ++++++++++++++++++++++++++++++++
>  36 files changed, 1332 insertions(+), 250 deletions(-)
>  create mode 100644 tests/vpd.c
> 
> -- 
> 2.21.0
