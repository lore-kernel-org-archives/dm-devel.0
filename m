From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] libmultipath: make vector_foreach_slot_backwards
	work as expected
Date: Fri, 24 May 2019 17:41:14 -0500
Message-ID: <1558737674-22335-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

All of the code that uses vector_foreach_slot_backwards() treats "i" as
the index of the entry "p", but the way it was coded, that wasn't the
case. "i" was the number of the entry counting from 1, not 0.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/vector.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 41d2b896..344dffd5 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -40,7 +40,7 @@ typedef struct _vector *vector;
 #define vector_foreach_slot_after(v,p,i) \
 	for (; (v) && i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
 #define vector_foreach_slot_backwards(v,p,i) \
-	for (i = VECTOR_SIZE(v); i > 0 && ((p) = (v)->slot[i-1]); i--)
+	for (i = VECTOR_SIZE(v) - 1; (int)i >= 0 && ((p) = (v)->slot[i]); i--)
 
 #define identity(x) (x)
 /*
-- 
2.17.2
