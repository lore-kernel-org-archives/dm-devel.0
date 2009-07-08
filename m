From: Paul Smith <paul@mad-scientist.net>
Subject: Re: Media failures cause Path/Device Failures in
	dm-multipath ?
Date: Wed, 8 Jul 2009 15:34:56 -0400
Message-ID: <1247081696.2984.25.camel@psmith-ubeta.netezza.com>
References: <1247002005.2984.10.camel@psmith-ubeta.netezza.com>
Reply-To: paul@mad-scientist.net,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1247002005.2984.10.camel@psmith-ubeta.netezza.com>
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

Hi all; does anyone have any thoughts about/comments on this?

It's kind of not so useful to be using this stuff if I can't recover
from a media failure, after all... what am I doing wrong?

Thanks!

On Tue, 2009-07-07 at 17:26 -0400, Paul Smith wrote:
> I have a configuration that has raid1 mirrors (md_raid1) built on top of
> linear segments of multipath'd scsi disks (dm-multipath).  This is Linux
> 2.6.27.25, FYI.  Unfortunately because this is an embedded environment
> it's not easy for us to jump to a newer kernel.
> 
> In this configuration when a scsi disk reports a media failure (SCSI
> Sense/ASC/ASCQ: 3/11/0), I would expect that the md_raid1 would be able
> to handle the error and read the data from the other mirror and then
> re-write the failed sector on the original image.
> 
> I have tried this with the no_path_retry attribute as 'fail'  and
> observe the following... 
> 
> dm-multipath reports the path failure. 
> Then it tries the request on the other path, which also gets a path
> failure.
> The failure of both paths fails the device.
> 
> md-raid1 gets the error and reads from the other mirror.
> When md-raid1 tries to re-write the data it encounters the failed
> device.
> 
> >From syslog:
> 
> Jul 1 20:46:27 hostname user.info kernel: sd 3:0:3:0: [sdaz] Result: hostbyte=0x00 driverbyte=0x08
> Jul 1 20:46:27 hostname user.info kernel: sd 3:0:3:0: [sdaz] Sense Key : 0x3 [current]
> Jul 1 20:46:27 hostname user.warn kernel: Info fld=0x217795c
> Jul 1 20:46:27 hostname user.info kernel: sd 3:0:3:0: [sdaz] ASC=0x11 ASCQ=0x0
> Jul 1 20:46:27 hostname user.warn kernel: device-mapper: multipath: Failing path 67:48.
> Jul 1 20:46:27 hostname daemon.notice multipathd: 67:48: mark as failed
> Jul 1 20:46:27 hostname daemon.notice multipathd: encl3Slot4: remaining active paths: 1
> Jul 1 20:46:29 hostname user.info kernel: sd 2:0:29:0: [sdab] Result: hostbyte=0x00 driverbyte=0x08
> Jul 1 20:46:29 hostname user.info kernel: sd 2:0:29:0: [sdab] Sense Key : 0x3 [current]
> Jul 1 20:46:29 hostname user.warn kernel: Info fld=0x217795c
> Jul 1 20:46:29 hostname user.info kernel: sd 2:0:29:0: [sdab] ASC=0x11 ASCQ=0x0
> Jul 1 20:46:29 hostname user.warn kernel: device-mapper: multipath: Failing path 65:176.
> Jul 1 20:46:30 hostname daemon.notice multipathd: 65:176: mark as failed
> Jul 1 20:46:30 hostname daemon.notice multipathd: encl3Slot4: remaining active paths: 0
> Jul 1 20:46:30 hostname user.err kernel: raid1: dm-36: rescheduling sector 35092739
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Disk failure on dm-38, disabling device.
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Operation continuing on 1 devices.
> Jul 1 20:46:30 hostname user.warn kernel: md: super_written gets error=-5, uptodate=0
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Disk failure on dm-36, disabling device.
> Jul 1 20:46:30 hostname user.alert kernel: raid1: Operation continuing on 1 devices.
> 
> When the no_path_retry attribute is set to '3' :
> 
> dm-multipath reports the path failure.
> Then retries the request on the other path, which also gets a path
> failure.
> On the failure of the second path, the device queues, and enters
> recovery mode.
> On the subsequent poll of the paths they are reinstated and the IOs are
> 'resumed'.....
> ... and of course fail with the media error again.......
> causing a hang...
> 
> >From syslog:
> 
> Jul  7 10:54:35 hostname user.info kernel: sd 2:0:19:0: [sds] Result: hostbyte=0x00 driverbyte=0x08
> Jul  7 10:54:35 hostname user.info kernel: sd 2:0:19:0: [sds] Sense Key : 0x3 [current]
> Jul  7 10:54:35 hostname user.warn kernel: Info fld=0x123c016d
> Jul  7 10:54:35 hostname user.info kernel: sd 2:0:19:0: [sds] ASC=0x11 ASCQ=0x0
> Jul  7 10:54:35 hostname user.warn kernel: device-mapper: multipath: Failing path 65:32.
> Jul  7 10:54:35 hostname daemon.notice multipathd: 65:32: mark as failed
> Jul  7 10:54:35 hostname daemon.notice multipathd: encl2Slot7: remaining active paths: 1
> Jul  7 10:54:37 hostname user.info kernel: sd 3:0:45:0: [sdcm]
> Jul  7 10:54:37 hostname user.info kernel: Result: hostbyte=0x00 driverbyte=0x08
> Jul  7 10:54:37 hostname user.info kernel: sd 3:0:45:0: [sdcm] Sense Key : 0x3
> Jul  7 10:54:37 hostname user.info kernel: [current]
> Jul  7 10:54:37 hostname user.warn kernel: Info fld=0x123c016d
> Jul  7 10:54:37 hostname user.info kernel: sd 3:0:45:0: [sdcm]
> Jul  7 10:54:37 hostname user.info kernel: ASC=0x11 ASCQ=0x0
> Jul  7 10:54:37 hostname user.warn kernel: device-mapper: multipath: Failing path 69:160.
> Jul  7 10:54:37 hostname daemon.notice multipathd: 69:160: mark as failed
> Jul  7 10:54:37 hostname daemon.warn multipathd: encl2Slot7: Entering recovery mode: max_retries=3
> Jul  7 10:54:37 hostname daemon.notice multipathd: encl2Slot7: remaining active paths: 0
> Jul  7 10:54:39 hostname daemon.warn multipathd: sds: readsector0 checker reports path is up
> Jul  7 10:54:39 hostname daemon.notice multipathd: 65:32: reinstated
> Jul  7 10:54:42 hostname daemon.notice multipathd: encl2Slot7: queue_if_no_path enabled
> Jul  7 10:54:42 hostname daemon.warn multipathd: encl2Slot7: Recovered to normal mode
> Jul  7 10:54:42 hostname daemon.notice multipathd: encl2Slot7: remaining active paths: 1
> Jul  7 10:54:42 hostname daemon.warn multipathd: sdcm: readsector0 checker reports path is up
> Jul  7 10:54:42 hostname daemon.notice multipathd: 69:160: reinstated
> Jul  7 10:54:42 hostname daemon.notice multipathd: encl2Slot7: remaining active paths: 2
> Jul  7 10:54:42 hostname user.info kernel: sd 2:0:19:0: [sds] Result: hostbyte=0x00 driverbyte=0x08
> Jul  7 10:54:42 hostname user.info kernel: sd 2:0:19:0: [sds]
> Jul  7 10:54:42 hostname user.info kernel: Sense Key : 0x3
> Jul  7 10:54:42 hostname user.info kernel: [current]
> Jul  7 10:54:42 hostname user.info kernel:
> Jul  7 10:54:42 hostname user.warn kernel: Info fld=0x123c016d
> Jul  7 10:54:42 hostname user.info kernel: sd 2:0:19:0: [sds]
> Jul  7 10:54:42 hostname user.info kernel: ASC=0x11 ASCQ=0x0
> Jul  7 10:54:42 hostname user.warn kernel: device-mapper: multipath: Failing path 65:32.
> Jul  7 10:54:43 hostname daemon.notice multipathd: 65:32: mark as failed
> Jul  7 10:54:43 hostname daemon.notice multipathd: encl2Slot7: remaining active paths: 1
> 
> 
> Should dm-multipath distinguish media failures from actual device
> errors?
> 
> Is there a different no_path_retry policy that would fail this request
> by queue subsequent requests?
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
