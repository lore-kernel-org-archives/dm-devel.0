From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] Documentation/filesystems/locking.rst: remove an
 incorrect sentence
Date: Tue,  1 Sep 2020 17:57:40 +0200
Message-ID: <20200901155748.2884-2-hch@lst.de>
References: <20200901155748.2884-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20200901155748.2884-1-hch@lst.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, nbd@other.debian.org, virtualization@lists.linux-foundation.org, ceph-devel@vger.kernel.org
List-Id: dm-devel.ids

unlock_native_capacity is never called from check_disk_change(), and
while revalidate_disk can be called from it, it can also be called
from two other places at the moment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/locking.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 64f94a18d97e75..c0f2c7586531b0 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -488,9 +488,6 @@ getgeo:			no
 swap_slot_free_notify:	no	(see below)
 ======================= ===================
 
-unlock_native_capacity and revalidate_disk are called only from
-check_disk_change().
-
 swap_slot_free_notify is called with swap_lock and sometimes the page lock
 held.
 
-- 
2.28.0
