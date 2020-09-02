From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 08/14] libmultipath: donot free *dst if REALLOC
 fails in, merge_words
Date: Wed, 2 Sep 2020 15:20:29 +0800
Message-ID: <f8ec7113-a9da-46a0-16c8-1e245f9592f0@huawei.com>
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

In merge_words func, if REALLOC() fails, the input *dst will
be freed. If so, mpp->hwhandler| mpp->features|mpp->selector
may be set to NULL after calling merge_words func in
disassemble_map func. This may cause accessing freed memory
problem.

Here, we donot free *dst if REALLOC() fails in merge_words func.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/dmparser.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index c1031616..482e9d0e 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -26,13 +26,12 @@ merge_words(char **dst, const char *word)

 	dstlen = strlen(*dst);
 	len = dstlen + strlen(word) + 2;
-	*dst = REALLOC(*dst, len);
+	p = REALLOC(*dst, len);

-	if (!*dst) {
-		free(p);
+	if (!p)
 		return 1;
-	}

+	*dst = p;
 	p = *dst + dstlen;
 	*p = ' ';
 	++p;
-- 
