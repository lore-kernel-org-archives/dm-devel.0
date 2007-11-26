From: Guido Guenther <agx@sigxcpu.org>
Subject: [PATCH 2/3] kpartx: remove unused "-n" code
Date: Mon, 26 Nov 2007 16:20:37 +0100
Message-ID: <20071126152037.GB13674@bogon.ms20.nix>
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

Signed-Off-By: Guido Guenther <agx@sigxcpu.org>

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 6d64e30..554f742 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -83,7 +83,7 @@ initpts(void)
 	addpts("sun", read_sun_pt);
 }
 
-static char short_opts[] = "ladgvnp:t:";
+static char short_opts[] = "ladgvp:t:";
 
 /* Used in gpt.c */
 int force_gpt=0;
@@ -189,8 +189,7 @@ main(int argc, char **argv){
 	struct slice all;
 	struct pt *ptp;
 	enum action what = LIST;
-	char *p, *type, *diskdevice, *device, *progname;
-	int lower, upper;
+	char *type, *diskdevice, *device, *progname;
 	int verbose = 0;
 	char partname[PARTNAME_SIZE], params[PARTNAME_SIZE + 16];
 	char * loopdev = NULL;
@@ -204,7 +203,6 @@ main(int argc, char **argv){
 	initpts();
 	init_crc32();
 
-	lower = upper = 0;
 	type = device = diskdevice = NULL;
 	memset(&all, 0, sizeof(all));
 	memset(&partname, 0, sizeof(partname));
@@ -241,14 +239,6 @@ main(int argc, char **argv){
 		case 'v':
 			verbose = 1;
 			break;
-		case 'n':
-			p = optarg;
-			lower = atoi(p);
-			if ((p[1] == '-') && p[2])
-				upper = atoi(p+2);
-			else
-				upper = lower;
-			break;
 		case 'p':
 			delim = optarg;
 			break;
@@ -333,8 +323,6 @@ main(int argc, char **argv){
 		perror(device);
 		exit(1);
 	}
-	if (!lower)
-		lower = 1;
 
 	/* add/remove partitions to the kernel devmapper tables */
 	for (i = 0; i < ptct; i++) {
