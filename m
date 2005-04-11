From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: patch for log_enqueue in multipath-tools-0.4.4-pre11
Date: Mon, 11 Apr 2005 15:59:50 -0500
Message-ID: <20050411205950.GA4999@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It looks to me like log_enqueue can accidentally mess up its la->tail ptr,
if it runs out of space for the new message.

If the la->head is just past la->start, and la->tail is just before la->end,
la->tail will get updated to be la->start, because there is no room at the
end of the buffer for the message.  Then when it realizes that there is no
room at the start of the buffer, la->tail will be updated to la->start - fwd
And the next message will be written before the buffer.

This patch fixes that.

-Ben
Ben Marzinski
bmarzins@redhat.com
(612) 638-0517

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log_enqueue.patch"

diff -urN multipath-tools-0.4.4-pre11/multipathd/log.c multipath-tools-0.4.4-log-fixed/multipathd/log.c
--- multipath-tools-0.4.4-pre11/multipathd/log.c	2005-03-31 03:25:06.000000000 -0600
+++ multipath-tools-0.4.4-log-fixed/multipathd/log.c	2005-04-11 14:27:41.000000000 -0500
@@ -119,7 +119,7 @@
 		logdbg(stderr, "enqueue: log area overrun, drop msg\n");
 
 		if (!la->empty)
-			la->tail -= fwd;
+			la->tail = lastmsg;
 
 		return 1;
 	}

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--G4iJoqBmSsgzjUCe--
