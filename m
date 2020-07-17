From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: [RFC PATCH v4 07/12] dm-verity: add bdev_setsecurity hook for dm-verity signature
Date: Fri, 17 Jul 2020 16:09:36 -0700
Message-ID: <20200717230941.1190744-8-deven.desai@linux.microsoft.com>
References: <20200717230941.1190744-1-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200717230941.1190744-1-deven.desai@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, viro@zeniv.linux.org.uk, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com
Cc: tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatshin@soleen.com
List-Id: dm-devel.ids

Add a security hook call to set a security property of a block_device
in dm-verity with the results of a verified, signed root-hash.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
 drivers/md/dm-verity-verify-sig.c | 7 +++++++
 include/linux/device-mapper.h     | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index 27dac8aa2e5a..242e2421d3c8 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -8,7 +8,10 @@
 #include <linux/device-mapper.h>
 #include <linux/verification.h>
 #include <keys/user-type.h>
+#include <linux/security.h>
+#include <linux/list.h>
 #include <linux/module.h>
+#include "dm-core.h"
 #include "dm-verity.h"
 #include "dm-verity-verify-sig.h"
 
@@ -182,6 +185,10 @@ int verity_verify_root_hash(const struct dm_verity *v)
 		goto cleanup;
 
 	sig_target->passed = true;
+
+	ret = security_bdev_setsecurity(dm_table_get_md(v->ti->table)->bdev,
+					DM_VERITY_SIGNATURE_SEC_NAME,
+					v->sig->sig, v->sig->sig_size);
 cleanup:
 	kfree(root_hash);
 	return ret;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8750f2dc5613..02be0be21d38 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -624,4 +624,6 @@ static inline unsigned long to_bytes(sector_t n)
 	return (n << SECTOR_SHIFT);
 }
 
+#define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME	".verity-sig"
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */
-- 
2.27.0
