From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/10] Misc multipath patches
Date: Fri, 13 Jul 2018 14:39:05 -0500
Message-ID: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
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

- patches 0001 and 0005 patch is some small unused code cleanup
- patches 0002 & 0003 are just some small bugfixes
- patch 0004 adds --param-alltgpt support to mpathpersist, since it
  appears to work correctly on devices that accept ALL_TG_PT
- patches 0006 & 0007 add a new method for blacklisting devices,
  "protocol", along with path wildcards to see the value of this for
  paths. I added this to deal with requests for being able to set
  multipath to only look at, for instancei, FC and iSCSI devices,
  without knowing beforehand what devices are going to be present on a
  system. There wasn't a set of udev properties that always worked to
  distinguish this for all devices, even if we could blacklist based on
  the values (which multipath currently can't).
- patch 0008 cleans up the blacklist filtering code, and fixes some
  printing inconsistencies.  It does mean that when filter_path is
  called, all of the whitelist messages are printed, even if a path is
  eventually blacklisted. Of course the blacklist message is printed
  last, and there can already be prior whitelist messages in the logs
  from calls to the other filter_* functions.
- patch 0009 is a small change to the how the tests Makefile works, to
  make the unit tests compile on an older machine I tested on.
- patch 0010 is a new set of unit tests that validate the return codes
  and the messages printed by the blacklist filter_* functions.

Benjamin Marzinski (10):
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

 kpartx/del-part-nodes.rules     |   2 +-
 libmpathpersist/mpath_persist.c |  10 +-
 libmultipath/blacklist.c        | 177 +++++++-------
 libmultipath/blacklist.h        |   5 +-
 libmultipath/config.c           |  15 ++
 libmultipath/config.h           |   2 +
 libmultipath/configure.c        |   2 +-
 libmultipath/devmapper.c        |   6 +-
 libmultipath/dict.c             |  14 +-
 libmultipath/discovery.c        |   5 +-
 libmultipath/print.c            |  74 ++++++
 libmultipath/print.h            |   2 +
 libmultipath/propsel.c          |   4 +-
 libmultipath/structs.h          |   2 -
 mpathpersist/main.c             |  11 +-
 mpathpersist/main.h             |   1 +
 mpathpersist/mpathpersist.8     |   4 +
 multipath/multipath.conf.5      |  24 +-
 tests/Makefile                  |   6 +-
 tests/blacklist.c               | 512 ++++++++++++++++++++++++++++++++++++++++
 20 files changed, 762 insertions(+), 116 deletions(-)
 create mode 100644 tests/blacklist.c

-- 
2.7.4
