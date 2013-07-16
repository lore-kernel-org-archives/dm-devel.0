From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/30] Update multipath.conf.defaults
Date: Tue, 16 Jul 2013 09:13:09 +0200
Message-ID: <1373958801-103613-19-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath.conf.defaults | 110 +++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 48 deletions(-)

diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index cd13369..f278f1f 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -4,6 +4,7 @@
 #defaults {
 #	verbosity 2
 #	polling_interval 5
+#	multipath_dir "/lib64/multipath"
 #	path_selector "service-time 0"
 #	path_grouping_policy "failover"
 #	uid_attribute "ID_SERIAL"
@@ -12,9 +13,10 @@
 #	features "0"
 #	path_checker "directio"
 #	alias_prefix "mpath"
+#	failback "manual"
 #	rr_min_io 1000
 #	rr_min_io_rq 1
-#	max_fds 1048576
+#	max_fds "max"
 #	rr_weight "uniform"
 #	queue_without_daemon "yes"
 #	flush_on_last_del "no"
@@ -78,7 +80,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "const"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -143,7 +145,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 12
 #		rr_min_io 100
@@ -156,7 +158,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 12
 #		rr_min_io 100
@@ -169,7 +171,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "const"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 18
 #		rr_min_io 100
@@ -182,7 +184,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 18
 #		rr_min_io 100
@@ -195,7 +197,7 @@
 #		features "0"
 #		hardware_handler "1 alua"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 12
 #		rr_min_io 100
@@ -219,7 +221,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 18
 #		rr_min_io 100
@@ -254,7 +256,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "1 emc"
 #		prio "emc"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 60
 #	}
@@ -288,7 +290,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 10
 #	}
@@ -310,7 +312,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "0"
 #		prio "hds"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -332,7 +334,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 300
 #	}
@@ -345,7 +347,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 300
 #	}
@@ -358,7 +360,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 300
 #	}
@@ -371,7 +373,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -384,7 +386,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -397,7 +399,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -410,7 +412,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -423,7 +425,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -436,7 +438,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -478,7 +480,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -499,7 +501,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -534,7 +536,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "1 alua"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -545,7 +547,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #		rr_min_io 100
@@ -570,7 +572,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "const"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 60
 #	}
@@ -582,7 +584,7 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "const"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 60
 #	}
@@ -594,7 +596,7 @@
 #		features "0"
 #		hardware_handler "1 alua"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 60
 #	}
@@ -607,7 +609,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -620,7 +622,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -633,7 +635,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -646,7 +648,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -658,13 +660,13 @@
 #		features "3 queue_if_no_path pg_init_retries 50"
 #		hardware_handler "0"
 #		prio "ontap"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		rr_min_io 128
 #		flush_on_last_del "yes"
 #		dev_loss_tmo "infinity"
-#		retain_attached_hw_handler yes
-#		detect_prio yes
+#		retain_attached_hw_handler "yes"
+#		detect_prio "yes"
 #	}
 #	device {
 #		vendor "NEXENTA"
@@ -674,7 +676,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "0"
 #		prio "const"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 30
 #		rr_min_io 128
@@ -687,7 +689,7 @@
 #		features "1 queue_if_no_path"
 #		hardware_handler "0"
 #		prio "ontap"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		rr_min_io 128
 #	}
@@ -720,7 +722,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -733,7 +735,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -745,7 +747,7 @@
 #		features "0"
 #		hardware_handler "1 alua"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -757,7 +759,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -778,7 +780,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #	}
 #	device {
@@ -811,7 +813,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -824,7 +826,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -836,7 +838,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #		rr_min_io 1000
@@ -851,7 +853,7 @@
 #		features "2 pg_init_retries 50"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 15
 #	}
@@ -864,7 +866,7 @@
 #		features "0"
 #		hardware_handler "1 rdac"
 #		prio "rdac"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -876,7 +878,7 @@
 #		features "0"
 #		hardware_handler "1 alua"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
@@ -888,7 +890,19 @@
 #		features "0"
 #		hardware_handler "0"
 #		prio "alua"
-#		failback immediate
+#		failback "immediate"
+#		rr_weight "uniform"
+#		no_path_retry "queue"
+#	}
+#	device {
+#		vendor "DataCore"
+#		product "Virtual Disk"
+#		path_grouping_policy "group_by_prio"
+#		path_checker "tur"
+#		features "0"
+#		hardware_handler "0"
+#		prio "alua"
+#		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry "queue"
 #	}
-- 
1.7.12.4
