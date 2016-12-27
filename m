From: tang.junhui@zte.com.cn
Subject: [PATCH 03/12] libmultipath: add two list iteration macros
Date: Tue, 27 Dec 2016 16:03:20 +0800
Message-ID: <1482825809-9528-4-git-send-email-tang.junhui@zte.com.cn>
References: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1482825809-9528-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, hare@suse.de, bmarzins@redhat.com, mwilck@suse.com, bart.vanassche@sandisk.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn, tang.wenjun3@zte.com.cn
List-Id: dm-devel.ids

From: tang.junhui <tang.junhui@zte.com.cn>

Add two list iteration macros, they are used to iterate list forwards
or backwards from the given begin node to the given end node, which
would be used in merging uevents.

Change-Id: I8bb53fef9276bb62a5e0f4fdac6455086dc03d9b
Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 libmultipath/list.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index ceaa381..e728ff0 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -294,6 +294,18 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
 
 /**
+ * list_for_some_entry	-	iterate list of given interval
+ * @pos:	the type * to use as a loop counter.
+ * @from:	the begin node of the iteration.
+ * @to:		the end node of the iteration.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_some_entry(pos, from, to, member)				\
+	for (pos = list_entry((from)->next, typeof(*pos), member);	\
+	     &pos->member != (to);					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))
+
+/**
  * list_for_each_entry_reverse - iterate backwards over list of given type.
  * @pos:	the type * to use as a loop counter.
  * @head:	the head for your list.
@@ -305,6 +317,18 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
+ * list_for_some_entry_reverse	-	iterate backwards list of given interval
+ * @pos:	the type * to use as a loop counter.
+ * @from:	the begin node of the iteration.
+ * @to:		the end node of the iteration.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_some_entry_reverse(pos, from, to, member)			\
+	for (pos = list_entry((from)->prev, typeof(*pos), member);	\
+	     &pos->member != (to);					\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+
+/**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
  * @pos:	the type * to use as a loop counter.
  * @n:		another type * to use as temporary storage
-- 
2.8.1.windows.1
