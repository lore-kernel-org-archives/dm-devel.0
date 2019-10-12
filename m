From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 63/72] multipath tests: fix -Wformat-literal
	warning
Date: Sat, 12 Oct 2019 21:28:56 +0000
Message-ID: <20191012212703.12989-64-martin.wilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/test-log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/test-log.c b/tests/test-log.c
index 76a266eb..d685d582 100644
--- a/tests/test-log.c
+++ b/tests/test-log.c
@@ -6,6 +6,7 @@
 #include "log.h"
 #include "test-log.h"
 
+__attribute__((format(printf, 3, 0)))
 void __wrap_dlog (int sink, int prio, const char * fmt, ...)
 {
 	char buff[MAX_MSG_SIZE];
-- 
2.23.0
