From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] avoid compiler warning about cast in OFFSET_OF
	macro
Date: Wed, 18 Jun 2008 12:19:36 +0200
Message-ID: <87ve07xcxz.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

While I happen to know these warnings are false alerts,

  dmsetup.c:1949: warning: cast from pointer to integer of different size
  dmsetup.c:1950: warning: cast from pointer to integer of different size
  dmsetup.c:1951: warning: cast from pointer to integer of different size
  dmsetup.c:1952: warning: cast from pointer to integer of different size
  dmsetup.c:1953: warning: cast from pointer to integer of different size
  dmsetup.c:1955: warning: cast from pointer to integer of different size

their mere presence (and our becoming inured to them) makes it more
likely someone will introduce a new one that will be ignored along
with all those.

So I changed the offending OFFSET_OF macro to generate equivalent code
(-O2-generated, before/after .o files are identical) but without triggering
the warning:

From 1219430622d29c7a3f8bdc6ad1fdd2a64082070e Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Wed, 18 Jun 2008 12:05:12 +0200
Subject: [PATCH] avoid compiler warning about cast in OFFSET_OF macro

* dmsetup/dmsetup.c (OFFSET_OF): Use an equivalent definition
that does not cast a pointer value to a narrower type.
---
 dmsetup/dmsetup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/dmsetup/dmsetup.c b/dmsetup/dmsetup.c
index fdc52e3..b242f1c 100644
--- a/dmsetup/dmsetup.c
+++ b/dmsetup/dmsetup.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
  * Copyright (C) 2005-2007 NEC Corporation
  *
  * This file is part of the device-mapper userspace tools.
@@ -1927,7 +1927,7 @@ static const struct dm_report_object_type _report_types[] = {
 };

 /* Column definitions */
-#define OFFSET_OF(strct, field) ((unsigned int) &((struct strct *)NULL)->field)
+#define OFFSET_OF(strct, field) (((char*)&((struct strct*)0)->field) - (char*)0)
 #define STR (DM_REPORT_FIELD_TYPE_STRING)
 #define NUM (DM_REPORT_FIELD_TYPE_NUMBER)
 #define FIELD_O(type, strct, sorttype, head, field, width, func, id, desc) {DR_ ## type, sorttype, OFFSET_OF(strct, field), width, id, head, &_ ## func ## _disp, desc},
--
1.5.6.rc3.13.gb55d4
