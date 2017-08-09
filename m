From: Gris Ge <fge@redhat.com>
Subject: [PATCH V2] multipathd daemon: Fix incorrect use of
	CLOCK_MONOTONIC in pthread
Date: Thu, 10 Aug 2017 00:21:26 +0800
Message-ID: <20170809162126.7831-1-fge@redhat.com>
References: <20170809132214.3081-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809132214.3081-1-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Issue:
    When multipathd is starting up, it will reply "timeout\n" immediatly
    when got any IPC command from socket. The expected way is to wait
    uxsock_timeout/1000 seconds.

Root cause:
    pthread_mutex_timedlock() is expecting a CLOCK_REALTIME time.

Fix:
    Use CLOCK_REALTIME for pthread_mutex_timedlock().

Signed-off-by: Gris Ge <fge@redhat.com>
---
 multipathd/cli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 32d49766..002abe61 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -475,7 +475,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 	/*
 	 * execute handler
 	 */
-	if (clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
+	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
 		tmo.tv_sec += timeout;
 	} else {
 		tmo.tv_sec = 0;
-- 
2.14.0
