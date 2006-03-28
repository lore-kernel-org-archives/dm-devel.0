From: Jure =?UTF-8?Q?Pe=C4=8Dar?= <pegasus@nerv.eu.org>
Subject: LVM2 stripe problems on AoE volumes
Date: Tue, 28 Mar 2006 20:10:42 +0200
Message-ID: <20060328201042.12f4ec17.pegasus@nerv.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
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
Cc: sah@coraid.com
List-Id: dm-devel.ids


Hi all,

I'm currently playing with Ata-over-Ethernet storage from
www.coraid.com. It works very well, however I found some strange
problems when lvm2 striping is used on the AoE disks.

Actually the problem is mentioned in their FAQ at
http://www.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.5
but I would like to figure out why is this happening and how to fix the
problem.

The situation:

Create a volume group of two AoE disks and create a lv on them with
stripe (lvcreate -i 2). Format it with ext2 or 3. You can write on it
as much as you want. You can read either the disks or the lv device
with dd as much as you want. However, reading from a file on the volume
oopses as soon as you read over one stripe size, which is 64k by
default.=20

At least that is the situation on rhel4u2 kernel (2.6.9-22.0.2.ELsmp).
Vanilla 2.6.16 behaves a little different - writing also crash, but not
always, and reading crashes immediately, so hard that I wasn't able to
get any complete oops output at all.

So all I have right now is this oops from rhel4u2 kernel:

Unable to handle kernel NULL pointer dereference at virtual address
00000000 printing eip:
c014aaa0
*pde =3D 364bf001
Oops: 0000 [#1]
SMP
Modules linked in: aoe(U) dm_mod e1000 ext3 jbd raid1 qla2300(U) qla2xxx
(U) qla2xxx_conf(U) mptscsih mptbase sd_mod dCPU:    3 EIP:    0060:
[<c014aaa0>]    Not tainted VLI EFLAGS: 00010246   (2.6.9-22.0.2.ELsmp)
EIP is at page_address+0x6/0x6e
eax: 00000000   ebx: 00000000   ecx: f6a6da80   edx: 00000000
esi: f7531400   edi: f7531680   ebp: 00000000   esp: f643fb68
ds: 007b   es: 007b   ss: 0068
Process cat (pid: 968, threadinfo=3Df643f000 task=3Df7575930)
Stack: f735f5fc f7531400 f7531680 00000000 f896427f f6a6da80 f6a43580
f7531464 f6a6dc00 00000000 c0223630 3a385f85 00000000 00000078 f6a6dc00
4c908780 00000000 f6a6dc00 f7ce0880 f6ac667c f88040b8 f6a6dc00 f899a2de
00000002 Call Trace:
 [<f896427f>] aoeblk_make_request+0xa6/0x14b [aoe]
 [<c0223630>] generic_make_request+0x18e/0x19e
 [<f899a2de>] __map_bio+0x35/0xb2 [dm_mod]
 [<f899a4e1>] __clone_and_map+0xc0/0x2c3 [dm_mod]
 [<f8915944>] ext3_get_block+0x64/0x6c [ext3]
 [<f899a77c>] __split_bio+0x98/0xfe [dm_mod]
 [<f899a859>] dm_request+0x77/0x8b [dm_mod]
 [<c0223630>] generic_make_request+0x18e/0x19e
 [<c022370a>] submit_bio+0xca/0xd2
 [<c01bf9ba>] radix_tree_insert+0x6e/0xe7
 [<c01766cc>] mpage_end_io_read+0x0/0x61
 [<c017679b>] mpage_bio_submit+0x19/0x1d
 [<c0176cf6>] mpage_readpages+0xef/0xf9
 [<f8916480>] ext3_readpages+0x12/0x14 [ext3]
 [<f89158e0>] ext3_get_block+0x0/0x6c [ext3]
 [<c0145535>] read_pages+0x33/0xdd
 [<c0143148>] buffered_rmqueue+0x17d/0x1a5
 [<c0143245>] __alloc_pages+0xd5/0x2f7
 [<c01458bd>] do_page_cache_readahead+0x138/0x158
 [<c0145a0e>] page_cache_readahead+0x131/0x19e
 [<c013fe37>] do_generic_mapping_read+0xfa/0x3ae
 [<c0140353>] __generic_file_aio_read+0x19f/0x1bd
 [<c01400eb>] file_read_actor+0x0/0xc9
 [<c01403b1>] generic_file_aio_read+0x40/0x47
 [<c0159c95>] do_sync_read+0x97/0xc9
 [<c01ab790>] selinux_file_permission+0x117/0x120
 [<c011fee1>] autoremove_wake_function+0x0/0x2d
 [<c0159d7d>] vfs_read+0xb6/0xe2
 [<c0159f90>] sys_read+0x3c/0x62
 [<c02d137f>] syscall_call+0x7/0xb
Code: 08 0f 0b de 01 7e 28 2e c0 89 d8 5b e9 c7 fd ff ff 5b c3 69 c0 01
00 37 9e c1 e8 19 c1 e0 07 05 00 30 43 c0 c3 <0>Fatal exception: panic
in 5 seconds Kernel panic - not syncing: Fatal exception

My theory is that dm is doing something at striping that aoe driver
cannot digest. Can anyone familiar with dm internals comment on that?


--=20

Jure Pe=C4=8Dar
http://jure.pecar.org
