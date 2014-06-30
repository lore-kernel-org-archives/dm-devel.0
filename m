From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 00/12] miscellaneous multipath patches
Date: Mon, 30 Jun 2014 00:13:51 -0500
Message-ID: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
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

Here are some bugfix, cleanup, and minor feature patches. Let me know if
any of these seem problematic. I'm definitely open to using a seperate
timeout for prioritizers, for instance.

Benjamin Marzinski (12):
  Fix memory issues in path reordering failure code paths
  Return the correct size buffer in set_value()
  enable gcc format-security check
  change conf->dry_run to conf->cmd
  allow users to add wwids to /etc/multipath/wwids with -a
  Make multipath add wwids from kernel cmdline mpath.wwids with -A
  Make multipathd orphan paths that were removed externally
  Add missing interactive commands to multipathd man page
  orphan paths on failed add
  Improve multipath.conf syntax checking
  make prioritizers use checker_timeout, if set
  Add multipath.conf force_sync option

 Makefile.inc                          |   2 +-
 libmultipath/config.c                 |   1 +
 libmultipath/config.h                 |  15 +++-
 libmultipath/configure.c              |  12 ++-
 libmultipath/dict.c                   |  33 ++++++++
 libmultipath/discovery.c              |  14 +++-
 libmultipath/parser.c                 | 154 +++++++++++++++++++++++++++-------
 libmultipath/prio.c                   |   7 ++
 libmultipath/prio.h                   |   1 +
 libmultipath/prioritizers/alua.c      |   4 +-
 libmultipath/prioritizers/alua_rtpg.c |   5 +-
 libmultipath/prioritizers/emc.c       |   2 +-
 libmultipath/prioritizers/hds.c       |   2 +-
 libmultipath/prioritizers/hp_sw.c     |   2 +-
 libmultipath/prioritizers/ontap.c     |   4 +-
 libmultipath/prioritizers/rdac.c      |   2 +-
 libmultipath/structs_vec.c            |  31 ++++++-
 libmultipath/wwids.c                  |  44 ++++++++++
 libmultipath/wwids.h                  |   1 +
 multipath.conf.annotated              |  16 +++-
 multipath/main.c                      |  72 ++++++++++------
 multipath/multipath.8                 |   8 +-
 multipath/multipath.conf.5            |  13 ++-
 multipathd/main.c                     |   6 +-
 multipathd/multipathd.8               |  29 +++++++
 multipathd/multipathd.service         |   1 +
 26 files changed, 398 insertions(+), 83 deletions(-)

-- 
1.8.3.1
