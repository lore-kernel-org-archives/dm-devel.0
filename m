From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/32] Misc Multipath patches
Date: Wed,  1 Aug 2018 15:56:46 -0500
Message-ID: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This batch of patches is a resend of my previous 10 patches, as well
as new patches mostly found by running coverity.

patches 0001-0010 are identical to my previous patchset
patches 0012-0015 & 0021-0032 are minor issues found by coverity.
        Not all of them are bugs that could actually occur in practice,
        but they are simple and hopefully non-controversial changes.
patches 0016-0020 are a number of fixes to the tur checker.These are
        the ones that should get the most attention.

Also, I would love to have a 0.7.8 tagged release.

Benjamin Marzinski (32):
  libmultipath: remove last of rbd code
  libmultipath: fix detect alua corner case
  multipath: fix setting conf->version
  mpathpersist: add --param-alltgpt option
  libmutipath: remove unused IDE bus type
  multipathd: add new protocol path wildcard
  libmultipath: add "protocol" blacklist option.
  libmultipath: remove _filter_* blacklist functions
  multipath tests: change to work with old make versions
  multipath tests: add blacklist tests
  mpathpersist: add missing --param-rk usage info
  kpartx: minor fixes to make coverity happy
  kpartx: Fix memory leak of uuid found by coverity
  kpartx: fix bad dm_devn return
  kpartx: remove duplicated gpt validation check
  libmultipath: fix tur checker timeout
  libmultipath: fix tur checker double locking
  libmultipath: fix tur memory misuse
  libmultipath: cleanup tur locking
  libmultipath: fix tur checker timeout issue
  libmultipath: fix set_int error path
  libmultipath: fix length issues in get_vpd_sgio
  libmultipath: _install_keyword cleanup
  libmultipath: remove unused code
  libmultipath: fix memory issue in path_latency prio
  libmultipath: fix null dereference int alloc_path_group
  libmutipath: don't use malformed uevents
  multipath: fix max array size in print_cmd_valid
  multipathd: function return value tweaks
  multipathd: minor fixes
  multipathd: remove useless check and fix format
  multipathd: fix memory leak on error in configure

 kpartx/dasd.c                            |   5 +-
 kpartx/del-part-nodes.rules              |   2 +-
 kpartx/devmapper.c                       |  15 +-
 kpartx/gpt.c                             |  10 -
 libmpathpersist/mpath_persist.c          |  10 +-
 libmultipath/blacklist.c                 | 177 +++++------
 libmultipath/blacklist.h                 |   5 +-
 libmultipath/checkers/tur.c              | 165 ++++------
 libmultipath/config.c                    |  15 +
 libmultipath/config.h                    |   2 +
 libmultipath/configure.c                 |   2 +-
 libmultipath/devmapper.c                 |   6 +-
 libmultipath/dict.c                      |  19 +-
 libmultipath/discovery.c                 |  19 +-
 libmultipath/parser.c                    |  12 +-
 libmultipath/print.c                     |  82 ++++-
 libmultipath/print.h                     |   2 +
 libmultipath/prioritizers/path_latency.c |   3 +-
 libmultipath/propsel.c                   |   4 +-
 libmultipath/structs.c                   |   2 +-
 libmultipath/structs.h                   |   2 -
 libmultipath/uevent.c                    |   6 +
 mpathpersist/main.c                      |  12 +-
 mpathpersist/main.h                      |   1 +
 mpathpersist/mpathpersist.8              |   4 +
 multipath/main.c                         |   2 +-
 multipath/multipath.conf.5               |  24 +-
 multipathd/cli_handlers.c                |  11 +-
 multipathd/main.c                        |  26 +-
 tests/Makefile                           |   6 +-
 tests/blacklist.c                        | 512 +++++++++++++++++++++++++++++++
 31 files changed, 889 insertions(+), 274 deletions(-)
 create mode 100644 tests/blacklist.c

-- 
2.7.4
