From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 10 Jan 2013 10:14:24 -0800
Message-ID: <20130110181424.GS26407@google.com>
References: <20130104235040.GA26407@google.com>
 <CAMM=eLdxz17qG8=Px5VoRpv2pGsGhVn3erCQLrcr=Lm-vCOrWw@mail.gmail.com>
 <20130110164704.GA30790@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130110164704.GA30790-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, Jan 10, 2013 at 11:47:04AM -0500, Mike Snitzer wrote:
> On Wed, Jan 09 2013 at 11:12am -0500,
> Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > (take3 with feeling.. I reverted to the gmail's old compose so all
> > should be right in my plain-text gmail world... apologies to Kent and
> > dm-devel for the redundant messages)
> > 
> > Hey Kent,
> > 
> > On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > I've (finally!) got a bcache branch hacked up that ought to be suitable
> > > to go upstream, possibly in staging initially.
> > >
> > > It's currently closer to the dev branch than the stable branch, plus
> > > some additional minor changes to make it all more self contained. The
> > > code has seen a decent amount of testing and I think it's in good shape,
> > > but I'd like it if it could see a bit more testing before I see about
> > > pushing it upstream.
> > >
> > > If anyone wants to try it out, checkout the bcache-for-staging branch.
> > > It's against Linux 3.7.
> > 
> > I pulled your 'bcache-for-staging' code into a 'dm-devel-cache-bcache'
> > branch on my github:
> > https://github.com/snitm/linux
> > 
> > Purpose is to have a single kernel to compare dm-cache and bcache.  My
> > branch is against 3.8-rc2.  While importing your code I needed the
> > following change to get bcache to compile:
> > https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827537a0234551253
> > 
> > It now builds without issue but I haven't tested the resulting bcache
> 
> Just tried to use bcache at it locked up:

Interesting, this is a new bug...

The main bcache branch is also on top of 3.7, and it doesn't have this
new allocation code and should be fine if you want to try that (there
were also a few bugs I fixed in the master branch without updating the
staging branch, but this looks like something new).

Gonna try and reproduce this, after I fix that sysfs code. Hrm.

> 
> # make-bcache -B /dev/striped_vg/bcache_origin -C /dev/stec/bcache_data
> UUID:                   edaef824-3b1c-4d14-a8fb-07fe7faa51e3
> Set UUID:               9808e4a4-0da4-49b1-8a33-0fe097ba2d59
> nbuckets:               32768
> block_size:             1
> bucket_size:            1024
> nr_in_set:              1
> nr_this_dev:            0
> first_bucket:           1
> UUID:                   0281d6a9-4ce0-4570-89e5-16bac3006fa2
> Set UUID:               9808e4a4-0da4-49b1-8a33-0fe097ba2d59
> nbuckets:               2048
> block_size:             1
> bucket_size:            1024
> nr_in_set:              1
> nr_this_dev:            0
> first_bucket:           1
> 
> [root@rhel-storage-02 ~]# echo /dev/striped_vg/bcache_origin > /sys/fs/bcache/register
> [root@rhel-storage-02 ~]# echo /dev/stec/bcache_data > /sys/fs/bcache/register
> 
> bcache: invalidating existing data                                                                                                                                     
> BUG: soft lockup - CPU#2 stuck for 22s! [kworker/2:1:9723]                                                                                                             
> Modules linked in: skd(O) dm_cache_cleaner dm_cache_mq dm_cache_basic dm_cache dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio dm_mod xfs exportfs libcrc32c iom
> emory_vsl(O) bcache ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod configfs bnx2f
> c fcoe 8021q libfcoe garp libfc stp llc scsi_transport_fc scsi_tgt sunrpc acpi_cpufreq freq_table mperf ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_t
> ables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 iscsi_tcp li
> biscsi_tcp libiscsi scsi_transport_iscsi vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support kvm_intel kvm microcode i2c_i801 i2c_core lpc_ich mfd_core igb ses 
> enclosure sg ixgbe dca ptp pps_core mdio i7core_edac edac_core ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic ata_piix megaraid_sas [last unloa
> ded: dm_cache_basic]                                                                                                                                                   
> CPU 2                                                                                                                                                                  
> Pid: 9723, comm: kworker/2:1 Tainted: P        W  O 3.8.0-rc2.snitm+ #34 FUJITSU                          PRIMERGY RX300 S6             /D2619                         
> RIP: 0010:[<ffffffffa05f9af0>]  [<ffffffffa05f9af0>] invalidate_buckets_lru+0x60/0x7a0 [bcache]                                                                        
> RSP: 0018:ffff880203315ca8  EFLAGS: 00000287                                                                                                                           
> RAX: ffffc90003c12000 RBX: 0000000000000000 RCX: 0000000000000000                                                                                                      
> RDX: 0000000000000800 RSI: ffffc90003c12000 RDI: ffff880205522000                                                                                                      
> RBP: ffff880203315ce8 R08: ffff8802055229c8 R09: 0000000000000000                                                                                                      
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000                                                                                                      
> R13: ffff880203315c98 R14: 0000000000000000 R15: 0000000000000000                                                                                                      
> FS:  0000000000000000(0000) GS:ffff88033fc40000(0000) knlGS:0000000000000000                                                                                           
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                                                                                                                      
> CR2: 00007f00998c0008 CR3: 0000000286afc000 CR4: 00000000000007e0                                                                                                      
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                                                                                      
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                                                                                      
> Process kworker/2:1 (pid: 9723, threadinfo ffff880203314000, task ffff88032f418a80)                                                                                    
> Stack:                                                                                                                                                                 
>  0000000000000000 ffff8802055229c8 0000000000000000 ffff880205522000                                                                                                   
>  ffff880203315d78 ffff880205522aec ffff88032f418a80 ffff88032f418a80                                                                                                   
>  ffff880203315d08 ffffffffa05fa350 ffff880205522000 ffff880203315d78                                                                                                   
> Call Trace:                                                                                                                                                            
>  [<ffffffffa05fa350>] invalidate_buckets+0x30/0x110 [bcache]                                                                                                           
>  [<ffffffffa05fa8e7>] bch_allocator_thread+0x4b7/0x720 [bcache]                                                                                                        
>  [<ffffffff810018d7>] ? __switch_to+0x157/0x4f0                                                                                                                        
>  [<ffffffff81082850>] ? idle_balance+0x1c0/0x320                                                                                                                       
>  [<ffffffff81066dd0>] ? wake_up_bit+0x40/0x40                                                                                                                          
>  [<ffffffff814f4b75>] ? __schedule+0x3f5/0x710                                                                                                                         
>  [<ffffffff8105f347>] process_one_work+0x177/0x430                                                                                                                     
>  [<ffffffffa05fa430>] ? invalidate_buckets+0x110/0x110 [bcache]                                                                                                        
>  [<ffffffff810612de>] worker_thread+0x12e/0x380                                                                                                                        
>  [<ffffffff810611b0>] ? manage_workers+0x180/0x180                                                                                                                     
>  [<ffffffff8106654e>] kthread+0xce/0xe0                                                                                                                                
>  [<ffffffff81066480>] ? kthread_freezable_should_stop+0x70/0x70                                                                                                        
>  [<ffffffff814fe7ac>] ret_from_fork+0x7c/0xb0                                                                                                                          
>  [<ffffffff81066480>] ? kthread_freezable_should_stop+0x70/0x70                                                                                                        
> Code: 52 4c 8d 24 90 48 8b 97 c0 00 00 00 48 8d 0c 52 48 8d 34 88 31 c9 31 c0 49 39 f4 0f 83 ba 02 00 00 66 2e 0f 1f 84 00 00 00 00 00 <41> 0f b7 44 24 0a a8 03 0f 85 
> 7b 02 00 00 41 8b 0c 24 85 c9 0f
