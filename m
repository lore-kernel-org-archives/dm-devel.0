From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Dm-mirror Issue
Date: Wed, 25 Jul 2012 10:38:55 -0500
Message-ID: <D83C6575-B911-4B34-BD0B-B53CC145B364@redhat.com>
References: <CAEfaOmgBJ32kjNAY57=k7p+PfnsTRMRCvujK=KOW-XpcscR8DA@mail.gmail.com>
	<CAEfaOmhqN=ifxMnuYphdAiWzrwP4qfGW+ViYziFmwLEvRSXwDA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEfaOmhqN=ifxMnuYphdAiWzrwP4qfGW+ViYziFmwLEvRSXwDA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


On Jul 25, 2012, at 3:58 AM, Gaurav Mahajan wrote:

> Hi,
> 
> I want to run Dm-raid1 or dm-mirror in degraded mode. 
> 
> So say I have 2 Disks (loop devices) and I create a mirror device over that (using dmsetup).
> Create EXT4 over the new device, mounted it and started a huge number of IO using dd on that device.
> Now while the IO are going on, I failed the 'Default' Mirror in the mirror set.
> 
> Then ideally the IO operation should not break. All the IO should go to other mirror.
> But it is not happening. Either my dd command hangs till the default device comes back or it returns an IO error 
> and breaks the IO operations on disk.
> 
> Is this is known behavior ? 
> Or
> I am missing something in configuration ?
> 
> I tried disabling initial sync, but still it is behaving same.
> 
> I am using Kernel 2.6.32. 
> Mirror target's version is 1.12.0 

This is expected behavior.  The dm-raid1.c code as written will block I/O in the event of a failure and wait for repair.  This repair can be automated (as LVM does with dmeventd monitoring) or manual, but you are stuck until the condition is cleared.

Much of this boils down to the fact that failures are not recorded by the mirror in a superblock or log by the kernel.  MD RAID can handle these situations because it does record device failures in the array superblocks.  You can use MD or - if you prefer device-mapper - you can use dm-raid.c.  Documentation for device-mapper raid targets can be found in the kernel source: linux/Documentation/device-mapper/dm-raid.txt.  Alternately, you can create RAID devices via LVM (or 'mdadm' as I eluded to above).

 brassow
