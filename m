From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/42] Use VECTOR_SIZE() defines
Date: Tue,  8 Jan 2013 14:54:09 +0100
Message-ID: <1357653259-62650-32-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The size of a vector slot might be larger than one, so we should
be using the VECTOR_SIZE() define everywhere.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/vector.c |    8 ++++----
 libmultipath/vector.h |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 652f118..74079a4 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -81,7 +81,7 @@ vector_insert_slot(vector v, int slot, void *value)
 	if (!vector_alloc_slot(v))
 		return NULL;
 
-	for (i = (v->allocated /VECTOR_DEFAULT_SIZE) - 2; i >= slot; i--)
+	for (i = VECTOR_SIZE(v) - 2; i >= slot; i--)
 		v->slot[i + 1] = v->slot[i];
 
 	v->slot[slot] = value;
@@ -94,7 +94,7 @@ find_slot(vector v, void * addr)
 {
 	int i;
 
-	for (i = 0; i < (v->allocated / VECTOR_DEFAULT_SIZE); i++)
+	for (i = 0; i < VECTOR_SIZE(v); i++)
 		if (v->slot[i] == addr)
 			return i;
 
@@ -109,7 +109,7 @@ vector_del_slot(vector v, int slot)
 	if (!v || !v->allocated || slot < 0 || slot > VECTOR_SIZE(v))
 		return;
 
-	for (i = slot + 1; i < (v->allocated / VECTOR_DEFAULT_SIZE); i++)
+	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
 		v->slot[i-1] = v->slot[i];
 
 	v->allocated -= VECTOR_DEFAULT_SIZE;
@@ -137,7 +137,7 @@ vector_repack(vector v)
 	if (!v || !v->allocated)
 		return;
 
-	for (i = 0; i < (v->allocated / VECTOR_DEFAULT_SIZE); i++)
+	for (i = 0; i < VECTOR_SIZE(v); i++)
 		if (i > 0 && v->slot[i] == NULL)
 			vector_del_slot(v, i--);
 }
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index ca42be1..6779186 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -31,14 +31,14 @@ struct _vector {
 typedef struct _vector *vector;
 
 #define VECTOR_DEFAULT_SIZE 1
-#define VECTOR_SLOT(V,E) (((V) && (E) < (V)->allocated) ? (V)->slot[(E)] : NULL)
-#define VECTOR_SIZE(V)   ((V) ? (V)->allocated : 0)
-#define VECTOR_LAST_SLOT(V)   (((V) && (V)->allocated) ? (V)->slot[((V)->allocated - 1)] : NULL)
+#define VECTOR_SIZE(V)   ((V) ? ((V)->allocated) / VECTOR_DEFAULT_SIZE : 0)
+#define VECTOR_SLOT(V,E) (((V) && (E) < VECTOR_SIZE(V)) ? (V)->slot[(E)] : NULL)
+#define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)->slot[(VECTOR_SIZE(V) - 1)] : NULL)
 
 #define vector_foreach_slot(v,p,i) \
-	for (i = 0; (v) && i < (v)->allocated && ((p) = (v)->slot[i]); i++)
+	for (i = 0; (v) && i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
 #define vector_foreach_slot_after(v,p,i) \
-	for (; (v) && i < (v)->allocated && ((p) = (v)->slot[i]); i++)
+	for (; (v) && i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
 #define vector_foreach_slot_backwards(v,p,i) \
 	for (i = VECTOR_SIZE(v); i > 0 && ((p) = (v)->slot[i-1]); i--)
 
-- 
1.7.4.2
