From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 10/20] libmultipath: add vector_free_const()
Date: Tue, 20 Feb 2018 14:26:48 +0100
Message-ID: <20180220132658.22295-11-mwilck@suse.com>
References: <20180220132658.22295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180220132658.22295-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

... to dispose of constant vectors (const struct _vector*).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/vector.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 5cfd4d060412..3f6e579ae19a 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -46,6 +46,7 @@ typedef struct _vector *vector;
 extern vector vector_alloc(void);
 extern void *vector_alloc_slot(vector v);
 extern void vector_free(vector v);
+#define vector_free_const(x) vector_free((vector)(long)(x))
 extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
 extern void vector_del_slot(vector v, int slot);
-- 
2.16.1
