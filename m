From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 12:11:15 -0400
Message-ID: <20090625161115.GB22616@redhat.com>
References: <200906250904.57149.elendil@planet.nl>
	<yq1tz24qqaj.fsf@sermon.lab.mkp.net>
	<200906251748.45475.elendil@planet.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200906251748.45475.elendil@planet.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frans Pop <elendil@planet.nl>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Thu, Jun 25 2009 at 11:48am -0400,
Frans Pop <elendil@planet.nl> wrote:

> On Thursday 25 June 2009, Martin K. Petersen wrote:
> > >>>>> "Frans" == Frans Pop <elendil@planet.nl> writes:
> >
> > Frans> During boot of 2.6.31-rc1 on an arm EABI system I got the
> > Frans> following errors: device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
> > Frans> initialised: dm-devel@redhat.com device-mapper: table: 254:0:
> > Frans> target device sda6 is misaligned device-mapper: table: 254:0:
> > Frans> target device sda6 is misaligned device-mapper: table: 254:1:
> > Frans> target device sda6 is misaligned device-mapper: table: 254:1:
> > Frans> target device sda6 is misaligned 
> >
> > Frans> Please advise and let me know what additional info is needed.
> >
> > What kind of disk is this?
> 
> It's a standard SATA disk; the driver is sata_mv:
> 
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: HDT722516DLA380, V43OA91A, max UDMA/133
> ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> scsi 0:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> 
> I've just also tested rc1 in the Hercules s390 emulator, and I get exactly
> the same there on a virtual dasd disk:
> 
> dasd-eckd 0.0.0121: New DASD 3390/02 (CU 3990/02) with 1113 cylinders, 15 heads, 224 sectors
> dasd-eckd 0.0.0121: DASD with 4 KB/block, 801360 KB total size, 48 KB/track, compatible disk layout
>  dasdb:VOL1/  0X0121: dasdb1 dasdb2
> [...]
> device-mapper: table: 254:0: target device dasdb1 is misaligned
> device-mapper: table: 254:0: target device dasdb2 is misaligned
> device-mapper: table: 254:0: target device dasdb1 is misaligned
> device-mapper: table: 254:0: target device dasdb2 is misaligned

In addition to the other commands I asked for in my previous mail;
please provide the output from the following commands on both your real
and emulated configs:

dmsetup ls
dmsetup table

Mike
