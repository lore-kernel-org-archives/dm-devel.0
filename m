From: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [kvm-devel] I/O bandwidth control on KVM
Date: Wed, 05 Mar 2008 10:30:09 -0600
Message-ID: <47CECA91.2010507@codemonkey.ws>
References: <20080229.210531.226799765.ryov__28298.7898834564$1204287044$gmane$org@valinux.co.jp>	<47CA2A7B.8000400@codemonkey.ws>	<20080304.154109.193687573.ryov@valinux.co.jp>
	<20080306.005353.104038921.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030703080706060900040408"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080306.005353.104038921.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: kvm-devel@lists.sourceforge.net, dm-devel@redhat.com, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030703080706060900040408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ryo Tsuruta wrote:
> Hi,
>
>   
>> If you are using virtio drivers in the guest (which I presume you are 
>> given the reference to /dev/vda), try using the following -drive syntax:
>>
>> -drive file=/dev/mapper/ioband1,if=virtio,boot=on,cache=off
>>
>> This will force the use of O_DIRECT.  By default, QEMU does not open 
>> with O_DIRECT so you'll see page cache effects.
>>     
>
> I tried the test with "cache=off" option, here is the result. 
>   

Can you give the attached patch a try?  The virtio backend does 
synchronous IO requests blocking the guest from making progress until 
the IO completes.  It's possible that what you're seeing is the 
scheduler competing with your IO bandwidth limiting in order to ensure 
fairness since IO completion is intimately tied to CPU consumption 
(since we're using blocking IO).

The attached patch implements AIO support for the virtio backend so if 
this is the case, you should see the proper proportions.

Regards,

Anthony Liguori

--------------030703080706060900040408
Content-Type: text/x-diff;
 name="virtio:blk_aio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="virtio:blk_aio.patch"

diff --git a/qemu/hw/virtio-blk.c b/qemu/hw/virtio-blk.c
index 301b5a1..3c56bed 100644
--- a/qemu/hw/virtio-blk.c
+++ b/qemu/hw/virtio-blk.c
@@ -71,59 +71,121 @@ typedef struct VirtIOBlock
     BlockDriverState *bs;
 } VirtIOBlock;
 
+typedef struct VBDMARequestState VBDMARequestState;
+
+typedef struct VBDMAState
+{
+    VirtQueueElement elem;
+    int count;
+    int is_write;
+    unsigned int wlen;
+    VirtQueue *vq;
+    VirtIODevice *vdev;
+    VBDMARequestState *requests;
+} VBDMAState;
+
+struct VBDMARequestState
+{
+    VBDMAState *dma;
+    BlockDriverAIOCB *aiocb;
+    VBDMARequestState *next;
+};
+
 static VirtIOBlock *to_virtio_blk(VirtIODevice *vdev)
 {
     return (VirtIOBlock *)vdev;
 }
 
+static void virtio_io_completion(void *opaque, int ret)
+{
+    VBDMARequestState *req = opaque, **ppreq;
+    VBDMAState *dma = req->dma;
+    struct virtio_blk_inhdr *in;
+
+    for (ppreq = &dma->requests; *ppreq; ppreq = &(*ppreq)->next) {
+	if (*ppreq == req) { 
+	    *ppreq = req->next;
+	    break;
+	}
+    }
+
+    qemu_free(req);
+
+    if (dma->requests)
+	return;
+
+    in = (void *)dma->elem.in_sg[dma->elem.in_num - 1].iov_base;
+    dma->wlen += sizeof(*in);
+    if (ret == -EOPNOTSUPP)
+	in->status = VIRTIO_BLK_S_UNSUPP;
+    else
+	in->status = VIRTIO_BLK_S_OK;
+    virtqueue_push(dma->vq, &dma->elem, dma->wlen);
+    virtio_notify(dma->vdev, dma->vq);
+    qemu_free(dma);
+}
+
 static void virtio_blk_handle_output(VirtIODevice *vdev, VirtQueue *vq)
 {
     VirtIOBlock *s = to_virtio_blk(vdev);
-    VirtQueueElement elem;
+    VBDMAState *dma = qemu_mallocz(sizeof(VBDMAState));
     unsigned int count;
 
-    while ((count = virtqueue_pop(vq, &elem)) != 0) {
-	struct virtio_blk_inhdr *in;
+    while ((count = virtqueue_pop(vq, &dma->elem)) != 0) {
 	struct virtio_blk_outhdr *out;
-	unsigned int wlen;
+	VBDMARequestState *req;
 	off_t off;
 	int i;
 
-	out = (void *)elem.out_sg[0].iov_base;
-	in = (void *)elem.in_sg[elem.in_num - 1].iov_base;
+	out = (void *)dma->elem.out_sg[0].iov_base;
 	off = out->sector;
 
+	dma->vq = vq;
+	dma->vdev = vdev;
+
 	if (out->type & VIRTIO_BLK_T_SCSI_CMD) {
-	    wlen = sizeof(*in);
-	    in->status = VIRTIO_BLK_S_UNSUPP;
+	    req = qemu_mallocz(sizeof(VBDMARequestState));
+	    req->dma = dma;
+	    req->next = dma->requests;
+	    dma->requests = req;
+	    virtio_io_completion(req, -EOPNOTSUPP);
 	} else if (out->type & VIRTIO_BLK_T_OUT) {
-	    wlen = sizeof(*in);
-
-	    for (i = 1; i < elem.out_num; i++) {
-		bdrv_write(s->bs, off,
-			   elem.out_sg[i].iov_base,
-			   elem.out_sg[i].iov_len / 512);
-		off += elem.out_sg[i].iov_len / 512;
+	    dma->count = dma->elem.out_num - 1;
+	    dma->is_write = 1;
+	    for (i = 1; i < dma->elem.out_num; i++) {
+		req = qemu_mallocz(sizeof(VBDMARequestState));
+		req->dma = dma;
+		req->next = dma->requests;
+		dma->requests = req;
+
+		req->aiocb = bdrv_aio_write(s->bs, off,
+					    dma->elem.out_sg[i].iov_base,
+					    dma->elem.out_sg[i].iov_len / 512,
+					    virtio_io_completion, req);
+		off += dma->elem.out_sg[i].iov_len / 512;
 	    }
-
-	    in->status = VIRTIO_BLK_S_OK;
 	} else {
-	    wlen = sizeof(*in);
-
-	    for (i = 0; i < elem.in_num - 1; i++) {
-		bdrv_read(s->bs, off,
-			  elem.in_sg[i].iov_base,
-			  elem.in_sg[i].iov_len / 512);
-		off += elem.in_sg[i].iov_len / 512;
-		wlen += elem.in_sg[i].iov_len;
+	    dma->count = dma->elem.in_num - 1;
+	    dma->is_write = 0;
+	    for (i = 0; i < dma->elem.in_num - 1; i++) {
+		req = qemu_mallocz(sizeof(VBDMARequestState));
+		req->dma = dma;
+		req->next = dma->requests;
+		dma->requests = req;
+
+		req->aiocb = bdrv_aio_read(s->bs, off,
+					   dma->elem.in_sg[i].iov_base,
+					   dma->elem.in_sg[i].iov_len / 512,
+					   virtio_io_completion, req);
+		off += dma->elem.in_sg[i].iov_len / 512;
+		dma->wlen += dma->elem.in_sg[i].iov_len;
 	    }
-
-	    in->status = VIRTIO_BLK_S_OK;
 	}
 
-	virtqueue_push(vq, &elem, wlen);
-	virtio_notify(vdev, vq);
+	dma = qemu_mallocz(sizeof(VBDMAState));
     }
+
+    qemu_free(dma);
 }
 
 static void virtio_blk_update_config(VirtIODevice *vdev, uint8_t *config)

--------------030703080706060900040408
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030703080706060900040408--
