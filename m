From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] multipath-tools: fix wrong annotation about
	default value
Date: Fri, 11 Jan 2008 18:15:43 -0500 (EST)
Message-ID: <20080111.181543.34766095.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

This patch fixes some wrong annotations about default value.
It should be applied on top of your latest git.

Thanks,
Kiyoshi Ueda

--- git/multipath.conf.annotated	2008-01-11 17:46:17.000000000 -0500
+++ fix/multipath.conf.annotated	2008-01-11 17:57:48.000000000 -0500
@@ -38,7 +38,7 @@
 #	# scope   : multipath
 #	# desc    : the default path grouping policy to apply to unspecified
 #	#           multipaths
-#	# default : multibus
+#	# default : failover
 #	#
 #	path_grouping_policy	multibus
 #
@@ -96,7 +96,7 @@
 #	#	    0 means immediate failback, values >0 means deffered failback
 #	#	    expressed in seconds.
 #	# values  : manual|immediate|n > 0
-#	# default : immediate
+#	# default : manual
 #	#
 #	failback	manual
 #
@@ -219,7 +219,7 @@
 #		#	    0 means immediate failback, values >0 means deffered failback
 #		#	    expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : immediate
+#		# default : manual
 #		#
 #		failback		manual
 #
@@ -330,7 +330,7 @@
 #		#	    0 means immediate failback, values >0 means deffered failback
 #		#	    expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : immediate
+#		# default : manual
 #		#
 #		failback		30
 #
