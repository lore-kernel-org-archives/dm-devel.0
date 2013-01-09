From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3 v3] add resync speed control for dm-raid1
Date: Wed, 9 Jan 2013 00:43:21 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guangliang Zhao <gzhao@suse.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, lucienchao@gmail.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I did this already some times ago.
I'm sending my patches in the next mail.

Basically, my and Guangliang's patches have the following differences:

my patch: uses per-module throttle settings
Guangliang's patch: uses per-device settings
(my patch could be changed to use per-device throttle too, but without 
userspace support it isn't much useful because userspace lvm can 
reload the mirror and per-device settings would be lost)

my patch: uses fine grained throttling of the individual IOs in kcopyd - 
it measures active/inactive ratio and if the disk is active more than the 
specified percentage of time, sleep is inserted.
Guangliang's patch: throttles on segment granularity, it waits when 
starting new segment, but segment is copied unthrottled.

my patch: the user selects a percentage value (0 - 100) in 
"/sys/module/dm_mirror/parameters/raid1_resync_throttle", the device is 
kept active the specified percent of time
Guangliang's patch: limits the number of segments per a specified 
interval

My patch is noticeably bigger.

Mikulas


On Mon, 7 Jan 2013, Guangliang Zhao wrote:

> Hi,
> 
> These patches are used to add resync speed control for dm-raid1. The
> second and third patch provide support for user-space tool dmsetup.
> I have made some modifications by the comments. This is the third
> version.
> 
> Guangliang Zhao (3):
>   dm raid1: add resync speed control for dm-raid1
>   dm raid1: add interface to set resync speed
>   dm raid1: add interface to get resync speed
> 
>  drivers/md/dm-raid1.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 89 insertions(+), 1 deletion(-)
> 
> -- 
> 1.7.10.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
