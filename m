From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/29] multipath.conf.annotated: remove 'udev_dir'
Date: Mon, 15 Jul 2013 15:00:22 +0200
Message-ID: <1373893230-26077-22-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Deprecated, remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath.conf.annotated |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 7ed62de..a20302c 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -9,13 +9,6 @@
 ##
 #defaults {
 #	#
-#	# name    : udev_dir
-#	# desc    : directory where udev creates its device nodes
-#	# default : /dev
-#	#
-#	udev_dir	/dev
-#
-#	#
 #	# name    : polling_interval
 #	# scope   : multipathd
 #	# desc    : interval between two path checks in seconds. For
-- 
1.7.10.4
