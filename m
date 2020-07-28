From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] libmultipath: fix a memory leak in
 disassemble_status func
Date: Tue, 28 Jul 2020 21:48:06 +0800
Message-ID: <9bc76686-747f-e85b-d25f-db5a056cf869@huawei.com>
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
To: mwilck@suse.com, bmarzins@redhat.com, christophe.varoqui@opensvc.com, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong@huawei.com, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


In disassemble_status func, for dealing with selector args,
word is allocated by get_word func. However, word is not freed.
Then a memory leak occurs.

Here, we call FREE(word) to free word.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/dmparser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 3dc77242..a4a989b2 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -584,6 +584,7 @@ int disassemble_status(char *params, struct multipath *mpp)
 						   &def_minio) == 1 &&
 					    def_minio != mpp->minio)
 							mpp->minio = def_minio;
+					FREE(word);
 				} else
 					p += get_word(p, NULL);
 			}
-- 
2.24.0.windows.2
