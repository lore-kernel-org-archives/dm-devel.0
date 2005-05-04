From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: default_prio_callout in multipath-tools-0.4.5-pre2
Date: Wed, 04 May 2005 11:16:51 -0400 (EDT)
Message-ID: <13752.7124294595$1115219555@news.gmane.org>
References: <20050503.172624.74755745.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
	<1115157176.2277.33.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1115157176.2277.33.camel@zezette>
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

Thank you for your comment.

On Tue, 03 May 2005 23:52:55 +0200, christophe varoqui wrote:
> Are you talking about the setting in multipath.conf.synthetic ?
> 
> If so, it is just there as a synthax example.
> Nobody should copy this template in /etc/ without editing to fit its
> needs.
> 
> The philosophy should be :
> 
> 1. try first with no config file
> 2. if not satisfied, try to massage a config file
> 3. when satisfied, submit your tuning for inclusion in the default
> hardware table.
> 
> For most users, there should only be aliases in the config file.

OK.  I understood the philosophy.
But as you say, I think the config templates are misleading.

In step 2, it's likely that users copy it in /etc and edit only
the part which they are interested in. (I did, at least.)
So the line like 'default_prio_callout "/bin/true"' is probably
kept using without much care.

Therefore I think making the template with just comments
(like the following example) would be a good starting point for
users to do step 2 in your phylosophy, provided that embedded
default value should work for most cases.
It also prevents users from configuring things unintentionally.

Thanks,
Ky (Kiyoshi Ueda)

---------------- In case of multipath.conf.synthetic ------------------
###
### Many users don't need this template, since all default settings
### are built in.  If a default value doesn't fit your needs, copy
### this template as /etc/multipath.conf and edit the proper part.
###
#
#defaults {
#	multipath_tool	"/sbin/multipath -v 0"
#	udev_dir	/dev
#	polling_interval 10
#	default_selector	"round-robin 0"
#	default_path_grouping_policy	multibus
#	default_getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
#	default_prio_callout	"/bin/true"
#	default_features	"0"
#	rr_wmin_io		100
#}
#devnode_blacklist {
#	wwid 26353900f02796769
#	devnode "(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
#	devnode "hd[a-z][[0-9]*]"
#	devnode "cciss!c[0-9]d[0-9]*[p[0-9]*]"
#}
#multipaths {
#	multipath {
#		wwid			3600508b4000156d700012000000b0000
#		alias			yellow
#		path_grouping_policy	multibus
#		path_checker		readsector0
#		path_selector		"round-robin 0"
#	}
#	multipath {
#		wwid	1DEC_____321816758474
#		alias	red
#	}
#}
#devices {
#	device {
#		vendor			"COMPAQ  "
#		product			"HSV110 (C)COMPAQ"
#		path_grouping_policy	multibus
#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
#		path_checker		readsector0
#		path_selector		"round-robin 0"
#		features		"1 queue_if_no_path"
#		hardware_handler	"0"
#	}
#	device {
#		vendor			"COMPAQ  "
#		product			"MSA1000         "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"COMPAQ  "
#		product			"MSA1000 VOLUME  "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"DEC     "
#		product			"HSG80           "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"HP      "
#		product			"HSV100          "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"3PARdata"
#		product			"VV              "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"IBM     "
#		product			"3542            "
#		path_grouping_policy	group_by_serial
#		path_checker		tur
#	}
#	device {
#		vendor			"DDN     "
#		product			"SAN DataDirector"
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"FSC     "
#		product			"CentricStor     "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"HITACHI "
#		product			"DF400           "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"HITACHI "
#		product			"DF500           "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"HITACHI "
#		product			"DF600           "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"IBM     "
#		product			"ProFibre 4000R  "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"SGI     "
#		product			"TP9100          "
#		vendor			"COMPAQ  "
#		product			"MSA1000         "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"SGI     "
#		product			"TP9300          "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"SGI     "
#		product			"TP9400          "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		vendor			"SGI     "
#		product			"TP9500          "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		# all paths active but with a switchover latency
#		# LSI controlers
#		vendor			"STK     "
#		product			"OPENstorage D280"
#		path_grouping_policy	group_by_serial
#		path_checker		tur
#	}
#	device {
#		# assymmetric array
#		vendor			"SUN     "
#		product			"StorEdge 3510   "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#	device {
#		# symmetric array
#		vendor			"SUN     "
#		product			"T4              "
#		path_grouping_policy	multibus
#		path_checker		tur
#	}
#}
