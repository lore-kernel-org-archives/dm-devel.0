From: mwilck@suse.com
Subject: [PATCH v2 41/42] libmultipath: refuse reloading an
	existing map with different WWID
Date: Wed, 12 Aug 2020 13:34:05 +0200
Message-ID: <20200812113405.26206-3-mwilck@suse.com>
References: <20200812113405.26206-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113405.26206-1-mwilck@suse.com>
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
reloading it with a new WWID is harmful. The existing paths would first
be replaced by others with the new WWID. The WWIDs of the new paths wouldn't
match the map WWID; thus the next time the map is disassembled, the (correct)
path WWIDs would be overwritten by the different map WWID (with subsequent
patches from this series, they'd be orphaned instead, which is better but
still not ideal). When the map is reloaded later, paths with diffent WWIDs
may be mixed, causing data corruption.

Refuse reloading a map under such circumstances.

Note: this patch doesn't change multipath-tools behavior in the case
where valid map aliases are supposed to be swapped (typically if the bindings
file differs between initrd and root FS). In this case, select_action()
selects ACT_RENAME, which this patch doesn't affect. The user-visible behavior
in this case remains as-is: the map renames fail, and the aliases remain
unchanged, thus not matching the current bindings file, but art least
internally consistent.

To fully fix this use case, coalesce_paths() must cease setting up maps one
by one. Instead, we'd need to build up a full set of maps-to-be-set-up,
and create them in a single batch, figuring out a "rename strategy" beforehand
to avoid clashes between existing and to-be-created maps (for example,
a name swap A<->B would need to be carried out as B->tmp, A->B, tmp->A).
Implementing that is out of the scope of this patch series.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 315eb6a..5f60f74 100644
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
2.28.0
