From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] WARNING: at fs/block_dev.c:5 when removing LV on
 removed device
Date: Thu, 18 Jun 2015 17:01:17 -0400
Message-ID: <20150618210117.GB6390@redhat.com>
References: <20150618165713.GB19417@two.firstfloor.org>
 <20150618180408.GD2321@redhat.com>
 <20150618180804.GC19417@two.firstfloor.org>
 <20150618181619.GE2321@redhat.com>
 <20150618190815.GA6390@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618190815.GA6390@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Jun 18, 2015 at 03:08:15PM -0400, Vivek Goyal wrote:
> On Thu, Jun 18, 2015 at 02:16:19PM -0400, Mike Snitzer wrote:
> > On Thu, Jun 18 2015 at  2:08pm -0400,
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > Hmm, so you have a filesystem active on it too?
> > > 
> > > I unmounted it before.
> > > 
> > > >  
> > > > > Also the VG removal did not work of course.
> > > > 
> > > > Once you resolve the filesystem piece, from vgremove man page:
> > > > 
> > > > "vgremove allows you to remove one or more volume groups.  If one or
> > > > more physical volumes in the volume group are lost, consider vgreduce
> > > > --removemissing to make the volume group metadata consistent again."
> > > 
> > > Well in any case there should not be WARN()s.
> > 
> > Yes well I don't even know what WARN_ON you're hitting.  You're running
> > a 4.0.4 fedora kernel.  Which WARN_ON() is triggering?  The
> > WARN_ON_ONCE() in bdev_write_inode()? -- likely since the only caller of
> > bdev_write_inode is __blkdev_put...
> > 
> > /**
> >  * write_inode_now      -       write an inode to disk
> >  * @inode: inode to write to disk
> >  * @sync: whether the write should be synchronous or not
> >  *
> >  * This function commits an inode to disk immediately if it is dirty. This is
> >  * primarily needed by knfsd.
> >  *
> >  * The caller must either have a ref on the inode or must have set I_WILL_FREE.
> >  */
> > 
> > So I have no idea why bdev_write_inode() is using WARN_ON_ONCE.. makes
> > since that write_inode_now() will fail if the disk no longer exists.  SO
> > the WARN_ON_ONCE seems misplaced.
> > 
> > Git blame shows its all hch's fault:
> > 
> > 564f00f6c (Christoph Hellwig  2015-01-14 10:42:33 +0100   57) WARN_ON_ONCE(write_inode_now(inode, true));
> > 
> > 564f00f6c block_dev: only write bdev inode on close
> 
> I can reproduce it too in a Fedora 22 virtual machine. I just have to do
> "umount <mnt>" after hot unplugging the virtIO disk.
> 
> But it does not happen without lvm. If I create ext4 fs directly on
> /dev/vda1, then when disk goes way, fs automatically gets unmounted.

Let me correct myself. It is happening without lvm too. So I just
exported a virtio disk in guest. Created a partition /dev/vda1. Created
fs ext4 and mounted /dev/vda1. Opened a text file, scribbled something
into it, closed file and got out of mount directory. And now I removed
the disk and tried to umount /dev/vda1 and and boom, I get the error.

Last time I did not notice it because it is WARN_ON_ONCE() and I had
not rebooted my machine.

So problem does not seem to be related to device mapper.

To me it looks like that we should just get rid of WARN_ON_ONCE() a
and replace it with something like, printk(KERN_WARN: "write_inode_now() failed.").


Jun 18 16:56:35 vm2-f22 kernel: Buffer I/O error on dev vda1, logical
block 557056, lost sync page write
Jun 18 16:56:35 vm2-f22 kernel: JBD2: Error -5 detected when updating
journal superblock for vda1-8.
Jun 18 16:56:35 vm2-f22 kernel: Buffer I/O error on dev vda1, logical
block 0, lost sync page write
Jun 18 16:56:35 vm2-f22 kernel: ------------[ cut here ]------------
Jun 18 16:56:35 vm2-f22 kernel: WARNING: CPU: 5 PID: 1870 at
fs/block_dev.c:56 __blkdev_put+0xc0/0x220()
Jun 18 16:56:35 vm2-f22 kernel: Modules linked in: nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
xt_conntrack ebtable_nat ebtable_broute bridge ebtable_filter ebtables
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_mangle iptable_security iptable_raw snd_hda_codec_generic
snd_hda_intel snd_hda_controller virtio_balloon snd_hda_codec snd_hwdep
snd_seq snd_seq_device snd_pcm snd_hda_core snd_timer snd soundcore
crct10dif_pclmul ppdev crc32_pclmul parport_pc crc32c_intel acpi_cpufreq
parport pvpanic i2c_piix4 serio_raw ghash_clmulni_intel nfsd auth_rpcgss
nfs_acl lockd grace sunrpc qxl drm_kms_helper ttm 8021q
Jun 18 16:56:35 vm2-f22 kernel:  drm garp stp virtio_console virtio_blk
llc 8139too mrp virtio_pci 8139cp virtio_ring ata_generic mii virtio
pata_acpi
Jun 18 16:56:35 vm2-f22 kernel: CPU: 5 PID: 1870 Comm: umount Not tainted
4.1.0-rc8+ #3
Jun 18 16:56:35 vm2-f22 kernel: Hardware name: Red Hat KVM, BIOS 0.5.1
01/01/2011
Jun 18 16:56:35 vm2-f22 kernel:  0000000000000000 00000000a79061d2
ffff88021816fd98 ffffffff817fc09b
Jun 18 16:56:35 vm2-f22 kernel:  0000000000000000 0000000000000000
ffff88021816fdd8 ffffffff8109f47a
Jun 18 16:56:35 vm2-f22 kernel:  0000000000000000 ffff880236c287f8
ffff880236c28680 ffff880236c28770
Jun 18 16:56:35 vm2-f22 kernel: Call Trace:
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff817fc09b>] dump_stack+0x45/0x57
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff8109f47a>]
warn_slowpath_common+0x8a/0xc0
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff8109f5aa>]
warn_slowpath_null+0x1a/0x20
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81259910>]
__blkdev_put+0xc0/0x220
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81259f00>]
blkdev_put+0x50/0x130
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff812212b1>]
kill_block_super+0x41/0x80
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81221609>]
deactivate_locked_super+0x49/0x80
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81221a6c>]
deactivate_super+0x6c/0x80
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81240383>]
cleanup_mnt+0x43/0xa0
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81240432>]
__cleanup_mnt+0x12/0x20
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff810bc594>]
task_work_run+0xd4/0xf0
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81013d15>]
do_notify_resume+0x95/0xa0
Jun 18 16:56:35 vm2-f22 kernel:  [<ffffffff81802a3c>] int_signal+0x12/0x17
Jun 18 16:56:35 vm2-f22 kernel: ---[ end trace cf189e68bb5b80cd ]---

Thanks
Vivek
