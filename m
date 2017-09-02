From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/31] libmultipath: add DI_NOIO flag for pathinfo
Date: Sun,  3 Sep 2017 00:38:42 +0200
Message-ID: <20170902223900.7339-14-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This flag can used to avoid any IO on the device itself. Useful
for getting the path state without the risk of hanging or running
into IO errors.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 8 ++++++++
 libmultipath/discovery.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3a912d76..0ff2faa7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1926,6 +1926,14 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	path_state = path_offline(pp);
 	if (path_state == PATH_REMOVED)
 		goto blank;
+	else if (mask & DI_NOIO) {
+		/*
+		 * Avoid any IO on the device itself.
+		 * Behave like DI_CHECKER in the "path unavailable" case.
+		 */
+		pp->chkrstate = pp->state = path_state;
+		return PATHINFO_OK;
+	}
 
 	/*
 	 * fetch info not available through sysfs
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 51c23d6f..65352881 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -62,6 +62,7 @@ enum discovery_mode {
 	__DI_PRIO,
 	__DI_WWID,
 	__DI_BLACKLIST,
+	__DI_NOIO,
 };
 
 #define DI_SYSFS	(1 << __DI_SYSFS)
@@ -70,6 +71,7 @@ enum discovery_mode {
 #define DI_PRIO		(1 << __DI_PRIO)
 #define DI_WWID		(1 << __DI_WWID)
 #define DI_BLACKLIST	(1 << __DI_BLACKLIST)
+#define DI_NOIO		(1 << __DI_NOIO) /* Avoid IO on the device */
 
 #define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
 			 DI_WWID)
-- 
2.14.0
