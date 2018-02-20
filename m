From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 11/20] libmultipath: add vector_convert()
Date: Tue, 20 Feb 2018 14:26:49 +0100
Message-ID: <20180220132658.22295-12-mwilck@suse.com>
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

This is a handy helper for creating one vector from another,
mapping each element of the origin vector to an element of
the target vector with a given conversion function. It can
also be used to "concatenate" vectors by passing in a non-NULL first
argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/vector.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 3f6e579ae19a..6018b57525bf 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -42,6 +42,35 @@ typedef struct _vector *vector;
 #define vector_foreach_slot_backwards(v,p,i) \
 	for (i = VECTOR_SIZE(v); i > 0 && ((p) = (v)->slot[i-1]); i--)
 
+#define identity(x) (x)
+/*
+ * Given a vector vec with elements of given type,
+ * return a newly allocated vector with elements conv(e) for each element
+ * e in vec. "conv" may be a macro or a function.
+ * Use "identity" for a simple copy.
+ */
+#define vector_convert(new, vec, type, conv)				\
+	({								\
+		const struct _vector *__v = (vec);			\
+		vector __t = (new);					\
+		type *__j;						\
+		int __i;						\
+									\
+		if (__t == NULL)					\
+			__t = vector_alloc();				\
+		if (__t != NULL) {					\
+			vector_foreach_slot(__v, __j, __i) {		\
+				if (vector_alloc_slot(__t) == NULL) {	\
+					vector_free(__t);		\
+					__t = NULL;			\
+					break;				\
+				}					\
+				vector_set_slot(__t, conv(__j));	\
+			}						\
+		}							\
+		__t;							\
+	})
+
 /* Prototypes */
 extern vector vector_alloc(void);
 extern void *vector_alloc_slot(vector v);
-- 
2.16.1
