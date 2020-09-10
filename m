From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V4 02/14] libmultipath: change malloc to calloc
 in print_foreign_topology
Date: Thu, 10 Sep 2020 18:47:34 +0800
Message-ID: <e7fd9cde-bb39-4fe4-65bd-17d0997c840e@huawei.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel
	mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

We chanege malloc to calloc.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/foreign.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index e8f61351..fce19347 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -544,8 +544,8 @@ void print_foreign_topology(int verbosity)
 	int buflen = MAX_LINE_LEN * MAX_LINES;
 	char *buf = NULL, *tmp = NULL;

-	buf = malloc(buflen);
-	buf[0] = '\0';
+	buf = calloc(1, buflen);
+
 	while (buf != NULL) {
 		char *c = buf;

-- 
