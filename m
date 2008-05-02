From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: oops in linear_mergeable_bvec
Date: Thu, 1 May 2008 21:31:57 -0700
Message-ID: <20080501213157.e53535b7.akpm@linux-foundation.org>
References: <3b2bc9d0804300352k76bdc2f1id7da040761bca427@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3b2bc9d0804300352k76bdc2f1id7da040761bca427@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: marco gaddoni <marco.gaddoni@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 30 Apr 2008 12:52:38 +0200 "marco gaddoni" <marco.gaddoni@gmail.com> wrote:

> Hello,
> 
> i have this repeatable oops in linear_mergeable_bvec
> 
> the kernel is the Debian testing as of this morning,
> 
> i am trying to rsync some data from this box to my pc.
> the data is on a software raid 0 made of 2 ide disks
> 
> the oops is triggered during the copy of a specific file,
> allways the same.
> 
> what can be the problem?
> 
> arianna:~# cat /proc/mdstat
> Personalities : [linear]
> md2 : active linear hda1[0] hdb1[1]
>       277321856 blocks 64k rounding
> 
> unused devices: <none>
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual
> address 00000010
> printing eip: c881609a *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: nf_nat_ftp nf_conntrack_ftp nfsd auth_rpcgss
> exportfs nfs lockd nfs_acl sunrpc ipt_MASQUERADE ipt_LOG
> ip6table_filter xt_state xt_NFQUEUE xt_hashlimit ip6_tables xt_tcpmss
> xt_tcpudp ipt_addrtype xt_pkttype iptable_raw xt_CLASSIFY xt_CONNMARK
> xt_MARK xt_comment ipt_REJECT xt_length xt_connmark ipt_owner
> ipt_recent ipt_iprange xt_physdev xt_policy xt_multiport xt_conntrack
> iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> iptable_filter ip_tables x_tables ipv6 deflate zlib_deflate
> zlib_inflate twofish twofish_common camellia serpent blowfish
> des_generic cbc ecb aes_i586 aes_generic geode_aes blkcipher xcbc
> sha256_generic sha1_generic crypto_null af_key psmouse ide_generic
> snd_intel8x0 snd_ac97_codec parport_pc ac97_bus i2c_i801 parport
> snd_pcm i2c_core intel_rng snd_timer snd soundcore snd_page_alloc
> intel_agp agpgart pcspkr shpchp pci_hotplug iTCO_wdt rtc evdev ext3
> jbd mbcache linear md_mod ide_cd cdrom ide_disk ata_generic libata
> scsi_mod floppy e100 mii piix generic ide_core
> 
> Pid: 5203, comm: rsync Not tainted (2.6.24-1-686 #1)
> EIP: 0060:[<c881609a>] EFLAGS: 00010246 CPU: 0
> EIP is at linear_mergeable_bvec+0x9a/0x10b [linear]
> EAX: c6595fc0 EBX: 00000000 ECX: 00000000 EDX: 0000002c
> ESI: c78a63c0 EDI: 00000000 EBP: 00000000 ESP: c16d5c68
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rsync (pid: 5203, ti=c16d4000 task=c7b09250 task.ti=c16d4000)
> Stack: 0b3ed648 00000002 0b3ed648 c6747360 167dac90 00000004 0b3ed648 00000002
>        c16ce660 c0196e63 c6747360 c16ce660 c8816000 c642b8c8 c019718e c16ce660
>        c1011720 00000004 c16d5da0 c0197a3e 00001000 00000000 000000ff 00001000
> Call Trace:
>  [<c0196e63>] bio_alloc_bioset+0x9b/0xf3
>  [<c8816000>] linear_mergeable_bvec+0x0/0x10b [linear]
>  [<c019718e>] __bio_add_page+0xf0/0x162
>  [<c0197a3e>] bio_add_page+0x31/0x37
>  [<c019ab9c>] do_mpage_readpage+0x516/0x5d2
>  [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
>  [<c01e1499>] radix_tree_insert+0x4f/0x15e
>  [<c015acdd>] add_to_page_cache+0x67/0x80
>  [<c019adf3>] mpage_readpages+0x96/0xc3
>  [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
>  [<c015f343>] __alloc_pages+0x59/0x2d5
>  [<c8916c2f>] ext3_readpages+0x0/0x15 [ext3]
>  [<c0161101>] __do_page_cache_readahead+0x127/0x1a6
>  [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
>  [<c016147c>] page_cache_sync_readahead+0x2a/0x2f
>  [<c015afae>] do_generic_mapping_read+0xdd/0x3b2
>  [<c015a7c7>] file_read_actor+0x0/0xcc
>  [<c015c95c>] generic_file_aio_read+0x16b/0x1a6
>  [<c015a7c7>] file_read_actor+0x0/0xcc
>  [<c0178493>] do_sync_read+0xc7/0x10a
>  [<c01353f9>] autoremove_wake_function+0x0/0x35
>  [<c011bf41>] do_page_fault+0x1f7/0x592
>  [<c01783cc>] do_sync_read+0x0/0x10a
>  [<c0178d19>] vfs_read+0x9f/0x14b
>  [<c0179182>] sys_read+0x41/0x67
>  [<c0103e5e>] sysenter_past_esp+0x6b/0xa1
>  =======================
> Code: 24 04 89 d1 31 d2 85 c9 89 44 24 08 74 08 89 c8 31 d2 f7 f3 89
> c1 8b 44 24 08 f7 f3 89 ca 89 c2 8b 46 04 8b 1c 90 eb 03 83 c3 14 <8b>
> 53 10 8b 43 0c 8b 73 04 8b 7b 08 89 d1 89 54 24 24 89 c2 01
> EIP: [<c881609a>] linear_mergeable_bvec+0x9a/0x10b [linear] SS:ESP 0068:c16d5c68

(cc dm-devel) (which often has no effect)

I wonder which kernel.org kernel was used to generate 2.6.24-1-686.
