From: Kevin Corry <kevcorry@us.ibm.com>
Subject: [PATCH] dm-striped device sizes must be multiple of
	chunk-size
Date: Tue, 14 Mar 2006 16:31:01 -0600
Message-ID: <200603141631.02655.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: DevMapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

The dm-striped target currently does not enforce that the size of a stripe 
device be a multiple of the chunk-size. Under certain conditions, this can 
lead to I/O requests going off the end of an underlying device. This 
test-case shows one example.

echo "0 100 linear /dev/hdb1 0" | dmsetup create linear0
echo "0 100 linear /dev/hdb1 100" | dmsetup create linear1
echo "0 200 striped 2 32 /dev/mapper/linear0 0 /dev/mapper/linear1 0" | \
   dmsetup create stripe0
dd if=/dev/zero of=/dev/mapper/stripe0 bs=1k

This will produce the output:
dd: writing '/dev/mapper/stripe0': Input/output error
97+0 records in
96+0 records out

And in the kernel log will be:
attempt to access beyond end of device
dm-0: rw=0, want=104, limit=100

The patch below will check that the table size is a multiple of the stripe 
chunk-size when the table is created, which will prevent the above striped 
device from being created.

This should not effect tools like LVM or EVMS, since in all the cases I can 
think of, striped devices are always created with the sizes being a multiple 
of the chunk-size.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/


The size of a stripe device must be a multiple of its chunk-size.

Signed-off-by: Kevin Corry <kevcorry@us.ibm.com>

 dm-stripe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- diff/drivers/md/dm-stripe.c	2006-03-14 15:57:30.000000000 -0600
+++ source/drivers/md/dm-stripe.c	2006-03-14 16:01:41.000000000 -0600
@@ -103,6 +103,12 @@
 		return -EINVAL;
 	}
 
+	if (((uint32_t)ti->len) & (chunk_size - 1)) {
+		ti->error = "dm-stripe: Target length not divisable by "
+		    "chunk size";
+		return -EINVAL;
+	}
+
 	width = ti->len;
 	if (sector_div(width, stripes)) {
 		ti->error = "dm-stripe: Target length not divisable by "
