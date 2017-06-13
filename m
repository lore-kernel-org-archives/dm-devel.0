From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/7] no_path_retry/queue_if_no_path logic &
	logging/man page fixes
Date: Wed, 14 Jun 2017 00:55:47 +0200
Message-ID: <20170613225554.11181-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

This patch set attempts to sanitize the logic used for consistently handling
options that can be set both via the "features" string and explicit multipath.conf
options. This is most prominently "no_path_retry" vs. "queue_if_no_path", but also
"retain_attached_hw_handler" vs. the feature of the same name.

The logic this patch set follows is:
 - If "no_path_retry" is set to any value, "queue_if_no_path" is ignored
   (this is the case nowadays for almost all "real" storage arrays, thanks to hwtable).
 - Otherwise, if "queue_if_no_path" is set, treat it like "no_path_retry queue".

... likewise for "retain_attached_hw_handler".

The logic is implemented in select_features() (which needs to be called after
select_no_path_retry()) for multipath groups, and similarly in merge_hwe() for
hwtable entries. The actual feature setting is made in assemble_map(), I also
fix a problem there.

The patch set documents the behavior in the man page, and adds some more
man page fixes.

Finally, by skipping superfluous default initializations in load_config(), the
log messages for the respective config settings become more appropriate.

Review and comments are highly welcome.

Regards,
Martin

Martin Wilck (7):
  libmultipath: load_config: skip setting unnecessary defaults
  libmultipath: add/remove_feature: use const char* for feature
  libmultipath: clarify option conflicts for "features"
  libmultipath: merge_hwe: fix queue_if_no_path logic
  libmultipath: assemble_map: fix queue_if_no_path logic
  multipath.conf.5: document no_path_retry vs. queue_if_no_path
  multipath.conf.5: Remove ??? and other minor fixes

 libmultipath/config.c      | 36 ++++++++++++++------------------
 libmultipath/configure.c   |  4 ++--
 libmultipath/dmparser.c    |  5 ++---
 libmultipath/propsel.c     | 39 +++++++++++++++++++++-------------
 libmultipath/structs.c     | 30 +++++++++++++-------------
 libmultipath/structs.h     |  4 ++--
 multipath/multipath.conf.5 | 52 ++++++++++++++++++++++++++--------------------
 7 files changed, 92 insertions(+), 78 deletions(-)

-- 
2.13.0
