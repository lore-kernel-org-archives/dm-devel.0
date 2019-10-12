From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 14/72] multipath tests: use -lpthread for alias
	test
Date: Sat, 12 Oct 2019 21:27:54 +0000
Message-ID: <20191012212703.12989-15-martin.wilck@suse.com>
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

This becomes necessary because of the previous patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/Makefile b/tests/Makefile
index 0ce318c6..0dce8571 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -29,6 +29,7 @@ blacklist-test_LIBDEPS := -ludev
 vpd-test_OBJDEPS :=  ../libmultipath/discovery.o
 vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
+alias-test_LIBDEPS := -lpthread -ldl
 
 lib/libchecktur.so:
 	mkdir lib
-- 
2.23.0
