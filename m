From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 12/16] Make set_multipath_wwid actually do
	something
Date: Thu,  2 May 2013 16:46:33 -0500
Message-ID: <1367531197-8987-13-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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

mpp->wwid is a character array in the multipath struction, not a pointer,
so it is never NULL. multipath needs to check if the string is empty
instead.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7073915..72622b0 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -106,7 +106,7 @@ orphan_paths (vector pathvec, struct multipath * mpp)
 static void
 set_multipath_wwid (struct multipath * mpp)
 {
-	if (mpp->wwid)
+	if (strlen(mpp->wwid))
 		return;
 
 	dm_get_uuid(mpp->alias, mpp->wwid);
-- 
1.8.2
