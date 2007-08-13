From: joe@perches.com
Subject: [PATCH] [153/2many] MAINTAINERS - DEVICE-MAPPER  (LVM)
Date: Sun, 12 Aug 2007 23:26:14 -0700
Message-ID: <46bff986.szARdClTcYqQa8So%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S967765AbXHMHn4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ea991f0..36a7d25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1472,6 +1472,7 @@ P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 S:	Maintained
+F:	drivers/md/dm*
 
 DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
