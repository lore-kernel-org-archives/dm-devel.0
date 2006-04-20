From: Steve Feehan <sfeehan@sbb.uvm.edu>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 17:05:04 -0400
Message-ID: <20060420210504.GC32417@ingress.sbb.uvm.edu>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
	<4447E8BF.1060205@bzed.de>
	<20060420204739.GB32417@ingress.sbb.uvm.edu>
	<4447F4AC.5040904@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4447F4AC.5040904@free.fr>
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

On Thu, Apr 20, 2006 at 10:53:00PM +0200, Christophe Varoqui wrote:
> Steve Feehan a ?crit :
> >On Thu, Apr 20, 2006 at 10:02:07PM +0200, Bernd Zeimetz wrote:
> >  
> >>Steve Feehan wrote:
> >>    
> >>>Hello. I'm trying to figure out multipath on a StorageWorks HSG80
> >>>contoller. I'm using Ubuntu "Dapper" with the following software
> >>>  
> >>>      
> >>there was a thread about the HSG80s few days ago.
> >>http://www.redhat.com/archives/dm-devel/2006-April/msg00025.html
> >>probably that answers all your questions.
> >>    
> >
> >Yes, I saw that. The particular problem that I saw there
> >was the misreporting of unit size. The Ubuntu init script
> >takes care of this and all of my units report the same 
> >size.
> >
> >  
> That's certainly where the IO errors are triggered at bootup.
> Can you send the code snippet ?

You mean from the init script? Here it is:

hsg80_init() {
        dummy_capa=2097152

        for i in $(grep -rl 2097152 /sys/block/sd*/size|awk -F/ '{print
$4}')
        do
                echo
                echo "##################################"
                echo "FIXING HSG80 device: $i"
                echo
                sg_start -start /dev/$i
                sleep 1
                echo 1>/sys/block/$i/device/rescan
        done
}

I put the echo's in so that I could see if and for which devices
it was being called. And yes, it's called for the two "ghost"
devices (sdc and sdd).


But if you look at boot output, the errors begin well before
the multipath-tools init script runs. 

Here is a trimmed excerpt:


[42949387.600000] qla2200 0000:03:01.0: Found an ISP2200, irq 169,
iobase 0xf8826000
[42949387.700000] qla2200 0000:03:01.0: Configuring PCI space...
[42949387.780000] qla2200 0000:03:01.0: Configure NVRAM parameters...
[42949387.940000] qla2200 0000:03:01.0: Verifying loaded RISC code...
[42949388.200000] qla2200 0000:03:01.0: LIP reset occured (0).
[42949388.270000] qla2200 0000:03:01.0: Waiting for LIP to complete...
[42949390.910000] qla2200 0000:03:01.0: LOOP UP detected (1 Gbps).
[42949390.990000] qla2200 0000:03:01.0: Topology - (F_Port), Host Loop
address 0xffff
[42949391.170000] scsi0 : qla2xxx
[42949391.210000] qla2200 0000:03:01.0:
[42949391.210000]  QLogic Fibre Channel HBA Driver: 8.01.03-k
[42949391.210000]   QLogic QLA22xx -
[42949391.210000]   ISP2200: PCI (66 MHz) @ 0000:03:01.0 hdma-, host#=0,
fw=2.02.08 TP
[42949391.480000] scsi: unknown device type 12
[42949391.540000]   Vendor: DEC       Model: HSG80CCL          Rev: V87F
[42949391.620000]   Type:   RAID                               ANSI SCSI
revision: 02
[42949391.730000]   Vendor: DEC       Model: HSG80             Rev: V87F
[42949391.810000]   Type:   Direct-Access                      ANSI SCSI
revision: 02
[42949391.910000] usbcore: registered new driver usbfs
[42949391.910000] scsi: unknown device type 12
[42949391.910000]   Vendor: DEC       Model: HSG80CCL          Rev: V87F
[42949391.910000]   Type:   RAID                               ANSI SCSI
revision: 02
[42949391.920000]   Vendor: DEC       Model: HSG80             Rev: V87F
[42949391.920000]   Type:   Direct-Access                      ANSI SCSI
revision: 02
[42949392.400000] usbcore: registered new driver hub
[42949392.470000] scsi: unknown device type 12
[42949392.520000]   Vendor: DEC       Model: HSG80CCL          Rev: V87F
[42949392.610000]   Type:   RAID                               ANSI SCSI
revision: 02
[42949392.710000] ACPI: PCI Interrupt 0000:01:00.0[D] -> GSI 19 (level,
low) -> IRQ 177
[42949394.820000] SCSI device sda: 426583554 512-byte hdwr sectors
(218411 MB)
[42949394.910000] SCSI device sda: drive cache: write through
[42949394.980000]  sda: unknown partition table
[42949395.050000] sd 0:0:0:1: Attached scsi disk sda
[42949395.120000] SCSI device sdb: 426583554 512-byte hdwr sectors
(218411 MB)
[42949395.210000] SCSI device sdb: drive cache: write through
[42949395.290000] SCSI device sdb: 426583554 512-byte hdwr sectors
(218411 MB)
[42949395.380000] SCSI device sdb: drive cache: write through
[42949395.450000]  sdb: unknown partition table
[42949395.510000] sd 0:0:1:1: Attached scsi disk sdb
[42949395.580000] sdc : READ CAPACITY failed.
[42949395.580000] sdc : status=1, message=00, host=0, driver=08
[42949395.710000] sd: Current: sense key: Not Ready
[42949395.770000]     Additional sense: Logical unit not ready,
initializing cmd. required
[42949395.870000] sdc: asking for cache data failed
[42949395.930000] sdc: assuming drive cache: write through
[42949396.000000] sdc : READ CAPACITY failed.
[42949396.000000] sdc : status=1, message=00, host=0, driver=08
[42949396.130000] sd: Current: sense key: Not Ready
[42949396.190000]     Additional sense: Logical unit not ready,
initializing cmd. required
[42949396.300000] sdc: asking for cache data failed
[42949396.360000] sdc: assuming drive cache: write through
[42949396.430000]  sdc:<6>sd 0:0:2:1: Device not ready.
[42949396.490000] end_request: I/O error, dev sdc, sector 0
[42949396.560000] Buffer I/O error on device sdc, logical block 0
[42949396.640000] sd 0:0:2:1: Device not ready.
[42949396.700000] end_request: I/O error, dev sdc, sector 0
[42949396.770000] Buffer I/O error on device sdc, logical block 0
[42949396.840000]  unable to read partition table
[42949396.900000] sd 0:0:2:1: Attached scsi disk sdc
[42949396.970000] sdd : READ CAPACITY failed.
[42949396.970000] sdd : status=1, message=00, host=0, driver=08
[42949397.100000] sd 0:0:2:1: Device not ready.
[42949397.100000] end_request: I/O error, dev sdc, sector 2097024
[42949397.100000] Buffer I/O error on device sdc, logical block 262128
[42949397.310000] sd 0:0:2:1: Device not ready.


.... and then hundreds of lines of such errors ....

Begin: Running /scripts/local-bottom ...
Done.
Done.
Begin: Running /scripts/init-bottom ...
Done.
 * version 2.86 booting
Starting multipath
##################################
FIXING HSG80 device: sdc

[42949413.900000] SCSI device sdc: 426583554 512-byte hdwr sectors
(218411 MB)
[42949413.990000] SCSI device sdc: drive cache: write through

##################################
FIXING HSG80 device: sdd

[42949415.090000] SCSI device sdd: 426583554 512-byte hdwr sectors
(218411 MB)
[42949415.180000] SCSI device sdd: drive cache: write through
[42949415.440000] device-mapper: hp_sw version 0.4 loaded
[42949415.520000] device-mapper: dm-round-robin version 1.0.0 loaded
 done.
 * Starting basic networking...
 * [ ok ]
 * Starting kernel event manager...
 * [ ok ]
 * Loading hardware drivers... [42949416.810000] device-mapper: hp_sw:
 * queueing START_STOP command on 8:16
[42949417.030000]  0:0:0:0: Attached scsi generic sg0 type 12
[42949417.100000] sd 0:0:0:1: Attached scsi generic sg1 type 0
[42949417.170000]  0:0:1:0: Attached scsi generic sg2 type 12
[42949417.240000] sd 0:0:1:1: Attached scsi generic sg3 type 0
[42949417.320000] sd 0:0:3:1: Device not ready.
[42949417.320000] end_request: I/O error, dev sdd, sector 426583424
[42949417.320000] printk: 40 messages suppressed.


.... and the errors continue for the rest of the boot process.
Once the file system is mounted, no more errors. At least not
for the short period that the system has been up.

-- 
Steve Feehan
