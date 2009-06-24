From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: [PATCH multipath-tools-0.4.7.rhel5.13] Re: multipathd
	configuration for Sun StorageTek 2510
Date: Wed, 24 Jun 2009 17:04:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906241700480.22601@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906231512040.18393@e-smith.charlieb.ott.istop.com>
	<1245868230.26915.22.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245868230.26915.22.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Wed, 24 Jun 2009, Chandra Seetharaman wrote:

> I see "SUN" "LCSM100_F" in hwtable.c Christophe's tree
> (http://git.kernel.org/?p=linux/storage/multipath-tools/.git)

Does Christophe's repo have a problem?

bash-3.2$ git-clone 
http://git.kernel.org/?p=linux/storage/multipath-tools/.git
Initialized empty Git repository in 
/home/speech/bradyc/WIP/multipath-tools.upstream/multipath-tools/.git/
Cannot get remote repository information.
Perhaps git-update-server-info needs to be run there?
bash-3.2$

Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>

diff -ru multipath-tools-0.4.7.rhel5.13.orig/libmultipath/hwtable.c multipath-tools-0.4.7.rhel5.13/libmultipath/hwtable.c
--- multipath-tools-0.4.7.rhel5.13.orig/libmultipath/hwtable.c	2008-08-29 14:30:27.000000000 -0400
+++ multipath-tools-0.4.7.rhel5.13/libmultipath/hwtable.c	2009-06-24 16:54:18.431447000 -0400
@@ -691,6 +691,22 @@
  		.minio         = DEFAULT_MINIO,
  		.checker_name  = RDAC,
  	},
+	/* SUN/LSI 2510 */
+	{
+		.vendor        = "SUN",
+		.product       = "LCSM100_I",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
  	/*
  	 * DELL arrays
  	 */
diff -ru multipath-tools-0.4.7.rhel5.13.orig/multipath.conf.defaults multipath-tools-0.4.7.rhel5.13/multipath.conf.defaults
--- multipath-tools-0.4.7.rhel5.13.orig/multipath.conf.defaults	2008-08-29 14:30:26.000000000 -0400
+++ multipath-tools-0.4.7.rhel5.13/multipath.conf.defaults	2009-06-24 16:52:35.661869000 -0400
@@ -505,6 +505,20 @@
  #		rr_min_io		1000
  #               path_checker            rdac
  #	}
+#       device {
+#               vendor                  "SUN"
+#               product                 "LCSM100_I"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n" 
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
  #	device {
  #		vendor			"GNBD"
  #		product			"GNBD"
