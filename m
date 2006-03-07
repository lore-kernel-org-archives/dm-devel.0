From: Mirko Vogt <mirko-vogt@web.de>
Subject: dmcrypt on OpenWrt (using uClibc)
Date: Tue, 07 Mar 2006 20:06:33 +0100
Message-ID: <440DD9B9.1040504@web.de>
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

Hi!

I ported dm-crypt to OpenWrt but have a few problems using it.
OpenWrt is based on the uClibc - maybe it's relevant.
The kernel-modules are loaded successfully, this seems not to be the
problem - aes, too.

# dmsetup create foo /dev/scsi/host0/bus0/target0/lun0/part1
/dev/scsi/host0/bus0/target0/lun0/part1:1 Invalid format
Command failed
#

Here is a strace:

# strace dmsetup create foo /dev/scsi/host0/bus0/target0/lun0/part1
execve("/usr/sbin/dmsetup", ["dmsetup", "create", "foo",
"/dev/scsi/host0/bus0/target0/lun"...], [/* 8 vars */]) = 0
svr4_syscall()                          = -1 ERRNO_4090 (Unknown error 4090)
stat("/etc/ld.so.cache", 0x7ffe6ad8)    = -1 ENOENT (No such file or
directory)
open("/lib/libdevmapper.so.1.02", O_RDONLY) = -1 ENOENT (No such file or
directory)
open("/lib/libdevmapper.so.1.02", O_RDONLY) = -1 ENOENT (No such file or
directory)
open("/usr/lib/libdevmapper.so.1.02", O_RDONLY) = 3
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x2aaae000
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\20\36"...,
4096) = 4096
old_mmap(NULL, 323584, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x2aaed000
old_mmap(0x2aaed000, 55052, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
3, 0) = 0x2aaed000
old_mmap(0x2ab3a000, 7154, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED,
3, 0xd000) = 0x2ab3a000
close(3)                                = 0
munmap(0x2aaae000, 4096)                = 0
open("/lib/libc.so.0", O_RDONLY)        = 3
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x2aaae000
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\240\270"...,
4096) = 4096
old_mmap(NULL, 655360, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x2ab3c000
old_mmap(0x2ab3c000, 366372, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
3, 0) = 0x2ab3c000
old_mmap(0x2abd6000, 4479, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED,
3, 0x5a000) = 0x2abd6000
old_mmap(0x2abd8000, 15640, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x2abd8000
close(3)                                = 0
munmap(0x2aaae000, 4096)                = 0
ioctl(0, TIOCNXCL, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCNXCL, {B38400 opost isig icanon echo ...}) = 0
brk(0)                                  = 0x10002000
brk(0x10003000)                         = 0x10003000
open("/proc/devices", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, TIOCNXCL, 0x7ffe5858)          = -1 ENOTTY (Inappropriate ioctl
for device)
brk(0x10004000)                         = 0x10004000
read(3, "Character devices:\n  1 mem\n  4 t"..., 4096) = 305
close(3)                                = 0
open("/proc/misc", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, TIOCNXCL, 0x7ffe5858)          = -1 ENOTTY (Inappropriate ioctl
for device)
read(3, " 63 device-mapper\n200 tun\n", 4096) = 26
close(3)                                = 0
stat64(0x7ffe5ac0, 0x7ffe59f0)          = 0
open("/dev/mapper/control", O_RDWR|O_LARGEFILE) = 3
open("/proc/devices", O_RDONLY|O_LARGEFILE) = 4
ioctl(4, TIOCNXCL, 0x7ffe5838)          = -1 ENOTTY (Inappropriate ioctl
for device)
read(4, "Character devices:\n  1 mem\n  4 t"..., 4096) = 305
read(4, "", 4096)                       = 0
close(4)                                = 0
brk(0x10007000)                         = 0x10007000
ioctl(3, 0xc138fd00, 0x100023d0)        = 0
open("/dev/scsi/host0/bus0/target0/lun0/part1", O_RDONLY|O_LARGEFILE) = 4
ioctl(4, TIOCNXCL, 0x7ffe63e8)          = -1 EINVAL (Invalid argument)
read(4, "\27\264,\222\10py\204w\17\326\2\17;\374\361>\376\353\254"...,
4096) = 4096
write(2, "/dev/scsi/host0/bus0/target0/lun"...,
39/dev/scsi/host0/bus0/target0/lun0/part1) = 39
write(2, ":", 1:)                        = 1
write(2, "1", 11)                        = 1
write(2, " Invalid format\n", 16 Invalid format
)       = 16
close(4)                                = 0
write(2, "Command failed\n", 15Command failed
)        = 15
close(3)                                = 0
exit(1)
#

Sorry for my bad English.

Thanks a lot - you are my last hope,

Mirko
