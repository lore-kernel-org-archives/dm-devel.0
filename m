From: Vasily Averin <vvs@sw.ru>
Subject: dm: struct io_restriction reordered
Date: Mon, 29 Oct 2007 09:31:52 +0300
Message-ID: <47257E58.2030606@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757238AbXJ2Gci@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, devel@openvz.org
Cc: Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

it saves some bytes memory

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -110,12 +110,12 @@ struct target_type {
 };

 struct io_restrictions {
+	unsigned long		seg_boundary_mask;
 	unsigned int		max_sectors;
+	unsigned int		max_segment_size;
 	unsigned short		max_phys_segments;
 	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
-	unsigned int		max_segment_size;
-	unsigned long		seg_boundary_mask;
 	unsigned char		no_cluster; /* inverted so that 0 is default */
 };
