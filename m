From: Guido Guenther <agx@sigxcpu.org>
Subject: [PATCH 3/3] kpartx: on delete process partitions in
	reverse order
Date: Mon, 26 Nov 2007 16:27:32 +0100
Message-ID: <20071126152732.GC13674@bogon.ms20.nix>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

otherwise we try to remove the extended partition of MSDOS labels
(/dev/mapper/mpathX-part[1-4]) before the logical partition
/dev/mapper/mpathX-partY (Y>5) which fails.

Signed-Off-By: Guido Guenther <agx@sigxcpu.org>

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 554f742..7098d65 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -391,7 +391,7 @@ main(int argc, char **argv){
 			break;
 
 		case DELETE:
-			for (j = 0; j < n; j++) {
+			for (j = n-1; j >= 0; j--) {
 				if (safe_sprintf(partname, "%s%s%d",
 					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
