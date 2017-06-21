From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 00/11] multipath-tools:
	no_path_retry/queue_if_no_path/hwhandler logic
Date: Wed, 21 Jun 2017 17:06:19 +0200
Message-ID: <20170621150630.25773-1-mwilck@suse.com>
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

In the long run, we should get rid of the "features" settings duplicating
configuration options altogether; the patch set prepares this by printing
warning messages.

The logic is implemented in the new function reconcile_features_with_options,
which is called from both select_features() and merge_hwe(). In setup_map(),
we need to call select_features() after select_no_path_retry() to make this work.
The actual feature setting for device-mapper is made in assemble_map(), the
patch set also fixes the logic there.

The patch set documents the behavior in the man page, and adds some more
man page fixes.

By skipping superfluous default initializations in load_config(), the
log messages for the respective config settings become more appropriate.

The logic for setting hardware handler is also improved. Since kernel 4.3,
"retain_attached_hw_handler yes" is implicitly set by the kernel, and setting
the hardware handler from user space is only possible in special situations.
Acknowledge that in multipathd, and don't try to set or unset either this
feature or the hwhandler attribute itself if it's doomed to fail.

Review and comments are highly welcome.

Changes wrt v1:
  - Suggestions from Ben Marzinski:
    * Made sure "multipathd show config" still works (1/8).
    * Fixed logging for default setting of "max_sectors" (1/8)
    * Consistent internal treatment of mp->features (3/8, 4/8)
    * Fixed whitespace error (6/8)
    * Added deprecated warnings (8/8)
  - Made sure the same logic is used in propsel.c and config.c by
    calling the same function (3/8, 4/8)
  - Added deprecated warnings (8/8)

Changes wrt v2:
 - Added Acked-by:/Reviewed-by: tags
 - 1/11: clarify comment in select_max_sectors_kb (Hannes Reinecke)
 - 3/11: call select_retain_hwhandler before select_features
 - 8/11: don't suggest using retain_attached_hw_handler in log msg
 - 9/11, 10/11, 11/11: new

Martin Wilck (11):
  libmultipath: load_config: skip setting unnecessary defaults
  libmultipath: add/remove_feature: use const char* for feature
  libmultipath: clarify option conflicts for "features"
  libmultipath: merge_hwe: fix queue_if_no_path logic
  libmultipath: assemble_map: fix queue_if_no_path logic
  multipath.conf.5: document no_path_retry vs. queue_if_no_path
  multipath.conf.5: Remove ??? and other minor fixes
  libmultipath: add deprecated warning for some features settings
  libmultipath: retain_attached_hw_handler obsolete with 4.3+
  libmultipath: don't try to set hwhandler if it is retained
  libmultipath: don't [un]set queue_if_no_path after domap

 libmultipath/config.c      |  36 +++++-----------
 libmultipath/configure.c   |  72 ++++++++++++++++++++++++--------
 libmultipath/dict.c        |  11 +++--
 libmultipath/discovery.c   |   4 ++
 libmultipath/dmparser.c    |   8 ++--
 libmultipath/propsel.c     | 101 ++++++++++++++++++++++++++++++++++++++-------
 libmultipath/propsel.h     |   3 ++
 libmultipath/structs.c     |  30 +++++++-------
 libmultipath/structs.h     |   6 ++-
 libmultipath/util.c        |  36 ++++++++++++++++
 libmultipath/util.h        |   2 +
 multipath/multipath.conf.5 |  67 ++++++++++++++++++------------
 12 files changed, 266 insertions(+), 110 deletions(-)

-- 
2.13.1
