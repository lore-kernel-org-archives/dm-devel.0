From: Andy <genanr@emsphone.com>
Subject: Re: prio ignored in multipath.conf
Date: Tue, 7 Jul 2009 11:07:26 -0500
Message-ID: <20090707160726.GA18695@thumper2>
References: <20090707144155.GA16220@thumper2>
	<1246979128.20189.315.camel@breeves.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1246979128.20189.315.camel@breeves.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 07, 2009 at 04:05:28PM +0100, Bryn M. Reeves wrote:
> On Tue, 2009-07-07 at 09:41 -0500, Andy wrote:
> > I am trying to change the path priorities on QLA2432 HBAs to a 3PAR array.
> > The kernel is 2.6.31-rc1 and multipath tools v0.4.9
> > 
> > I created a small C program to change priorities (right now it just prints
> > some info).  But, when I run multipath the verbose information keeps saying
> > prio = const (controller setting), even though I have "prio  allant" (allant
> > is the name of my prioritizer).  If I have "prio alllant" a global default
> > it will run the code for the non-QLA2432/3PAR device, but not the devices
> > that are under the control of the QLA2432.  It always sets prio to const and
> > the QLA2432 paths.  This use to work at some point with older
> > multipath/kernel versions.
> 
> It would help if you included your multipath.conf (or a link to it).
> 

defaults {
	# multipath_tool	"/sbin/multipath -v 0 -S"
	udev_dir	/dev
	# polling_interval 10
	# default_selector	"round-robin 0"
	selector	"round-robin 0"
	# default_selector_args	0
	path_checker "readsector0"
	# default_path_grouping_policy	multibus
	# default_getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
	# default_prio_callout	"/bin/false"
	# path_grouping_policy	multibus
	path_grouping_policy group_by_prio
	getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
	prio_callout	"/bin/true"
	# prio_callout	"/sbin/mpath_prio_random"
	# prio "allant"
	rr_min_io	8

}

blacklist {
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z][[0-9]*]"
	devnode "^sda[[0-9]*]"	
	devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

# devnode_blacklist {
#	devnode "(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
#	devnode "hd[a-z][[0-9]*]"
#	devnode "sda[[0-9]*]"	
#	devnode "^(sda)[0-9]*"
#	devnode "cciss!c[0-9]d[0-9]*[p[0-9]*]"
# }


multipaths {

	multipath {
		# start_first_path	1
		wwid 			350002ac000020246
		# path_grouping_policy	multibus
		path_grouping_policy	group_by_prio
		# path_checker		readsector0
		# path_selector		"round-robin 0"
		prio			allant
		# path_selector_args	0
		rr_min_io		8	# u02 io count
		alias 			u02 
	}



	multipath {
		# start_first_path	1
		wwid 			350002ac000ed0246
		# path_grouping_policy	multibus
		path_grouping_policy	group_by_prio
		# path_checker		readsector0
		path_selector		"round-robin 0"
		# path_selector_args	0
		prio			allant
		rr_min_io		1	# u01 io count
		alias 			u01_vm1
	}
	multipath {
		# start_first_path	1
		wwid 			350002ac000ee0246
		# path_grouping_policy	multibus
		path_grouping_policy	group_by_prio
		# path_checker		readsector0
		path_selector		"round-robin 0"
		# path_selector_args	0
		prio			allant	
		rr_min_io		1	# u01 io count
		alias 			u01_vm2
	}
	multipath {
		# start_first_path	1
		wwid 			350002ac001260246
		# path_grouping_policy	multibus
		path_grouping_policy	group_by_prio
		# path_checker		readsector0
		path_selector		"round-robin 0"
		# path_selector_args	0
		prio			allant
		rr_min_io		1	# u01 io count
		alias 			u01_vm3
	}
	multipath {
		# start_first_path	1
		wwid 			350002ac001670246
		# path_grouping_policy	multibus
		path_grouping_policy	group_by_prio
		# path_checker		readsector0
		path_selector		"round-robin 0"
		prio			allant
		# path_selector_args	0
		rr_min_io		1	# u01 io count
		alias 			u01_vm4
	}
}

devices {
	device {
		vendor			"COMPAQ  "
		product			"HSV110 (C)COMPAQ"
		path_grouping_policy	multibus
		getuid_callout          "/sbin/scsi_id -g -u -s"
		path_checker		readsector0
		path_selector		round-robin
	}
	device {
		vendor			"COMPAQ  "
		product			"MSA1000         "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"COMPAQ  "
		product			"MSA1000 VOLUME  "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"DEC     "
		product			"HSG80           "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"HP      "
		product			"HSV100          "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"3PARdata"
		product			"VV              "
		# path_grouping_policy	multibus
		path_grouping_policy    group_by_prio
		prio			allant
		path_checker		tur
	}
	device {
		vendor			"DDN     "
		product			"SAN DataDirector"
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"FSC     "
		product			"CentricStor     "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"HITACHI "
		product			"DF400           "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"HITACHI "
		product			"DF500           "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"HITACHI "
		product			"DF600           "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"IBM     "
		product			"ProFibre 4000R  "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"SGI     "
		product			"TP9100          "
		vendor			"COMPAQ  "
		product			"MSA1000         "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"SGI     "
		product			"TP9300          "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"SGI     "
		product			"TP9400          "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		vendor			"SGI     "
		product			"TP9500          "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		# all paths active but with a switchover latency
		# LSI controlers
		vendor			"STK     "
		product			"OPENstorage D280"
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		# assymmetric array
		vendor			"SUN     "
		product			"StorEdge 3510   "
		path_grouping_policy	multibus
		path_checker		tur
	}
	device {
		# symmetric array
		vendor			"SUN     "
		product			"T4              "
		path_grouping_policy	multibus
		path_checker		tur
	}
}
