From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH v3 2/6] list_bl: Add hlist_bl_add_before/behind helpers
Date: Sun, 17 Mar 2019 14:22:54 +0200
Message-ID: <20190317122258.21760-3-ntsironis@arrikto.com>
References: <20190317122258.21760-1-ntsironis@arrikto.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317122258.21760-1-ntsironis@arrikto.com>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: mpatocka@redhat.com, paulmck@linux.ibm.com, hch@infradead.org, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Add hlist_bl_add_before/behind helpers to add an element before/after an
existing element in a bl_list.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 include/linux/list_bl.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 3fc2cc57ba1b..ae1b541446c9 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -86,6 +86,32 @@ static inline void hlist_bl_add_head(struct hlist_bl_node *n,
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
+			((uintptr_t)n | ((uintptr_t)*pprev & LIST_BL_LOCKMASK)));
+}
+
+static inline void hlist_bl_add_behind(struct hlist_bl_node *n,
+				       struct hlist_bl_node *prev)
+{
+	n->next = prev->next;
+	n->pprev = &prev->next;
+	prev->next = n;
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
