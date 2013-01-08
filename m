From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/42] libmultipath: prio keyword ignored for
	multipath config
Date: Tue,  8 Jan 2013 14:54:00 +0100
Message-ID: <1357653259-62650-23-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

When specifying the 'prio' keyword in the multipath section
of the configuration file the value is ignored.
Problem is that the 'wwid' value is set only after the call
to select_prio(), so the correct definition couldn't been
found in the config file.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b5df8e3..6848b70 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -891,6 +891,9 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		}
 	}
 
+	if (path_state == PATH_UP && (mask & DI_WWID) && !strlen(pp->wwid))
+		get_uid(pp);
+
 	 /*
 	  * Retrieve path priority, even for PATH_DOWN paths if it has never
 	  * been successfully obtained before.
@@ -905,9 +908,6 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		}
 	}
 
-	if (path_state == PATH_UP && (mask & DI_WWID) && !strlen(pp->wwid))
-		get_uid(pp);
-
 	return 0;
 
 blank:
-- 
1.7.4.2
