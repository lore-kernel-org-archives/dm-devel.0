From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/3] multipathd/cli.h: Add a header file guard
Date: Mon, 11 Dec 2017 16:45:03 -0800
Message-ID: <20171212004503.12823-4-bart.vanassche@wdc.com>
References: <20171212004503.12823-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171212004503.12823-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch avoids that compilation breaks if the multipathd/cli.h
header file is included multiple times from the same compilation unit.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 multipathd/cli.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipathd/cli.h b/multipathd/cli.h
index d289167e20ff..021f25b7085a 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -1,3 +1,6 @@
+#ifndef _CLI_H_
+#define _CLI_H_
+
 #include <stdint.h>
 
 enum {
@@ -126,3 +129,5 @@ void free_handlers (void);
 int cli_init (void);
 void cli_exit(void);
 char * key_generator (const char * str, int state);
+
+#endif /* _CLI_H_ */
-- 
2.15.1
