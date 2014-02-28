From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-raid: check events in super_validate
Date: Fri, 28 Feb 2014 14:40:22 -0600
Message-ID: <7D5F856A-768B-458C-9ED2-812D49A635F3@redhat.com>
References: <52ED0628.4030203@stratus.com> <20140225163020.6f299f15@notabene.brown> <DB09A2EA-5D6C-449F-A61A-EFF556F269B8@redhat.com> <530D17BF.7090008@stratus.com> <3E58643B-64BF-4A4B-9D44-3D075148FE80@redhat.com> <4A643D2E-04C2-462A-8CF8-9BB2A4DC38AE@redhat.com> <530E8418.50707@stratus.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530E8418.50707@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

The commit that fixed the problem was:
f466722ca614edcd14f3337373f33132117c7612
f466722 md: Change handling of save_raid_disk and metadata update during recover

I don't know if this is safe to independently apply to previous kernels or not yet.  Neil, do you know?

I have applied it directly to the 3.13 kernel and it solves the problem.  However, applying it to the 3.12 kernel does not solve the problem.  There is obviously something else I'm missing or the fuzziness of the patch on 3.12 is causing things to not behave as expected.

 brassow


On Feb 26, 2014, at 6:17 PM, Nate Dailey wrote:

> Interesting. I had tried this with the latest stable kernel.org kernel (as of a month or so ago) and still hit it.
> 
> I'll mention that the initial resync on creating the raid1 can be interrupted okay; the problem only happens after that completes, and a disk is removed and re-added.
> 
> Nate
> 
> 
> 
> On 02/26/2014 05:21 PM, Brassow Jonathan wrote:
>> On Feb 25, 2014, at 4:59 PM, Brassow Jonathan wrote:
>> 
>>> On Feb 25, 2014, at 4:22 PM, Nate Dailey wrote:
>>> 
>>>> Here's what I've done to reproduce this:
>>>> 
>>>> - remove a disk containing one leg of an LVM raid1 mirror
>>>> - do enough IO that a lengthy recovery will be required
>>>> - insert the removed disk
>>>> - let recovery begin, but deactivate the LV before it completes
>>>> - activate the LV
>>>> 
>>>> This is the point where the recovery should start back up, but it doesn't. I haven't tried this in a few weeks, but am happy to try it again if it would help.
>>> Confirmed (test output below).  I'll get started on this.  This code can be a bit tricky and I've been away from it for a while.  It will take me a bit to re-familiarize myself with it and review your patch.
>> I've tested this again with the latest code from upstream (kernel 3.14.0-rc4) and I cannot reproduce the problem there.  I'll see if I can find the last non-working version...
>> 
>>  brassow
>> 
> 

