From: devzero@web.de
Subject: =?iso-8859-15?Q?Re:__[RFC][PATCH]_dm-cow:_copy-on-write_stac?=
	=?iso-8859-15?Q?kable_target_for?=
Date: Thu, 25 Jan 2007 20:08:14 +0100
Message-ID: <1584190895@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
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
To: bergevan@us.ibm.com, ericvh@hera.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Eric/Gorka, 

great work!

since i have used cowloop (http://www.atconsultancy.nl/cowloop/total.html ) some time ago but quit using it due to the fact that it never seems to happen that this is included in mainline, your project really looks like an interesting new alternative. (just came across this one while reading through dm-devel)

+a real world example of BW:
+
+0 8385866 cow /dev/sdb1 0 /dev/sdb2 /dev/sdb3 0

unfortunately, from my "user perspective" (not being a kernel hacker) this looks much more complicated than cowloop.
ok, i didn`t take one hour to really to dig into this to try to understand, but cowloop just seems "easy as 1-2-3" in comparison to this one.
any special reason for this, or maybe room left for improvement ? (ok, there maybe room for improvement of my brain, though :)

+A simple script file is included to format WB.
+The way it works is the standard dmsetup calls for
+the device mapper. The arguments are

you mean some script which makes this thingie easier to setup ?
did i misunderstand or did you miss to include this script ?

regards
roland k.
sysadmin






List:       dm-devel
Subject:    [dm-devel] [RFC][PATCH] dm-cow: copy-on-write stackable target for
From:       Eric Van Hensbergen <ericvh () hera ! kernel ! org>
Date:       2006-11-27 16:59:05
Message-ID: 200611271659.kARGx5qb017564 () hera ! kernel ! org
[Download message RAW]

Subject: [RFC] [PATCH] dm-cow: copy-on-write stackable target for device-mapper

This is the first cut of a device-mapper target which allows stacking of
multiple block devices and in which the top-layer of the stack is a 
copy-on-write layer.  It was originally developed in support of a cluster 
image management solution.

Existing device mapper snapshot facilities could be used to implement 
stackable block devices, as they support a copy-on-write mechanism 
for taking snapshots of logical volumes.  However, benchmarks (using
bonnie++) of such solutions showed an order of magnitude performance 
degredation.  This target was written in an attempt to provide a stacking 
and copy-on-write solution which would incur only a minimal overhead.

Detailed performance results will be available shortly in a technical-report
available via IBM's CyberDigest website -- however, initial results obtained 
with bonnie++ show dramatic performance improvements.

The code within this module was developed by an intern (Gorka
Guardiola) during his stay with us at IBM Research.  Please direct comments
both to myself and Gorka.

Signed-off-by: Eric Van Hensbegren <bergevan@us.ibm.com>
---
 Documentation/device-mapper/dm-cow.txt |   29 +
 drivers/md/Kconfig                     |   15 +
 drivers/md/Makefile                    |    1 
 drivers/md/dm-cow.c                    |  926 ++++++++++++++++++++++++++++++++
 4 files changed, 971 insertions(+), 0 deletions(-)

diff --git a/Documentation/device-mapper/dm-cow.txt b/Documentation/device-mapper/dm-cow.txt
new file mode 100644
index 0000000..2b18ee6
--- /dev/null
+++ b/Documentation/device-mapper/dm-cow.txt
@@ -0,0 +1,29 @@
+This is a target for the dm-mapper which stacks
+block devices. The base image B is a formatted block
+device. Over that go N read only block devices R
+and then 1 write device W. It does copy on write
+of the devices, and reads from the appropiate device.
+You start by formatting B. Then add a W on it.
+W consists on two parts, a block device for the bitmap
+which should start zeroed and which gets some magic number
+on it the first time it is used. The you can add another
+W and the first W turns into a R. WRB. and so on.
+
+A simple script file is included to format WB.
+The way it works is the standard dmsetup calls for
+the device mapper. The arguments are
+
+N M logdevname Bdevname Boffset Rbitmapdev Rdevname Roffset Wbitmapdev Wdevname Woffset 
+
+N and M are the offsets on the logical device /dev/mapper/logdevname
+
+Bdevname is the base image device name
+Boffset is the offset on the base image device
+Rbitmapdev is the block device for the bitmap on a read only device
+
+and so on.
+
+a real world example of BW:
+
+0 8385866 cow /dev/sdb1 0 /dev/sdb2 /dev/sdb3 0
+
______________________________________________________________________
XXL-Speicher, PC-Virenschutz, Spartarife & mehr: Nur im WEB.DE Club!		
Jetzt gratis testen! http://freemail.web.de/home/landingpad/?mc=021130
