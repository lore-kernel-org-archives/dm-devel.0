From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] dm log userspace, fix table status output
Date: Tue, 28 Jul 2009 10:30:11 -0500
Message-ID: <1248795011.25220.2.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

'dmsetup table' is not coming out right.  This patch and the following
patch fix that.

 brassow

The missing ' ' at the end of the status output causes mirror
status output arguments to run together.  Adding the space at
the end makes this log module consistent with the other two
existing log modules, "disk" and "core".

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
 
Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -577,7 +577,7 @@ static int userspace_status(struct dm_di
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		DMEMIT("%s %u %s %s", log->type->name, lc->usr_argc + 1,
+		DMEMIT("%s %u %s %s ", log->type->name, lc->usr_argc + 1,
 		       lc->uuid, lc->usr_argv_str);
 		break;
 	}
