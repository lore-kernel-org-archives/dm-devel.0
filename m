From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/6] tests/uevent: fix -Wcast-qual errors
Date: Tue,  6 Mar 2018 23:56:28 +0100
Message-ID: <20180306225633.12028-2-mwilck@suse.com>
References: <20180306225633.12028-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306225633.12028-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

I overlooked these in my previous series of fixes.

Fixes: "libmultipath: fix compiler warnings for -Wcast-qual"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/uevent.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/uevent.c b/tests/uevent.c
index b7d6458710f4..0836b08d5b50 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -172,7 +172,7 @@ static void test_dm_name_good(void **state)
 	const char *name = uevent_get_dm_name(uev);
 
 	assert_string_equal(name, DM_NAME);
-	free((void*)name);
+	FREE_CONST(name);
 }
 
 static void test_dm_name_bad_0(void **state)
@@ -183,7 +183,7 @@ static void test_dm_name_bad_0(void **state)
 	uev->envp[3] = "DM_NAME" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_ptr_equal(name, NULL);
-	free((void*)name);
+	FREE_CONST(name);
 }
 
 static void test_dm_name_bad_1(void **state)
@@ -194,7 +194,7 @@ static void test_dm_name_bad_1(void **state)
 	uev->envp[3] = "DM_NAMES=" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_ptr_equal(name, NULL);
-	free((void*)name);
+	FREE_CONST(name);
 }
 
 static void test_dm_name_good_1(void **state)
@@ -206,7 +206,7 @@ static void test_dm_name_good_1(void **state)
 	uev->envp[2] = "DM_NAME=" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_string_equal(name, DM_NAME);
-	free((void*)name);
+	FREE_CONST(name);
 }
 
 static void test_dm_uuid_false_0(void **state)
-- 
2.16.1
