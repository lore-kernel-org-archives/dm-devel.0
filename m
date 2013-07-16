From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/30] Document 'infinity' as possible value for
	dev_loss_tmo
Date: Tue, 16 Jul 2013 09:12:53 +0200
Message-ID: <1373958801-103613-3-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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

infinity is a valid value for dev_loss_tmo, so we should be
documenting it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath.conf.annotated | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 488720c..09ed632 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -248,9 +248,10 @@
 #	# desc    : The number of seconds the scsi layer will wait after a
 #	#           problem has been detected on a FC remote port before
 #	#           removing it from the system.
-#	# values  : n > 0
+#	# values  : infinity | n > 0
 #	# default : determined by the OS
 #	dev_loss_tmo 600
+#
 #	# name    : bindings_file
 #	# scope   : multipath
 #	# desc    : The location of the bindings file that is used with
-- 
1.7.12.4
