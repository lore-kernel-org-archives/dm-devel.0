From: mwilck@suse.com
Subject: [PATCH v2 82/84] libmultipath: free pp if store_path
	fails in disassemble_map
Date: Wed, 12 Aug 2020 13:35:59 +0200
Message-ID: <20200812113601.26658-3-mwilck@suse.com>
References: <20200812113601.26658-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113601.26658-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Zhiqiang Liu <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

In disassemble_map func, one pp will be allocated and stored in
pgp->paths. However, if store_path fails, pp will not be freed,
then memory leak problem occurs.

Here, we will call free_path to free pp when store_path fails.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 25e6a4a..c103161 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -306,11 +306,15 @@ int disassemble_map(const struct _vector *pathvec,
 					goto out1;
 
 				strlcpy(pp->dev_t, word, BLK_DEV_SIZE);
-			}
-			FREE(word);
 
-			if (store_path(pgp->paths, pp))
-				goto out;
+				if (store_path(pgp->paths, pp)) {
+					free_path(pp);
+					goto out1;
+				}
+			} else if (store_path(pgp->paths, pp))
+				goto out1;
+
+			FREE(word);
 
 			pgp->id ^= (long)pp;
 			pp->pgindex = i + 1;
-- 
2.28.0
