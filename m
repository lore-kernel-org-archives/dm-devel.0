From: Gris Ge <fge@redhat.com>
Subject: [PATCH 1/4] multipathd daemon: Fix incorrect use of
	CLOCK_MONOTONIC in pthread
Date: Tue, 21 Nov 2017 22:09:14 +0800
Message-ID: <20171121140917.18298-2-fge@redhat.com>
References: <20171121140917.18298-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171121140917.18298-1-fge@redhat.com>
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
index deb72cbe..f10f862c 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -480,7 +480,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 	/*
 	 * execute handler
 	 */
-	if (clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
+	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
 		tmo.tv_sec += timeout;
 	} else {
 		tmo.tv_sec = 0;
-- 
2.15.0
