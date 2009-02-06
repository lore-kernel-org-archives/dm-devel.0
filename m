From: Atsushi SAKAI <sakaia@jp.fujitsu.com>
Subject: [PATCH] fix typo in FSF address
Date: Fri, 06 Feb 2009 18:02:38 +0900
Message-ID: <20090206090240.7E51D480002@m022.s.css.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Device Mapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

 I found a typo Bosto"m" in FSF address.
And I am checking around linux source code.
Here is the only place which uses Bosto"m" (not Boston).

Signed-off-by: Atsushi SAKAI <sakaia@jp.fujitsu.com>

Thanks
Atsushi SAKAI


---
 drivers/md/raid6.h         |    2 +-
 drivers/md/raid6algos.c    |    2 +-
 drivers/md/raid6altivec.uc |    2 +-
 drivers/md/raid6int.uc     |    2 +-
 drivers/md/raid6mmx.c      |    2 +-
 drivers/md/raid6recov.c    |    2 +-
 drivers/md/raid6sse1.c     |    2 +-
 drivers/md/raid6sse2.c     |    2 +-
 drivers/md/raid6x86.h      |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid6.h b/drivers/md/raid6.h
index 98dcde8..3090646 100644
--- a/drivers/md/raid6.h
+++ b/drivers/md/raid6.h
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6algos.c b/drivers/md/raid6algos.c
index 21987e3..1f6a3c8 100644
--- a/drivers/md/raid6algos.c
+++ b/drivers/md/raid6algos.c
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6altivec.uc b/drivers/md/raid6altivec.uc
index b9afd35..2175806 100644
--- a/drivers/md/raid6altivec.uc
+++ b/drivers/md/raid6altivec.uc
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6int.uc b/drivers/md/raid6int.uc
index ad004ce..32a0bac 100644
--- a/drivers/md/raid6int.uc
+++ b/drivers/md/raid6int.uc
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6mmx.c b/drivers/md/raid6mmx.c
index d4e4a1b..804cb50 100644
--- a/drivers/md/raid6mmx.c
+++ b/drivers/md/raid6mmx.c
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6recov.c b/drivers/md/raid6recov.c
index a8c4d94..7a98b86 100644
--- a/drivers/md/raid6recov.c
+++ b/drivers/md/raid6recov.c
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6sse1.c b/drivers/md/raid6sse1.c
index 0666237..15c5889 100644
--- a/drivers/md/raid6sse1.c
+++ b/drivers/md/raid6sse1.c
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6sse2.c b/drivers/md/raid6sse2.c
index b034ad8..2e92e96 100644
--- a/drivers/md/raid6sse2.c
+++ b/drivers/md/raid6sse2.c
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
diff --git a/drivers/md/raid6x86.h b/drivers/md/raid6x86.h
index 99fea7a..4c22c15 100644
--- a/drivers/md/raid6x86.h
+++ b/drivers/md/raid6x86.h
@@ -5,7 +5,7 @@
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
  *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
  *   (at your option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
-- 
1.5.2.2
