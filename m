From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [Patch] kpartx to accept device map name
Date: Mon, 16 May 2005 15:21:26 -0400
Message-ID: <4288F2B6.9070808@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020402020308080602020708"
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

This is a multi-part message in MIME format.
--------------020402020308080602020708
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello Christophe,

Attached patch adds '-m' option which makes kpartx
to accept device map name.

Using with the cvs version of libdevmapper or with the
patch suggested by Kiyoshi Ueda today, we don't need
to depend on asynchronous nature of hotplug when it's
not necessary.

For example, we can do this for initialization:
  multipath
  dmsetup info -c --noheadings -o name | xargs -l1 kpartx -a -m
otherwise we had to insert adhoc length of sleep to wait for
the completion of hotplug events.

Please consider to apply.

Thanks,
Jun'ichi Nomura


--------------020402020308080602020708
Content-Type: text/x-patch;
 name="kpartx-mapname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kpartx-mapname.patch"

Index: kpartx/kpartx.c
===================================================================
--- e5bb12309df918f41b63a339fdc936f77241d332/kpartx/kpartx.c  (mode:100644)
+++ uncommitted/kpartx/kpartx.c  (mode:100644)
@@ -70,7 +70,7 @@
 	addpts("unixware", read_unixware_pt);
 }
 
-static char short_opts[] = "ladgvnp:t:";
+static char short_opts[] = "ladgvnp:t:m";
 
 /* Used in gpt.c */
 int force_gpt=0;
@@ -183,6 +183,7 @@
 	char * delim = NULL;
 	int loopro = 0;
 	int hotplug = 0;
+	int use_mapname = 0;
 	struct stat buf;
 
 	initpts();
@@ -245,12 +246,16 @@
 		case 'd':
 			what = DELETE;
 			break;
+		case 'm':
+			use_mapname = 1;
+			break;
 		default:
 			usage();
 			exit(1);
 	}
 
-	if (dm_prereq(DM_TARGET, 0, 0, 0) && (what == ADD || what == DELETE)) {
+	if (dm_prereq(DM_TARGET, 0, 0, 0)
+	    && (what == ADD || what == DELETE || use_mapname)) {
 		fprintf(stderr, "device mapper prerequisites not met\n"); 
 		exit(1);
 	}
@@ -267,6 +272,21 @@
 		exit(1);
 	}
 
+	if (use_mapname) {
+		int len;
+		char *realdev, *dmdir;
+
+		dmdir = dm_dir();
+		len = strlen(dmdir) + strlen(device) + 2;
+		realdev = malloc(sizeof(char) * len);
+		if (!realdev) {
+			printf("failed to alloc memory\n");
+			exit(1);
+		}
+		snprintf(realdev, len, "%s/%s", dmdir, device);
+		diskdevice = device = realdev;
+	}
+
 	if (stat(device, &buf)) {
 		printf("failed to stat() %s\n", device);
 		exit (1);

--------------020402020308080602020708
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------020402020308080602020708--
