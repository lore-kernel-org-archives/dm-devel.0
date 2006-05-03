From: Casey Feskens <cfeskens@willamette.edu>
Subject: RHEL4U3 multipath returns nothing
Date: Wed, 03 May 2006 09:55:23 -0700
Message-ID: <4458E07B.8090504@willamette.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I'm having some issues working with multipath-tools for the first time, 
and hoping I can get some assistance.  I'm using RHEL4 Update 3, and 
device-mapper-multipath-0.4.5-12.0.RHEL4, connecting to a EMC CX300.

On boot, multipathing seems to work properly, but I'm finding myself unable
to add new multipath devices after boot.  I'm also experiencing the 
problem that
some others report, where the multipath command returns nothing.  I can 
get as
far as multipathd recognizing the new devices in an "orphan" state:

multipathd> list paths

0:0:2:0 sda 8:0    [ready] [orphan]
1:0:0:0 sdb 8:16   [active][ready] XXXXXXXXX........... 9/20
1:0:1:0 sdc 8:32  1 [active][ready] XXXXXXXXX........... 9/20
2:0:0:0 sdd 8:48   [active][ready] XXXXXXXXX........... 9/20
2:0:1:0 sde 8:64  1 [active][ready] XXXXXXXXX........... 9/20
1:0:0:1 sdg 8:96   [ready] [orphan]
1:0:1:1 sdh 8:112  [ready] [orphan]
2:0:0:1 sdi 8:128  [ready] [orphan]
2:0:1:1 sdj 8:144  [ready] [orphan]

But am unsure how to activate the new paths.  The 'multipath' command
returns nothing unless debugging is turned up.  Does anyone have any
advice?  Is anyone else using RHEL4U3 and able to get 'multipath' to
return any output?

Thanks for any help you may be able to offer.

Here is the output of 'multipath -v3'

load path identifiers cache
#
# all paths in cache :
#
3600508e0000000001d536334e1ad3203  0:0:2:0 sda 8:0  [ready] 
LSILOGIC/Logical V
360060160816015006484729e02d7da11  1:0:0:0 sdb 8:16  [active][ready] 
DGC     /
360060160816015006484729e02d7da11  1:0:1:0 sdc 8:32 1 [active][ready] DGC
360060160816015006484729e02d7da11  2:0:0:0 sdd 8:48  [active][ready] 
DGC     /
360060160816015006484729e02d7da11  2:0:1:0 sde 8:64 1 [active][ready] DGC
36006016081601500e052340032dada11  1:0:0:1 sdg 8:96  [ready] DGC     /RAID 5
36006016081601500e052340032dada11  1:0:1:1 sdh 8:112  [ready] DGC     
/RAID 5
36006016081601500e052340032dada11  2:0:0:1 sdi 8:128  [ready] DGC     
/RAID 5
36006016081601500e052340032dada11  2:0:1:1 sdj 8:144  [ready] DGC     
/RAID 5
dm-0 blacklisted
hda blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
===== path info sda (mask 0x1f) =====
bus = 1
dev_t = 8:0
size = 142577664
vendor = LSILOGIC
product = Logical Volume
rev = 3000
h:b:t:l = 0:0:2:0
tgt_node_name =
serial =
path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
uid = 3600508e0000000001d536334e1ad3203 (cache)
===== path info sdb (mask 0x1f) =====
bus = 1
dev_t = 8:16
size = 209715200
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 1:0:0:0
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 0
uid = 360060160816015006484729e02d7da11 (cache)
===== path info sdc (mask 0x1f) =====
bus = 1
dev_t = 8:32
size = 209715200
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 1:0:1:0
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 1
uid = 360060160816015006484729e02d7da11 (cache)
===== path info sdd (mask 0x1f) =====
bus = 1
dev_t = 8:48
size = 209715200
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 2:0:0:0
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 0
uid = 360060160816015006484729e02d7da11 (cache)
===== path info sde (mask 0x1f) =====
bus = 1
dev_t = 8:64
size = 209715200
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 2:0:1:0
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 1
uid = 360060160816015006484729e02d7da11 (cache)
path sdf not found in pathvec

===== path info sdf (mask 0x1f) =====
bus = 1
dev_t = 8:80
===== path info sdg (mask 0x1f) =====
bus = 1
dev_t = 8:96
size = 125829120
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 1:0:0:1
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 0
uid = 36006016081601500e052340032dada11 (cache)
===== path info sdh (mask 0x1f) =====
bus = 1
dev_t = 8:112
size = 125829120
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 1:0:1:1
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 1
uid = 36006016081601500e052340032dada11 (cache)
===== path info sdi (mask 0x1f) =====
bus = 1
dev_t = 8:128
size = 125829120
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 2:0:0:1
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 0
uid = 36006016081601500e052340032dada11 (cache)
===== path info sdj (mask 0x1f) =====
bus = 1
dev_t = 8:144
size = 125829120
vendor = DGC
product = RAID 5
rev = 0216
h:b:t:l = 2:0:1:1
tgt_node_name = 0x50060160b02188c1
serial = APM00052503252
path checker = emc_clariion (controler setting)
state = 2
getprio = /sbin/mpath_prio_emc /dev/%n (controler setting)
prio = 1
uid = 36006016081601500e052340032dada11 (cache)
sr0 blacklisted

And an strace of multipath -v0:

23068 execve("/sbin/multipath", ["multipath", "-v0"], [/* 18 vars */]) = 0
23068 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23068 brk(0)                            = 0x524000
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23068 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23068 open("/etc/ld.so.cache", O_RDONLY) = 3
23068 fstat(3, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23068 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 3, 0) = 0x2a95557000
23068 close(3)                          = 0
23068 open("/lib64/libdevmapper.so.1.02", O_RDONLY) = 3
23068 read(3, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\2603\200"..., 832) = 832
23068 fstat(3, {st_mode=S_IFREG|0555, st_size=64904, ...}) = 0
23068 mmap(0x39cd800000, 1108680, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x39cd800000
23068 mprotect(0x39cd80e000, 1051336, PROT_NONE) = 0
23068 mmap(0x39cd90d000, 8192, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd000) = 0x39cd90d000
23068 close(3)                          = 0
23068 open("/usr/lib64/libsysfs.so.1", O_RDONLY) = 3
23068 read(3, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200/`\315"..., 832) = 832
23068 fstat(3, {st_mode=S_IFREG|0755, st_size=51776, ...}) = 0
23068 mmap(0x39cd600000, 1096328, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x39cd600000
23068 mprotect(0x39cd60c000, 1047176, PROT_NONE) = 0
23068 mmap(0x39cd70b000, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xb000) = 0x39cd70b000
23068 close(3)                          = 0
23068 open("/lib64/tls/libc.so.6", O_RDONLY) = 3
23068 read(3, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23068 fstat(3, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23068 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x39cd300000
23068 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23068 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x12a000) = 0x39cd52a000
23068 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23068 close(3)                          = 0
23068 open("/lib64/libselinux.so.1", O_RDONLY) = 3
23068 read(3, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220+\300"..., 832) = 832
23068 fstat(3, {st_mode=S_IFREG|0755, st_size=62504, ...}) = 0
23068 mmap(0x39cdc00000, 1111640, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x39cdc00000
23068 mprotect(0x39cdc0e000, 1054296, PROT_NONE) = 0
23068 mmap(0x39cdd0e000, 4096, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xe000) = 0x39cdd0e000
23068 mmap(0x39cdd0f000, 1624, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cdd0f000
23068 close(3)                          = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95565000
23068 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23068 arch_prctl(ARCH_SET_FS, 0x2a955648a0) = 0
23068 munmap(0x2a95557000, 46176)       = 0
23068 access("/etc/selinux/", F_OK)     = 0
23068 brk(0)                            = 0x524000
23068 brk(0x545000)                     = 0x545000
23068 open("/etc/selinux/config", O_RDONLY) = 3
23068 fstat(3, {st_mode=S_IFREG|0644, st_size=449, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(3, "# This file controls the state o"..., 4096) = 449
23068 close(3)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 open("/proc/mounts", O_RDONLY)    = 3
23068 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(3, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(3)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 getuid()                          = 0
23068 open("/proc/devices", O_RDONLY)   = 3
23068 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(3, "Character devices:\n  1 mem\n  4 /"..., 1024) = 438
23068 close(3)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 open("/proc/misc", O_RDONLY)      = 3
23068 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(3, "165 vmmon\n 63 device-mapper\n183 "..., 1024) = 61
23068 close(3)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 stat("/dev/mapper/control", {st_mode=S_IFCHR|0600, 
st_rdev=makedev(10, 63), ...}) = 0
23068 open("/dev/mapper/control", O_RDWR) = 3
23068 open("/proc/devices", O_RDONLY)   = 4
23068 fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(4, "Character devices:\n  1 mem\n  4 /"..., 1024) = 438
23068 read(4, "", 1024)                 = 0
23068 close(4)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 ioctl(3, DM_VERSION, 0x5254e0)    = 0
23068 ioctl(3, DM_LIST_VERSIONS, 0x5254e0) = 0
23068 open("/proc/mounts", O_RDONLY)    = 4
23068 fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(4, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(4)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 stat("/etc/multipath.conf", {st_mode=S_IFREG|0644, st_size=8791, 
...}) = 023068 open("/etc/multipath.conf", O_RDONLY) = 4
23068 fstat(4, {st_mode=S_IFREG|0644, st_size=8791, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(4, "# These are the compiled in defa"..., 4096) = 4096
23068 read(4, "h\"\n#\t\tpath_checker\t\temc_clariion"..., 4096) = 4096
23068 read(4, "out          \"/sbin/scsi_id -g -"..., 4096) = 599
23068 read(4, "", 4096)                 = 0
23068 close(4)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 socket(PF_FILE, SOCK_STREAM, 0)   = 4
23068 connect(4, {sa_family=AF_FILE, path="/var/run/multipathd.sock"}, 
110) = 0
23068 write(4, "\r\0\0\0\0\0\0\0", 8)   = 8
23068 write(4, "dump pathvec\0", 13)    = 13
23068 read(4, "\260\23\0\0\0\0\0\0", 8) = 8
23068 read(4, 
"sda\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 5040) = 5040
23068 close(4)                          = 0
23068 lstat("/sys/block", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/block", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 4
23068 fstat(4, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(4, /* 32 entries */, 4096) = 816
23068 lstat("/sys/block/sdj", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdj", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdh", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdh", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdg", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdg", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sr0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sr0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/dm-0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/dm-0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/md0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/md0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sde", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sde", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdd", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdd", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdc", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdc", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sdb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sda", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/sda", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/hda", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/hda", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram15", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram15", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram14", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram14", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram13", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram13", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram12", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram12", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram11", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram11", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram10", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram10", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram9", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram9", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram8", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram8", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram7", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram7", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram6", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram6", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram5", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram5", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram4", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram4", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram3", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram3", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram2", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram2", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram1", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram1", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/block/ram0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(4, /* 0 entries */, 4096) = 0
23068 close(4)                          = 0
23068 stat("/sys/block/sda/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sda/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:03.0/host0/target0:0:2/0:0:2:0", 
255) = 76
23068 
lstat("/sys/devices/pci0000:00/0000:00:02.0/0000:02:03.0/host0/target0:0:2/0:0:2:0", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 4
23068 fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(4, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(4)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 4
23068 fstat(4, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(4, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(4, /* 0 entries */, 4096) = 0
23068 close(4)                          = 0
23068 lstat("/sys/bus/i2c/devices/0:0:2:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/0:0:2:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/0:0:2:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/0:0:2:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/0:0:2:0", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/0:0:2:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/0:0:2:0", 
"../../../devices/pci0000:00/0000:00:02.0/0000:02:03.0/host0/target0:0:2/0:0:2:0", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 4
23068 fstat(4, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(4, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(4)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 4
23068 fstat(4, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(4, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(4, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(4, /* 0 entries */, 4096) = 0
23068 close(4)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/0:0:2:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sda/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sda/dev", O_RDONLY) = 4
23068 read(4, "8:0\n", 4096)            = 4
23068 close(4)                          = 0
23068 stat("/sys/block/sda/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sda/size", O_RDONLY) = 4
23068 read(4, "142577664\n", 4096)      = 10
23068 close(4)                          = 0
23068 stat("/sys/block/sda/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sda/device/vendor", O_RDONLY) = 4
23068 read(4, "LSILOGIC\n", 4096)       = 9
23068 close(4)                          = 0
23068 stat("/sys/block/sda/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sda/device/model", O_RDONLY) = 4
23068 read(4, "Logical Volume  \n", 4096) = 17
23068 close(4)                          = 0
23068 stat("/sys/block/sda/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sda/device/rev", O_RDONLY) = 4
23068 read(4, "3000\n", 4096)           = 5
23068 close(4)                          = 0
23068 readlink("/sys/block/sda/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:03.0/host0/target0:0:2/0:0:2:0", 
255) = 76
23068 stat("/sys/class/fc_transport/target0:0:2/node_name", 
0x7fbffff410) = -1 ENOENT (No such file or directory)
23068 open("/dev/sda", O_RDONLY)        = 4
23068 ioctl(4, SG_IO, 0x7fbffff520)     = 0
23068 ioctl(4, SG_IO, 0x7fbffff420)     = 0
23068 stat("/sys/block/sdb/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdb/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:0", 
255) = 76
23068 
lstat("/sys/devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:0", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 5
23068 fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(5, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(5)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 5
23068 fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(5, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(5, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(5, /* 0 entries */, 4096) = 0
23068 close(5)                          = 0
23068 lstat("/sys/bus/i2c/devices/1:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/1:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/1:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/1:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/1:0:0:0", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/1:0:0:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/1:0:0:0", 
"../../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:0", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 5
23068 fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(5, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(5)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 5
23068 fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(5, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(5, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(5, /* 0 entries */, 4096) = 0
23068 close(5)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/1:0:0:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdb/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdb/dev", O_RDONLY) = 5
23068 read(5, "8:16\n", 4096)           = 5
23068 close(5)                          = 0
23068 stat("/sys/block/sdb/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdb/size", O_RDONLY) = 5
23068 read(5, "209715200\n", 4096)      = 10
23068 close(5)                          = 0
23068 stat("/sys/block/sdb/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdb/device/vendor", O_RDONLY) = 5
23068 read(5, "DGC     \n", 4096)       = 9
23068 close(5)                          = 0
23068 stat("/sys/block/sdb/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdb/device/model", O_RDONLY) = 5
23068 read(5, "RAID 5          \n", 4096) = 17
23068 close(5)                          = 0
23068 stat("/sys/block/sdb/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdb/device/rev", O_RDONLY) = 5
23068 read(5, "0216\n", 4096)           = 5
23068 close(5)                          = 0
23068 readlink("/sys/block/sdb/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:0", 
255) = 76
23068 stat("/sys/class/fc_transport/target1:0:0/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target1:0:0/node_name", O_RDONLY) = 5
23068 read(5, "0x50060160b02188c1\n", 4096) = 19
23068 close(5)                          = 0
23068 open("/dev/sdb", O_RDONLY)        = 5
23068 ioctl(5, SG_IO, 0x7fbffff520)     = 0
23068 ioctl(5, SG_IO, 0x7fbffff520)     = 0
23068 pipe([6, 7])                      = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23069
23068 close(7 <unfinished ...>
23069 close(1 <unfinished ...>
23068 <... close resumed> )             = 0
23069 <... close resumed> )             = 0
23068 read(6,  <unfinished ...>
23069 dup(7)                            = 1
23069 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdb"], [/* 18 vars */]) = 0
23069 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23069 brk(0)                            = 0x502000
23069 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23069 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23069 open("/etc/ld.so.cache", O_RDONLY) = 8
23069 fstat(8, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23069 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 8, 0) = 0x2a95557000
23069 close(8)                          = 0
23069 open("/lib64/tls/libc.so.6", O_RDONLY) = 8
23069 read(8, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23069 fstat(8, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23069 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 8, 0) = 0x39cd300000
23069 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23069 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 8, 0x12a000) = 0x39cd52a000
23069 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23069 close(8)                          = 0
23069 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23069 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23069 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23069 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23069 munmap(0x2a95557000, 46176)       = 0
23069 open("/dev/sdb", O_RDWR|O_NONBLOCK) = 8
23069 ioctl(8, SG_IO, 0x7fbffff7b0)     = 0
23069 close(8)                          = 0
23069 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23069 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23069 write(1, "0\n", 2 <unfinished ...>
23068 <... read resumed> "0\n", 15)     = 2
23069 <... write resumed> )             = 2
23068 read(6,  <unfinished ...>
23069 munmap(0x2a95557000, 4096)        = 0
23069 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23069
23068 close(6)                          = 0
23068 stat("/sys/block/sdc/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdc/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:0", 
255) = 76
23068 
lstat("/sys/devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:0", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 6
23068 fstat(6, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(6, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(6)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 6
23068 fstat(6, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(6, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(6, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(6, /* 0 entries */, 4096) = 0
23068 close(6)                          = 0
23068 lstat("/sys/bus/i2c/devices/1:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/1:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/1:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/1:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/1:0:1:0", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/1:0:1:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/1:0:1:0", 
"../../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:0", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 6
23068 fstat(6, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(6, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(6)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 6
23068 fstat(6, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(6, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(6, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(6, /* 0 entries */, 4096) = 0
23068 close(6)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/1:0:1:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdc/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdc/dev", O_RDONLY) = 6
23068 read(6, "8:32\n", 4096)           = 5
23068 close(6)                          = 0
23068 stat("/sys/block/sdc/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdc/size", O_RDONLY) = 6
23068 read(6, "209715200\n", 4096)      = 10
23068 close(6)                          = 0
23068 stat("/sys/block/sdc/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdc/device/vendor", O_RDONLY) = 6
23068 read(6, "DGC     \n", 4096)       = 9
23068 close(6)                          = 0
23068 stat("/sys/block/sdc/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdc/device/model", O_RDONLY) = 6
23068 read(6, "RAID 5          \n", 4096) = 17
23068 close(6)                          = 0
23068 stat("/sys/block/sdc/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdc/device/rev", O_RDONLY) = 6
23068 read(6, "0216\n", 4096)           = 5
23068 close(6)                          = 0
23068 readlink("/sys/block/sdc/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:0", 
255) = 76
23068 stat("/sys/class/fc_transport/target1:0:1/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target1:0:1/node_name", O_RDONLY) = 6
23068 read(6, "0x50060160b02188c1\n", 4096) = 19
23068 close(6)                          = 0
23068 open("/dev/sdc", O_RDONLY)        = 6
23068 ioctl(6, SG_IO, 0x7fbffff520)     = 0
23068 ioctl(6, SG_IO, 0x7fbffff520)     = 0
23068 pipe([7, 8])                      = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23070
23068 close(8)                          = 0
23068 read(7,  <unfinished ...>
23070 close(1)                          = 0
23070 dup(8)                            = 1
23070 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdc"], [/* 18 vars */]) = 0
23070 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23070 brk(0)                            = 0x502000
23070 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23070 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23070 open("/etc/ld.so.cache", O_RDONLY) = 9
23070 fstat(9, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23070 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 9, 0) = 0x2a95557000
23070 close(9)                          = 0
23070 open("/lib64/tls/libc.so.6", O_RDONLY) = 9
23070 read(9, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23070 fstat(9, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23070 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 9, 0) = 0x39cd300000
23070 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23070 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 9, 0x12a000) = 0x39cd52a000
23070 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23070 close(9)                          = 0
23070 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23070 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23070 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23070 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23070 munmap(0x2a95557000, 46176)       = 0
23070 open("/dev/sdc", O_RDWR|O_NONBLOCK) = 9
23070 ioctl(9, SG_IO, 0x7fbffff7b0)     = 0
23070 close(9)                          = 0
23070 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23070 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23070 write(1, "1\n", 2 <unfinished ...>
23068 <... read resumed> "1\n", 15)     = 2
23070 <... write resumed> )             = 2
23068 read(7,  <unfinished ...>
23070 munmap(0x2a95557000, 4096)        = 0
23070 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23070
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(7)                          = 0
23068 stat("/sys/block/sdd/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdd/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:0", 
255) = 76
23068 
lstat("/sys/devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:0", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 7
23068 fstat(7, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(7, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(7)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 7
23068 fstat(7, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(7, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(7, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(7, /* 0 entries */, 4096) = 0
23068 close(7)                          = 0
23068 lstat("/sys/bus/i2c/devices/2:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/2:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/2:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/2:0:0:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/2:0:0:0", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/2:0:0:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/2:0:0:0", 
"../../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:0", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 7
23068 fstat(7, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(7, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(7)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 7
23068 fstat(7, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(7, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(7, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(7, /* 0 entries */, 4096) = 0
23068 close(7)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/2:0:0:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdd/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdd/dev", O_RDONLY) = 7
23068 read(7, "8:48\n", 4096)           = 5
23068 close(7)                          = 0
23068 stat("/sys/block/sdd/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdd/size", O_RDONLY) = 7
23068 read(7, "209715200\n", 4096)      = 10
23068 close(7)                          = 0
23068 stat("/sys/block/sdd/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdd/device/vendor", O_RDONLY) = 7
23068 read(7, "DGC     \n", 4096)       = 9
23068 close(7)                          = 0
23068 stat("/sys/block/sdd/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdd/device/model", O_RDONLY) = 7
23068 read(7, "RAID 5          \n", 4096) = 17
23068 close(7)                          = 0
23068 stat("/sys/block/sdd/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdd/device/rev", O_RDONLY) = 7
23068 read(7, "0216\n", 4096)           = 5
23068 close(7)                          = 0
23068 readlink("/sys/block/sdd/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:0", 
255) = 76
23068 stat("/sys/class/fc_transport/target2:0:0/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target2:0:0/node_name", O_RDONLY) = 7
23068 read(7, "0x50060160b02188c1\n", 4096) = 19
23068 close(7)                          = 0
23068 open("/dev/sdd", O_RDONLY)        = 7
23068 ioctl(7, SG_IO, 0x7fbffff520)     = 0
23068 ioctl(7, SG_IO, 0x7fbffff520)     = 0
23068 pipe([8, 9])                      = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23071
23068 close(9 <unfinished ...>
23071 close(1 <unfinished ...>
23068 <... close resumed> )             = 0
23068 read(8,  <unfinished ...>
23071 <... close resumed> )             = 0
23071 dup(9)                            = 1
23071 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdd"], [/* 18 vars */]) = 0
23071 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23071 brk(0)                            = 0x502000
23071 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23071 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23071 open("/etc/ld.so.cache", O_RDONLY) = 10
23071 fstat(10, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23071 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 10, 0) = 0x2a95557000
23071 close(10)                         = 0
23071 open("/lib64/tls/libc.so.6", O_RDONLY) = 10
23071 read(10, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23071 fstat(10, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23071 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 10, 0) = 0x39cd300000
23071 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23071 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 10, 0x12a000) = 0x39cd52a000
23071 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23071 close(10)                         = 0
23071 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23071 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23071 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23071 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23071 munmap(0x2a95557000, 46176)       = 0
23071 open("/dev/sdd", O_RDWR|O_NONBLOCK) = 10
23071 ioctl(10, SG_IO, 0x7fbffff7b0)    = 0
23071 close(10)                         = 0
23071 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23071 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23071 write(1, "0\n", 2)                = 2
23068 <... read resumed> "0\n", 15)     = 2
23068 read(8,  <unfinished ...>
23071 munmap(0x2a95557000, 4096)        = 0
23071 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23071
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(8)                          = 0
23068 stat("/sys/block/sde/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sde/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:0", 
255) = 76
23068 
lstat("/sys/devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:0", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 8
23068 fstat(8, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(8, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(8)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 8
23068 fstat(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(8, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(8, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(8, /* 0 entries */, 4096) = 0
23068 close(8)                          = 0
23068 lstat("/sys/bus/i2c/devices/2:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/2:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/2:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/2:0:1:0", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/2:0:1:0", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/2:0:1:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/2:0:1:0", 
"../../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:0", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 8
23068 fstat(8, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(8, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(8)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 8
23068 fstat(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(8, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(8, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(8, /* 0 entries */, 4096) = 0
23068 close(8)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/2:0:1:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sde/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sde/dev", O_RDONLY) = 8
23068 read(8, "8:64\n", 4096)           = 5
23068 close(8)                          = 0
23068 stat("/sys/block/sde/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sde/size", O_RDONLY) = 8
23068 read(8, "209715200\n", 4096)      = 10
23068 close(8)                          = 0
23068 stat("/sys/block/sde/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sde/device/vendor", O_RDONLY) = 8
23068 read(8, "DGC     \n", 4096)       = 9
23068 close(8)                          = 0
23068 stat("/sys/block/sde/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sde/device/model", O_RDONLY) = 8
23068 read(8, "RAID 5          \n", 4096) = 17
23068 close(8)                          = 0
23068 stat("/sys/block/sde/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sde/device/rev", O_RDONLY) = 8
23068 read(8, "0216\n", 4096)           = 5
23068 close(8)                          = 0
23068 readlink("/sys/block/sde/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:0", 
255) = 76
23068 stat("/sys/class/fc_transport/target2:0:1/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target2:0:1/node_name", O_RDONLY) = 8
23068 read(8, "0x50060160b02188c1\n", 4096) = 19
23068 close(8)                          = 0
23068 open("/dev/sde", O_RDONLY)        = 8
23068 ioctl(8, SG_IO, 0x7fbffff520)     = 0
23068 ioctl(8, SG_IO, 0x7fbffff520)     = 0
23068 pipe([9, 10])                     = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23072
23068 close(10)                         = 0
23068 read(9,  <unfinished ...>
23072 close(1)                          = 0
23072 dup(10)                           = 1
23072 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sde"], [/* 18 vars */]) = 0
23072 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23072 brk(0)                            = 0x502000
23072 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23072 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23072 open("/etc/ld.so.cache", O_RDONLY) = 11
23072 fstat(11, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23072 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 11, 0) = 0x2a95557000
23072 close(11)                         = 0
23072 open("/lib64/tls/libc.so.6", O_RDONLY) = 11
23072 read(11, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23072 fstat(11, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23072 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 11, 0) = 0x39cd300000
23072 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23072 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 11, 0x12a000) = 0x39cd52a000
23072 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23072 close(11)                         = 0
23072 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23072 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23072 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23072 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23072 munmap(0x2a95557000, 46176)       = 0
23072 open("/dev/sde", O_RDWR|O_NONBLOCK) = 11
23072 ioctl(11, SG_IO, 0x7fbffff7b0)    = 0
23072 close(11)                         = 0
23072 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23072 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23072 write(1, "1\n", 2)                = 2
23068 <... read resumed> "1\n", 15)     = 2
23068 read(9,  <unfinished ...>
23072 munmap(0x2a95557000, 4096)        = 0
23072 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23072
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(9)                          = 0
23068 stat("/sys/block/sdf/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdf/device", 
"../../devices/pci0000:00/0000:00:06.0/0000:03:00.1/usb2/2-2/2-2:1.0/host4/target4:0:0/4:0:0:0", 
255) = 93
23068 
lstat("/sys/devices/pci0000:00/0000:00:06.0/0000:03:00.1/usb2/2-2/2-2:1.0/host4/target4:0:0/4:0:0:0", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 9
23068 fstat(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(9, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(9)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 9
23068 fstat(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(9, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(9, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(9, /* 0 entries */, 4096) = 0
23068 close(9)                          = 0
23068 lstat("/sys/bus/i2c/devices/4:0:0:0", 0x7fbfffef00) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/4:0:0:0", 0x7fbfffef00) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/4:0:0:0", 0x7fbfffef00) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/4:0:0:0", 0x7fbfffef00) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/4:0:0:0", 0x7fbfffef00) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/4:0:0:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/4:0:0:0", 
"../../../devices/pci0000:00/0000:00:06.0/0000:03:00.1/usb2/2-2/2-2:1.0/host4/target4:0:0/4:0:0:0", 
255) = 96
23068 open("/proc/mounts", O_RDONLY)    = 9
23068 fstat(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(9, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(9)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 9
23068 fstat(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(9, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(9, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(9, /* 0 entries */, 4096) = 0
23068 close(9)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/4:0:0:0", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdf/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdf/dev", O_RDONLY) = 9
23068 read(9, "8:80\n", 4096)           = 5
23068 close(9)                          = 0
23068 stat("/sys/block/sdf/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdf/size", O_RDONLY) = 9
23068 read(9, "0\n", 4096)              = 2
23068 close(9)                          = 0
23068 stat("/sys/block/sdg/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdg/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:1", 
255) = 76
23068 
lstat("/sys/devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:1", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 9
23068 fstat(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(9, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(9)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 9
23068 fstat(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(9, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(9, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(9, /* 0 entries */, 4096) = 0
23068 close(9)                          = 0
23068 lstat("/sys/bus/i2c/devices/1:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/1:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/1:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/1:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/1:0:0:1", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/1:0:0:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/1:0:0:1", 
"../../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:1", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 9
23068 fstat(9, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(9, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(9)                          = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 9
23068 fstat(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(9, F_SETFD, FD_CLOEXEC)     = 0
23068 getdents64(9, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(9, /* 0 entries */, 4096) = 0
23068 close(9)                          = 0
23068 lstat("/sys/bus/scsi/drivers/sd/1:0:0:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdg/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdg/dev", O_RDONLY) = 9
23068 read(9, "8:96\n", 4096)           = 5
23068 close(9)                          = 0
23068 stat("/sys/block/sdg/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdg/size", O_RDONLY) = 9
23068 read(9, "125829120\n", 4096)      = 10
23068 close(9)                          = 0
23068 stat("/sys/block/sdg/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdg/device/vendor", O_RDONLY) = 9
23068 read(9, "DGC     \n", 4096)       = 9
23068 close(9)                          = 0
23068 stat("/sys/block/sdg/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdg/device/model", O_RDONLY) = 9
23068 read(9, "RAID 5          \n", 4096) = 17
23068 close(9)                          = 0
23068 stat("/sys/block/sdg/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdg/device/rev", O_RDONLY) = 9
23068 read(9, "0216\n", 4096)           = 5
23068 close(9)                          = 0
23068 readlink("/sys/block/sdg/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:0/1:0:0:1", 
255) = 76
23068 stat("/sys/class/fc_transport/target1:0:0/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target1:0:0/node_name", O_RDONLY) = 9
23068 read(9, "0x50060160b02188c1\n", 4096) = 19
23068 close(9)                          = 0
23068 open("/dev/sdg", O_RDONLY)        = 9
23068 ioctl(9, SG_IO, 0x7fbffff520)     = 0
23068 ioctl(9, SG_IO, 0x7fbffff520)     = 0
23068 pipe([10, 11])                    = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23073
23068 close(11)                         = 0
23068 read(10,  <unfinished ...>
23073 close(1)                          = 0
23073 dup(11)                           = 1
23073 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdg"], [/* 18 vars */]) = 0
23073 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23073 brk(0)                            = 0x502000
23073 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23073 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23073 open("/etc/ld.so.cache", O_RDONLY) = 12
23073 fstat(12, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23073 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 12, 0) = 0x2a95557000
23073 close(12)                         = 0
23073 open("/lib64/tls/libc.so.6", O_RDONLY) = 12
23073 read(12, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23073 fstat(12, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23073 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 12, 0) = 0x39cd300000
23073 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23073 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 12, 0x12a000) = 0x39cd52a000
23073 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23073 close(12)                         = 0
23073 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23073 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23073 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23073 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23073 munmap(0x2a95557000, 46176)       = 0
23073 open("/dev/sdg", O_RDWR|O_NONBLOCK) = 12
23073 ioctl(12, SG_IO, 0x7fbffff7b0)    = 0
23073 close(12)                         = 0
23073 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23073 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23073 write(1, "0\n", 2)                = 2
23068 <... read resumed> "0\n", 15)     = 2
23068 read(10,  <unfinished ...>
23073 munmap(0x2a95557000, 4096)        = 0
23073 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23073
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(10)                         = 0
23068 stat("/sys/block/sdh/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdh/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:1", 
255) = 76
23068 
lstat("/sys/devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:1", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 10
23068 fstat(10, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(10, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(10)                         = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 10
23068 fstat(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(10, F_SETFD, FD_CLOEXEC)    = 0
23068 getdents64(10, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(10, /* 0 entries */, 4096) = 0
23068 close(10)                         = 0
23068 lstat("/sys/bus/i2c/devices/1:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/1:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/1:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/1:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/1:0:1:1", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/1:0:1:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/1:0:1:1", 
"../../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:1", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 10
23068 fstat(10, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(10, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(10)                         = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 10
23068 fstat(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(10, F_SETFD, FD_CLOEXEC)    = 0
23068 getdents64(10, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(10, /* 0 entries */, 4096) = 0
23068 close(10)                         = 0
23068 lstat("/sys/bus/scsi/drivers/sd/1:0:1:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdh/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdh/dev", O_RDONLY) = 10
23068 read(10, "8:112\n", 4096)         = 6
23068 close(10)                         = 0
23068 stat("/sys/block/sdh/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdh/size", O_RDONLY) = 10
23068 read(10, "125829120\n", 4096)     = 10
23068 close(10)                         = 0
23068 stat("/sys/block/sdh/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdh/device/vendor", O_RDONLY) = 10
23068 read(10, "DGC     \n", 4096)      = 9
23068 close(10)                         = 0
23068 stat("/sys/block/sdh/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdh/device/model", O_RDONLY) = 10
23068 read(10, "RAID 5          \n", 4096) = 17
23068 close(10)                         = 0
23068 stat("/sys/block/sdh/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdh/device/rev", O_RDONLY) = 10
23068 read(10, "0216\n", 4096)          = 5
23068 close(10)                         = 0
23068 readlink("/sys/block/sdh/device", 
"../../devices/pci0000:00/0000:00:02.0/0000:02:01.0/host1/target1:0:1/1:0:1:1", 
255) = 76
23068 stat("/sys/class/fc_transport/target1:0:1/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target1:0:1/node_name", O_RDONLY) = 10
23068 read(10, "0x50060160b02188c1\n", 4096) = 19
23068 close(10)                         = 0
23068 open("/dev/sdh", O_RDONLY)        = 10
23068 ioctl(10, SG_IO, 0x7fbffff520)    = 0
23068 ioctl(10, SG_IO, 0x7fbffff520)    = 0
23068 pipe([11, 12])                    = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23074
23068 close(12)                         = 0
23068 read(11,  <unfinished ...>
23074 close(1)                          = 0
23074 dup(12)                           = 1
23074 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdh"], [/* 18 vars */]) = 0
23074 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23074 brk(0)                            = 0x502000
23074 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23074 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23074 open("/etc/ld.so.cache", O_RDONLY) = 13
23074 fstat(13, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23074 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 13, 0) = 0x2a95557000
23074 close(13)                         = 0
23074 open("/lib64/tls/libc.so.6", O_RDONLY) = 13
23074 read(13, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23074 fstat(13, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23074 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 13, 0) = 0x39cd300000
23074 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23074 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 13, 0x12a000) = 0x39cd52a000
23074 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23074 close(13)                         = 0
23074 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23074 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23074 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23074 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23074 munmap(0x2a95557000, 46176)       = 0
23074 open("/dev/sdh", O_RDWR|O_NONBLOCK) = 13
23074 ioctl(13, SG_IO, 0x7fbffff7b0)    = 0
23074 close(13)                         = 0
23074 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23074 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23074 write(1, "1\n", 2)                = 2
23068 <... read resumed> "1\n", 15)     = 2
23068 read(11,  <unfinished ...>
23074 munmap(0x2a95557000, 4096)        = 0
23074 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23074
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(11)                         = 0
23068 stat("/sys/block/sdi/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdi/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:1", 
255) = 76
23068 
lstat("/sys/devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:1", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 11
23068 fstat(11, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(11, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(11)                         = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 11
23068 fstat(11, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(11, F_SETFD, FD_CLOEXEC)    = 0
23068 getdents64(11, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(11, /* 0 entries */, 4096) = 0
23068 close(11)                         = 0
23068 lstat("/sys/bus/i2c/devices/2:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/2:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/2:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/2:0:0:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/2:0:0:1", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/2:0:0:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/2:0:0:1", 
"../../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:1", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 11
23068 fstat(11, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(11, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(11)                         = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 11
23068 fstat(11, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(11, F_SETFD, FD_CLOEXEC)    = 0
23068 getdents64(11, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(11, /* 0 entries */, 4096) = 0
23068 close(11)                         = 0
23068 lstat("/sys/bus/scsi/drivers/sd/2:0:0:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdi/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdi/dev", O_RDONLY) = 11
23068 read(11, "8:128\n", 4096)         = 6
23068 close(11)                         = 0
23068 stat("/sys/block/sdi/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdi/size", O_RDONLY) = 11
23068 read(11, "125829120\n", 4096)     = 10
23068 close(11)                         = 0
23068 stat("/sys/block/sdi/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdi/device/vendor", O_RDONLY) = 11
23068 read(11, "DGC     \n", 4096)      = 9
23068 close(11)                         = 0
23068 stat("/sys/block/sdi/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdi/device/model", O_RDONLY) = 11
23068 read(11, "RAID 5          \n", 4096) = 17
23068 close(11)                         = 0
23068 stat("/sys/block/sdi/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdi/device/rev", O_RDONLY) = 11
23068 read(11, "0216\n", 4096)          = 5
23068 close(11)                         = 0
23068 readlink("/sys/block/sdi/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:0/2:0:0:1", 
255) = 76
23068 stat("/sys/class/fc_transport/target2:0:0/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target2:0:0/node_name", O_RDONLY) = 11
23068 read(11, "0x50060160b02188c1\n", 4096) = 19
23068 close(11)                         = 0
23068 open("/dev/sdi", O_RDONLY)        = 11
23068 ioctl(11, SG_IO, 0x7fbffff520)    = 0
23068 ioctl(11, SG_IO, 0x7fbffff520)    = 0
23068 pipe([12, 13])                    = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23075
23068 close(13)                         = 0
23068 read(12,  <unfinished ...>
23075 close(1)                          = 0
23075 dup(13)                           = 1
23075 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdi"], [/* 18 vars */]) = 0
23075 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23075 brk(0)                            = 0x502000
23075 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23075 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23075 open("/etc/ld.so.cache", O_RDONLY) = 14
23075 fstat(14, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23075 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 14, 0) = 0x2a95557000
23075 close(14)                         = 0
23075 open("/lib64/tls/libc.so.6", O_RDONLY) = 14
23075 read(14, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23075 fstat(14, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23075 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 14, 0) = 0x39cd300000
23075 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23075 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 14, 0x12a000) = 0x39cd52a000
23075 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23075 close(14)                         = 0
23075 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23075 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23075 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23075 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23075 munmap(0x2a95557000, 46176)       = 0
23075 open("/dev/sdi", O_RDWR|O_NONBLOCK) = 14
23075 ioctl(14, SG_IO, 0x7fbffff7b0)    = 0
23075 close(14)                         = 0
23075 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23075 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23075 write(1, "0\n", 2)                = 2
23068 <... read resumed> "0\n", 15)     = 2
23068 read(12,  <unfinished ...>
23075 munmap(0x2a95557000, 4096)        = 0
23075 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23075
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(12)                         = 0
23068 stat("/sys/block/sdj/device", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 0
23068 readlink("/sys/block/sdj/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:1", 
255) = 76
23068 
lstat("/sys/devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:1", 
{st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/proc/mounts", O_RDONLY)    = 12
23068 fstat(12, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(12, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(12)                         = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 open("/sys/bus", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 12
23068 fstat(12, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(12, F_SETFD, FD_CLOEXEC)    = 0
23068 getdents64(12, /* 10 entries */, 4096) = 264
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/i2c", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pcmcia", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/ide", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/serio", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/usb", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/pci", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 lstat("/sys/bus/platform", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 getdents64(12, /* 0 entries */, 4096) = 0
23068 close(12)                         = 0
23068 lstat("/sys/bus/i2c/devices/2:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/ide/devices/2:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pci/devices/2:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/pcmcia/devices/2:0:1:1", 0x7fbfffef40) = -1 ENOENT 
(No such file or directory)
23068 lstat("/sys/bus/platform/devices/2:0:1:1", 0x7fbfffef40) = -1 
ENOENT (No such file or directory)
23068 lstat("/sys/bus/scsi/devices/2:0:1:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 readlink("/sys/bus/scsi/devices/2:0:1:1", 
"../../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:1", 
255) = 79
23068 open("/proc/mounts", O_RDONLY)    = 12
23068 fstat(12, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
23068 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23068 read(12, "rootfs / rootfs rw 0 0\n/proc /pr"..., 1024) = 444
23068 close(12)                         = 0
23068 munmap(0x2a95557000, 4096)        = 0
23068 lstat("/sys/bus/scsi/drivers", {st_mode=S_IFDIR|0755, st_size=0, 
...}) = 023068 open("/sys/bus/scsi/drivers", 
O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 12
23068 fstat(12, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
23068 fcntl(12, F_SETFD, FD_CLOEXEC)    = 0
23068 getdents64(12, /* 4 entries */, 4096) = 96
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sr", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 lstat("/sys/bus/scsi/drivers/sd", {st_mode=S_IFDIR|0755, 
st_size=0, ...}) = 0
23068 getdents64(12, /* 0 entries */, 4096) = 0
23068 close(12)                         = 0
23068 lstat("/sys/bus/scsi/drivers/sd/2:0:1:1", {st_mode=S_IFLNK|0777, 
st_size=0, ...}) = 0
23068 stat("/sys/block/sdj/dev", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 0
23068 open("/sys/block/sdj/dev", O_RDONLY) = 12
23068 read(12, "8:144\n", 4096)         = 6
23068 close(12)                         = 0
23068 stat("/sys/block/sdj/size", {st_mode=S_IFREG|0444, st_size=4096, 
...}) = 023068 open("/sys/block/sdj/size", O_RDONLY) = 12
23068 read(12, "125829120\n", 4096)     = 10
23068 close(12)                         = 0
23068 stat("/sys/block/sdj/device/vendor", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdj/device/vendor", O_RDONLY) = 12
23068 read(12, "DGC     \n", 4096)      = 9
23068 close(12)                         = 0
23068 stat("/sys/block/sdj/device/model", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdj/device/model", O_RDONLY) = 12
23068 read(12, "RAID 5          \n", 4096) = 17
23068 close(12)                         = 0
23068 stat("/sys/block/sdj/device/rev", {st_mode=S_IFREG|0444, 
st_size=4096, ...}) = 0
23068 open("/sys/block/sdj/device/rev", O_RDONLY) = 12
23068 read(12, "0216\n", 4096)          = 5
23068 close(12)                         = 0
23068 readlink("/sys/block/sdj/device", 
"../../devices/pci0000:04/0000:04:02.0/0000:06:01.0/host2/target2:0:1/2:0:1:1", 
255) = 76
23068 stat("/sys/class/fc_transport/target2:0:1/node_name", 
{st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
23068 open("/sys/class/fc_transport/target2:0:1/node_name", O_RDONLY) = 12
23068 read(12, "0x50060160b02188c1\n", 4096) = 19
23068 close(12)                         = 0
23068 open("/dev/sdj", O_RDONLY)        = 12
23068 ioctl(12, SG_IO, 0x7fbffff520)    = 0
23068 ioctl(12, SG_IO, 0x7fbffff520)    = 0
23068 pipe([13, 14])                    = 0
23068 clone(child_stack=0, 
flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0x2a95564930) = 23076
23068 close(14)                         = 0
23068 read(13,  <unfinished ...>
23076 close(1)                          = 0
23076 dup(14)                           = 1
23076 execve("/sbin/mpath_prio_emc", ["/sbin/mpath_prio_emc", 
"/dev/sdj"], [/* 18 vars */]) = 0
23076 uname({sys="Linux", node="localhost.localdomain", ...}) = 0
23076 brk(0)                            = 0x502000
23076 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95556000
23076 access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or 
directory)23076 open("/etc/ld.so.cache", O_RDONLY) = 15
23076 fstat(15, {st_mode=S_IFREG|0644, st_size=46176, ...}) = 0
23076 mmap(NULL, 46176, PROT_READ, MAP_PRIVATE, 15, 0) = 0x2a95557000
23076 close(15)                         = 0
23076 open("/lib64/tls/libc.so.6", O_RDONLY) = 15
23076 read(15, 
"\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0`\3051\315"..., 832) = 832
23076 fstat(15, {st_mode=S_IFREG|0755, st_size=1493186, ...}) = 0
23076 mmap(0x39cd300000, 2310056, PROT_READ|PROT_EXEC, 
MAP_PRIVATE|MAP_DENYWRITE, 15, 0) = 0x39cd300000
23076 mprotect(0x39cd42b000, 1085352, PROT_NONE) = 0
23076 mmap(0x39cd52a000, 24576, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 15, 0x12a000) = 0x39cd52a000
23076 mmap(0x39cd530000, 16296, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x39cd530000
23076 close(15)                         = 0
23076 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95563000
23076 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95564000
23076 mprotect(0x39cd52a000, 12288, PROT_READ) = 0
23076 arch_prctl(ARCH_SET_FS, 0x2a95563b00) = 0
23076 munmap(0x2a95557000, 46176)       = 0
23076 open("/dev/sdj", O_RDWR|O_NONBLOCK) = 15
23076 ioctl(15, SG_IO, 0x7fbffff7b0)    = 0
23076 close(15)                         = 0
23076 fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
23076 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x2a95557000
23076 write(1, "1\n", 2)                = 2
23068 <... read resumed> "1\n", 15)     = 2
23068 read(13,  <unfinished ...>
23076 munmap(0x2a95557000, 4096)        = 0
23076 exit_group(0)                     = ?
23068 <... read resumed> "", 13)        = 0
23068 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 23076
23068 --- SIGCHLD (Child exited) @ 0 (0) ---
23068 close(13)                         = 0
23068 close(4)                          = 0
23068 close(5)                          = 0
23068 close(6)                          = 0
23068 close(7)                          = 0
23068 close(8)                          = 0
23068 close(9)                          = 0
23068 close(10)                         = 0
23068 close(11)                         = 0
23068 close(12)                         = 0
23068 close(3)                          = 0
23068 exit_group(1)                     = ?

-- 
---------------------------------------------
Casey Feskens <cfeskens@willamette.edu>
System Administrator/Network Svcs. Consultant
Willamette Integrated Technology Services
Willamette University, Salem, OR
---------------------------------------------
