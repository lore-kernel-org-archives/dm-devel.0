From: mwilck@suse.com
Subject: [PATCH 41/42] libmultipath: refuse reloading an existing
	map with different WWID
Date: Thu,  9 Jul 2020 12:35:12 +0200
Message-ID: <20200709103513.8142-3-mwilck@suse.com>
References: <20200709103513.8142-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103513.8142-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

If a map with given name (alias) already exists with a different WWID,
reloading it with a new WWID will be harmful. The existing paths would
be replaced by other, unrelated ones. The WWIDs of the new paths would
not match the map WWID, and thus sooner or later overwritten by
disassemble_map with the map's wwid.

Refuse reloading a map under such circumstances. This makes it impossible
to "swap" multipath names in a single reconfigure run, but avoiding
data corruption should be worth it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index c62807e..75e11fd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -897,10 +897,21 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		return DOMAP_DRY;
 	}
 
-	if (mpp->action == ACT_CREATE &&
-	    dm_map_present(mpp->alias)) {
-		condlog(3, "%s: map already present", mpp->alias);
-		mpp->action = ACT_RELOAD;
+	if (mpp->action == ACT_CREATE && dm_map_present(mpp->alias)) {
+		char wwid[WWID_SIZE];
+
+		if (dm_get_uuid(mpp->alias, wwid, sizeof(wwid)) == 0) {
+			if (!strncmp(mpp->wwid, wwid, sizeof(wwid))) {
+				condlog(3, "%s: map already present",
+					mpp->alias);
+				mpp->action = ACT_RELOAD;
+			} else {
+				condlog(0, "%s: map \"%s\" already present with WWID %s, skipping",
+					mpp->wwid, mpp->alias, wwid);
+				condlog(0, "please check alias settings in config and bindings file");
+				mpp->action = ACT_REJECT;
+			}
+		}
 	}
 
 	switch (mpp->action) {
-- 
2.26.2
