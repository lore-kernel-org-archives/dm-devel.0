From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] dm log userspace, fix table status output
Date: Tue, 28 Jul 2009 10:41:04 -0500
Message-ID: <1248795664.25220.5.camel@hydrogen.msp.redhat.com>
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

This patch fixes up the arguments that get printed when a
STATUSTYPE_TABLE request is issued.

We keep a copy of the arguments passed to userspace for
creating a log, just in case we need to resend them.  These
are the same arguments that are desired in the
STATUSTYPE_TABLE request, except for one.  When creating
the userspace log, the userspace daemon must know the size
of the mirror, so that is appended onto the arguments given
in the constructor table.  We were printing this extra
argument out as well, which is a mistake.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -561,6 +561,7 @@ static int userspace_status(struct dm_di
 			    char *result, unsigned maxlen)
 {
 	int r = 0;
+	char *index;
 	size_t sz = (size_t)maxlen;
 	struct log_c *lc = log->context;
 
@@ -577,8 +578,25 @@ static int userspace_status(struct dm_di
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		DMEMIT("%s %u %s %s ", log->type->name, lc->usr_argc + 1,
-		       lc->uuid, lc->usr_argv_str);
+		DMEMIT("%s %u %s ", log->type->name, lc->usr_argc, lc->uuid);
+
+		/*
+		 * The usr_argv that we keep has an extra 'mirror device
+		 * length' field appended to the original given arguments.
+		 * We should not include that field in our output.
+		 */
+		index = strrchr(lc->usr_argv_str, ' ');
+		BUG_ON(!index); /* There will always be a ' ' */
+		index += 2;  /* I want the space and 1 more for NULL */
+
+		/*
+		 * Make DMEMIT behave the way we want.  Only allow
+		 * the amount of the string we need plus what has
+		 * already been written (if there is sufficient space).
+		 */
+		if (maxlen > (index - lc->usr_argv_str + sz))
+			maxlen = index - lc->usr_argv_str + sz;
+		DMEMIT("%s ", lc->usr_argv_str);
 		break;
 	}
 	return (r) ? 0 : (int)sz;
