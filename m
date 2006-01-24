From: Nicola Murino <n.murino@theorematica.it>
Subject: EMC CX LUN problem
Date: Tue, 24 Jan 2006 22:31:28 +0100
Message-ID: <43D69CB0.8020402@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,

I'm trying to configure a new emc cx storage, I have the following:

2 server, each server has a qla2462 dual port hba
each qla2462 is connected to a switch (only one switch)
1 emc cx storage with 4 path connected to the switch

I defined two lun on the storage however I'm able to see only one LUN

multipath -l show the following:

multipath -l
mail (36006016086f01600e46f567adb8cda11)
[size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
 \_ 1:0:1:0 sdd 8:48  [active][ready]
 \_ 1:0:1:1 sde 8:64  [active][ready]
 \_ 2:0:1:0 sdh 8:112 [active][ready]
 \_ 2:0:1:1 sdi 8:128 [active][ready]
\_ round-robin 0 [enabled]
 \_ 2:0:0:0 sdf 8:80  [active][ready]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
 \_ 2:0:0:1 sdg 8:96  [active][ready]


this seems correct for my configuration however I'm not able to see the 
other LUN, tommorrow I'll try to connect the 2 server directly to the 
storage, some other hint?

from dmesg:

QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 16 (level, low) -> IRQ 16
qla2400 0000:08:00.0: Found an ISP2432, irq 16, iobase 0xf881a000
qla2400 0000:08:00.0: Configuring PCI space...
PCI: Setting latency timer of device 0000:08:00.0 to 64
qla2400 0000:08:00.0: Configure NVRAM parameters...
qla2400 0000:08:00.0: Verifying loaded RISC code...
qla2400 0000:08:00.0: Allocated (1061 KB) for firmware dump...
qla2400 0000:08:00.0: Waiting for LIP to complete...
qla2400 0000:08:00.0: LIP reset occured (f8f7).
qla2400 0000:08:00.0: LIP occured (f8f7).
qla2400 0000:08:00.0: LOOP UP detected (2 Gbps).
qla2400 0000:08:00.0: Topology - (F_Port), Host Loop address 0x0
scsi1 : qla2xxx
qla2400 0000:08:00.0:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QLE2462 - PCI-Express to 4Gb FC, Dual Channel
  ISP2432: PCIe (2.5Gb/s x4) @ 0000:08:00.0 hdma-, host#=1, fw=4.00.16 [IP]
ACPI: PCI Interrupt 0000:08:00.1[B] -> GSI 17 (level, low) -> IRQ 20
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdb: 314572800 512-byte hdwr sectors (161061 MB)
sdb: test WP failed, assume Write Enabled
sdb: asking for cache data failed
sdb: assuming drive cache: write through
qla2400 0000:08:00.1: Found an ISP2432, irq 20, iobase 0xf881c000
SCSI device sdb: 314572800 512-byte hdwr sectors (161061 MB)
qla2400 0000:08:00.1: Configuring PCI space...
PCI: Setting latency timer of device 0000:08:00.1 to 64
sdb: test WP failed, assume Write Enabled
qla2400 0000:08:00.1: Configure NVRAM parameters...
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb:<6>sd 1:0:0:0: Device not ready.
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
sd 1:0:0:0: Device not ready.
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
 unable to read partition table
sd 1:0:0:0: Attached scsi disk sdb
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
qla2400 0000:08:00.1: Verifying loaded RISC code...
SCSI device sdc: 314572800 512-byte hdwr sectors (161061 MB)
sdc: test WP failed, assume Write Enabled
sdc: asking for cache data failed
sdc: assuming drive cache: write through
SCSI device sdc: 314572800 512-byte hdwr sectors (161061 MB)
sdc: test WP failed, assume Write Enabled
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 sdc:<6>sd 1:0:0:1: Device not ready.
end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
sd 1:0:0:1: Device not ready.
end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
 unable to read partition table
sd 1:0:0:1: Attached scsi disk sdc
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdd: 314572800 512-byte hdwr sectors (161061 MB)
sdd: Write Protect is off
sdd: Mode Sense: 87 00 00 08
SCSI device sdd: drive cache: write through
SCSI device sdd: 314572800 512-byte hdwr sectors (161061 MB)
sdd: Write Protect is off
sdd: Mode Sense: 87 00 00 08
SCSI device sdd: drive cache: write through
 sdd: unknown partition table
sd 1:0:1:0: Attached scsi disk sdd
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sde: 314572800 512-byte hdwr sectors (161061 MB)
sde: Write Protect is off
sde: Mode Sense: 87 00 00 08
SCSI device sde: drive cache: write through
SCSI device sde: 314572800 512-byte hdwr sectors (161061 MB)
sde: Write Protect is off
sde: Mode Sense: 87 00 00 08
SCSI device sde: drive cache: write through
 sde: unknown partition table
sd 1:0:1:1: Attached scsi disk sde
qla2400 0000:08:00.1: Allocated (1061 KB) for firmware dump...
qla2400 0000:08:00.1: Waiting for LIP to complete...
qla2400 0000:08:00.1: LIP reset occured (f8f7).
qla2400 0000:08:00.1: LIP occured (f8f7).
qla2400 0000:08:00.1: LOOP UP detected (2 Gbps).
qla2400 0000:08:00.1: Topology - (F_Port), Host Loop address 0x0
scsi2 : qla2xxx
qla2400 0000:08:00.1:
 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
  QLogic QLE2462 - PCI-Express to 4Gb FC, Dual Channel
  ISP2432: PCIe (2.5Gb/s x4) @ 0000:08:00.1 hdma-, host#=2, fw=4.00.16 [IP]
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdf: 314572800 512-byte hdwr sectors (161061 MB)
sdf: test WP failed, assume Write Enabled
sdf: asking for cache data failed
sdf: assuming drive cache: write through
SCSI device sdf: 314572800 512-byte hdwr sectors (161061 MB)
sdf: test WP failed, assume Write Enabled
sdf: asking for cache data failed
sdf: assuming drive cache: write through
 sdf:<6>sd 2:0:0:0: Device not ready.
end_request: I/O error, dev sdf, sector 0
Buffer I/O error on device sdf, logical block 0
sd 2:0:0:0: Device not ready.
end_request: I/O error, dev sdf, sector 0
Buffer I/O error on device sdf, logical block 0
 unable to read partition table
sd 2:0:0:0: Attached scsi disk sdf
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdg: 314572800 512-byte hdwr sectors (161061 MB)
sdg: test WP failed, assume Write Enabled
sdg: asking for cache data failed
sdg: assuming drive cache: write through
SCSI device sdg: 314572800 512-byte hdwr sectors (161061 MB)
sdg: test WP failed, assume Write Enabled
sdg: asking for cache data failed
sdg: assuming drive cache: write through
 sdg:<6>sd 2:0:0:1: Device not ready.
end_request: I/O error, dev sdg, sector 0
Buffer I/O error on device sdg, logical block 0
sd 2:0:0:1: Device not ready.
end_request: I/O error, dev sdg, sector 0
Buffer I/O error on device sdg, logical block 0
 unable to read partition table
sd 2:0:0:1: Attached scsi disk sdg
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdh: 314572800 512-byte hdwr sectors (161061 MB)
sdh: Write Protect is off
sdh: Mode Sense: 87 00 00 08
SCSI device sdh: drive cache: write through
SCSI device sdh: 314572800 512-byte hdwr sectors (161061 MB)
sdh: Write Protect is off
sdh: Mode Sense: 87 00 00 08
SCSI device sdh: drive cache: write through
 sdh: unknown partition table
sd 2:0:1:0: Attached scsi disk sdh
  Vendor: DGC       Model: RAID 5            Rev: 0219
  Type:   Direct-Access                      ANSI SCSI revision: 04
SCSI device sdi: 314572800 512-byte hdwr sectors (161061 MB)
sdi: Write Protect is off
sdi: Mode Sense: 87 00 00 08
SCSI device sdi: drive cache: write through
SCSI device sdi: 314572800 512-byte hdwr sectors (161061 MB)
sdi: Write Protect is off
sdi: Mode Sense: 87 00 00 08
SCSI device sdi: drive cache: write through
 sdi: unknown partition table
sd 2:0:1:1: Attached scsi disk sdi

it seems as if only one LUN was defined but the management software 
confirm that two LUN was created,

any help would be appreciated,

thanks
Nicola
