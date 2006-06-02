From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [multipath-tools] [patch] getopt cleanup
Date: Thu, 1 Jun 2006 19:19:12 -0500
Message-ID: <20060602001912.GD25695@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GZVR6ND4mMseVXL/"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

'q' and 'i' are never used, so don't accept them as valid options

-Ben

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="getopt_cleanup.patch"

diff -urpN mp-devel-clean/multipath/main.c mp-devel-patched/multipath/main.c
--- mp-devel-clean/multipath/main.c	2006-04-03 14:10:39.000000000 -0500
+++ mp-devel-patched/multipath/main.c	2006-06-01 12:49:54.000000000 -0500
@@ -321,7 +321,7 @@ main (int argc, char *argv[])
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":qdl::Ffi:M:v:p:b:")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dl::FfM:v:p:b:")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--GZVR6ND4mMseVXL/--
