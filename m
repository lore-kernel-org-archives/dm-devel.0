From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 00/16] miscellaneous dm-multipath patches
Date: Wed, 11 Dec 2013 00:42:54 -0600
Message-ID: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Here are a number of bugfixes and minor features. The first 8 are a resubmit of the patches I sent on Jun 28th.  I didn't see any objection to any of them, so
I just rebased them.

Benjamin Marzinski (16):
  Add multipath path format wildcard
  Fix multipath rename from user_friendly_name to wwid
  Turn off user_friendly_names for netapp devices
  Don't detect prioritizers that don't work
  Only load a multipath device RO if RW load fails with EROFS
  signal waiter thread to stop waiting on dm events
  fix mutipath -W on empty wwids file
  multipathd: Add envp variable
  libmultipath: try to deal with bindings file hand editting
  kpartx: Make kpartx able to create read-only loop devices
  libmultipath: show default configurations
  multipathd: Don't touch the multipath device after setup_multipath
    fails
  kpartx: fix strict aliasing warning
  libmultipath: blacklist blktap devices
  multipathd: allow /dev/<devnode> to be used for multipathd commands
  kpartx: autoload loop module on loop partition creation

 kpartx/dasd.c             |  4 +-
 kpartx/kpartx.c           |  3 +-
 kpartx/lopart.c           | 19 +++++++--
 libmultipath/alias.c      | 39 ++++++++++++++-----
 libmultipath/blacklist.c  |  2 +-
 libmultipath/configure.c  |  7 ----
 libmultipath/devmapper.c  | 98 ++++++++++++-----------------------------------
 libmultipath/devmapper.h  |  3 --
 libmultipath/dict.c       |  4 --
 libmultipath/hwtable.c    |  1 +
 libmultipath/print.c      | 11 ++++++
 libmultipath/propsel.c    | 13 +++++--
 libmultipath/util.c       | 22 +++++++++++
 libmultipath/util.h       |  1 +
 libmultipath/waiter.c     |  9 +++++
 libmultipath/wwids.c      |  6 +++
 multipath/main.c          | 23 +----------
 multipathd/cli_handlers.c | 21 +++++++++-
 multipathd/main.c         | 21 +++++++---
 19 files changed, 171 insertions(+), 136 deletions(-)

-- 
1.8.4.2
