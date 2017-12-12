From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/3] Allow the compiler to verify the consistency
	of the uxsock_timeout definition and declaration
Date: Mon, 11 Dec 2017 16:45:02 -0800
Message-ID: <20171212004503.12823-3-bart.vanassche@wdc.com>
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

Global variables should be defined after the header file with
their declaration has been included. Hence move the declaration
of usock_timeout further down.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 multipathd/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 31ce923385a7..d611597a4ef8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -39,8 +39,6 @@
 static int use_watchdog;
 #endif
 
-int uxsock_timeout;
-
 /*
  * libmultipath
  */
@@ -106,6 +104,7 @@ struct mpath_event_param
 };
 
 int logsink;
+int uxsock_timeout;
 int verbosity;
 int bindings_read_only;
 int ignore_new_devs;
-- 
2.15.1
