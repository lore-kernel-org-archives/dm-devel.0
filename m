From: tang.junhui@zte.com.cn
Subject: [PATCH] multipathd: fix memory allocation logic error
	for polls in uxsock_listen()
Date: Wed, 10 Aug 2016 17:32:40 +0800
Message-ID: <1470821560-10864-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

logic error exists in memory allocation for polls in uxsock_listen(), even if the allocated memory size meet the needs, it is still to realloc memory, which is not up to expectations.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 multipathd/uxlsnr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index f114e59..fa29b2a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -145,7 +145,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
 	condlog(3, "uxsock: startup listener");
-	polls = (struct pollfd *)MALLOC(MIN_POLLS + 1);
+	polls = (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollfd));
 	if (!polls) {
 		condlog(0, "uxsock: failed to allocate poll fds");
 		return NULL;
@@ -167,9 +167,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		}
 		if (num_clients != old_clients) {
 			struct pollfd *new;
-			if (num_clients < MIN_POLLS) {
+			if (num_clients <= MIN_POLLS && old_clients > MIN_POLLS) {
 				new = REALLOC(polls, (1 + MIN_POLLS) *
 						sizeof(struct pollfd));
+			} else if (num_clients <= MIN_POLLS && old_clients <= MIN_POLLS) {
+				new = polls;
 			} else {
 				new = REALLOC(polls, (1+num_clients) *
 						sizeof(struct pollfd));
@@ -181,7 +183,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				pthread_yield();
 				continue;
 			}
-			num_clients = old_clients;
+			old_clients = num_clients;
 			polls = new;
 		}
 		polls[0].fd = ux_sock;
-- 
2.8.1.windows.1
