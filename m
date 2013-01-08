From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/42] Make 'allocated' an integer in vector.h
Date: Tue,  8 Jan 2013 14:54:10 +0100
Message-ID: <1357653259-62650-33-git-send-email-hare@suse.de>
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

I don't trust the programmers here, as we're unconditionally
decreasing the 'allocated' setting on vector_free().
So better make that an integer to catch underflows.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/vector.c |    2 +-
 libmultipath/vector.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 74079a4..dcf69bf 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -114,7 +114,7 @@ vector_del_slot(vector v, int slot)
 
 	v->allocated -= VECTOR_DEFAULT_SIZE;
 
-	if (!v->allocated) {
+	if (v->allocated <= 0) {
 		FREE(v->slot);
 		v->slot = NULL;
 		v->allocated = 0;
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 6779186..7612b4c 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -25,7 +25,7 @@
 
 /* vector definition */
 struct _vector {
-	unsigned int allocated;
+	int allocated;
 	void **slot;
 };
 typedef struct _vector *vector;
-- 
1.7.4.2
