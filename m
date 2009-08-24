From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 23:14:16 +0200
Message-ID: <20090824231416.598ecc11@pc-jsosic.srce.hr>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
	<Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
	<20090824202915.27815959@pc-jsosic.srce.hr>
	<1251139716.24406.4.camel@chandra-ubuntu>
	<20090824205933.4b4c8456@pc-jsosic.srce.hr>
	<1251145497.24406.18.camel@chandra-ubuntu>
	<20090824223627.6e1a918c@pc-jsosic.srce.hr>
	<1251147451.24406.28.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251147451.24406.28.camel@chandra-ubuntu>
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

On Mon, 24 Aug 2009 13:57:31 -0700
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> If you are up for debugging, we can try putting some debug to see if
> we are getting any sense information along with the IO failure.

OK, here is the dmesg from last reboot, only things that are of
importance to this case:

SCSI subsystem initialized
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.07
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 17 (level, low) -> IRQ 17
mptbase: ioc0: Initiating bringup

...

mptbase: ioc1: Initiating bringup
ioc1: LSISAS1068E B3: Capabilities={Initiator}
PCI: Setting latency timer of device 0000:09:00.0 to 64
scsi1 : ioc1: LSISAS1068E B3, FwRev=011704dbh, Ports=1, MaxQ=829, IRQ=22
  Vendor: SUN       Model: LCSM100_S         Rev: 0735
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 204800 512-byte hdwr sectors (105 MB)
sdb: Write Protect is off
sdb: Mode Sense: 77 00 10 08
SCSI device sdb: drive cache: write back w/ FUA
SCSI device sdb: 204800 512-byte hdwr sectors (105 MB)
sdb: Write Protect is off
sdb: Mode Sense: 77 00 10 08
SCSI device sdb: drive cache: write back w/ FUA
 sdb:end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
Dev sdb: unable to read RDB block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
 unable to read partition table
sd 1:0:0:0: Attached scsi disk sdb
  Vendor: SUN       Model: LCSM100_S         Rev: 0735
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 241172480 512-byte hdwr sectors (123480 MB)
sdc: Write Protect is off
sdc: Mode Sense: 77 00 10 08
SCSI device sdc: drive cache: write back w/ FUA
SCSI device sdc: 241172480 512-byte hdwr sectors (123480 MB)
sdc: Write Protect is off
sdc: Mode Sense: 77 00 10 08
SCSI device sdc: drive cache: write back w/ FUA
 sdc:end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
Dev sdc: unable to read RDB block 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
 unable to read partition table
sd 1:0:0:1: Attached scsi disk sdc
  Vendor: SUN       Model: LCSM100_S         Rev: 0735
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 43274240 512-byte hdwr sectors (22156 MB)
sdd: Write Protect is off
sdd: Mode Sense: 77 00 10 08
SCSI device sdd: drive cache: write back w/ FUA
SCSI device sdd: 43274240 512-byte hdwr sectors (22156 MB)
sdd: Write Protect is off
sdd: Mode Sense: 77 00 10 08
SCSI device sdd: drive cache: write back w/ FUA
 sdd: unknown partition table
sd 1:0:0:2: Attached scsi disk sdd
  Vendor: SUN       Model: LCSM100_S         Rev: 0735
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sde: 204800 512-byte hdwr sectors (105 MB)
sde: Write Protect is off
sde: Mode Sense: 77 00 10 08
SCSI device sde: drive cache: write back w/ FUA
SCSI device sde: 204800 512-byte hdwr sectors (105 MB)
sde: Write Protect is off
sde: Mode Sense: 77 00 10 08
SCSI device sde: drive cache: write back w/ FUA
 sde:end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
printk: 8 messages suppressed.
Buffer I/O error on device sde, logical block 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
Dev sde: unable to read RDB block 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
 unable to read partition table
sd 1:0:1:0: Attached scsi disk sde
  Vendor: SUN       Model: LCSM100_S         Rev: 0735
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdf: 241172480 512-byte hdwr sectors (123480 MB)
sdf: Write Protect is off
sdf: Mode Sense: 77 00 10 08
SCSI device sdf: drive cache: write back w/ FUA
SCSI device sdf: 241172480 512-byte hdwr sectors (123480 MB)
sdf: Write Protect is off
sdf: Mode Sense: 77 00 10 08
SCSI device sdf: drive cache: write back w/ FUA
 sdf: unknown partition table
sd 1:0:1:1: Attached scsi disk sdf
  Vendor: SUN       Model: LCSM100_S         Rev: 0735
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdg: 43274240 512-byte hdwr sectors (22156 MB)
sdg: Write Protect is off
sdg: Mode Sense: 77 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
SCSI device sdg: 43274240 512-byte hdwr sectors (22156 MB)
sdg: Write Protect is off
sdg: Mode Sense: 77 00 10 08
SCSI device sdg: drive cache: write back w/ FUA
 sdg:end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
printk: 8 messages suppressed.
Buffer I/O error on device sdg, logical block 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
Dev sdg: unable to read RDB block 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
 unable to read partition table
sd 1:0:1:2: Attached scsi disk sdg
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
libata version 3.00 loaded.


Now, this seems like some kind of a problem on the LCMS100_S driver
side? MPT_SAS?


Very strange...




-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
| start fighting cancer -> http://www.worldcommunitygrid.org/   |
