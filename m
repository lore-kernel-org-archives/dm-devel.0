From: John Hughes <john@Calva.COM>
Subject: Re: Dell MD3000/multipath - huge numbers of I/O errors
	on	boot
Date: Tue, 29 Sep 2009 18:55:31 +0200
Message-ID: <4AC23C03.4000405@Calva.COM>
References: <4ABCC970.70603@Calva.COM>
	<E463DF2B2E584B4A82673F53D62C2EF474E032F1@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474E032F1@cosmail01.lsi.com>
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

Moger, Babu wrote:
> This is a know problem.. As far as I know these errors mostly come during the boot-up if the scsi rdac handler is not there in the initrd image. You might want to try building scsi_dh_rdac into the initrd image.
Yay!  that works.  Now I get a nice quiet(ish) boot:

[    0.000000] Initializing cgroup subsys cpuset
...
[    1.292136] SCSI subsystem initialized
[    1.294173] rdac: device handler registered
...
[   30.781404] scsi3 : ioc0: LSISAS1068 B0, FwRev=000a3300h, Ports=1, MaxQ=366, IRQ=38
[   30.820324] scsi 3:0:0:0: Direct-Access     DELL     MD3000           0735 PQ: 0 ANSI: 5
[   30.843415] scsi 3:0:0:0: rdac: LUN 0 (owned)
[   30.843838] sd 3:0:0:0: [sdb] 142323712 512-byte hardware sectors: (72.8 GB/67.8 GiB)
[   30.844158] sd 3:0:0:0: [sdb] Write Protect is off
[   30.844251] sd 3:0:0:0: [sdb] Mode Sense: 77 00 10 08
[   30.844929] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   30.845678] sd 3:0:0:0: [sdb] 142323712 512-byte hardware sectors: (72.8 GB/67.8 GiB)
[   30.846020] sd 3:0:0:0: [sdb] Write Protect is off
[   30.846114] sd 3:0:0:0: [sdb] Mode Sense: 77 00 10 08
[   30.846532] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   30.846649]  sdb: unknown partition table
[   30.857018] sd 3:0:0:0: [sdb] Attached SCSI disk
[   30.857114] sd 3:0:0:0: Embedded Enclosure Device
[   31.229896] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   31.234390] scsi 3:0:0:1: Direct-Access     DELL     MD3000           0735 PQ: 0 ANSI: 5
[   31.256709] scsi 3:0:0:1: rdac: LUN 1 (unowned)
[   31.257125] sd 3:0:0:1: [sdc] 142323712 512-byte hardware sectors: (72.8 GB/67.8 GiB)
[   31.257444] sd 3:0:0:1: [sdc] Write Protect is off
[   31.257539] sd 3:0:0:1: [sdc] Mode Sense: 77 00 10 08
[   31.257909] sd 3:0:0:1: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   31.258338] sd 3:0:0:1: [sdc] 142323712 512-byte hardware sectors: (72.8 GB/67.8 GiB)
[   31.258651] sd 3:0:0:1: [sdc] Write Protect is off
[   31.258744] sd 3:0:0:1: [sdc] Mode Sense: 77 00 10 08
[   31.259108] sd 3:0:0:1: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   31.259223]  sdc:<2>ldm_validate_partition_table(): Disk read failed.
[   31.264296] Dev sdc: unable to read RDB block 0
[   31.264389]  unable to read partition table
[   31.264521] sd 3:0:0:1: [sdc] Attached SCSI disk
[   31.264614] sd 3:0:0:1: Embedded Enclosure Device
[   31.528977] sd 3:0:0:1: Attached scsi generic sg4 type 0
