From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH v3 1/6] list: Don't use WRITE_ONCE() in hlist_add_behind()
Date: Sun, 17 Mar 2019 14:22:53 +0200
Message-ID: <20190317122258.21760-2-ntsironis@arrikto.com>
References: <20190317122258.21760-1-ntsironis@arrikto.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317122258.21760-1-ntsironis@arrikto.com>
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: mpatocka@redhat.com, paulmck@linux.ibm.com, hch@infradead.org, iliastsi@arrikto.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Commit 1c97be677f72b3 ("list: Use WRITE_ONCE() when adding to lists and
hlists") introduced the use of WRITE_ONCE() to atomically write the list
head's ->next pointer.

hlist_add_behind() doesn't touch the hlist head's ->first pointer so
there is no reason to use WRITE_ONCE() in this case.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
---
 include/linux/list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index edb7628e46ed..b68d2a85859b 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -743,7 +743,7 @@ static inline void hlist_add_behind(struct hlist_node *n,
 				    struct hlist_node *prev)
 {
 	n->next = prev->next;
-	WRITE_ONCE(prev->next, n);
+	prev->next = n;
 	n->pprev = &prev->next;
 
 	if (n->next)
-- 
2.11.0
