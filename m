From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/11] Cleanup whitespaces
Date: Thu, 17 Jan 2013 15:59:23 +0100
Message-ID: <1358434773-2002-2-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/uxlsnr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 85dbd70..71fc3b4 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -1,6 +1,6 @@
 /*
  * Original author : tridge@samba.org, January 2002
- * 
+ *
  * Copyright (c) 2005 Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  */
@@ -54,7 +54,7 @@ static void new_client(int ux_sock)
 	int fd;
 
 	fd = accept(ux_sock, &addr, &len);
-	
+
 	if (fd == -1)
 		return;
 
@@ -133,7 +133,7 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 
 		/* most of our life is spent in this call */
 		poll_count = poll(polls, i, SLEEP_TIME);
-		
+
 		if (poll_count == -1) {
 			if (errno == EINTR)
 				continue;
-- 
1.7.10.4
