From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/2] Add missing includes for remember_wwid
Date: Tue, 7 May 2013 17:12:37 -0500
Message-ID: <20130507221237.GT6253@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

My previous commit (0245b3ac6e34dee1ab039bba71806bc35c286ab8) caused a
warning on compile, since it didn't include the wwids.h file in
main.c

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index f02ad16..eb4bc8a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -60,6 +60,7 @@
 #include "cli_handlers.h"
 #include "lock.h"
 #include "waiter.h"
+#include "wwids.h"
 
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
-- 
1.8.2
