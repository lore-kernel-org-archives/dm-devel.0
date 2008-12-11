From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/6] config file cleanup and a defaults file
Date: Thu, 11 Dec 2008 16:07:25 -0600
Message-ID: <20081211220725.GK1585@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch cleans up multipath.conf.annotated and multipath.conf.synthetic adds
a multipath.conf.defaults file that lists the builtin default configs.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath.conf.annotated |  159 +++++++++----
 multipath.conf.defaults  |  574 +++++++++++++++++++++++++++++++++++++++++++++++
 multipath.conf.synthetic |    3 
 3 files changed, 691 insertions(+), 45 deletions(-)

Index: multipath-tools-081203/multipath.conf.annotated
===================================================================
--- multipath-tools-081203.orig/multipath.conf.annotated
+++ multipath-tools-081203/multipath.conf.annotated
@@ -19,6 +19,7 @@
 #	# name    : polling_interval
 #	# scope   : multipathd
 #	# desc    : interval between two path checks in seconds
+#	# values  : n > 0
 #	# default : 5
 #	#
 #	polling_interval 10
@@ -38,6 +39,13 @@
 #	# scope   : multipath
 #	# desc    : the default path grouping policy to apply to unspecified
 #	#           multipaths
+#	# values  : failover           = 1 path per priority group
+#	#           multibus           = all valid paths in 1 priority group
+#	#           group_by_serial    = 1 priority group per detected serial
+#	#                                number
+#	#           group_by_prio      = 1 priority group per path priority
+#	#                                value
+#	#           group_by_node_name = 1 priority group per target node name
 #	# default : failover
 #	#
 #	path_grouping_policy	multibus
@@ -59,16 +67,27 @@
 #	#           exploitable prio value for example.
 #	# default : (null)
 #	#
-#	#prio	"alua"
+#	prio	"alua"
 #
 #	#
-#	# name    : path_checker
+#	# name    : features
+#	# scope   : multipath
+#	# desc    : The default extra features of multipath devices. The
+#	#           only existing feature currently is queue_if_no_path, which
+#	#           is the same as setting no_path_retry to queue.
+#	# values  : "1 queue_if_no_path"
+#	# default : (null)
+#	#
+#	features	"1 queue_if_no_path"
+#
+#	#
+#	# name    : path_checker, checker
 #	# scope   : multipath & multipathd
 #	# desc    : the default method used to determine the paths' state
-#	# values  : readsector0|tur|emc_clariion|hp_sw|directio
+#	# values  : readsector0|tur|emc_clariion|hp_sw|directio|rdac|cciss_tur
 #	# default : directio
 #	#
-#	#path_checker	directio
+#	path_checker	directio
 #
 #	#
 #	# name    : rr_min_io
@@ -103,8 +122,8 @@
 #	# name    : failback
 #	# scope   : multipathd
 #	# desc    : tell the daemon to manage path group failback, or not to.
-#	#	    0 means immediate failback, values >0 means deffered failback
-#	#	    expressed in seconds.
+#	#	    0 means immediate failback, values >0 means deffered
+#	#           failback expressed in seconds.
 #	# values  : manual|immediate|n > 0
 #	# default : manual
 #	#
@@ -119,7 +138,7 @@
 #	# values  : queue|fail|n (>0)
 #	# default : (null)
 #	#
-#	#no_path_retry  queue
+#	no_path_retry  queue
 #
 #	#
 #	# name    : user_friendly_names
@@ -140,13 +159,16 @@
 ## name    : blacklist
 ## scope   : multipath & multipathd
 ## desc    : list of device names to discard as not multipath candidates
-## default : cciss, fd, hd, md, dm, sr, scd, st, ram, raw, loop
+##           Devices can be identified by their device node name "devnode",
+##           their WWID "wwid", or their vender and product strings
+##           "device"
+## default : fd, hd, md, dm, sr, scd, st, ram, raw, loop, dcssblk
 ##
 #blacklist {
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
-#	devnode "^hd[a-z][[0-9]*]"
-#	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
+#	devnode "^hd[a-z]"
+#	devnode "^dcssblk[0-9]*"
 #       device {
 #               vendor DEC.*
 #               product MSA[15]00
@@ -200,47 +222,60 @@
 #		# scope   : multipath
 #		# desc    : path grouping policy to apply to this multipath
 #		# values  : failover, multibus, group_by_serial
-#		# default : failover
+#		# values  : failover           = 1 path per priority group
+#		#           multibus           = all valid paths in 1 priority
+#		#                                group
+#		#           group_by_serial    = 1 priority group per detected
+#		#                                serial number
+#		#           group_by_prio      = 1 priority group per path
+#		#                                priority value
+#		#           group_by_node_name = 1 priority group per target
+#		#                                node name
 #		#
-#		path_grouping_policy	multibus
+#		path_grouping_policy	failover
 #
 #		#
 #		# name    : path_selector
 #		# desc    : the path selector algorithm to use for this mpath
 #		#           these algo are offered by the kernel mpath target
 #		# values  : "round-robin 0"
-#		# default : "round-robin 0"
 #		#
 #		path_selector		"round-robin 0"
 #
 #		#
 #		# name    : failback
 #		# scope   : multipathd
-#		# desc    : tell the daemon to manage path group failback, or not to.
-#		#	    0 means immediate failback, values >0 means deffered failback
-#		#	    expressed in seconds.
+#		# desc    : tell the daemon to manage path group failback, or
+#		#	    not to. 0 means immediate failback, values >0 means
+#		#	    deffered failback expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : manual
 #		#
-#		failback		immediate
+#		failback		manual
+#
+#		#
+#		# name    : rr_weight
+#		# scope   : multipath
+#		# desc    : if set to priorities the multipath configurator will
+#		#	    assign path weights as "path prio * rr_min_io"
+#		# values  : priorities|uniform
+#		#
+#		rr_weight	priorities
 #
 #		#
 #		# name    : no_path_retry
 #		# scope   : multipath & multipathd
-#		# desc    : tell the number of retries until disable queueing, or
-#		#           "fail" means immediate failure (no queueing),
+#		# desc    : tell the number of retries until disable queueing,
+#		#           or "fail" means immediate failure (no queueing),
 #		#           "queue" means never stop queueing
 #		# values  : queue|fail|n (>0)
-#		# default : (null)
 #		#
-#		#no_path_retry  queue
+#		no_path_retry  queue
 #
 #		#
 #		# name    : rr_min_io
 #		# scope   : multipath
 #		# desc    : the number of IO to route to a path before switching
 #		#           to the next in the same path group
-#		# default : 1000
 #		#
 #		rr_min_io	100
 #	}
@@ -276,23 +311,25 @@
 #		#
 #		# name    : path_grouping_policy
 #		# scope   : multipath
-#		# desc    : path grouping policy to apply to multipath hosted
-#		#           by this storage controller
-#		# values  : failover        = 1 path per priority group
-#		#           multibus        = all valid paths in 1 priority
-#		#                             group
-#		#           group_by_serial = 1 priority group per detected
-#		#                             serial number
-#		# default : failover
+#		# desc    : path grouping policy to apply to this multipath
+#		# values  : failover, multibus, group_by_serial
+#		# values  : failover           = 1 path per priority group
+#		#           multibus           = all valid paths in 1 priority
+#		#                                group
+#		#           group_by_serial    = 1 priority group per detected
+#		#                                serial number
+#		#           group_by_prio      = 1 priority group per path
+#		#                                priority value
+#		#           group_by_node_name = 1 priority group per target
+#		#                                node name
 #		#
-#		path_grouping_policy	multibus
+#		path_grouping_policy	failover
 #
 #		#
 #		# name    : getuid_callout
 #		# scope   : multipath
 #		# desc    : the program and args to callout to obtain a unique 
 #		#           path identifier. Absolute path required
-#		# default : /lib/udev/scsi_id -g -u -s
 #		#
 #		getuid_callout          "/lib/udev/scsi_id -g -u -d /dev/%n"
 #
@@ -307,11 +344,11 @@
 #		prio          "hp_sw"
 #
 #		#
-#		# name    : path_checker
+#		# name    : path_checker, checker
 #		# scope   : multipathd
 #		# desc    : path checking alorithm to use to check path state
-#		# values  : readsector0|tur|emc_clariion|hp_sw|directio
-#		# default : directio
+#		# values  : readsector0|tur|emc_clariion|hp_sw|directio|rdac|
+#		#           cciss_tur
 #		#
 #		path_checker		directio
 #
@@ -320,27 +357,64 @@
 #		# desc    : the path selector algorithm to use for this mpath
 #		#           these algo are offered by the kernel mpath target
 #		# values  : "round-robin 0"
-#		# default : "round-robin 0"
 #		#
 #		path_selector		"round-robin 0"
 #
 #		#
+#		# name    : features
+#		# scope   : multipath
+#		# desc    : The extra features of multipath devices. The only
+#		#           existing feature currently is queue_if_no_path,
+#		#           which is the same as setting no_path_retry to queue.
+#		# values  : "1 queue_if_no_path"
+#		#
+#		features	"1 queue_if_no_path"
+#
+#		#
+#		# name    : hardware_handler
+#		# scope   : multipath
+#		# desc    : If set, it specifies a module that will be used to
+#		#           perform hardware specific actions when switching
+#		#	    path groups or handling IO errors
+#		# values  : "0"|"1 emc"
+#		# default : "0"
+#		#
+#		hardware_handler "1 emc"
+#
+#		#
 #		# name    : failback
 #		# scope   : multipathd
-#		# desc    : tell the daemon to manage path group failback, or not to.
-#		#	    0 means immediate failback, values >0 means deffered failback
-#		#	    expressed in seconds.
+#		# desc    : tell the daemon to manage path group failback, or
+#		#	    not to. 0 means immediate failback, values >0 means
+#		#	    deffered failback expressed in seconds.
 #		# values  : manual|immediate|n > 0
-#		# default : manual
 #		#
 #		failback		30
 #
 #		#
+#		# name    : rr_weight
+#		# scope   : multipath
+#		# desc    : if set to priorities the multipath configurator will
+#		#           assign path weights as "path prio * rr_min_io"
+#		# values  : priorities|uniform
+#		#
+#		rr_weight	priorities
+#
+#		#
+#		# name    : no_path_retry
+#		# scope   : multipath & multipathd
+#		# desc    : tell the number of retries until disable queueing,
+#		#           or "fail" means immediate failure (no queueing),
+#		#           "queue" means never stop queueing
+#		# values  : queue|fail|n (>0)
+#		#
+#		no_path_retry  queue
+#
+#		#
 #		# name    : rr_min_io
 #		# scope   : multipath
 #		# desc    : the number of IO to route to a path before switching
 #		#           to the next in the same path group
-#		# default : 1000
 #		#
 #		rr_min_io	100
 #
@@ -348,7 +422,6 @@
 #		# name    : product_blacklist
 #		# scope   : multipath & multipathd
 #		# desc    : product strings to blacklist for this vendor
-#		# default : none
 #		#
 #		product_blacklist	LUN_Z
 #	}
Index: multipath-tools-081203/multipath.conf.defaults
===================================================================
--- /dev/null
+++ multipath-tools-081203/multipath.conf.defaults
@@ -0,0 +1,574 @@
+# These are the compiled in default settings.  They will be used unless you
+# overwrite these values in your config file.
+
+#defaults {
+#	udev_dir		/dev
+#	polling_interval	5
+#	selector		"round-robin 0"
+#	path_grouping_policy	failover
+#	getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#	prio			const
+#	path_checker		directio
+#	rr_min_io		1000
+#	rr_weight		uniform
+#	failback		manual
+#	no_path_retry		fail
+#	user_friendly_names	no
+#}
+#
+#blacklist {
+#	devnode	"^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
+#	devnode	"^hd[a-z]"
+#	devnode	"^dcssblk[0-9]*"
+#}
+#
+#devices {
+#	device {
+#		vendor			"APPLE*"
+#		product			"Xserve RAID"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"3PARdata"
+#		product			"VV"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"DEC"
+#		product			"HSG80"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"1 hp-sw"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		hp_sw
+#		prio			hp_sw
+#	}
+#	device {
+#		vendor			"HP"
+#		product			"A6189A"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"(COMPAQ|HP)"
+#		product			"(MSA|HSV)1.0.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"1 hp-sw"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		hp_sw
+#		prio			hp_sw
+#	}
+#	device {
+#		vendor			"HP"
+#		product			"MSA VOLUME"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			alua
+#	}
+#	device {
+#		vendor			"HP"
+#		product			"MSA2000s*"
+#		getuid_callout		"/sbin/cciss_id %n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"(COMPAQ|HP)"
+#		product			"HSV1[01]1|HSV2[01]0|HSV300"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			alua
+#	}
+#	device {
+#		vendor			"HP"
+#		product			"MSA2[02]12*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"HP"
+#		product			"LOGICAL VOLUME.*"
+#		getuid_callout		"/lib/udev/scsi_id -n -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"DDN"
+#		product			"SAN DataDirector"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"EMC"
+#		product			"SYMMETRIX"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -ppre-spc3-83 -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"DGC"
+#		product			".*"
+#		product_blacklist	"LUNZ"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"1 emc"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		60
+#		rr_min_io		1000
+#		path_checker		emc_clariion
+#		prio			emc
+#	}
+#	device {
+#		vendor			"FSC"
+#		product			"CentricStor"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_serial
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"(HITACHI|HP)"
+#		product			"OPEN-.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		100
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"HITACHI"
+#		product			"DF.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			hds
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"ProFibre 4000R"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		readsector0
+#		prio			const
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"1722-600"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		300
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"1742"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"1814"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"1815"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"3526"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"3542"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_serial
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"2105(800|F20)"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_serial
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"1750500"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			alua
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"2107900"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"2145"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			alua
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"S/390 DASD ECKD"
+#		product_blacklist	"S/390.*"
+#		getuid_callout		"/sbin/dasdinfo -u -b %n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"NETAPP"
+#		product			"LUN.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		128
+#		path_checker		directio
+#		prio			netapp
+#	}
+#	device {
+#		vendor			"IBM"
+#		product			"Nseries.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		128
+#		path_checker		directio
+#		prio			netapp
+#	}
+#	device {
+#		vendor			"Pillar"
+#		product			"Axiom.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			alua
+#	}
+#	device {
+#		vendor			"SGI"
+#		product			"TP9[13]00"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"SGI"
+#		product			"TP9[45]00"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"SGI"
+#		product			"IS.*"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"STK"
+#		product			"OPENstorage D280"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"SUN"
+#		product			"(StorEdge 3510|T4)"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#		prio			const
+#	}
+#	device {
+#		vendor			"PIVOT3"
+#		product			"RAIGE VOLUME"
+#		getuid_callout		"/sbin/scsi_id -p 0x80 -g -u -s /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			const
+#	}
+#	device {
+#		vendor			"SUN"
+#		product			"CSM200_R"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#	device {
+#		vendor			"SUN"
+#		product			"LCSM100_F"
+#		getuid_callout		"/lib/udev/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#		path_checker		rdac
+#		prio			rdac
+#	}
+#}
Index: multipath-tools-081203/multipath.conf.synthetic
===================================================================
--- multipath-tools-081203.orig/multipath.conf.synthetic
+++ multipath-tools-081203/multipath.conf.synthetic
@@ -21,7 +21,6 @@
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z][[0-9]*]"
-#	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
 #	device {
 #		vendor DEC.*
 #		product MSA[15]00
@@ -60,7 +59,7 @@
 #		rr_weight		priorities
 #		no_path_retry		queue
 #		rr_min_io		100
-#		product_blacklist	LUN_Z
+#		product_blacklist	LUNZ
 #	}
 #	device {
 #		vendor			"COMPAQ  "
