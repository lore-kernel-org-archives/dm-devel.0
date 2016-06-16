From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/39] libmultipath/devmapper.c: check for errors
	from sscanf()
Date: Thu, 16 Jun 2016 11:47:17 +0200
Message-ID: <1466070465-1021-12-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/devmapper.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f395481..0223e18 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -116,7 +116,10 @@ dm_lib_prereq (void)
 
 	dm_get_library_version(version, sizeof(version));
 	condlog(3, "libdevmapper version %s", version);
-	sscanf(version, "%d.%d.%d ", &v[0], &v[1], &v[2]);
+	if (sscanf(version, "%d.%d.%d ", &v[0], &v[1], &v[2]) != 3) {
+		condlog(0, "invalid libdevmapper version %s", version);
+		return 1;
+	}
 
 	if VERSION_GE(v, minv)
 		return 0;
-- 
2.6.6
