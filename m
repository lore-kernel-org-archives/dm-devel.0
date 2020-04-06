From: deven.desai@linux.microsoft.com
Subject: [RFC PATCH v2 09/12] dm-verity: add bdev_setsecurity hook for root-hash
Date: Mon,  6 Apr 2020 15:14:36 -0700
Message-ID: <20200406221439.1469862-10-deven.desai@linux.microsoft.com>
References: <20200406221439.1469862-1-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200406221439.1469862-1-deven.desai@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org
Cc: tyhicks@linux.microsoft.com, pasha.tatashin@soleen.com, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Deven Bowers <deven.desai@linux.microsoft.com>

Add a security hook call to set a security property of a block_device
in dm-verity with the root-hash that was verified to match the merkel-tree.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
 drivers/md/dm-verity-target.c | 8 ++++++++
 include/linux/device-mapper.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index c507f3a4e237..225f67ab378d 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -16,8 +16,10 @@
 #include "dm-verity.h"
 #include "dm-verity-fec.h"
 #include "dm-verity-verify-sig.h"
+#include "dm-core.h"
 #include <linux/module.h>
 #include <linux/reboot.h>
+#include <linux/security.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -530,6 +532,12 @@ static int verity_verify_io(struct dm_verity_io *io)
 			return -EIO;
 	}
 
+	r = security_bdev_setsecurity(dm_table_get_md(v->ti->table)->bdev,
+				      DM_VERITY_ROOTHASH_SEC_NAME,
+				      v->root_digest, v->digest_size);
+	if (unlikely(r < 0))
+		return r;
+
 	/*
 	 * At this point, the merkel tree has finished validating.
 	 * if signature was specified, validate the signature here.
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 6bd49aa48186..467db44de194 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -625,5 +625,6 @@ static inline unsigned long to_bytes(sector_t n)
 }
 
 #define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME	".verity-sig"
+#define DM_VERITY_ROOTHASH_SEC_NAME DM_NAME	".verity-rh"
 
 #endif	/* _LINUX_DEVICE_MAPPER_H */
-- 
2.26.0
