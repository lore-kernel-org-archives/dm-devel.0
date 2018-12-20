From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 1/3] list_bl: Add hlist_bl_add_before/behind
	helpers
Date: Thu, 20 Dec 2018 20:06:49 +0200
Message-ID: <20181220180651.4879-2-ntsironis@arrikto.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181220180651.4879-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: mpatocka@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

Add hlist_bl_add_before/behind helpers to add an element before/after an
existing element in a bl_list.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 include/linux/list_bl.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 3fc2cc57ba1b..2fd918e5fd48 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -86,6 +86,33 @@ static inline void hlist_bl_add_head(struct hlist_bl_node *n,
 	hlist_bl_set_first(h, n);
 }
 
+static inline void hlist_bl_add_before(struct hlist_bl_node *n,
+				       struct hlist_bl_node *next)
+{
+	struct hlist_bl_node **pprev = next->pprev;
+
+	n->pprev = pprev;
+	n->next = next;
+	next->pprev = &n->next;
+
+	/* pprev may be `first`, so be careful not to lose the lock bit */
+	WRITE_ONCE(*pprev,
+		   (struct hlist_bl_node *)
+			((unsigned long)n |
+			 ((unsigned long)*pprev & LIST_BL_LOCKMASK)));
+}
+
+static inline void hlist_bl_add_behind(struct hlist_bl_node *n,
+				       struct hlist_bl_node *prev)
+{
+	n->next = prev->next;
+	n->pprev = &prev->next;
+	WRITE_ONCE(prev->next, n);
+
+	if (n->next)
+		n->next->pprev = &n->next;
+}
+
 static inline void __hlist_bl_del(struct hlist_bl_node *n)
 {
 	struct hlist_bl_node *next = n->next;
-- 
2.11.0
