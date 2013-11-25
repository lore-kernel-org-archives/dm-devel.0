From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1/1] MD/DM RAID: Fix hang due to recent RAID5 locking changes
Date: Mon, 25 Nov 2013 08:20:33 -0600
Message-ID: <D89A7889-9B7B-40F1-AD7D-08937D168C7E@redhat.com>
References: <1385335843-14021-1-git-send-email-jbrassow@redhat.com> <1385335843-14021-2-git-send-email-jbrassow@redhat.com> <20131125110315.262223cf@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131125110315.262223cf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: dm-devel.ids


On Nov 24, 2013, at 6:03 PM, NeilBrown wrote:

> On Sun, 24 Nov 2013 17:30:43 -0600 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> When commit 773ca82 was made in v3.12-rc1, it caused RAID4/5/6 devices
>> that were created via device-mapper (dm-raid.c) to hang on creation.
>> This is not necessarily the fault of that commit, but perhaps the way
>> dm-raid.c was setting-up and activating devices.
>> 
>> Device-mapper allows I/O and memory allocations in the constructor
>> (i.e. raid_ctr()), but nominal and recovery I/O should not be allowed
>> until a 'resume' is issued (i.e. raid_resume()).  It has been problematic
>> (at least in the past) to call mddev_resume before mddev_suspend was
>> called, but this is how DM behaves - CTR then resume.  To solve the
>> problem, raid_ctr() was setting up the structures, calling md_run(), and
>> then also calling mddev_suspend().  The stage was then set for raid_resume()
>> to call mddev_resume().
>> 
>> Commit 773ca82 caused a change in behavior during raid5.c:run().
>> 'setup_conf->grow_stripes->grow_one_stripe' is called which creates the
>> stripe cache and increments 'active_stripes'.
>> 'grow_one_stripe->release_stripe' doesn't actually decrement 'active_stripes'
>> anymore.  The side effect of this is that when raid_ctr calls mddev_suspend,
>> it waits for 'active_stripes' to reduce to 0 - which never happens.
> 
> Hi Jon,
> this sounds like the same bug that is fixed by 
> 
> commit ad4068de49862b083ac2a15bc50689bb30ce3e44
> Author: majianpeng <majianpeng@gmail.com>
> Date:   Thu Nov 14 15:16:15 2013 +1100
> 
>    raid5: Use slow_path to release stripe when mddev->thread is null
> 
> which is already en-route to 3.12.x.  Could you check if it fixes the bug for
> you?

Sure, I'll check.  Just reading the subject of the patch, I have high hopes.  The slow path decrements 'active_stripes', which was causing the above problem...  I'll make sure though.