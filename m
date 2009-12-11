From: NeilBrown <neilb@suse.de>
Subject: [PATCH libdmraid-events 3/3] Fix minor memory leak in
	lib_main
Date: Fri, 11 Dec 2009 14:22:58 +1100
Message-ID: <20091211032413.811950494@suse.de>
References: <20091211032255.766079509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=memory-leak
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

As lib_argv[3] is set to NULL, there is no point mallocing
some space an putting it there.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 libdmraid-events.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- libdmraid-events.orig/libdmraid-events.c
+++ libdmraid-events/libdmraid-events.c
@@ -209,7 +209,7 @@ static int lib_main(char op, const char*
     int lib_argc=3;
     char *lib_argv[4];
     
-    for(i=0; i<4; i++)
+    for(i=0; i<3; i++)
 		lib_argv[i]=malloc(strlen(device) + 1);
     
     strcpy(lib_argv[0], "dso");
@@ -229,7 +229,7 @@ static int lib_main(char op, const char*
 	libdmraid_exit(lc);
     }
 
-    for(i=0; i<4; i++)
+    for(i=0; i<3; i++)
 		free(lib_argv[i]);        
 
     return ret;
