Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4562129B206
	for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750769714; cv=none; b=i2cfxuO9O26+bRa37GPidLGDK5ZlpyjBMC6EkUjgKbu/cRjzuxoGMC3wE/cJEceAKIZbwvn7iu5M8ccfu88ci8RD5e/0LSjNjoVI/7MhAQv53UH1/9fm/GNrcvrD4HWKar2UzKv2RyAvQo2k3CADDb2fcqlgmhxNiNUahXQhiqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750769714; c=relaxed/simple;
	bh=aEH/JPUmwK6Qpqzke+Ft7K+avzZ9i+00MLCogLRCQZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IbYPw4FS47m/jJnoCmiXX3aSJMwsefNStUn1i0TNKkCAzVYxa+2Bv21HlkKoGQUntq2fA5syAdE7fiXDyI0zj0HDMRmODP8ts5xCZtjxyDeEOXpygNFyM6kDQdSYOVGoB3+NQy4+fCkpzZe9yAGuq6YXfhrR6Vbv+nMaPyeX37Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iIxuT+On; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIxuT+On"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a524caf77eso797296f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 05:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750769708; x=1751374508; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gqrfwj7e0G6X0DoS9to4906aKQRNG2kwuQ3GGIzCAxw=;
        b=iIxuT+On8CsphmNq/8MgrJ5VJzNQ9kaCxJebqzSF7wZDyiVy9xtAdwSQsInQhGzI7/
         nz88ehc1HbD4K+bqy6xWvxhpVdQfMPxQOm1SR+P7hLG1bEA7S3BWkd/YDvuMVeO9qmbP
         utq/34KwV75+UKwTquxowpRDhbjmLp4Qr+OCBbn+MzBpPMqhawjlIGI/GZyxqVF2isOa
         gAA9pqftfGygncAMAAII0AT9NLErjBCf4wY7PJvWYkyRMyERSHqrbPuqIKWQYwXLo6L6
         R5Itvy12uPAiCfn63dD1PAiNXMqVNCAmoKuM7u2dQU51644rrMQi3Py2YtnMuuPirOP5
         S2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750769708; x=1751374508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gqrfwj7e0G6X0DoS9to4906aKQRNG2kwuQ3GGIzCAxw=;
        b=xLPSmHOaM5pCW4S0+JB2K9VsYzJlZG005WRbejU1YYD1cRTndxoNKERDchAM+LCi8T
         0t0O8CYpIlNkZ2hWchZo6YGsvRfxs4/hgwVTttFx32cSYjfchc2i94em80Jrp4OpL1jG
         ZKru2qSmzi28SXBb7XjpUNvHO9h8oaEaflxA8+HsF81dEZ3sKWWWm3JZx0gljRK4I8ah
         FCpxP5mdUbAL0w3ldlMWGoaj09PPWfABssJPbfaZ3P08A8sEXEi2PX4+OpWj+5nRQoz4
         0mb0vJSI+w/f/0hmxkOe7utXcYV0Zq2phYNZwCxRuwW0MRA86re1cQjxkIMnUw80RwT/
         Dzhw==
X-Forwarded-Encrypted: i=1; AJvYcCXfEzjgGh3XrHSjAQkdLVLiL6OfajwK+zjdZf6cqfUbdL60N56m0KALrh5iOYzlIWTYuUgOQR2Naw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxVktZ25wL6uXjJyZs0mLzhIto/dJzROUVadoH/bopmtW/vU+ti
	sIPpBHt2PjZRLKGpbjUiZSuuR7ixNH+fKWyO+jvPt8zXkCKpUeiu8kI=
X-Gm-Gg: ASbGncuVljw9SOJ0/ncu0uvDSGZWRvGzxBkLLUBocJpAt1BHCPU6Nucn4C11jG0xDS2
	ukdiB+6X9N5PMJCQp8xEgWiPEM3wjh1d6+cecdug1v6LSTh+IEFRZyhs0QGPyjCOs2nlM+vgtgD
	cKMadISWKOr1WGOb50XnRzTfUySchKayooxYwIhNqtGZzYJ4SY3Sib2Xpq/A/b4eHXrAZ1GddXs
	5CuSgnLr1fOybiHvUcRMAJYGVry+LGektB3Ma378KU9vIlCqUhroaH+g39JNSMRF9cyG9S8FaMT
	Ih1speESVZW1B3EJIQHqHDfHq7gOe+FKtPzzPQTi/l7AVfazO7myiuXlx1onQn23ybOmBADxNXg
	U/5OK92XqRtTA+b7fxiu2zEeONQtzVLs=
X-Google-Smtp-Source: AGHT+IEbm7z9sVwb5Z50OZ9Ey5kBDa6yMr9AxT+oZHbO+eo6WNof3hvjCEKvQaa+16DilgLZw4Y6vg==
X-Received: by 2002:a05:6000:2d85:b0:3a4:ec9c:fb58 with SMTP id ffacd0b85a97d-3a6d13103c7mr2691642f8f.9.1750769708073;
        Tue, 24 Jun 2025 05:55:08 -0700 (PDT)
Received: from localhost (8.red-80-39-33.staticip.rima-tde.net. [80.39.33.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8068d3fsm1888993f8f.37.2025.06.24.05.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 05:55:07 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: replace FSF licences boilerplate with a SPDX-License-Identifier
Date: Tue, 24 Jun 2025 14:55:05 +0200
Message-ID: <20250624125506.7708-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Missing:

util.c: maybe GPL-2.0-or-later ???
libmpathutil/util.c: * License: LGPL-2.1-or-later
libmpathutil/util.c: * Code copied from busybox (GPLv2 or later)

ambiguous, only "GPL" !!!
libmultipath/prioritizers/alua.c: * This file is released under the GPL.
libmultipath/prioritizers/alua_rtpg.c: * This file is released under the GPL.
libmultipath/prioritizers/alua_rtpg.h: * This file is released under the GPL.
libmultipath/prioritizers/alua_spc3.h: * This file is released under the GPL.
libmultipath/prioritizers/hds.c: * This file is released under the GPL.
libmultipath/prioritizers/weightedpath.c: *  This file is released under the GPL

---
 kpartx/dasd.c                            | 14 +-------------
 kpartx/dasd.h                            | 14 +-------------
 kpartx/efi.h                             | 14 +-------------
 kpartx/gpt.c                             | 14 +-------------
 kpartx/gpt.h                             | 14 +-------------
 kpartx/kpartx_id                         |  7 +------
 libdmmp/docs/doc-preclean.pl             | 15 +--------------
 libdmmp/libdmmp.c                        | 14 +-------------
 libdmmp/libdmmp/libdmmp.h                | 14 +-------------
 libdmmp/libdmmp_misc.c                   | 14 +-------------
 libdmmp/libdmmp_mp.c                     | 14 +-------------
 libdmmp/libdmmp_path.c                   | 14 +-------------
 libdmmp/libdmmp_pg.c                     | 14 +-------------
 libdmmp/libdmmp_private.h                | 14 +-------------
 libdmmp/test/libdmmp_speed_test.c        | 14 +-------------
 libdmmp/test/libdmmp_test.c              | 14 +-------------
 libmpathcmd/mpath_cmd.c                  | 14 +-------------
 libmpathcmd/mpath_cmd.h                  | 14 +-------------
 libmpathutil/msort.c                     | 16 ++--------------
 libmpathutil/parser.c                    | 11 +----------
 libmpathutil/parser.h                    | 11 +----------
 libmpathutil/vector.c                    | 11 +----------
 libmpathutil/vector.h                    | 11 +----------
 libmpathvalid/mpath_valid.h              | 14 +-------------
 libmultipath/alias.c                     | 13 +------------
 libmultipath/checkers/cciss_tur.c        | 14 +-------------
 libmultipath/dm-generic.c                | 14 +-------------
 libmultipath/dm-generic.h                | 14 +-------------
 libmultipath/file.c                      | 13 +------------
 libmultipath/foreign.c                   | 14 +-------------
 libmultipath/foreign.h                   | 14 +-------------
 libmultipath/foreign/nvme.c              | 14 +-------------
 libmultipath/generic.c                   | 14 +-------------
 libmultipath/generic.h                   | 14 +-------------
 libmultipath/io_err_stat.c               |  3 +--
 libmultipath/list.h                      |  3 +--
 libmultipath/nvme/argconfig.h            | 15 +--------------
 libmultipath/nvme/linux/nvme.h           | 10 +---------
 libmultipath/nvme/linux/nvme_ioctl.h     | 10 +---------
 libmultipath/nvme/nvme.h                 | 10 +---------
 libmultipath/prioritizers/ana.c          |  3 +--
 libmultipath/prioritizers/datacore.c     |  4 +---
 libmultipath/prioritizers/ontap.c        | 10 +---------
 libmultipath/prioritizers/path_latency.c |  3 +--
 libmultipath/sysfs.c                     | 14 +-------------
 libmultipath/uevent.c                    | 14 +-------------
 libmultipath/valid.c                     | 14 +-------------
 libmultipath/valid.h                     | 14 +-------------
 libmultipath/version.h                   | 11 +----------
 multipath/main.c                         | 11 +----------
 tests/blacklist.c                        | 15 +--------------
 tests/directio.c                         | 15 +--------------
 tests/dmevents.c                         | 15 +--------------
 tests/parser.c                           | 15 +--------------
 tests/pgpolicy.c                         | 15 +--------------
 tests/uevent.c                           | 15 +--------------
 tests/util.c                             | 15 +--------------
 tests/valid.c                            | 15 +--------------
 58 files changed, 59 insertions(+), 668 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index f0398645..337d5f45 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * dasd.c
  *
@@ -7,19 +8,6 @@
  *
  * Copyright (c) 2005, Hannes Reinecke, SUSE Linux Products GmbH
  * Copyright IBM Corporation, 2009
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #define _GNU_SOURCE
diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 481ad79e..21704fa2 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * dasd.h
  *
@@ -7,19 +8,6 @@
  *
  * Copyright (c) 2005, Hannes Reinecke, SUSE Linux Products GmbH
  * Copyright IBM Corporation, 2009
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef DASD_H_INCLUDED
diff --git a/kpartx/efi.h b/kpartx/efi.h
index 10af0e71..33396b16 100644
--- a/kpartx/efi.h
+++ b/kpartx/efi.h
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   efi.[ch] - Manipulates EFI variables as exported in /proc/efi/vars
 
   Copyright (C) 2001 Dell Computer Corporation <Matt_Domsch@dell.com>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef EFI_H_INCLUDED
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index fbf6ae22..69ddce99 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
     gpt.[ch]
 
@@ -6,19 +7,6 @@
     EFI GUID Partition Table handling
     Per Intel EFI Specification v1.02
     http://developer.intel.com/technology/efi/efi.htm
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
 #define _FILE_OFFSET_BITS 64
diff --git a/kpartx/gpt.h b/kpartx/gpt.h
index b35320ff..c711a86d 100644
--- a/kpartx/gpt.h
+++ b/kpartx/gpt.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
     gpt.[ch]
 
@@ -6,19 +7,6 @@
     EFI GUID Partition Table handling
     Per Intel EFI Specification v1.02
     http://developer.intel.com/technology/efi/efi.htm
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
 #ifndef GPT_H_INCLUDED
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index ffd3424a..ad5541fb 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -1,5 +1,5 @@
 #!/bin/sh
-#
+# SPDX-License-Identifier: GPL-2.0-only
 # kpartx_id
 #
 # Generates ID information for device-mapper tables.
@@ -8,11 +8,6 @@
 # Author:
 #       Hannes Reinecke <hare@suse.de>
 #
-#
-#       This program is free software; you can redistribute it and/or modify it
-#       under the terms of the GNU General Public License as published by the
-#       Free Software Foundation version 2 of the License.
-#
 # This script generates ID information used to generate persistent symlinks.
 # It relies on the UUID strings generated by the various programs; the name
 # of the tables are of no consequence.
diff --git a/libdmmp/docs/doc-preclean.pl b/libdmmp/docs/doc-preclean.pl
index 9a9a4cef..20309655 100755
--- a/libdmmp/docs/doc-preclean.pl
+++ b/libdmmp/docs/doc-preclean.pl
@@ -1,19 +1,6 @@
 #!/usr/bin/perl
+# SPDX-License-Identifier: GPL-3.0-or-later
 # Copyright (C) 2016 Red Hat, Inc.
-#
-# This program is free software: you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation, either version 3 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program.  If not, see <http://www.gnu.org/licenses/>.
-#
 # Author: Gris Ge <fge@redhat.com>
 
 use strict;
diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 8b9686a6..79550f52 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2017 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 25cd42ec..04080826 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2017 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/libdmmp_misc.c b/libdmmp/libdmmp_misc.c
index 92bbf8d3..47f668ab 100644
--- a/libdmmp/libdmmp_misc.c
+++ b/libdmmp/libdmmp_misc.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2017 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/libdmmp_mp.c b/libdmmp/libdmmp_mp.c
index 1be8ba1a..556e559d 100644
--- a/libdmmp/libdmmp_mp.c
+++ b/libdmmp/libdmmp_mp.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2016 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/libdmmp_path.c b/libdmmp/libdmmp_path.c
index 96a96f4a..46548733 100644
--- a/libdmmp/libdmmp_path.c
+++ b/libdmmp/libdmmp_path.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2016 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/libdmmp_pg.c b/libdmmp/libdmmp_pg.c
index 68f1917f..588d36f8 100644
--- a/libdmmp/libdmmp_pg.c
+++ b/libdmmp/libdmmp_pg.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2016 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index d154146c..5ea3d8a0 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015 - 2016 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  *         Todd Gill <tgill@redhat.com>
  */
diff --git a/libdmmp/test/libdmmp_speed_test.c b/libdmmp/test/libdmmp_speed_test.c
index d91ba50a..855e1305 100644
--- a/libdmmp/test/libdmmp_speed_test.c
+++ b/libdmmp/test/libdmmp_speed_test.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015-2016 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  */
 
diff --git a/libdmmp/test/libdmmp_test.c b/libdmmp/test/libdmmp_test.c
index a940b576..cf17fab5 100644
--- a/libdmmp/test/libdmmp_test.c
+++ b/libdmmp/test/libdmmp_test.c
@@ -1,19 +1,7 @@
+// SPDX-License-Identifier: GPL-3.0-or-later
 /*
  * Copyright (C) 2015-2017 Red Hat, Inc.
  *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, either version 3 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  * Author: Gris Ge <fge@redhat.com>
  */
 
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index a55bf95b..ec74a1d1 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /*
  * Copyright (C) 2015 Red Hat, Inc.
  *
  * This file is part of the device-mapper multipath userspace tools.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2.1
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <stdlib.h>
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index c96fabcf..4097e05c 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /*
  * Copyright (C) 2015 Red Hat, Inc.
  *
  * This file is part of the device-mapper multipath userspace tools.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2.1
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef MPATH_CMD_H_INCLUDED
diff --git a/libmpathutil/msort.c b/libmpathutil/msort.c
index 9df7b267..8107d497 100644
--- a/libmpathutil/msort.c
+++ b/libmpathutil/msort.c
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: LGPL-2.1-or-later
 /* An alternative to qsort, with an identical interface.
    This file is part of the GNU C Library.
    Copyright (C) 1992-2022 Free Software Foundation, Inc.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, see
-   <https://www.gnu.org/licenses/>.  */
+ */
 
 #include <alloca.h>
 #include <stdint.h>
diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index b1db433f..131a5ed0 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Part:        Configuration file parser/reader. Place into the dynamic
  *              data structure representation the conf file
@@ -5,16 +6,6 @@
  * Version:     $Id: parser.c,v 1.0.3 2003/05/11 02:28:03 acassen Exp $
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
- *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
  */
 
 #include <syslog.h>
diff --git a/libmpathutil/parser.h b/libmpathutil/parser.h
index 179aeca8..3d14226b 100644
--- a/libmpathutil/parser.h
+++ b/libmpathutil/parser.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Soft:        Keepalived is a failover program for the LVS project
  *              <www.linuxvirtualserver.org>. It monitor & manipulate
@@ -8,16 +9,6 @@
  * Version:     $Id: parser.h,v 1.0.3 2003/05/11 02:28:03 acassen Exp $
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
- *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
  */
 
 #ifndef PARSER_H_INCLUDED
diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 581631c5..3d54ed9e 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Part:        Vector structure manipulation.
  *
@@ -5,16 +6,6 @@
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
  *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Copyright (c) 2002, 2003, 2004 Alexandre Cassen
  * Copyright (c) 2005 Christophe Varoqui
  */
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 17309e0c..07012776 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Soft:        Keepalived is a failover program for the LVS project
  *              <www.linuxvirtualserver.org>. It monitor & manipulate
@@ -8,16 +9,6 @@
  * Version:     $Id: vector.h,v 1.0.3 2003/05/11 02:28:03 acassen Exp $
  *
  * Author:      Alexandre Cassen, <acassen@linux-vs.org>
- *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
  */
 
 #ifndef VECTOR_H_INCLUDED
diff --git a/libmpathvalid/mpath_valid.h b/libmpathvalid/mpath_valid.h
index de165a2d..9b0aeaa6 100644
--- a/libmpathvalid/mpath_valid.h
+++ b/libmpathvalid/mpath_valid.h
@@ -1,20 +1,8 @@
+// SPDX-License-Identifier: LGPL-2.0-or-later
 /*
  * Copyright (C) 2015 Red Hat, Inc.
  *
  * This file is part of the device-mapper multipath userspace tools.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef MPATH_VALID_H_INCLUDED
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index ea6c7b4f..791af1ec 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2005 Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
@@ -30,18 +31,6 @@
  * significant parts of this file were taken from iscsi-bindings.c of the
  * linux-iscsi project.
  * Copyright (C) 2002 Cisco Systems, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * See the file COPYING included with this distribution for more details.
  */
 
 #define BINDINGS_FILE_HEADER		\
diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index eaf67b35..c89fe5e7 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -1,21 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  *****************************************************************************
  *                                                                           *
  *     (C)  Copyright 2007 Hewlett-Packard Development Company, L.P          *
  *                                                                           *
- * This program is free software; you can redistribute it and/or modify it   *
- * under the terms of the GNU General Public License as published by the Free*
- * Software  Foundation; either version 2 of the License, or (at your option)*
- * any later version.                                                        *
- *                                                                           *
- * This program is distributed in the hope that it will be useful, but       *
- * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY*
- * or FITNESS FOR  A PARTICULAR PURPOSE. See the GNU General Public License  *
- * for more details.                                                         *
- *                                                                           *
- * You should have received a copy of the GNU General Public License along   *
- * with this program.  If not, see <http://www.gnu.org/licenses/>.           *
- *                                                                           *
  *****************************************************************************
 */
 
diff --git a/libmultipath/dm-generic.c b/libmultipath/dm-generic.c
index e49f9bbf..8d7d7953 100644
--- a/libmultipath/dm-generic.c
+++ b/libmultipath/dm-generic.c
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 
 #include <stdint.h>
diff --git a/libmultipath/dm-generic.h b/libmultipath/dm-generic.h
index 9055ce1c..3db3dd42 100644
--- a/libmultipath/dm-generic.h
+++ b/libmultipath/dm-generic.h
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 #ifndef DM_GENERIC_H_INCLUDED
 #define DM_GENERIC_H_INCLUDED
diff --git a/libmultipath/file.c b/libmultipath/file.c
index 72f1d246..ce9ff610 100644
--- a/libmultipath/file.c
+++ b/libmultipath/file.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2005 Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
@@ -22,18 +23,6 @@
  * significant parts of this file were taken from iscsi-bindings.c of the
  * linux-iscsi project.
  * Copyright (C) 2002 Cisco Systems, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * See the file COPYING included with this distribution for more details.
  */
 
 int
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index af5b0ed3..138b2eb3 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
 #include <sys/sysmacros.h>
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 485fb2d8..97c1f8ac 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 #ifndef FOREIGN_H_INCLUDED
 #define FOREIGN_H_INCLUDED
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index cde660ce..0d19303e 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
 
 #include "nvme-lib.h"
diff --git a/libmultipath/generic.c b/libmultipath/generic.c
index e7cf2975..0babd9a6 100644
--- a/libmultipath/generic.c
+++ b/libmultipath/generic.c
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 
 #include "generic.h"
diff --git a/libmultipath/generic.h b/libmultipath/generic.h
index 2e4673be..77183b30 100644
--- a/libmultipath/generic.h
+++ b/libmultipath/generic.h
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 #ifndef GENERIC_H_INCLUDED
 #define GENERIC_H_INCLUDED
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 879c310a..64054c18 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.
  *
@@ -7,8 +8,6 @@
  * IO error stream statistic process for path failure event from kernel
  *
  * Author(s): Guan Junxiong 2017 <guanjunxiong@huawei.com>
- *
- * This file is released under the GPL version 2, or any later version.
  */
 
 #include <unistd.h>
diff --git a/libmultipath/list.h b/libmultipath/list.h
index 8f485209..58eecdcc 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -1,8 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copied from the Linux kernel source tree, version 2.6.0-test1.
  *
- * Licensed under the GPL v2 as per the whole kernel source tree.
- *
  */
 
 #ifndef LIST_H_INCLUDED
diff --git a/libmultipath/nvme/argconfig.h b/libmultipath/nvme/argconfig.h
index e6c54453..b3caa7be 100644
--- a/libmultipath/nvme/argconfig.h
+++ b/libmultipath/nvme/argconfig.h
@@ -1,21 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 ////////////////////////////////////////////////////////////////////////
 //
 // Copyright 2014 PMC-Sierra, Inc.
 //
-// This program is free software; you can redistribute it and/or
-// modify it under the terms of the GNU General Public License
-// as published by the Free Software Foundation; either version 2
-// of the License, or (at your option) any later version.
-//
-// This program is distributed in the hope that it will be useful,
-// but WITHOUT ANY WARRANTY; without even the implied warranty of
-// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-// GNU General Public License for more details.
-//
-// You should have received a copy of the GNU General Public License
-// along with this program; if not, write to the Free Software
-// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-//
 ////////////////////////////////////////////////////////////////////////
 
 ////////////////////////////////////////////////////////////////////////
diff --git a/libmultipath/nvme/linux/nvme.h b/libmultipath/nvme/linux/nvme.h
index f0cb2905..6ce8d22d 100644
--- a/libmultipath/nvme/linux/nvme.h
+++ b/libmultipath/nvme/linux/nvme.h
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Definitions for the NVM Express interface
  * Copyright (c) 2011-2014, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
  */
 
 #ifndef LINUX_NVME_H_INCLUDED
diff --git a/libmultipath/nvme/linux/nvme_ioctl.h b/libmultipath/nvme/linux/nvme_ioctl.h
index 3f6623c8..cae173d9 100644
--- a/libmultipath/nvme/linux/nvme_ioctl.h
+++ b/libmultipath/nvme/linux/nvme_ioctl.h
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Definitions for the NVM Express ioctl interface
  * Copyright (c) 2011-2014, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
  */
 
 #ifndef LINUX_NVME_IOCTL_H_INCLUDED
diff --git a/libmultipath/nvme/nvme.h b/libmultipath/nvme/nvme.h
index 019bce1b..ab71cea9 100644
--- a/libmultipath/nvme/nvme.h
+++ b/libmultipath/nvme/nvme.h
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Definitions for the NVM Express interface
  * Copyright (c) 2011-2014, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
  */
 
 #ifndef NVME_NVME_H_INCLUDED
diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index e9827dca..34527b22 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * (C) Copyright HUAWEI Technology Corp. 2017   All Rights Reserved.
  *
@@ -9,8 +10,6 @@
  *
  * Author(s): Cheng Jike <chengjike.cheng@huawei.com>
  *            Li Jie <lijie34@huawei.com>
- *
- * This file is released under the GPL version 2, or any later version.
  */
 #include <stdio.h>
 #include <sys/ioctl.h>
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index f288306c..ab813a0e 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * (C) 2010 Christophe Varoqui
  * (C) 2009 Dembach Goo Informatik GmbH & Co KG
@@ -9,9 +10,6 @@
  * This program was inspired by work from
  * Matthias Rudolph <matthias.rudolph@hds.com>
  *
- * This work is made available on the basis of the
- * GPLv2 for details see <http://www.gnu.org/licenses/>.
- *
  * Manon Goo 2009
  *
  *
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 90eaf274..03ca28e5 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -1,15 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright 2005 Network Appliance, Inc., All Rights Reserved
  * Author:  David Wysochanski available at davidw@netapp.com
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License v2 for more details.
  */
 
 #include <stdio.h>
diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index f4142577..11ffa684 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * (C) Copyright HUAWEI Technology Corp. 2017, All Rights Reserved.
  *
@@ -16,8 +17,6 @@
  *
  * Author(s): Yang Feng <philip.yang@huawei.com>
  * Revised:   Guan Junxiong <guanjunxiong@huawei.com>
- *
- * This file is released under the GPL version 2, or any later version.
  */
 
 #define _GNU_SOURCE
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index b2c1ce02..af27d107 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2005-2006 Kay Sievers <kay.sievers@vrfy.org>
- *
- *	This program is free software; you can redistribute it and/or modify it
- *	under the terms of the GNU General Public License as published by the
- *	Free Software Foundation version 2 of the License.
- *
- *	This program is distributed in the hope that it will be useful, but
- *	WITHOUT ANY WARRANTY; without even the implied warranty of
- *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *	General Public License for more details.
- *
- *	You should have received a copy of the GNU General Public License along
- *	with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  */
 
 
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 32135d7e..63cf2fbc 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * uevent.c - trigger upon netlink uevents from the kernel
  *
@@ -7,19 +8,6 @@
  *	  gcc -I /lib/modules/`uname -r`/build/include -o uevent_listen uevent_listen.c
  *
  * Copyright (C) 2004 Kay Sievers <kay.sievers@vrfy.org>
- *
- *	This program is free software; you can redistribute it and/or modify it
- *	under the terms of the GNU General Public License as published by the
- *	Free Software Foundation version 2 of the License.
- *
- *	This program is distributed in the hope that it will be useful, but
- *	WITHOUT ANY WARRANTY; without even the implied warranty of
- *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *	General Public License for more details.
- *
- *	You should have received a copy of the GNU General Public License along
- *	with this program.  If not, see <http://www.gnu.org/licenses/>.
- *
  */
 
 #include <unistd.h>
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index f23ee6b2..7bf86160 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2020 Benjamin Marzinski, IBM
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 #include <stddef.h>
 #include <errno.h>
diff --git a/libmultipath/valid.h b/libmultipath/valid.h
index 96ba5545..3483ec06 100644
--- a/libmultipath/valid.h
+++ b/libmultipath/valid.h
@@ -1,18 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
   Copyright (c) 2020 Benjamin Marzinski, IBM
-
-  This program is free software; you can redistribute it and/or
-  modify it under the terms of the GNU General Public License
-  as published by the Free Software Foundation; either version 2
-  of the License, or (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
 #ifndef VALID_H_INCLUDED
 #define VALID_H_INCLUDED
diff --git a/libmultipath/version.h b/libmultipath/version.h
index 4a721eda..7d92bb84 100644
--- a/libmultipath/version.h
+++ b/libmultipath/version.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Soft:        multipath device mapper target autoconfig
  *
@@ -5,16 +6,6 @@
  *
  * Author:      Christophe Varoqui
  *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Copyright (c) 2006 Christophe Varoqui
  */
 #ifndef VERSION_H_INCLUDED
diff --git a/multipath/main.c b/multipath/main.c
index 9967dc6d..f2adcdeb 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Soft:        multipath device mapper target autoconfig
  *
@@ -5,16 +6,6 @@
  *
  * Author:      Christophe Varoqui
  *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Copyright (c) 2003, 2004, 2005 Christophe Varoqui
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
diff --git a/tests/blacklist.c b/tests/blacklist.c
index ba8dfd07..ab3da619 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 Benjamin Marzinski, Redhat
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 #include <stdarg.h>
 #include <stddef.h>
diff --git a/tests/directio.c b/tests/directio.c
index 36282227..53444344 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 Benjamin Marzinski, Redhat
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #define _GNU_SOURCE
diff --git a/tests/dmevents.c b/tests/dmevents.c
index 2f98173c..6df4f036 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 Benjamin Marzinski, Redhat
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #include <pthread.h>
diff --git a/tests/parser.c b/tests/parser.c
index cf96d81f..efa7bf2b 100644
--- a/tests/parser.c
+++ b/tests/parser.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 SUSE Linux GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #include <stdbool.h>
diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index ccf29bc9..fb956d14 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 Benjamin Marzinski, Redhat
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #include <stdint.h>
diff --git a/tests/uevent.c b/tests/uevent.c
index 6a010ab2..39f5dbdd 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 SUSE Linux GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #include <stdbool.h>
diff --git a/tests/util.c b/tests/util.c
index 4850ddcb..da192ba6 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2018 Benjamin Marzinski, Redhat
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #define _GNU_SOURCE
diff --git a/tests/valid.c b/tests/valid.c
index c5a1eac0..3f15ce66 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -1,19 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2020 Benjamin Marzinski, Redhat
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <https://www.gnu.org/licenses/>.
- *
  */
 
 #define _GNU_SOURCE
-- 
2.50.0

