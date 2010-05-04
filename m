From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: FW: Postgresql Fsync issues with LVM/DM
Date: Tue, 4 May 2010 18:22:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1005041713150.6659@hs20-bc2-1.build.redhat.com>
References: <20100504011859.GB28352@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100504011859.GB28352@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg Stark <stark@google.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

Barriers are supported from kernel 2.6.30 on all DM targets except 
dm-raid1 and from 2.6.33 even on dm-raid1. 2.6.29 had a very primitive 
barrier support, it works only on linear nonfragmented volumes. DM in 
previous kernels had no barrier support.

If barriers are not supported, you must:
turn off disk write cache, with command
hdparm -W 0 /dev/hda		(on IDE, SATA)
or
sdparm --set=WCE=0 /dev/sda	(on SCSI)
or, for hardware RAID cards, if they don't have baterry-backed cache, turn 
off the write cache in BIOS. If they have baterry-backed cache, you can 
leave the cache enabled.

If you turn off write cache, postgres (and other journaled databases) will 
be safe, even without barriers on old kernels.

Some filesystems (ext2) don't send barriers at all. If you use them, you 
must turn off disk write cache anyway, regardless of kernel version.

Other filesystems (ext3,reiserfs) have barrier support off by default, you 
must use options in mount parameters to enable barriers. -o barrier=1 for 
ext3, or -o barrier=flush for reiserfs.

xfs and ext4 have barrier support on by default.

Mikulas


On Tue, 4 May 2010, Alasdair G Kergon wrote:

> FYI
> 
> (This was just the start of the discussion at FOSDEM: there'll be more to
> follow about any possibilities for optimisation.)
> 
> ----- Forwarded message from Greg Stark <stark@google.com> -----
> 
> Date: Tue, 27 Apr 2010 17:42:59 -0700
> From: Greg Stark <stark@google.com>
> Subject: Postgresql Fsync issues with LVM/DM
> To: Alasdair Kergon <agk@redhat.com>
> 
> Hi,
> 
> We met last year and again this year at FOSDEM and spent quite a while
> talking about Postgres and its issues with filesystems and LVM and DM.
> I'm sorry I haven't gotten back in touch with you sooner, especially
> as you were suggesting proposing some discussion points for the
> filesystems meeting, which I imagine is too late now :(
> 
> The topic has come up again so I would love to summarize some of the
> issues and see if I understand them correctly and ask you what the
> consequences are for various configurations of LVM. In particular I'm
> concerned that versions of LVM prior to kernel 2.6.29 reportedly do
> not pass write barriers through to devices and I'm unclear what the
> consequences of this are.
> 
> Postgres maintains multiple data files and the log files, and the
> relative timing of writes between the log files and the data files is
> critical. It guarantees this ordering itself rather than relying on
> any i/o ordering guarantees by issuing fsyncs and waiting for them to
> complete before issuing subsequent i/o requests. So as I understand
> it:
> 
> 1) If the fsync causes the filesystem to issue a write barrier which
> is passed through to the device and is honoured by the device and the
> fsync blocks until it's completed then Postgres wil never issue a
> subsequent i/o until the data has reached the stable media so LVM/DM
> is free to reorder i/o all it wants. no reordering guarantees are
> necessary.
> 
> 2) If the fsync causes the filesystem to issue a write barrier which
> is passed through to the device and is honoured by the device but the
> fsync returns early then as long as LVM/DM and the device cache
> doesn't reorder across the write barrier then the database integrity
> will not be threatened but commits could be lost. This guarantee would
> not hold if the data was spread across multiple volumes or multiple
> hardware devices though, which is quite common though.
> 
> 3) If the fsync causes the relevant buffers to be flushed and blocks
> until they're flushed and sent to the device then LVM or DM reordering
> i/o is again not relevant because Postgres won't issue any i/o which
> would be a problem to reorder. However if the device cache is a
> non-battery-backed volatile write-back cache or if it can reorder i/o
> itself then it could still be a problem because the fsync will return
> before the cache is flushed to stable media and the cache could be
> flushed out of order. If the cache is non-volatile then this
> configuration would be safe from both data integrity problems and lost
> commits.
> 
> I'm not sure which configurations are true for pre 2.6.29 LVM volumes,
> for different versions of filesystems and dm. I'm wondering if you can
> tell me if I'm way off base in my analysis, such as if I've failed to
> even characterize the possible factors properly or if I've missed any
> failure cases and if not which versions of filesystems, dm, lvm can
> offer which guarantees.
> 
> 
> -- 
> Google Ireland Ltd.,Gordon House, Barrow Street, Dublin 4, Ireland
> Registered in Dublin, Ireland Registration Number: 368047
> 
> ----- End forwarded message -----
> 
