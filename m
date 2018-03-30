From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/6] mpathcmd: fix libmpathcmd license
Date: Thu, 29 Mar 2018 22:37:02 -0500
Message-ID: <1522381023-15262-6-git-send-email-bmarzins@redhat.com>
References: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522381023-15262-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "tang.junhui" <tang.junhui@zte.com.cn>, Gris Ge <fge@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

There is no version 2 of the GNU Lesser General Public License, so
change the license header to version 2.1, which does exist. Also copy
the license header to mpath_cmd.c. I've CC'ed everyone who has
contributed code to libmpathcmd.

Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: tang.junhui <tang.junhui@zte.com.cn>
Cc: Gris Ge <fge@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathcmd/mpath_cmd.c | 19 +++++++++++++++++++
 libmpathcmd/mpath_cmd.h |  2 +-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 29d148c..61e6a98 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -1,3 +1,22 @@
+/*
+ * Copyright (C) 2015 Red Hat, Inc.
+ *
+ * This file is part of the device-mapper multipath userspace tools.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index b57b708..aaa8da9 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -5,7 +5,7 @@
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2
+ * as published by the Free Software Foundation; either version 2.1
  * of the License, or (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
-- 
2.7.4
