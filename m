From: Neil Brown <neilb@suse.de>
Subject: Re: Task blocked for more than 120 seconds
Date: Tue, 25 Mar 2008 14:50:20 +1100
Message-ID: <18408.30332.831113.447285@notabene.brown>
References: <87eja0o20v.fsf@willow.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Samuel Tardieu on Monday March 24
Sender: linux-raid-owner@vger.kernel.org
To: Samuel Tardieu <sam@rfc1149.net>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


Wrong mailing list.
copying to dm-devel@redhat.com

NeilBrown

On Monday March 24, sam@rfc1149.net wrote:
> On my laptop, doing heavy C++ compilations in parallel with -j3 (this
> is a dual core) often generates the following trace:
> 
> INFO: task g++:25119 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> message.
> g++           D c03916c0     0 25119  25118
>        ecfef200 00200086 c038ef18 c03916c0 c03916c0 f77b2230 f77b2378 c17fa6c0 
>        00000000 f89817bc f7486280 000000ff f7a1eb20 00000000 00000000 00000000 
>        c17fa6c0 00000000 d1401e9c c17f0408 c02a2aa1 d1401e94 c0147100 c02a2c93 
> Call Trace:
>  [<f89817bc>] dm_table_unplug_all+0x1e/0x2e [dm_mod]
>  [<c02a2aa1>] io_schedule+0x1b/0x24
>  [<c0147100>] sync_page+0x33/0x36
>  [<c02a2c93>] __wait_on_bit+0x33/0x58
>  [<c01470cd>] sync_page+0x0/0x36
>  [<c01472fd>] wait_on_page_bit+0x59/0x60
>  [<c012cf7b>] wake_bit_function+0x0/0x3c
>  [<c014e20d>] truncate_inode_pages_range+0x238/0x29f
>  [<c014e27d>] truncate_inode_pages+0x9/0xc
>  [<f8c67187>] ext2_delete_inode+0x12/0x6e [ext2]
>  [<f8c67175>] ext2_delete_inode+0x0/0x6e [ext2]
>  [<c0170ea5>] generic_delete_inode+0x8f/0xf3
>  [<c0170819>] iput+0x60/0x62
>  [<c0169aa5>] do_unlinkat+0xb7/0xf9
>  [<c0113a3e>] do_page_fault+0x1fa/0x4dc
>  [<c0104822>] sysenter_past_esp+0x5f/0x85
>  =======================
> 
> This is with 2.6.25-rc6 (SMP) and has been present, as far as I can
> remember, since the beginning of the 2.6.25-rc series. It is not
> always reproducible, but the trace is always the same.
> 
> My filesystem is stored on a ext3 (rw,noatime) dm_crypt'd partition
> leaving in a LVM volume.
> 
> % lsmod | grep dm | grep -v ' 0 *$'
> dm_crypt               14340  1 
> crypto_blkcipher       18308  6 ecb,cbc,dm_crypt
> dm_mod                 53008  26 dm_crypt,dm_mirror,dm_snapshot
> 
> Here is the code I have in dm-table.o:
> 
> 00001042 <dm_table_unplug_all>:
>     1042:       56                      push   %esi
>     1043:       53                      push   %ebx
>     1044:       8b 98 a0 00 00 00       mov    0xa0(%eax),%ebx
>     104a:       8d b0 a0 00 00 00       lea    0xa0(%eax),%esi
>     1050:       eb 10                   jmp    1062 <dm_table_unplug_all+0x20>
>     1052:       8b 43 10                mov    0x10(%ebx),%eax
>     1055:       8b 40 5c                mov    0x5c(%eax),%eax
>     1058:       8b 40 34                mov    0x34(%eax),%eax
>     105b:       e8 fc ff ff ff          call   105c <dm_table_unplug_all+0x1a>
>     1060:       8b 1b                   mov    (%ebx),%ebx
>     1062:       8b 03                   mov    (%ebx),%eax
>     1064:       0f 1f 40 00             nopl   0x0(%eax)
>     1068:       39 f3                   cmp    %esi,%ebx
>     106a:       75 e6                   jne    1052 <dm_table_unplug_all+0x10>
>     106c:       5b                      pop    %ebx
>     106d:       5e                      pop    %esi
>     106e:       c3                      ret    
> 
> The symbol in 105b call is, after relocation, blk_unplug.
> 
> It there anything else I can do to help debugging this?
> 
>  Sam
> -- 
> Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
