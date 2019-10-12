From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 49/72] libmultipath: vector_for_each_slot: fix
 -Wsign-compare warnings
Date: Sat, 12 Oct 2019 21:28:38 +0000
Message-ID: <20191012212703.12989-50-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/vector.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 344dffd5..e16ec461 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -36,9 +36,9 @@ typedef struct _vector *vector;
 #define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)->slot[(VECTOR_SIZE(V) - 1)] : NULL)
 
 #define vector_foreach_slot(v,p,i) \
-	for (i = 0; (v) && i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
+	for (i = 0; (v) && (int)i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
 #define vector_foreach_slot_after(v,p,i) \
-	for (; (v) && i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
+	for (; (v) && (int)i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]); i++)
 #define vector_foreach_slot_backwards(v,p,i) \
 	for (i = VECTOR_SIZE(v) - 1; (int)i >= 0 && ((p) = (v)->slot[i]); i--)
 
-- 
2.23.0
