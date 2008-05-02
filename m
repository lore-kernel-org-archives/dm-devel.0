From: "marco gaddoni" <marco.gaddoni@gmail.com>
Subject: Re: oops in linear_mergeable_bvec
Date: Fri, 2 May 2008 11:02:35 +0200
Message-ID: <3b2bc9d0805020202y52dd27b6l364d8192f7aa30ac@mail.gmail.com>
References: <3b2bc9d0804300352k76bdc2f1id7da040761bca427@mail.gmail.com>
	 <20080501213157.e53535b7.akpm@linux-foundation.org>
	 <18458.42641.306621.469263@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18458.42641.306621.469263@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 2, 2008 at 7:28 AM, Neil Brown <neilb@suse.de> wrote:
> On Thursday May 1, akpm@linux-foundation.org wrote:
>
>  > (cc dm-devel) (which often has no effect)
>
>  In this case it would be understandable - linux-raid is the correct
>  list :-)
>
>  OK, I'll push this to the top of my stack.....
>
>
>  > On Wed, 30 Apr 2008 12:52:38 +0200 "marco gaddoni" <marco.gaddoni@gmail.com> wrote:
>  >
>  > > Hello,
>  > >
>  > > i have this repeatable oops in linear_mergeable_bvec
>  > >
>  > > the kernel is the Debian testing as of this morning,
>  > >
>  > > i am trying to rsync some data from this box to my pc.
>  > > the data is on a software raid 0 made of 2 ide disks
>
>  It is a 'linear', not a 'raid 0' by the way.
>

ok

>
>  > >
>  > > the oops is triggered during the copy of a specific file,
>  > > allways the same.
>  > >
>  > > what can be the problem?
>  > >
>  > > arianna:~# cat /proc/mdstat
>  > > Personalities : [linear]
>  > > md2 : active linear hda1[0] hdb1[1]
>  > >       277321856 blocks 64k rounding
>  > >
>  > > unused devices: <none>
>
>  On decoding the Oops, it seems to in which_dev called from
>  linear_mergeable_bvec.
>  'hash' is NULL.  This is bads.
>  'block' seems to be 42, which is maybe a little bit surprising...
>
>  What is really strange is that when I disassemble the Code: (see
>  below), there is now "divl" instruction to match the "sector_div" in
>  which_dev.
>
>  So I'm somewhat perplexed.
>
>  What, exactly, are the sizes of hda1 and hdb1.  Knowing that might
>  help me see if anything else looks wrong.
>
>  NeilBrown
>

arianna:~# sfdisk -l /dev/hda

Disk /dev/hda: 24792 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hda1          0+  24791   24792- 199141708+  83  Linux
/dev/hda2          0       -       0          0    0  Empty
/dev/hda3          0       -       0          0    0  Empty
/dev/hda4          0       -       0          0    0  Empty
arianna:~# sfdisk -l /dev/hdb

Disk /dev/hdb: 9733 cylinders, 255 heads, 63 sectors/track
Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/hdb1          0+   9732    9733-  78180291   83  Linux
/dev/hdb2          0       -       0          0    0  Empty
/dev/hdb3          0       -       0          0    0  Empty
/dev/hdb4          0       -       0          0    0  Empty

or, in raw form

arianna:~# sfdisk -d /dev/hda
# partition table of /dev/hda
unit: sectors

/dev/hda1 : start=       63, size=398283417, Id=83
/dev/hda2 : start=        0, size=        0, Id= 0
/dev/hda3 : start=        0, size=        0, Id= 0
/dev/hda4 : start=        0, size=        0, Id= 0
arianna:~# sfdisk -d /dev/hdb
# partition table of /dev/hdb
unit: sectors

/dev/hdb1 : start=       63, size=156360582, Id=83
/dev/hdb2 : start=        0, size=        0, Id= 0
/dev/hdb3 : start=        0, size=        0, Id= 0
/dev/hdb4 : start=        0, size=        0, Id= 0
arianna:~#

i did try to remove the problematic file and
i got the same oops during rsync;
then i removed the whole drectory and the
rsync proceeded to copy another 20G of files
until it got the same oops in another place on
the filesystem.

the kernel version can be seen from

http://packages.debian.org/source/testing/linux-2.6
bottom of the page.
it is a 2.6.24 with patches.

>
>  Disassembly of "Code:"
>
>  Code;  ffffffd5 <END_OF_CODE+3fc2bfd5/????>
>  00000000 <_EIP>:
>  Code;  ffffffd5 <END_OF_CODE+3fc2bfd5/????>
>    0:   24 04                     and    $0x4,%al
>  Code;  ffffffd7 <END_OF_CODE+3fc2bfd7/????>
>    2:   89 d1                     mov    %edx,%ecx
>  Code;  ffffffd9 <END_OF_CODE+3fc2bfd9/????>
>    4:   31 d2                     xor    %edx,%edx
>  Code;  ffffffdb <END_OF_CODE+3fc2bfdb/????>
>    6:   85 c9                     test   %ecx,%ecx
>  Code;  ffffffdd <END_OF_CODE+3fc2bfdd/????>
>    8:   89 44 24 08               mov    %eax,0x8(%esp)
>  Code;  ffffffe1 <END_OF_CODE+3fc2bfe1/????>
>    c:   74 08                     je     16 <_EIP+0x16>
>  Code;  ffffffe3 <END_OF_CODE+3fc2bfe3/????>
>    e:   89 c8                     mov    %ecx,%eax
>  Code;  ffffffe5 <END_OF_CODE+3fc2bfe5/????>
>   10:   31 d2                     xor    %edx,%edx
>  Code;  ffffffe7 <END_OF_CODE+3fc2bfe7/????>
>   12:   f7 f3                     div    %ebx
>  Code;  ffffffe9 <END_OF_CODE+3fc2bfe9/????>
>   14:   89 c1                     mov    %eax,%ecx
>  Code;  ffffffeb <END_OF_CODE+3fc2bfeb/????>
>   16:   8b 44 24 08               mov    0x8(%esp),%eax
>  Code;  ffffffef <END_OF_CODE+3fc2bfef/????>
>   1a:   f7 f3                     div    %ebx
>  Code;  fffffff1 <END_OF_CODE+3fc2bff1/????>
>   1c:   89 ca                     mov    %ecx,%edx
>  Code;  fffffff3 <END_OF_CODE+3fc2bff3/????>
>   1e:   89 c2                     mov    %eax,%edx
>  Code;  fffffff5 <END_OF_CODE+3fc2bff5/????>
>   20:   8b 46 04                  mov    0x4(%esi),%eax
>  Code;  fffffff8 <END_OF_CODE+3fc2bff8/????>
>   23:   8b 1c 90                  mov    (%eax,%edx,4),%ebx this is conf->hash_table[block]???
>  Code;  fffffffb <END_OF_CODE+3fc2bffb/????>
>   26:   eb 03                     jmp    2b <_EIP+0x2b>
>  Code;  fffffffd <END_OF_CODE+3fc2bffd/????>
>   28:   83 c3 14                  add    $0x14,%ebx        This is "hash++;"
>  Code;  00000000 Before first symbol
>   2b:   8b 53 10                  mov    0x10(%ebx),%edx
>  Code;  00000003 Before first symbol
>   2e:   8b 43 0c                  mov    0xc(%ebx),%eax
>  Code;  00000006 Before first symbol
>   31:   8b 73 04                  mov    0x4(%ebx),%esi
>  Code;  00000009 Before first symbol
>   34:   8b 7b 08                  mov    0x8(%ebx),%edi
>  Code;  0000000c Before first symbol
>   37:   89 d1                     mov    %edx,%ecx
>  Code;  0000000e Before first symbol
>   39:   89 54 24 24               mov    %edx,0x24(%esp)
>  Code;  00000012 Before first symbol
>   3d:   89 c2                     mov    %eax,%edx
>  Code;  00000014 Before first symbol
>   3f:   01                        .byte 0x1
>
>
>
>
>
>
>  > >
>  > >
>  > > BUG: unable to handle kernel NULL pointer dereference at virtual
>  > > address 00000010
>  > > printing eip: c881609a *pde = 00000000
>  > > Oops: 0000 [#1] SMP
>  > > Modules linked in: nf_nat_ftp nf_conntrack_ftp nfsd auth_rpcgss
>  > > exportfs nfs lockd nfs_acl sunrpc ipt_MASQUERADE ipt_LOG
>  > > ip6table_filter xt_state xt_NFQUEUE xt_hashlimit ip6_tables xt_tcpmss
>  > > xt_tcpudp ipt_addrtype xt_pkttype iptable_raw xt_CLASSIFY xt_CONNMARK
>  > > xt_MARK xt_comment ipt_REJECT xt_length xt_connmark ipt_owner
>  > > ipt_recent ipt_iprange xt_physdev xt_policy xt_multiport xt_conntrack
>  > > iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
>  > > iptable_filter ip_tables x_tables ipv6 deflate zlib_deflate
>  > > zlib_inflate twofish twofish_common camellia serpent blowfish
>  > > des_generic cbc ecb aes_i586 aes_generic geode_aes blkcipher xcbc
>  > > sha256_generic sha1_generic crypto_null af_key psmouse ide_generic
>  > > snd_intel8x0 snd_ac97_codec parport_pc ac97_bus i2c_i801 parport
>  > > snd_pcm i2c_core intel_rng snd_timer snd soundcore snd_page_alloc
>  > > intel_agp agpgart pcspkr shpchp pci_hotplug iTCO_wdt rtc evdev ext3
>  > > jbd mbcache linear md_mod ide_cd cdrom ide_disk ata_generic libata
>  > > scsi_mod floppy e100 mii piix generic ide_core
>  > >
>  > > Pid: 5203, comm: rsync Not tainted (2.6.24-1-686 #1)
>  > > EIP: 0060:[<c881609a>] EFLAGS: 00010246 CPU: 0
>  > > EIP is at linear_mergeable_bvec+0x9a/0x10b [linear]
>  > > EAX: c6595fc0 EBX: 00000000 ECX: 00000000 EDX: 0000002c
>  > > ESI: c78a63c0 EDI: 00000000 EBP: 00000000 ESP: c16d5c68
>  > >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>  > > Process rsync (pid: 5203, ti=c16d4000 task=c7b09250 task.ti=c16d4000)
>  > > Stack: 0b3ed648 00000002 0b3ed648 c6747360 167dac90 00000004 0b3ed648 00000002
>  > >        c16ce660 c0196e63 c6747360 c16ce660 c8816000 c642b8c8 c019718e c16ce660
>  > >        c1011720 00000004 c16d5da0 c0197a3e 00001000 00000000 000000ff 00001000
>  > > Call Trace:
>  > >  [<c0196e63>] bio_alloc_bioset+0x9b/0xf3
>  > >  [<c8816000>] linear_mergeable_bvec+0x0/0x10b [linear]
>  > >  [<c019718e>] __bio_add_page+0xf0/0x162
>  > >  [<c0197a3e>] bio_add_page+0x31/0x37
>  > >  [<c019ab9c>] do_mpage_readpage+0x516/0x5d2
>  > >  [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
>  > >  [<c01e1499>] radix_tree_insert+0x4f/0x15e
>  > >  [<c015acdd>] add_to_page_cache+0x67/0x80
>  > >  [<c019adf3>] mpage_readpages+0x96/0xc3
>  > >  [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
>  > >  [<c015f343>] __alloc_pages+0x59/0x2d5
>  > >  [<c8916c2f>] ext3_readpages+0x0/0x15 [ext3]
>  > >  [<c0161101>] __do_page_cache_readahead+0x127/0x1a6
>  > >  [<c891762b>] ext3_get_block+0x0/0xd0 [ext3]
>  > >  [<c016147c>] page_cache_sync_readahead+0x2a/0x2f
>  > >  [<c015afae>] do_generic_mapping_read+0xdd/0x3b2
>  > >  [<c015a7c7>] file_read_actor+0x0/0xcc
>  > >  [<c015c95c>] generic_file_aio_read+0x16b/0x1a6
>  > >  [<c015a7c7>] file_read_actor+0x0/0xcc
>  > >  [<c0178493>] do_sync_read+0xc7/0x10a
>  > >  [<c01353f9>] autoremove_wake_function+0x0/0x35
>  > >  [<c011bf41>] do_page_fault+0x1f7/0x592
>  > >  [<c01783cc>] do_sync_read+0x0/0x10a
>  > >  [<c0178d19>] vfs_read+0x9f/0x14b
>  > >  [<c0179182>] sys_read+0x41/0x67
>  > >  [<c0103e5e>] sysenter_past_esp+0x6b/0xa1
>  > >  =======================
>  > > Code: 24 04 89 d1 31 d2 85 c9 89 44 24 08 74 08 89 c8 31 d2 f7 f3 89
>  > > c1 8b 44 24 08 f7 f3 89 ca 89 c2 8b 46 04 8b 1c 90 eb 03 83 c3 14 <8b>
>  > > 53 10 8b 43 0c 8b 73 04 8b 7b 08 89 d1 89 54 24 24 89 c2 01
>  > > EIP: [<c881609a>] linear_mergeable_bvec+0x9a/0x10b [linear] SS:ESP 0068:c16d5c68
>  >
>  > (cc dm-devel) (which often has no effect)
>  >
>  > I wonder which kernel.org kernel was used to generate 2.6.24-1-686.
>  >
>  >
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
"Reality continues to ruin my life." - Calvin.
