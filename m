From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: latest multipath-tools from git breaks EMC CX
Date: Thu, 2 Jun 2005 23:54:22 -0700
Message-ID: <20050603065422.GA29496@us.ibm.com>
References: <20050602204630.GK22633@marowsky-bree.de>
	<1117748565.15294.106.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1117748565.15294.106.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

christophe varoqui [christophe.varoqui@free.fr] wrote:
> Most certainly the 8af5a2b1b5e4d3a457f5bb477214356385087eae commit is
> the culprit : I did a bit of spliting in path discovery, and introduced
> a new fn to get the sysfs bus that I use as a switch to choose a
> discovery template.
> 
> Reading your output, I would say the bus fetching went wrong.
> 
> Well, revert it or debug it :/
> 

I was hitting the same problem on my system (the sysfs_get_bus function
leaving bus a none) the hack below fix it for me, but I only tested the
bus code against scsi YMMV.

-andmike
--
Michael Anderson
andmike@us.ibm.com


Hack fix for libmultipath sysfs_get_bus function.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

--- multipath-tools-git/libmultipath/discovery.c	2005-06-03 06:11:15.752789640 -0700
+++ multipath-tools-fix/libmultipath/discovery.c	2005-06-03 06:21:15.913551336 -0700
@@ -337,6 +337,7 @@ get_serial (char * str, int fd)
 static void
 sysfs_get_bus (char * sysfs_path, struct path * curpath)
 {
+	struct sysfs_device *sdev;
 	char attr_path[FILE_NAME_SIZE];
 	char attr_buff[FILE_NAME_SIZE];
 
@@ -352,25 +353,19 @@ sysfs_get_bus (char * sysfs_path, struct
 		condlog(0, "attr_path too small");
 		return;
 	}
-	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
-		return;
-
-	if (strlen(attr_buff) + 4 > FILE_NAME_SIZE) {
-		condlog(0, "attr_path too small");
-		return;
-	}
-	snprintf(attr_path, FILE_NAME_SIZE, "%s/bus", attr_buff);
 
 	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
 		return;
 
-	basename(attr_buff, attr_path);
-	
-	if (!strncmp(attr_path, "scsi", 4))
+	sdev = sysfs_open_device_path(attr_buff);
+
+	if (!strncmp(sdev->bus, "scsi", 4))
 		curpath->bus = SYSFS_BUS_SCSI;
-	else if (!strncmp(attr_path, "ide", 3))
+	else if (!strncmp(sdev->bus, "ide", 3))
 		curpath->bus = SYSFS_BUS_IDE;
 
+	sysfs_close_device(sdev);
+
 	return;
 }
 
