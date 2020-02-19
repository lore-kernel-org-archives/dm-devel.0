From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 02/18] multipathd: staticify uxlsnr
	variables/functions
Date: Wed, 19 Feb 2020 00:48:24 -0600
Message-ID: <1582094920-9883-3-git-send-email-bmarzins@redhat.com>
References: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582094920-9883-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/uxlsnr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 020d7a9b..1c5ce9d2 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -40,7 +40,7 @@
 #include "cli.h"
 #include "uxlsnr.h"
 
-struct timespec sleep_time = {5, 0};
+static struct timespec sleep_time = {5, 0};
 
 struct client {
 	struct list_head node;
@@ -49,9 +49,9 @@ struct client {
 
 #define MIN_POLLS 1023
 
-LIST_HEAD(clients);
-pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
-struct pollfd *polls;
+static LIST_HEAD(clients);
+static pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
+static struct pollfd *polls;
 static int notify_fd = -1;
 static char *watch_config_dir;
 
@@ -122,13 +122,13 @@ static void dead_client(struct client *c)
 	pthread_cleanup_pop(1);
 }
 
-void free_polls (void)
+static void free_polls (void)
 {
 	if (polls)
 		FREE(polls);
 }
 
-void check_timeout(struct timespec start_time, char *inbuf,
+static void check_timeout(struct timespec start_time, char *inbuf,
 		   unsigned int timeout)
 {
 	struct timespec diff_time, end_time;
-- 
2.17.2
