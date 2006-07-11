From: Nicola Murino <n.murino@theorematica.it>
Subject: RE: dm-emc doesn't works with vanilla kernel
Date: Tue, 11 Jul 2006 14:25:39 +0200
Message-ID: <1152620739.7745.15.camel@d810>
References: <6CCEAEDF4D06984A83F427424F47D6E4149186@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4149186@CORPUSMX40A.corp.emc.com>
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

Thanks for your reply, 

I'm currently using multipath-tools 0.4.7, the problem happen when I
manually detach a path with a kernel>2.6.13, 


The system works fine with only an active path, here a re the logs:

Jul  7 12:29:00 nodob qla2300 0000:0a:03.0: LIP reset occured (f8ef).
Jul  7 12:29:35 nodob rport-2:0-0: blocked FC remote port time out:
removing target
Jul  7 12:29:45 nodob scsi2 (0:1): rejecting I/O to dead device
Jul  7 12:29:45 nodob device-mapper: dm-multipath: Failing path 8:112.
Jul  7 12:29:45 nodob device-mapper: dm-emc: emc_pg_init: sending
switch-over command


but when I reattach the failed path the system is unable to react to
this event, I have this in my logs (kernel-2.6.14 and 2.6.16):

Jul  7 12:30:05 nodob qla2300 0000:0a:03.0: LIP occured (f8ef).
Jul  7 12:30:06 nodob Vendor: DGC       Model: RAID 5            Rev:
0207
Jul  7 12:30:06 nodob Type:   Direct-Access                      ANSI
SCSI revision: 04
Jul  7 12:30:06 nodob SCSI device sdl: 629145600 512-byte hdwr sectors
(322123 MB)
Jul  7 12:30:06 nodob sdl: asking for cache data failed
Jul  7 12:30:06 nodob sdl: assuming drive cache: write through
Jul  7 12:30:06 nodob SCSI device sdl: 629145600 512-byte hdwr sectors
(322123 MB)
Jul  7 12:30:06 nodob sdl: asking for cache data failed
Jul  7 12:30:06 nodob sdl: assuming drive cache: write through
Jul  7 12:30:06 nodob sdl:<6>sd 2:0:0:0: Device not ready.
Jul  7 12:30:06 nodob end_request: I/O error, dev sdl, sector 0
Jul  7 12:30:06 nodob Buffer I/O error on device sdl, logical block 0
Jul  7 12:30:06 nodob sd 2:0:0:0: Device not ready.
Jul  7 12:30:06 nodob end_request: I/O error, dev sdl, sector 0
Jul  7 12:30:06 nodob Buffer I/O error on device sdl, logical block 0
Jul  7 12:30:06 nodob unable to read partition table
Jul  7 12:30:06 nodob Attached scsi disk sdl at scsi2, channel 0, id 0,
lun 0
Jul  7 12:30:06 nodob Attached scsi generic sg7 at scsi2, channel 0, id
0, lun 0,  type 0
Jul  7 12:30:06 nodob Vendor: DGC       Model: RAID 5            Rev:
0207
Jul  7 12:30:06 nodob Type:   Direct-Access                      ANSI
SCSI revision: 04
Jul  7 12:30:06 nodob error 1
Jul  7 12:30:06 nodob scsi: Unexpected response from host 2 channel 0 id
0 lun 0 while scanning, scan aborted

and I have to reboot the server to have a working system,

with kernel-2.6.13 on the same system with the same udev and
multipath-tools all is fine,

thanks
Nicola


Il giorno lun, 10/07/2006 alle 11.07 -0400, egoggin@emc.com ha scritto:
> I suspect that the problem is with multipath-tools not the
> dm-emc code.  You may need to upgrade your multipath-tools
> package to a version 0.4.7 base.  Could you try this and
> let me know the status?
> 
> I have no problem of this sort with my CX series CLARiiONs
> with version 2.6.(13,14,15,16) linux kernels.
> 
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com 
> > [mailto:dm-devel-bounces@redhat.com] On Behalf Of Nicola Murino
> > Sent: Saturday, July 08, 2006 5:09 AM
> > To: dm-devel@redhat.com
> > Subject: [dm-devel] dm-emc doesn't works with vanilla kernel
> > 
> > Hi all,
> > 
> > I'm successfully running multipath-tools on a gentoo server 
> > since almost
> > a year, only a problem:
> > 
> > if I use a kernel different from 2.6.13 after detaching a fibre path
> > dm-emc doesn't send trespass and the cx300 luns are not accessible, I
> > got this problem with kernel-2.6.14 and kernel-2.6.16.19, 
> > kernel-2.6.13
> > works ok. 
> > 
> > On another installation with centos, last kernel 
> > (2.6.9-34.01EL) and the
> > same storage all is fine.
> > 
> > Would be great if dm-emc works properly with the upstream kernels,
> > 
> > thanks
> > Nicola
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
