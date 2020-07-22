From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] libmultipath: free pp if store_path fails in
 disassemble_map
Date: Wed, 22 Jul 2020 16:41:28 +0800
Message-ID: <b1cccadd-955e-0341-879f-01659a04dbb4@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: mwilck@suse.com, Benjamin Marzinski <bmarzins@redhat.com>, christophe.varoqui@opensvc.com, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong@huawei.com, yanxiaodan@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

In disassemble_map func, one pp will be allocated and stored in pathvec
(only in client mode) and pgp->paths. However, if store_path fails, pp
will not be freed, then memory leak problem occurs.

Here, we will call free_path to free pp when store_path fails.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/dmparser.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 6225838b..3dc77242 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -142,6 +142,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 	int def_minio = 0;
 	struct path * pp;
 	struct pathgroup * pgp;
+	int pp_need_free_flag = 0;

 	p = params;

@@ -293,6 +294,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 			char devname[FILE_NAME_SIZE];

 			pp = NULL;
+			pp_need_free_flag = 0;
 			p += get_word(p, &word);

 			if (!word)
@@ -323,9 +325,15 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 					strncpy(pp->wwid, mpp->wwid,
 						WWID_SIZE - 1);
 				}
+
+				if (is_daemon)
+					pp_need_free_flag = 1;
+
 				/* Only call this in multipath client mode */
-				if (!is_daemon && store_path(pathvec, pp))
+				if (!is_daemon && store_path(pathvec, pp)) {
+					free_path(pp);
 					goto out1;
+				}
 			} else {
 				if (!strlen(pp->wwid) &&
 				    strlen(mpp->wwid))
@@ -334,8 +342,11 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 			}
 			FREE(word);

-			if (store_path(pgp->paths, pp))
+			if (store_path(pgp->paths, pp)) {
+				if (pp_need_free_flag)
+					free_path(pp);
 				goto out;
+			}

 			/*
 			 * Update wwid for multipaths which are not setup
-- 
2.24.0.windows.2
