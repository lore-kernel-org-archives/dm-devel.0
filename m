Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99056B65C
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706321918; cv=none; b=mkNtbdtG2FpbauP4I+oOfbpaHnO510mI2QxPeeMmP9Gqube2v+edGkWNMWQrzlHPOq+7yGpOAzfySP5XElK9DZK38Rb4qR7ncCppzQ4b/lyD0XeLeHTlJF456LwoNFEtIq+PE381RNWgMGWzG3gYBtpOE0cfSKZbZMcxszlasNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706321918; c=relaxed/simple;
	bh=3Nx7oCcvGQu7YKg69BWCqJ5+/6qM9TsT2K/uldZ8Px8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sq4lQ4TCT8tfTWTOA71FnM1DkDF44DQto44MIjw1i3wYoNEVH0KGo11ooeIWjGmHkseXhxofT0+41SRljPCAkOxCZclUhPtObnxstURdEN/WEMe5ct6KW8IgvuIYNiGfIw4hjc1b9W6HWI9NMXrF0YXD+f/MK1r7rxWbs8yDzhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GwxwVPBR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GwxwVPBR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706321915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U38w+Fn2Owzg1PP5i6gtth0CMu540KTNMDJXe/YmZ8I=;
	b=GwxwVPBRk0Nbyacl3WSXlN9fxMI3o8zjNP5e5EtlUbCoXq25VcIN1j9c9KRvrQh8BtRVPe
	Lg4DuVTGfeZ72NXtB0QZ5YNDJ52F7DseZlYHM6VEM979uOfhnxz8fPuLA5vpWe+vuzK15x
	bZv80K/D8H3E9i16THdf3sIVShzZKiw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-3Gr54TECOh-4Lg4PbrrYGQ-1; Fri, 26 Jan 2024 21:18:33 -0500
X-MC-Unique: 3Gr54TECOh-4Lg4PbrrYGQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7618C827D85;
	Sat, 27 Jan 2024 02:18:33 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67AEB40C95AD;
	Sat, 27 Jan 2024 02:18:33 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 5C8F6560BA; Fri, 26 Jan 2024 21:18:33 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: use a proper Makefile for dm-vdo
Date: Fri, 26 Jan 2024 21:18:33 -0500
Message-ID: <a29b6ce2f2a0d7548227b6e11f818293d39e8a11.1706321430.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Requires moving dm-vdo-target.c into drivers/md/dm-vdo/

This change adds a proper drivers/md/dm-vdo/Makefile and eliminates
the abnormal use of patsubst in drivers/md/Makefile -- which was the
cause of at least one build failure that was reported by the upstream
build bot.

Also, split out VDO's drivers/md/dm-vdo/Kconfig and include it from
drivers/md/Kconfig

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 MAINTAINERS                             |  1 -
 drivers/md/Kconfig                      | 18 +-------
 drivers/md/Makefile                     |  3 +-
 drivers/md/dm-vdo/Kconfig               | 17 +++++++
 drivers/md/dm-vdo/Makefile              | 61 +++++++++++++++++++++++++
 drivers/md/{ => dm-vdo}/dm-vdo-target.c | 52 ++++++++++-----------
 6 files changed, 107 insertions(+), 45 deletions(-)
 create mode 100644 drivers/md/dm-vdo/Kconfig
 create mode 100644 drivers/md/dm-vdo/Makefile
 rename drivers/md/{ => dm-vdo}/dm-vdo-target.c (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5357fbe1cc90..91254b134456 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6007,7 +6007,6 @@ M:	dm-devel@lists.linux.dev
 L:	dm-devel@lists.linux.dev
 S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
-F:	drivers/md/dm-vdo-target.c
 F:	drivers/md/dm-vdo/
 
 DEVLINK
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 9c4039106384..e11659186fd0 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -532,22 +532,6 @@ config DM_FLAKEY
 	help
 	 A target that intermittently fails I/O for debugging purposes.
 
-config DM_VDO
-	tristate "VDO: deduplication and compression target"
-	depends on 64BIT
-	depends on BLK_DEV_DM
-	select DM_BUFIO
-	select LZ4_COMPRESS
-	select LZ4_DECOMPRESS
-	help
-	  This device mapper target presents a block device with
-	  deduplication, compression and thin-provisioning.
-
-	  To compile this code as a module, choose M here: the module will
-	  be called dm-vdo.
-
-	  If unsure, say N.
-
 config DM_VERITY
 	tristate "Verity target support"
 	depends on BLK_DEV_DM
@@ -683,4 +667,6 @@ config DM_AUDIT
 	  Enables audit logging of several security relevant events in the
 	  particular device-mapper targets, especially the integrity target.
 
+source "drivers/md/dm-vdo/Kconfig"
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 47444b393abb..64b8f4deed4a 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -25,7 +25,6 @@ dm-ebs-y	+= dm-ebs-target.o
 dm-era-y	+= dm-era-target.o
 dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
-dm-vdo-y	+= dm-vdo-target.o $(patsubst drivers/md/dm-vdo/%.c,dm-vdo/%.o,$(wildcard $(src)/dm-vdo/*.c))
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
 md-mod-y	+= md.o md-bitmap.o
@@ -75,7 +74,7 @@ obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)		+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING) += dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
-obj-$(CONFIG_DM_VDO)            += dm-vdo.o
+obj-$(CONFIG_DM_VDO)            += dm-vdo/
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
 obj-$(CONFIG_DM_EBS)		+= dm-ebs.o
diff --git a/drivers/md/dm-vdo/Kconfig b/drivers/md/dm-vdo/Kconfig
new file mode 100644
index 000000000000..111ecd2c2a24
--- /dev/null
+++ b/drivers/md/dm-vdo/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config DM_VDO
+	tristate "VDO: deduplication and compression target"
+	depends on 64BIT
+	depends on BLK_DEV_DM
+	select DM_BUFIO
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	help
+	  This device mapper target presents a block device with
+	  deduplication, compression and thin-provisioning.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-vdo.
+
+	  If unsure, say N.
diff --git a/drivers/md/dm-vdo/Makefile b/drivers/md/dm-vdo/Makefile
new file mode 100644
index 000000000000..8f8d161a6dbe
--- /dev/null
+++ b/drivers/md/dm-vdo/Makefile
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_DM_VDO) += dm-vdo.o
+
+dm-vdo-objs := \
+	action-manager.o \
+	admin-state.o \
+	block-map.o \
+	chapter-index.o \
+	completion.o \
+	config.o \
+	constants.o \
+	data-vio.o \
+	dedupe.o \
+	delta-index.o \
+	dm-vdo-target.o \
+	dump.o \
+	encodings.o \
+	errors.o \
+	flush.o \
+	funnel-queue.o \
+	funnel-requestqueue.o \
+	funnel-workqueue.o \
+	geometry.o \
+	index-layout.o \
+	index.o \
+	index-page-map.o \
+	index-session.o \
+	int-map.o \
+	io-factory.o \
+	io-submitter.o \
+	logger.o \
+	logical-zone.o \
+	memory-alloc.o \
+	message-stats.o \
+	murmurhash3.o \
+	open-chapter.o \
+	packer.o \
+	permassert.o \
+	physical-zone.o \
+	pool-sysfs.o \
+	pool-sysfs-stats.o \
+	priority-table.o \
+	radix-sort.o \
+	recovery-journal.o \
+	repair.o \
+	slab-depot.o \
+	sparse-cache.o \
+	status-codes.o \
+	string-utils.o \
+	sysfs.o \
+	thread-cond-var.o \
+	thread-device.o \
+	thread-registry.o \
+	uds-sysfs.o \
+	uds-threads.o \
+	vdo.o \
+	vio.o \
+	volume-index.o \
+	volume.o \
+	wait-queue.o
diff --git a/drivers/md/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
similarity index 99%
rename from drivers/md/dm-vdo-target.c
rename to drivers/md/dm-vdo/dm-vdo-target.c
index 4fbc148681e5..fcba50d8d088 100644
--- a/drivers/md/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -13,32 +13,32 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
-#include "dm-vdo/admin-state.h"
-#include "dm-vdo/block-map.h"
-#include "dm-vdo/completion.h"
-#include "dm-vdo/constants.h"
-#include "dm-vdo/data-vio.h"
-#include "dm-vdo/dedupe.h"
-#include "dm-vdo/dump.h"
-#include "dm-vdo/encodings.h"
-#include "dm-vdo/errors.h"
-#include "dm-vdo/flush.h"
-#include "dm-vdo/io-submitter.h"
-#include "dm-vdo/logger.h"
-#include "dm-vdo/memory-alloc.h"
-#include "dm-vdo/message-stats.h"
-#include "dm-vdo/pool-sysfs.h"
-#include "dm-vdo/recovery-journal.h"
-#include "dm-vdo/repair.h"
-#include "dm-vdo/slab-depot.h"
-#include "dm-vdo/status-codes.h"
-#include "dm-vdo/string-utils.h"
-#include "dm-vdo/thread-device.h"
-#include "dm-vdo/thread-registry.h"
-#include "dm-vdo/types.h"
-#include "dm-vdo/uds-sysfs.h"
-#include "dm-vdo/vdo.h"
-#include "dm-vdo/vio.h"
+#include "admin-state.h"
+#include "block-map.h"
+#include "completion.h"
+#include "constants.h"
+#include "data-vio.h"
+#include "dedupe.h"
+#include "dump.h"
+#include "encodings.h"
+#include "errors.h"
+#include "flush.h"
+#include "io-submitter.h"
+#include "logger.h"
+#include "memory-alloc.h"
+#include "message-stats.h"
+#include "pool-sysfs.h"
+#include "recovery-journal.h"
+#include "repair.h"
+#include "slab-depot.h"
+#include "status-codes.h"
+#include "string-utils.h"
+#include "thread-device.h"
+#include "thread-registry.h"
+#include "types.h"
+#include "uds-sysfs.h"
+#include "vdo.h"
+#include "vio.h"
 
 #define	CURRENT_VERSION "8.3.0.65"
 
-- 
2.42.0

