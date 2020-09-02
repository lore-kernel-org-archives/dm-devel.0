From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 10/14] util/tests: use assert_non_null to ensure
 malloc, returns non-null pointer
Date: Wed, 2 Sep 2020 15:22:37 +0800
Message-ID: <a712b9bd-fa57-b723-129d-c6d8a61c8e84@huawei.com>
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

In tests/util.c, we should use assert_non_null to ensure
malloc() returns non-null pointer in both test_strlcpy_5
and test_strlcpy_6 func.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 tests/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/util.c b/tests/util.c
index 16774dff..455eeee5 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -523,6 +523,7 @@ static void test_strlcpy_5(void **state)
 	const int sz = sizeof(src_str);

 	tst = malloc(sz);
+	assert_non_null(tst);
 	memset(tst, 'f', sizeof(src_str));

 	rc = strlcpy(tst, src_str, sz);
@@ -540,6 +541,7 @@ static void test_strlcpy_6(void **state)
 	const int sz = sizeof(src_str);

 	tst = malloc(sz + 2);
+	assert_non_null(tst);
 	memset(tst, 'f', sz + 2);

 	rc = strlcpy(tst, src_str, sz + 2);
-- 
