From: mwilck@suse.com
Subject: [PATCH 10/11] multipath-tools tests/test-lib.c: drop
	__wrap_is_claimed_by_foreign
Date: Tue, 12 May 2020 00:39:30 +0200
Message-ID: <20200511223931.18261-11-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

is_claimed_by_foreign() is an inline function and can't be wrapped.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/test-lib.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tests/test-lib.c b/tests/test-lib.c
index 59275163..00bae58e 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -56,12 +56,6 @@ int __wrap_execute_program(char *path, char *value, int len)
 	return 0;
 }
 
-bool __wrap_is_claimed_by_foreign(struct udev_device *ud)
-{
-	condlog(5, "%s: %p", __func__, ud);
-	return false;
-}
-
 struct udev_list_entry
 *__wrap_udev_device_get_properties_list_entry(struct udev_device *ud)
 {
-- 
2.26.2
