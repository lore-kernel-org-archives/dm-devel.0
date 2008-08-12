From: "Brad Bendily" <bendily@gmail.com>
Subject: multipath -ll no output?
Date: Tue, 12 Aug 2008 12:14:04 -0500
Message-ID: <e27c898e0808121014p4f71b38ci84618fd172b63c9d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I'm having an issue that is ultimately i think related to when I run
the command:
multipath -ll

I get no output.

However, if I run:
multipath -d
I get:
# multipath -d
create: mpath0 (36006016012f01c000a2f03399138dd11)  DGC,RAID 5
[size=942G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][undef]
 \_ 1:0:0:0 sdb 8:16  [undef][ready]
 \_ 2:0:0:0 sdd 8:48  [undef][ready]
\_ round-robin 0 [prio=0][undef]
 \_ 1:0:1:0 sdc 8:32  [undef][ready]
 \_ 2:0:1:0 sde 8:64  [undef][ready]


So, my server can see the SAN and is able to get info from the SAN,
but it doesn't actually
create the mapper device in /dev/mapper/

Is there something i'm missing to be able to resolve this?


Output from multipath -v7 -ll

multipath -v7 -ll
dm-0: blacklisted
dm-10: blacklisted
dm-11: blacklisted
dm-12: blacklisted
dm-13: blacklisted
dm-14: blacklisted
dm-15: blacklisted
dm-16: blacklisted
dm-17: blacklisted
dm-18: blacklisted
dm-19: blacklisted
dm-1: blacklisted
dm-2: blacklisted
dm-3: blacklisted
dm-4: blacklisted
dm-5: blacklisted
dm-6: blacklisted
dm-7: blacklisted
dm-8: blacklisted
dm-9: blacklisted
hda: blacklisted
loop0: blacklisted
loop1: blacklisted
loop2: blacklisted
loop3: blacklisted
loop4: blacklisted
loop5: blacklisted
loop6: blacklisted
loop7: blacklisted
ram0: blacklisted
ram10: blacklisted
ram11: blacklisted
ram12: blacklisted
ram13: blacklisted
ram14: blacklisted
ram15: blacklisted
ram1: blacklisted
ram2: blacklisted
ram3: blacklisted
ram4: blacklisted
ram5: blacklisted
ram6: blacklisted
ram7: blacklisted
ram8: blacklisted
ram9: blacklisted
sda: not found in pathvec
sda: mask = 0x5
sda: bus = 1
sda: dev_t = 8:0
sda: size = 570949632
sda: vendor = DELL
sda: product = PERC 5/i
sda: rev = 1.03
sda: h:b:t:l = 0:2:0:0
sdb: not found in pathvec
sdb: mask = 0x5
sdb: bus = 1
sdb: dev_t = 8:16
sdb: size = 1974712832
sdb: vendor = DGC
sdb: product = RAID 5
sdb: rev = 0326
sdb: h:b:t:l = 1:0:0:0
sdb: tgt_node_name = 0x50060160c1e09805
sdc: not found in pathvec
sdc: mask = 0x5
sdc: bus = 1
sdc: dev_t = 8:32
sdc: size = 1974712832
sdc: vendor = DGC
sdc: product = RAID 5
sdc: rev = 0326
sdc: h:b:t:l = 1:0:1:0
sdc: tgt_node_name = 0x50060160c1e09805
sdd: not found in pathvec
sdd: mask = 0x5
sdd: bus = 1
sdd: dev_t = 8:48
sdd: size = 1974712832
sdd: vendor = DGC
sdd: product = RAID 5
sdd: rev = 0326
sdd: h:b:t:l = 2:0:0:0
sdd: tgt_node_name = 0x50060160c1e09805
sde: not found in pathvec
sde: mask = 0x5
sde: bus = 1
sde: dev_t = 8:64
sde: size = 1974712832
sde: vendor = DGC
sde: product = RAID 5
sde: rev = 0326
sde: h:b:t:l = 2:0:1:0
sde: tgt_node_name = 0x50060160c1e09805
sdf: not found in pathvec
sdf: mask = 0x5
sdf: bus = 1
sdf: dev_t = 8:80
sdf: size = 0
sdf: vendor = Dell
sdf: product = Virtual  Floppy
sdf: rev = 123
sdf: h:b:t:l = 4:0:0:0
sr0: blacklisted
===== paths list =====
uuid hcil    dev dev_t pri dm_st  chk_st   vend/prod/rev
     0:2:0:0 sda 8:0   -1  [undef][undef]  DELL,PERC 5/i
     1:0:0:0 sdb 8:16  -1  [undef][undef]  DGC,RAID 5
     1:0:1:0 sdc 8:32  -1  [undef][undef]  DGC,RAID 5
     2:0:0:0 sdd 8:48  -1  [undef][undef]  DGC,RAID 5
     2:0:1:0 sde 8:64  -1  [undef][undef]  DGC,RAID 5
     4:0:0:0 sdf 8:80  -1  [undef][faulty] Dell,Virtual  Floppy
libdevmapper: ioctl/libdm-iface.c(1570): dm names   NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|apps|cache2  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|apps|cache1  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table btr_cluster.msbd4
NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table sdb1  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table btr_cluster.msbd3
NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table btr_cluster.msbd2
NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table btr_cluster.msbd1
NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|system|swap  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|system|sys_lx
NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table sda5  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table btr_cluster.sbd  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table mail  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|system|var  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table sdd5  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table sda2  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table sdb5  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|apps|cache4  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table sdd1  NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|btr_lun|Mail
NF   [16384]
libdevmapper: ioctl/libdm-iface.c(1570): dm table lvm2|apps|cache3  NF   [16384]


Thanks
BB

-- 
Have Mercy & Say Yeah
