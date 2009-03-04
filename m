From: Asif Iqbal <vadud3@gmail.com>
Subject: dmsetup status not clear
Date: Wed, 4 Mar 2009 17:35:18 -0500
Message-ID: <a60f25fc0903041435ob7e7575kc2ebe0770d5cd36e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I have raid1 setup using nvidia raid controller.

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev f3) (prog-if 85 [Master SecO PriO])
	Subsystem: Sun Microsystems Computer Corp. Device 5348
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	I/O ports at 09e0 [size=8]
	I/O ports at 0be0 [size=4]
	I/O ports at 0960 [size=8]
	I/O ports at 0b60 [size=4]
	I/O ports at c000 [size=16]
	Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv
	Kernel modules: ata_generic, sata_nv, pata_acpi


When I take bad disk out I get this message in /var/log/messages

Mar  4 17:20:11 ftp0 kernel: [ 2095.666527] ata4: hard resetting link
Mar  4 17:20:12 ftp0 kernel: [ 2096.389020] ata4: SATA link down
(SStatus 0 SControl 300)
Mar  4 17:20:17 ftp0 kernel: [ 2101.388029] ata4: hard resetting link
Mar  4 17:20:17 ftp0 kernel: [ 2101.708031] ata4: SATA link down
(SStatus 0 SControl 300)
Mar  4 17:20:22 ftp0 kernel: [ 2106.709016] ata4: hard resetting link
Mar  4 17:20:22 ftp0 kernel: [ 2107.029018] ata4: SATA link down
(SStatus 0 SControl 300)
Mar  4 17:20:22 ftp0 kernel: [ 2107.029027] ata4.00: disabled
Mar  4 17:20:22 ftp0 kernel: [ 2107.029038] ata4: EH complete
Mar  4 17:20:22 ftp0 kernel: [ 2107.029461] ata4.00: detaching (SCSI 3:0:0:0)
Mar  4 17:20:22 ftp0 kernel: [ 2107.091392] sd 3:0:0:0: [sdb] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Mar  4 17:20:22 ftp0 kernel: [ 2107.092546] sd 3:0:0:0: [sdb]
Synchronizing SCSI cache
Mar  4 17:20:22 ftp0 kernel: [ 2107.092591] sd 3:0:0:0: [sdb] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Mar  4 17:20:22 ftp0 kernel: [ 2107.092594] sd 3:0:0:0: [sdb] Stopping disk
Mar  4 17:20:22 ftp0 kernel: [ 2107.092601] sd 3:0:0:0: [sdb] START_STOP FAILED
Mar  4 17:20:22 ftp0 kernel: [ 2107.092602] sd 3:0:0:0: [sdb] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

And the first  two lines from dmesg that did not show up in messages file

[ 2095.513781] ata4: exception Emask 0x10 SAct 0x0 SErr 0x1810000
action 0xe frozen
[ 2095.602104] ata4: SError: { PHYRdyChg LinkSeq TrStaTrns }
[ 2095.666527] ata4: hard resetting link


Now I inserted a new disk and I get this message from messages file


Mar  4 17:26:21 ftp0 kernel: [ 2465.606247] ata4: hard resetting link
Mar  4 17:26:25 ftp0 kernel: [ 2470.136026] ata4: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Mar  4 17:26:25 ftp0 kernel: [ 2470.160260] ata4.00: ATA-7: HITACHI
HDS7280SASUN80G  0638M70W3M, PF2OA6EA, max UDMA/133
Mar  4 17:26:25 ftp0 kernel: [ 2470.160265] ata4.00: 156301488
sectors, multi 0: LBA48 NCQ (depth 0/32)
Mar  4 17:26:26 ftp0 kernel: [ 2470.176260] ata4.00: configured for UDMA/133
Mar  4 17:26:26 ftp0 kernel: [ 2470.176267] ata4: EH complete
Mar  4 17:26:26 ftp0 kernel: [ 2470.176368] scsi 3:0:0:0:
Direct-Access     ATA      HITACHI HDS7280S PF2O PQ: 0 ANSI: 5
Mar  4 17:26:26 ftp0 kernel: [ 2470.177508] sd 3:0:0:0: [sdc]
156301488 512-byte hardware sectors (80026 MB)
Mar  4 17:26:26 ftp0 kernel: [ 2470.177524] sd 3:0:0:0: [sdc] Write
Protect is off
Mar  4 17:26:26 ftp0 kernel: [ 2470.177549] sd 3:0:0:0: [sdc] Write
cache: disabled, read cache: enabled, doesn't support DPO or FUA
Mar  4 17:26:26 ftp0 kernel: [ 2470.177621] sd 3:0:0:0: [sdc]
156301488 512-byte hardware sectors (80026 MB)
Mar  4 17:26:26 ftp0 kernel: [ 2470.177633] sd 3:0:0:0: [sdc] Write
Protect is off
Mar  4 17:26:26 ftp0 kernel: [ 2470.177657] sd 3:0:0:0: [sdc] Write
cache: disabled, read cache: enabled, doesn't support DPO or FUA
Mar  4 17:26:26 ftp0 kernel: [ 2470.177660]  sdc: sdc1 sdc2 < sdc5 >
Mar  4 17:26:26 ftp0 kernel: [ 2470.215634] sd 3:0:0:0: [sdc] Attached SCSI disk
Mar  4 17:26:26 ftp0 kernel: [ 2470.215936] sd 3:0:0:0: Attached scsi
generic sg1 type 0


Why is the new disk showing up as `sdc' instead of `sdb'  and why is
the write cache disabled?


Of course similar two lines below showing up only in dmesg and not in
messages file


[ 2465.456628] ata4: exception Emask 0x10 SAct 0x0 SErr 0x150000
action 0xe frozen
[ 2465.543901] ata4: SError: { PHYRdyChg CommWake Dispar }
[ 2465.606247] ata4: hard resetting link


Also, how can I find out if/when the raid1 sync completed? I do not
follow what the dmsetup status is saying


~$ sudo dmsetup status
nvidia_eeffhbef5: 0 6458067 linear
nvidia_eeffhbef1: 0 149838192 linear
nvidia_eeffhbef: 0 156301486 mirror 2 8:0 8:16 1183/1193 1 AD 1 core


-- 
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
