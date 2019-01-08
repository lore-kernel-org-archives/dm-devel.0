From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] multipath_tools: remove ENABLE_RADOS
Date: Tue,  8 Jan 2019 12:32:46 +0100
Message-ID: <20190108113246.5903-4-mwilck@suse.com>
References: <20190108113246.5903-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108113246.5903-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This is pointless since we removed RBD support altogether.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 23154fed..fc728ca9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -9,9 +9,6 @@
 # WITH_LOCAL_LIBDM	= 1
 # WITH_LOCAL_LIBSYSFS	= 1
 #
-# Uncomment to disable RADOS support (e.g. if rados headers are missing).
-# ENABLE_RADOS = 0
-#
 # Uncomment to disable libdmmp support
 # ENABLE_LIBDMMP = 0
 #
-- 
2.19.2
