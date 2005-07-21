From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: uxlsnr patch
Date: Thu, 21 Jul 2005 10:55:14 -0500
Message-ID: <20050721155514.GA4864@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Two little issues. Multipathd was shutting down whenever I tried to start
up gdb monitoring on it, because uxlsnr code didn't like getting a signal.
Also, having a lot of overlapping calls to the uxlsnr code caused really
bad things to happen because of a linked list oversight.

This patch corrects both.

-Ben

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="uxlsnr.patch"

diff -urpN mp-devel/multipathd/uxlsnr.c mp-devel-patched/multipathd/uxlsnr.c
--- mp-devel/multipathd/uxlsnr.c	2005-07-12 11:02:18.000000000 -0500
+++ mp-devel-patched/multipathd/uxlsnr.c	2005-07-21 10:46:08.497378920 -0500
@@ -51,6 +51,7 @@ static void new_client(int ux_sock)
 	memset(c, 0, sizeof(*c));
 	c->fd = fd;
 	c->next = clients;
+	if (c->next) c->next->prev = c;
 	clients = c;
 	num_clients++;
 }
@@ -112,6 +113,8 @@ void * uxsock_listen(char * (*uxsock_tri
 		poll_count = poll(polls, i, SLEEP_TIME);
 		
 		if (poll_count == -1) {
+			if (errno == EINTR)
+				continue;
 			/* something went badly wrong! */
 			condlog(0, "poll");
 			exit(1);

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--rwEMma7ioTxnRzrJ--
