From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: another manpage update
Date: Fri, 10 Feb 2012 12:18:38 -0600
Message-ID: <20120210181838.GR1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Missed an option with my last manpage update.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: multipath-tools-120123/multipath/multipath.conf.5
===================================================================
--- multipath-tools-120123.orig/multipath/multipath.conf.5
+++ multipath-tools-120123/multipath/multipath.conf.5
@@ -333,7 +333,9 @@ will disable the timeout.
 .TP
 .B dev_loss_tmo
 Specify the number of seconds the scsi layer will wait after a problem has
-been detected on a FC remote port before removing it from the system.
+been detected on a FC remote port before removing it from the system. This
+can be set to "infinity" which sets it to the max value of 2147483647
+seconds, or 68 years.
 .TP
 .B queue_without_daemon
 If set to
