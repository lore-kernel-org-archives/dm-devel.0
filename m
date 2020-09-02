From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 02/14] libmultipath: check malloc return value in,
 print_foreign_topology
Date: Wed, 2 Sep 2020 15:16:43 +0800
Message-ID: <a89192b4-f330-6a18-e4d7-e18305b1e66a@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

We check the return value of malloc in print_foreign_topology.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/foreign.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index e8f61351..44f32d03 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -545,6 +545,10 @@ void print_foreign_topology(int verbosity)
 	char *buf = NULL, *tmp = NULL;

 	buf = malloc(buflen);
+	if (!buf) {
+		condlog (0, "malloc buf failed.");
+		return;
+	}
 	buf[0] = '\0';
 	while (buf != NULL) {
 		char *c = buf;
--
