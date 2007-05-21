From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/21] [libmultipath] Fix overflow in circular
	queue
Date: Mon, 21 May 2007 11:23:25 +0200
Message-ID: <20070521092325.DB7E2D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Multipathd has a circular buffer where messages are stored prior to being
passed into the system logs. Under certain circumstances the circular buffer
fills up; and the intention appears to be that new messages are dropped until
space is freed in the buffer.

However sometimes the result of a full circular buffer is to overwrite the
earlier messages before they have been passed to the system buffer; resulting
in the loss of early messages and corruption of later messages.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/log.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/libmultipath/log.c b/libmultipath/log.c
index 8b339d7..90e4d1f 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -118,6 +118,11 @@ int log_enqueue (int prio, const char *
 	/* not enough space on tail : rewind */
 	if (la->head <= la->tail && len > (la->end - la->tail)) {
 		logdbg(stderr, "enqueue: rewind tail to %p\n", la->tail);
+                if (la->head == la->start ) {
+                        logdbg(stderr, "enqueue: can not rewind tail, drop msg\n");
+                        la->tail = lastmsg;
+                        return 1;  /* can't reuse */
+                }
 		la->tail = la->start;
 
 		if (la->empty)
-- 
1.4.3.4
