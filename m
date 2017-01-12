From: tang.junhui@zte.com.cn
Subject: [PATCH 03/11] libmultipath: add three list iteration
	macros
Date: Thu, 12 Jan 2017 13:52:19 +0800
Message-ID: <1484200347-11188-4-git-send-email-tang.junhui@zte.com.cn>
References: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1484200347-11188-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, bmarzins@redhat.com, hare@suse.de, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

Add three list iteration macros, list_for_each_entry_reverse_safe
is used for safe list iteration, and the other two macros are used
to iterate list forwards or backwards from the given begin node to
the given end node, which would be used in merging uevents.

Change-Id: I8bb53fef9276bb62a5e0f4fdac6455086dc03d9b
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/list.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index ceaa381..4433167 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -317,4 +317,45 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
+/**
+ * list_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_reverse_safe(pos, n, head, member)	 \
+	for (pos = list_entry((head)->prev, typeof(*pos), member),	 \
+		 n = list_entry(pos->member.prev, typeof(*pos), member); \
+	     &pos->member != (head);					\
+	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+
+/**
+ * list_for_some_entry	-	iterate list of given interval
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @from:	the begin node of the iteration.
+ * @to:		the end node of the iteration.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_some_entry_safe(pos, n, from, to, member)		 \
+	for (pos = list_entry((from)->next, typeof(*pos), member),	 \
+	     n = list_entry(pos->member.next, typeof(*pos), member); \
+	     &pos->member != (to);					                 \
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+/**
+ * list_for_some_entry_reverse	-	iterate backwards list of given interval
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @from:	the begin node of the iteration.
+ * @to:		the end node of the iteration.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_some_entry_reverse_safe(pos, n, from, to, member) \
+	for (pos = list_entry((from)->prev, typeof(*pos), member),	   \
+	     n = list_entry(pos->member.prev, typeof(*pos), member);   \
+	     &pos->member != (to);					                   \
+	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+
 #endif /* _LIST_H */
-- 
2.8.1.windows.1
