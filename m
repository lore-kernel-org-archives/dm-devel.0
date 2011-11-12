From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: don't print so many add map messages
Date: Fri, 11 Nov 2011 23:12:49 -0600
Message-ID: <20111112051249.GF24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Whenever a dm device gets a change uevent, multipathd prints an add map
message.  This can get confusing for users, so change that message to
not print at the default log level, and add a new message that only
prints if multipathd will actually try to add a map

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: multipath-tools-111111/multipathd/main.c
===================================================================
--- multipath-tools-111111.orig/multipathd/main.c
+++ multipath-tools-111111/multipathd/main.c
@@ -232,7 +232,7 @@ uev_add_map (struct uevent * uev, struct
 	char *alias;
 	int major = -1, minor = -1, rc;
 
-	condlog(2, "%s: add map (uevent)", uev->kernel);
+	condlog(3, "%s: add map (uevent)", uev->kernel);
 	alias = uevent_get_dm_name(uev);
 	if (!alias) {
 		condlog(3, "%s: No DM_NAME in uevent", uev->kernel);
@@ -280,6 +280,7 @@ ev_add_map (char * dev, char * alias, st
 		}
 		return 0;
 	}
+	condlog(2, "%s: adding map", alias);
 
 	/*
 	 * now we can register the map
