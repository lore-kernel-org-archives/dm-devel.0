From: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] iommu/amd: Fix NULL pointer deref on device detach READ
	FPDMA QUEUED errors since Linux 4.0
Date: Fri, 9 Oct 2015 16:45:28 +0200
Message-ID: <20151009144528.GA27420@8bytes.org>
References: <alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
	<20150929162042.GR3036@8bytes.org> <560BF73F.8000008@maya.org>
	<20151006101356.GE12506@8bytes.org> <56141507.7040103@maya.org>
	<20151007154005.GH28811@8bytes.org> <56155028.7060906@maya.org>
	<20151008173007.GL28811@8bytes.org> <5616BCF4.10104@maya.org>
	<5616C850.2000906@maya.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5616C850.2000906-YKS6W9RDU/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Cc: linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hi Andreas,

On Thu, Oct 08, 2015 at 09:47:28PM +0200, Andreas Hartmann wrote:
> This time, the oops was caused by the second PCI card I'm passing
> through to another VM (the ath9k card worked fine this time - chance?).
> I added the lspci output to the attached file, too.

I digged a little bit around here and found a 32bit PCI card and plugged
it into the AMD IOMMU box. I could reproduce the problem and here is
patch which fixes it for me. Can you test it too please? I'd like to
send a pull-req with this fix included to Linus for rc5.

Thanks,

	Joerg

From d07307c04edffaaa045fb83713f8808e55ffa895 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
Date: Fri, 9 Oct 2015 16:23:33 +0200
Subject: [PATCH] iommu/amd: Fix NULL pointer deref on device detach

When a device group is detached from its domain, the iommu
core code calls into the iommu driver to detach each device
individually.

Before this functionality went into the iommu core code, it
was implemented in the drivers, also in the AMD IOMMU
driver as the device alias handling code.

This code is still present, as there might be aliases that
don't exist as real PCI devices (and are therefore invisible
to the iommu core code).

Unfortunatly it might happen now, that a device is unbound
multiple times from its domain, first by the alias handling
code and then by the iommu core code (or vice verca).

This ends up in the do_detach function which dereferences
the dev_data->domain pointer. When the device is already
detached, this pointer is NULL and we get a kernel oops.

Removing the alias code completly is not an option, as that
would also remove the code which handles invisible aliases.
The code could be simplified, but this is too big of a
change outside the merge window.

For now, just check the dev_data->domain pointer in
do_detach and bail out if it is NULL.

Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Signed-off-by: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
---
 drivers/iommu/amd_iommu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f82060e7..08d2775 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2006,6 +2006,15 @@ static void do_detach(struct iommu_dev_data *dev_data)
 {
 	struct amd_iommu *iommu;
 
+	/*
+	 * First check if the device is still attached. It might already
+	 * be detached from its domain because the generic
+	 * iommu_detach_group code detached it and we try again here in
+	 * our alias handling.
+	 */
+	if (!dev_data->domain)
+		return;
+
 	iommu = amd_iommu_rlookup_table[dev_data->devid];
 
 	/* decrease reference counters */
-- 
2.5.1
