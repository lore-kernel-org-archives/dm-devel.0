From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 11/18] multipath: Fix minor text issues
Date: Thu,  7 Apr 2016 18:20:05 -0500
Message-ID: <1460071212-21018-12-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

The multipath.conf man page gave the incorrect default for
queue_without_daemon. The multipath usage output listed the -p option
twice. And multipath was misspelled in an mpathpersist error message.
This patch fixes these issues.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 multipath/main.c                | 1 -
 multipath/multipath.conf.5      | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 7a2249f..b23e116 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -852,7 +852,7 @@ int update_map_pr(struct multipath *mpp)
 	if (!mpp->reservation_key)
 	{
 		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		condlog(3, "%s: reservation_key not set in multiapth.conf", mpp->alias);
+		condlog(3, "%s: reservation_key not set in multipath.conf", mpp->alias);
 		return MPATH_PR_SUCCESS;
 	}
 
diff --git a/multipath/main.c b/multipath/main.c
index decb590..d14a913 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -107,7 +107,6 @@ usage (char * progname)
 		"  -r      force devmap reload\n" \
 		"  -i      ignore wwids file\n" \
 		"  -B      treat the bindings file as read only\n" \
-		"  -p      policy failover|multibus|group_by_serial|group_by_prio\n" \
 		"  -b fil  bindings file location\n" \
 		"  -w      remove a device from the wwids file\n" \
 		"  -W      reset the wwids file include only the current devices\n" \
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 9752c67..31c0eb8 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -389,7 +389,7 @@ multipathd running, access to the paths cannot be restored, and the kernel
 cannot be told to stop queueing IO. Setting queue_without_daemon to
 .I no
 , avoids this problem. Default is
-.I yes
+.I no
 .TP
 .B bindings_file
 The full pathname of the binding file to be used when the user_friendly_names option is set. Defaults to
-- 
1.8.3.1
