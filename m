From: mwilck@suse.com
Subject: [PATCH 03/35] tests: __wrap_dlog: use check_expected()
Date: Thu,  9 Jul 2020 12:15:48 +0200
Message-ID: <20200709101620.6786-4-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

For function parameters, cmocka's check_expected() API should be used
rather than will_return() / mock_type().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/test-log.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/test-log.c b/tests/test-log.c
index d685d58..051491e 100644
--- a/tests/test-log.c
+++ b/tests/test-log.c
@@ -12,7 +12,7 @@ void __wrap_dlog (int sink, int prio, const char * fmt, ...)
 	char buff[MAX_MSG_SIZE];
 	va_list ap;
 
-	assert_int_equal(prio, mock_type(int));
+	check_expected(prio);
 	va_start(ap, fmt);
 	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
 	va_end(ap);
@@ -21,7 +21,6 @@ void __wrap_dlog (int sink, int prio, const char * fmt, ...)
 
 void expect_condlog(int prio, char *string)
 {
-	will_return(__wrap_dlog, prio);
+	expect_value(__wrap_dlog, prio, prio);
 	will_return(__wrap_dlog, string);
 }
-
-- 
2.26.2
