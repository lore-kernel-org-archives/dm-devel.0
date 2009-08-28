From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] dm log userspace status fix 2
Date: Fri, 28 Aug 2009 00:34:54 -0500
Message-ID: <1251437694.16038.10.camel@hydrogen.msp.redhat.com>
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

The output of 'dmsetup table' includes an internal
field that should not be there.  This patch removes it.

We keep a copy of the arguments passed to userspace for
creating a log, just in case we need to resend them.  These
are the same arguments that are desired in the
STATUSTYPE_TABLE request, except for one.  When creating
the userspace log, the userspace daemon must know the size
of the mirror, so that is added to the arguments given
in the constructor table.  We were printing this extra
argument out as well, which is a mistake.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -560,6 +560,7 @@ static int userspace_status(struct dm_di
 			    char *result, unsigned maxlen)
 {
 	int r = 0;
+	char *table_args;
 	size_t sz = (size_t)maxlen;
 	struct log_c *lc = log->context;
 
@@ -576,8 +577,12 @@ static int userspace_status(struct dm_di
 		break;
 	case STATUSTYPE_TABLE:
 		sz = 0;
-		DMEMIT("%s %u %s %s ", log->type->name, lc->usr_argc + 1,
-		       lc->uuid, lc->usr_argv_str);
+		table_args = strstr(lc->usr_argv_str, " ");
+		BUG_ON(!table_args); /* There will always be a ' ' */
+		table_args++;
+
+		DMEMIT("%s %u %s %s ", log->type->name, lc->usr_argc,
+		       lc->uuid, table_args);
 		break;
 	}
 	return (r) ? 0 : (int)sz;
