From: Hans van Kranenburg <hans@knorrie.org>
Subject: Re: Dm-integrity freeze
Date: Wed, 22 May 2019 09:52:24 +0200
Message-ID: <ad69eefc-4237-e610-603a-1053d39f0a10@knorrie.org>
References: <5D8A23C5-B6AD-48EA-B0AD-AD1BD1A2B97B@gmail.com>
	<9d19e5b1-b76f-27da-fa4a-f3a83e6e2791@gmail.com>
	<2a12ef24-ab21-a9bb-af40-3743d0b8e2c7@knorrie.org>
	<33d155ac-9b09-c8b0-3df1-88063dac964f@knorrie.org>
	<20190521220736.GB30736@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190521220736.GB30736@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Victor Helmholtz <victor.helmholtz@gmail.com>
List-Id: dm-devel.ids

On 5/22/19 12:07 AM, Mike Snitzer wrote:
> On Tue, May 21 2019 at  4:33pm -0400,
> Hans van Kranenburg <hans@knorrie.org> wrote:
> 
>> Hi,
>>
>> On 5/21/19 10:43 AM, Hans van Kranenburg wrote:
>>> Hi,
>>>
>>> I'm seeing the same lockup, also 4.19. This is mdadm RAID10 on top of 4x
>>> a partition with only dm-integrity.
>>>
>>> It just happened out of the blue, no heavy load or anything. All IO to
>>> it is frozen now.
>>>
>>> [...]
>>
>> There it is again... dmesg dump below. All cpus on 100% iowait.
>>
>> It's triggered after a few minutes by running some Windows 2019 server
>> install (ugh, don't ask) in a Xen HVM domU, which writes into a raw
>> sparse file on a btrfs filesystem on LVM on mdadm RAID10 on 4x
>> dm-integrity (wheeee!!)...
>>
>> This morning it was triggered a few minutes after starting an old
>> windows 2008 server image that I copied to this machine.
>>
>> When running only other Linux vms, and when copying data onto
>> filesystems that live in LVM logical volumes I haven't seen this problem
>> yet, at all, in the last few weeks that this machine is running.
>>
>> I noticed there's a "dm integrity: fix deadlock with overlapping I/O"
>> fix in a later 4.19. Is there any chance this is related? I have no
>> idea, but any hints or suggestions about what to try would be appreciated.
> 
> Yes, all your hung tasks are hung in wait_and_add_new_range().
> 
> Please use that later 4.19 or apply commit 4ed319c6ac08 ("dm integrity:
> fix deadlock with overlapping I/O")

Oh, silly me, that one is in 4.19.35 and I already have 4.9.37 based on
Debian in my repo, just rebooted the machine into it. Let's see what
happens today.

Thanks for confirming, sorry for the noise.

Hans
