From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: iSCSI device / error getting device,
	error adding target to table
Date: Fri, 8 Jul 2016 16:16:08 -0700
Message-ID: <nlpc7p$mh8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:dm-devel-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: dm-devel-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Errors-To: dm-devel-bounces-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

We have a DotHill iSCSI device which i've already setup with one volume. 
  The device has two controllers each with two network ports, so the 
volume is accessible via four different IP addresses.  On the initiator, 
the volume thus shows up as four disks, /dev/sde thru /dev/sdh.  I 
already created a partition and currently i just mount one of the 
partitions, but would like to setup multipath instead so if something 
fails, the multipath device will continue working without having to 
remount anything.

I used scsi_id to find the WWID of sde thru sdh, they all have the same 
WWID.  I thought a multipath.conf like this would work:

blacklist {
         wwid "*"
}
blacklist_exceptions {
	wwid "3600c0ff00012400bdb0e485701000000"
}
defaults {
	selector		"round-robin 0"
	path_grouping_policy	multibus
	getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
	user_friendly_names	yes
}
multipaths {
	multipath {
		wwid	3600c0ff00012400bdb0e485701000000
	}
}
devices {
	device {
		vendor		"DotHill"
		product		"R/Evo 2330-2R"
		no_path_retry	"queue"
	}
}

but when i start multipathd i see a bunch of errors and no successes:

Jul  8 16:02:42 initiator kernel: device-mapper: table: 253:3: 
multipath: error getting device
Jul  8 16:02:42 initiator kernel: device-mapper: ioctl: error adding 
target to table
[previous 2 lines repeated several times]
Jul  8 16:02:42 initiator multipathd: path checkers start up
Jul  8 16:02:46 initiator kernel: device-mapper: table: 253:3: 
multipath: error getting device
Jul  8 16:02:46 initiator kernel: device-mapper: ioctl: error adding 
target to table
Jul  8 16:02:46 initiator multipathd: dm-3: remove map (uevent)
Jul  8 16:02:46 initiator multipathd: dm-3: devmap not registered, can't 
remove
[previous 4 lines repeated several times]

and 'multipath -v2' command doesn't print anything.  The 
initiator/server is running RHEL5.
