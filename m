From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: Question about work queues
Date: Fri, 16 Nov 2007 11:11:05 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC0194E46D@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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


Hi all,=20

I'm working on the dm-stripe.c driver, adding in the workqueue calls to s=
etup eventing for use with dmeventd. I'm hitting a strange problem though=
, its dumping a call trace in the workqueue.c file at line 166 where it c=
hecks the work->entry list to see if its empty:

Nov 14 20:26:20 dmraid-devhost kernel: ------------[ cut here ]----------=
--
Nov 14 20:26:20 dmraid-devhost kernel: kernel BUG at kernel/workqueue.c:1=
66!
Nov 14 20:26:20 dmraid-devhost kernel: invalid opcode: 0000 [1] SMP=20
Nov 14 20:26:20 dmraid-devhost kernel: CPU 1=20
Nov 14 20:26:20 dmraid-devhost kernel: Modules linked in: autofs4 hidp rf=
comm l2cap bluetooth sunrpc e1000 nf_conntrack_netbios_ns ipt_REJECT nf_c=
onntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables xt=
_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand =
acpi_cpufreq dm_mirror dm_multipath dm_mod sbs dock battery ac radeon drm=
 ipv6 floppy snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event s=
nd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sr_=
mod e100 button cdrom parport_pc soundcore mii parport rtc_cmos ata_gener=
ic snd_page_alloc serio_raw i2c_i801 i2c_core sg ahci libata sd_mod scsi_=
mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
Nov 14 20:26:20 dmraid-devhost kernel: Pid: 3462, comm: dmraid Not tainte=
d 2.6.23-rc9 #12
Nov 14 20:26:20 dmraid-devhost kernel: RIP: 0010:[<ffffffff81045064>]=A0 =
[<ffffffff81045064>] queue_work+0x1b/0x40
Nov 14 20:26:20 dmraid-devhost kernel: RSP: 0000:ffff81001c5a3c28=A0 EFLA=
GS: 00010283
Nov 14 20:26:20 dmraid-devhost kernel: RAX: ffff81003a0d63b0 RBX: ffff810=
03a0d63a8 RCX: 00000000ffffffff
Nov 14 20:26:20 dmraid-devhost kernel: RDX: 0000000000000000 RSI: ffff810=
03a0d63a8 RDI: ffff8100280ae2c0
Nov 14 20:26:20 dmraid-devhost kernel: RBP: 0000000000000000 R08: ffff810=
03d266000 R09: ffffffff812653a0
Nov 14 20:26:20 dmraid-devhost kernel: R10: 0000000000000000 R11: ffff810=
03d198970 R12: ffffc2000073a080
Nov 14 20:26:20 dmraid-devhost kernel: R13: 0000000000000002 R14: ffff810=
027a04820 R15: 0000000000000002
Nov 14 20:26:20 dmraid-devhost kernel: FS:=A0 00002b7923cabb40(0000) GS:f=
fff810037ce1300(0000) knlGS:0000000000000000
Nov 14 20:26:20 dmraid-devhost kernel: CS:=A0 0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Nov 14 20:26:20 dmraid-devhost kernel: CR2: 00007fffa78d13a0 CR3: 0000000=
01c61a000 CR4: 00000000000006e0
Nov 14 20:26:20 dmraid-devhost kernel: DR0: 0000000000000000 DR1: 0000000=
000000000 DR2: 0000000000000000
Nov 14 20:26:20 dmraid-devhost kernel: DR3: 0000000000000000 DR6: 0000000=
0ffff0ff0 DR7: 0000000000000400
Nov 14 20:26:20 dmraid-devhost kernel: Process dmraid (pid: 3462, threadi=
nfo ffff81001c5a2000, task ffff81001c40e810)
Nov 14 20:26:20 dmraid-devhost kernel: Stack:=A0 ffff81003a0d6380 fffffff=
f882d23d0 000000001d1c4500 0000000000000002
Nov 14 20:26:20 dmraid-devhost kernel:=A0 0000000000000002 ffff810027a04c=
00 0000000000000000 ffffc20000735165
Nov 14 20:26:20 dmraid-devhost kernel:=A0 0000000000000000 000000003a388a=
00 ffffc2000073a080 ffff810027a04c00
Nov 14 20:26:20 dmraid-devhost kernel: Call Trace:
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff882d23d0>] :dm_mod:st=
ripe_ctr+0x2c1/0x2d2
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff882d1607>] :dm_mod:dm=
_table_add_target+0x152/0x29f
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff882d2f9e>] :dm_mod:ta=
ble_load+0xfb/0x1c9
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff882d2ea3>] :dm_mod:ta=
ble_load+0x0/0x1c9
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff882d3a5f>] :dm_mod:ct=
l_ioctl+0x223/0x26e
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff81097ef5>] do_ioctl+0=
x55/0x6b
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff8109814e>] vfs_ioctl+=
0x243/0x25c
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff810981c0>] sys_ioctl+=
0x59/0x79
Nov 14 20:26:20 dmraid-devhost kernel:=A0 [<ffffffff8100bd7c>] tracesys+0=
xdc/0xe1
Nov 14 20:26:20 dmraid-devhost kernel:=20
Nov 14 20:26:20 dmraid-devhost kernel:=20
Nov 14 20:26:20 dmraid-devhost kernel: Code: 0f 0b eb fe 65 8b 34 25 24 0=
0 00 00 e8 a6 f9 ff ff 48 89 de=20
Nov 14 20:26:20 dmraid-devhost kernel: RIP=A0 [<ffffffff81045064>] queue_=
work+0x1b/0x40
Nov 14 20:26:20 dmraid-devhost kernel:=A0 RSP <ffff81001c5a3c28>

Have I forgot something in initializing my work_struct? Below is what I'v=
e added to the driver for using the workqueue model:

I've added the work_struct to the stripe_c structure and the calls to wor=
kqueue and trigger_event function like multipath
(I also added a dm_target struct pointer to record the target table for l=
ater use in the dm_table_event() call):

struct stripe_c {
=A0=A0=A0=A0=A0 uint32_t stripes;

=A0=A0=A0=A0=A0 /* The size of this target / num. stripes */
=A0=A0=A0=A0=A0 sector_t stripe_width;

=A0=A0=A0=A0=A0 /* stripe chunk size */
=A0=A0=A0=A0=A0 uint32_t chunk_shift;
=A0=A0=A0=A0=A0 sector_t chunk_mask;

=A0=A0=A0=A0=A0 struct stripe stripe[0];
=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0 /* Needed for handling events */
=A0=A0=A0=A0=A0 struct dm_target *ti;
=A0=A0=A0=A0=A0=20
=A0=A0=A0=A0=A0 /* New work_queue setup for triggering events*/
=A0=A0=A0=A0=A0 struct work_struct trigger_event;

};

struct workqueue_struct *kstriped;
static void trigger_event(struct work_struct *work);

/*
=A0* An event is triggered whenever a drive drops out of a=20
=A0* stripe volume.
=A0*/
static void trigger_event(struct work_struct *work)
{
=A0=A0=A0=A0=A0 struct stripe_c *sc =3D container_of(work, struct stripe_=
c, trigger_event);

=A0=A0=A0=A0=A0 dm_table_event(sc->ti->table);
}

Added the calls to stripe_ctr() for Initialization and creation of the st=
ruct & queue:

=A0=A0=A0=A0=A0 /* Create the workqueue */
=A0=A0=A0=A0=A0 kstriped =3D create_singlethread_workqueue("kstriped");
=A0=A0=A0=A0=A0 if (!kstriped) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DMERR("failed to create workqueue ks=
triped");
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 /* Initialize the work_struct */
=A0=A0=A0=A0=A0 INIT_WORK(&sc->trigger_event, trigger_event);
=A0=A0=A0=A0=A0 /* Set pointer to dm target; used in trigger_event */
=A0=A0=A0=A0=A0 sc->ti =3D ti;
=A0=A0=A0=A0=A0=20
In the stripe_dtr() function I put the flush and destroy workqueue:

=A0=A0=A0=A0=A0=A0flush_workqueue(kstriped);
=A0=A0=A0=A0=A0 destroy_workqueue(kstriped);
=A0=A0=A0=A0=A0 kfree(sc);

And for my test of all this to make sure its setup correctly I added a te=
st call of queue_work() in the stripe_ctr() function at the bottom before=
 the "return 0;"

=A0=A0=A0=A0=A0=A0queue_work(kstriped, &sc->trigger_event);

It's when it hits this call that it is generating the error above; saying=
 the &work->entry is empty (as if it didn't get initialized)? I thought t=
hat the INIT_WORK() call sets this list pointer? Do I need a call to INIT=
_LIST_HEAD()? I've tried reading up some in my "Kernel Driver" O'reilly b=
ook and my "Understanding the Linux Kernel" Book and I can't find what is=
 missing.=20

Any help would be appreciated, thanks everyone.



Brian Wood
Software Engineer
Intel Corp., Manageability & Platform Software Division
brian.j.wood@intel.com
