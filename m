From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/5] multipath-tools: Log all messages
Date: Mon, 3 Aug 2009 17:00:03 -0500
Message-ID: <20090803220003.GS15326@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

When the log thread pulls the last message off the buffer, it sets
la->empty.  However, then it returns la->empty, which means that the log is
empty, instead of 0, which means that it found a message.  This means that
multipathd is not logging the last message in the buffer when the log threa
runs. This patch changes the return code, so that multipathd logs all the
messages in the buffer.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools/libmultipath/log.c
===================================================================
--- multipath-tools.orig/libmultipath/log.c
+++ multipath-tools/libmultipath/log.c
@@ -181,7 +181,7 @@ int log_dequeue (void * buff)
 
 	memset((void *)src, 0,  len);
 
-	return la->empty;
+	return 0;
 }
 
 /*
