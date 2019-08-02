From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 1/2] dm-zoned: add SPDX license identifiers
Date: Fri,  2 Aug 2019 15:02:50 -0700
Message-ID: <20190802220251.1217-2-dmitry.fomichev@wdc.com>
References: <20190802220251.1217-1-dmitry.fomichev@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190802220251.1217-1-dmitry.fomichev@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 1 +
 drivers/md/dm-zoned-reclaim.c  | 1 +
 drivers/md/dm-zoned-target.c   | 1 +
 drivers/md/dm-zoned.h          | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 8545dcee9fd0..23e9a6d9350b 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2017 Western Digital Corporation or its affiliates.
  *
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index edf4b95eb075..387894e2add1 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2017 Western Digital Corporation or its affiliates.
  *
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 51d029bbb740..1bf6e6eebee1 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2017 Western Digital Corporation or its affiliates.
  *
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index ed8de49c9a08..1a3b06de2c00 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2017 Western Digital Corporation or its affiliates.
  *
-- 
2.21.0
