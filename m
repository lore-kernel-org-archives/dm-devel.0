From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH][RESEND] multipath: fix cciss device names
Date: Fri, 27 Jul 2012 15:57:18 -0500
Message-ID: <20120727205718.GL5299@ether.msp.redhat.com>
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

When we're looking for cciss devices in sysfs, they have a "!" not a "/".
If users run multipath on a cciss device using it's devnode name,
/dev/cciss/cXdY, multipath should convert that to the sysfs name.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: multipath-tools-120518/multipath/main.c
===================================================================
--- multipath-tools-120518.orig/multipath/main.c
+++ multipath-tools-120518/multipath/main.c
@@ -409,6 +409,16 @@ get_dev_type(char *dev) {
 		return DEV_DEVMAP;
 }
 
+static void
+convert_dev(char *dev)
+{
+	char *ptr = strstr(dev, "cciss/");
+	if (ptr) {
+		ptr += 5;
+		*ptr = '!';
+	}
+}
+
 int
 main (int argc, char *argv[])
 {
@@ -514,6 +524,8 @@ main (int argc, char *argv[])
 
 		strncpy(conf->dev, argv[optind], FILE_NAME_SIZE);
 		conf->dev_type = get_dev_type(conf->dev);
+		if (conf->dev_type == DEV_DEVNODE)
+			convert_dev(conf->dev);
 	}
 	conf->daemon = 0;
 
