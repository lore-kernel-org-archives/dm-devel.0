From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] multipath_tools: add alias while printing
	checker_message
Date: Tue, 13 Apr 2010 09:21:12 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF48D088D7E@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch adds alias while printing checker messages. 
Example of current Checker message. 

Apr 11 04:03:53 mymachine multipathd: sde: rdac checker reports path is down

Most of the time "sde" is meaningless when debugging the past failures. 

This patch add alias before the checker message..  
Example of the new message..

Apr 12 16:55:54 mymachine multipathd: mpathb: sde - rdac checker reports path is down

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <Vijay.Chauhan@lsi.com>

---
--- multipath-tools/multipathd/main.c.orig	2010-04-12 13:58:27.000000000 -0500
+++ multipath-tools/multipathd/main.c	2010-04-12 14:01:08.000000000 -0500
@@ -61,7 +61,7 @@
 #define CMDSIZE 160
 
 #define LOG_MSG(a,b) \
-	if (strlen(b)) condlog(a, "%s: %s", pp->dev, b);
+	if (strlen(b)) condlog(a, "%s: %s - %s", pp->mpp->alias, pp->dev, b);
 
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
