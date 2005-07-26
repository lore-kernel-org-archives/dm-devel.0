From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: log issues
Date: Tue, 26 Jul 2005 15:57:41 -0500
Message-ID: <20050726205741.GC32327@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
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


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There are two log issues that I uncovered. #1 If the log is emptied when the
tail points to the very end of the log area, and the next message needs
to roll over to the start, it doesn't pull the head around too, so the head
is pointing at an empty message, causing you to print a priority 0 message
of nothing. #2 It is possible for the log to be totally full, and on the
next enqueue, have the log tail point to the log head, which causes the entire
existing log to be lost.

This patch fixes both.

-Ben Marzinski


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="log.patch"

diff -urpN mp-devel/multipathd/log.c mp-devel-patched/multipathd/log.c
--- mp-devel/multipathd/log.c	2005-07-12 11:02:17.000000000 -0500
+++ mp-devel-patched/multipathd/log.c	2005-07-26 15:44:21.588859336 -0500
@@ -108,18 +108,18 @@ int log_enqueue (int prio, const char * 
 		la->tail += ALIGN(fwd, sizeof(void *));
 	}
 	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
-	len = ALIGN(strlen(buff) * sizeof(char) + 1, sizeof(void *));
-
+	len = ALIGN(sizeof(struct logmsg) + strlen(buff) * sizeof(char) + 1,
+		    sizeof(void *));
 	/* not enough space on tail : rewind */
-	if (la->head <= la->tail &&
-	    (len + sizeof(struct logmsg)) > (la->end - la->tail)) {
+	if (la->head <= la->tail && len > (la->end - la->tail)) {
 		logdbg(stderr, "enqueue: rewind tail to %p\n", la->tail);
 		la->tail = la->start;
+		if (la->empty)
+			la->head = la->start;
 	}
 
 	/* not enough space on head : drop msg */
-	if (la->head > la->tail &&
-	    (len + sizeof(struct logmsg)) > (la->head - la->tail)) {
+	if (la->head > la->tail && len >= (la->head - la->tail)) {
 		logdbg(stderr, "enqueue: log area overrun, drop msg\n");
 
 		if (!la->empty)
@@ -153,7 +153,7 @@ int log_dequeue (void * buff)
 
 	if (la->empty)
 		return 1;
-	
+
 	int len = strlen((char *)&src->str) * sizeof(char) +
 		  sizeof(struct logmsg) + 1;
 

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--1yeeQ81UyVL57Vl7--
