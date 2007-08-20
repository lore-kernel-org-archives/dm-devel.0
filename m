From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: dm-multipath doesn't work with read-only devices in
	RedHat 5 ?
Date: Mon, 20 Aug 2007 14:49:32 +0200
Message-ID: <922357036.20070820144932@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
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

Hi!
It seems I can't create a multipath map to read-only device
in RedHat 5.0, while I was able to do so in RedHat 4.4.
When I change the device to disable write-protect, it's OK.

SCSI device sdf: 33554432 512-byte hdwr sectors (17180 MB)
sdf: Write Protect is on
SCSI device sdf: drive cache: write through

# ls -l /dev/sdf
brw-r----- 1 root disk 8, 80 Aug 20 16:37 /dev/sdf

# dmsetup --version
Library version:   1.02.13 (2006-11-28)
Driver version:    4.11.0

# dmsetup create qqq << EOF
> 0 33554432 multipath 0 0 1 1 round-robin 0 1 1 8:80 1000
> EOF
device-mapper: table: 253:11: multipath: error getting device
device-mapper: ioctl: error adding target to table
device-mapper: reload ioctl failed: Invalid argument
Command failed

When I remove write-protect from the device and rescan it, everything
is OK:

SCSI device sdf: 33554432 512-byte hdwr sectors (17180 MB)
sdf: Write Protect is off
SCSI device sdf: drive cache: write through

# dmsetup create qqq << EOF
> 0 33554432 multipath 0 0 1 1 round-robin 0 1 1 8:80 1000
> EOF
# dmsetup table qqq
0 33554432 multipath 0 0 1 1 round-robin 0 1 1 8:80 1000

Relevant strace:
fstat(4, {st_mode=S_IFREG|0644, st_size=58, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x2aaaadfcc000
read(4, "0 33554432 multipath 0 0 1 1 rou"..., 4096) = 58
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0x2aaaadfcc000, 4096)            = 0
ioctl(3, DM_DEV_CREATE, 0x118d3ac0)     = 0
ioctl(3, DM_TABLE_LOAD, 0x118d3ac0)     = -1 EINVAL (Invalid argument)

What would you advise?

Thanks,

Maxim.
