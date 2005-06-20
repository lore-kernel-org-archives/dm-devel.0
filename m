From: "goggin, edward" <egoggin@emc.com>
Subject: an unintentionally blacklisted LU and a multipathd
	SIGSEGV in 0.4 .5-pre3
Date: Mon, 20 Jun 2005 10:58:35 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AAD3@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Alasdair G Kergon' <agk@redhat.com>, 'Lars Marowsky-Bree' <lmb@suse.de>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Found an annoying problem last week with multipath-tools-0.4.5-pre3 that was
consistently terminating my multipathd and unbeknownst to me, excluding one
of my SCSI LUs from receiving multipathing services.

First, an LU with a scsi_id assigned UID of
36006016087711200afd8d0905137d911
was being blacklisted because the default blacklist includes a regular
expression
of the form "(ram | raw | loop | fd)[0-9]*" which happens to match the
substring "fd8"
in the UID.  I've fixed the problem by changing the blacklist regular
expression
to instead be "^(ram | raw | loop | fd)[0-9]*" since the intention is really
to exclude
devices from multipath discovery only when their name __begins__ with any of
the
prefixes within the parenthesis.  Turns out "fd" is the  only one of these
listed
prefixes which contains exclusively valid alpha-hexa-numeric characters.
The "fd"
Characters should not mistakenly collide with hexa-numeric characters at the
beginning of at least a scsi_id assigned block device UID since scsi_id is
assigning either an alpha 0, 1, 2, or 3 to the first character of the UID
string.

This problem is likely in all versions of multipath-tools since 0.4.4-pre7
when the
use of both regcomp and regexec were first introduced.

Second, the multipathd in version 0.4.5-pre3 of multipath-tools will SIGSEGV
whenever it dereferences a null mpp field of a path struct in checkerloop().
This
field will be null at least in cases where the path is either blacklisted or
its UID
cannot be determined.

I've included a patch for both problems below.

diff -ur multipath-tools-0.4.5-pre3.orig/libmultipath/blacklist.c
multipath-tools-0.4.5-pre3/libmultipath/blacklist.c
--- multipath-tools-0.4.5-pre3.orig/libmultipath/blacklist.c	2005-06-10
03:28:53.000000000 -0500
+++ multipath-tools-0.4.5-pre3/libmultipath/blacklist.c	2005-06-17
18:20:20.670980296 -0500
@@ -55,7 +55,7 @@
 {
 	int r = 0;
 
-	r += store_ble(blist, "(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
+	r += store_ble(blist, "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
 	r += store_ble(blist, "hd[a-z]");
 	r += store_ble(blist, "cciss!c[0-9]d[0-9]*");
 
diff -ur multipath-tools-0.4.5-pre3.orig/multipathd/main.c
multipath-tools-0.4.5-pre3/multipathd/main.c
--- multipath-tools-0.4.5-pre3.orig/multipathd/main.c	2005-06-10
03:28:53.000000000 -0500
+++ multipath-tools-0.4.5-pre3/multipathd/main.c	2005-06-20
10:13:24.059190944 -0500
@@ -723,6 +723,13 @@
 		condlog(4, "tick");
 
 		vector_foreach_slot (allpaths->pathvec, pp, i) {
+			/*
+			 * Don't both to check this path -- it is likely
+			 * either blacklisted or its getuid callout is
+			 * not returning successfully.
+			 */
+			if (!pp->mpp)
+				continue;
 			if (pp->tick) {
 				/*
 				 * don't check this path yet
