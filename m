From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath dict.c
Date: 10 Oct 2011 04:18:38 -0000
Message-ID: <20111010041838.5573.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-10-10 04:18:38

Modified files:
	libmultipath   : dict.c 

Log message:
	Fix for bz #716329
	
	Don't accept a file_timeout of 0. Not applicable upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.20&r2=1.17.2.21

--- multipath-tools/libmultipath/dict.c	2011/10/10 04:15:41	1.17.2.20
+++ multipath-tools/libmultipath/dict.c	2011/10/10 04:18:38	1.17.2.21
@@ -92,7 +92,7 @@
 	if (!buff)
 		return 1;
 	conf->file_timeout = atoi(buff);
-	if (conf->file_timeout < 0)
+	if (conf->file_timeout <= 0)
 		 conf->file_timeout = DEFAULT_FILE_TIMEOUT;
 
 	FREE(buff);
