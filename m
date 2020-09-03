From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] Documentation/hdio: fix up obscure bd_contains references
Date: Thu,  3 Sep 2020 07:40:56 +0200
Message-ID: <20200903054104.228829-2-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
Sender: linux-doc-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

bd_contains is an implementation detail and should not be mentioned in
a userspace API documentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/userspace-api/ioctl/hdio.rst | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/userspace-api/ioctl/hdio.rst b/Documentation/userspace-api/ioctl/hdio.rst
index e822e3dff1769b..817371bf94e948 100644
--- a/Documentation/userspace-api/ioctl/hdio.rst
+++ b/Documentation/userspace-api/ioctl/hdio.rst
@@ -181,7 +181,7 @@ HDIO_SET_UNMASKINTR
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
@@ -231,7 +231,7 @@ HDIO_SET_MULTCOUNT
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range supported by disk.
 	  - EBUSY	Controller busy or blockmode already set.
@@ -295,7 +295,7 @@ HDIO_GET_IDENTITY
 		the ATA specification.
 
 	error returns:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - ENOMSG	IDENTIFY DEVICE information not available
 
 	notes:
@@ -355,7 +355,7 @@ HDIO_SET_KEEPSETTINGS
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY		Controller busy
@@ -1055,7 +1055,7 @@ HDIO_SET_32BIT
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 3]
 	  - EBUSY	Controller busy
@@ -1085,7 +1085,7 @@ HDIO_SET_NOWERR
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY		Controller busy
@@ -1113,7 +1113,7 @@ HDIO_SET_DMA
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
@@ -1141,7 +1141,7 @@ HDIO_SET_PIO_MODE
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 255]
 	  - EBUSY	Controller busy
@@ -1237,7 +1237,7 @@ HDIO_SET_WCACHE
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
@@ -1265,7 +1265,7 @@ HDIO_SET_ACOUSTIC
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 254]
 	  - EBUSY	Controller busy
@@ -1305,7 +1305,7 @@ HDIO_SET_ADDRESS
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 2]
 	  - EBUSY		Controller busy
@@ -1331,7 +1331,7 @@ HDIO_SET_IDE_SCSI
 
 
 	error return:
-	  - EINVAL	(bdev != bdev->bd_contains) (not sure what this means)
+	  - EINVAL	Called on a partition instead of the whole disk device
 	  - EACCES	Access denied:  requires CAP_SYS_ADMIN
 	  - EINVAL	value out of range [0 1]
 	  - EBUSY	Controller busy
-- 
2.28.0
