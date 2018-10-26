From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [RFC] dm-bow working prototype
Date: Fri, 26 Oct 2018 16:03:10 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810261558460.28906@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181023212358.60292-1-paullawrence@google.com> <20181023221819.GB17552@agk-dp.fab.redhat.com> <296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com> <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
 <4a934593-1bd1-be5f-35c0-945c42762627@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a934593-1bd1-be5f-35c0-945c42762627@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Lawrence <paullawrence@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids



On Thu, 25 Oct 2018, Paul Lawrence wrote:

> Thank you for the suggestion. I spent part of yesterday experimenting with
> this idea, and it is certainly very promising. However, it does have some
> disadvantages as compared to dm-bow, if I am understanding the setup
> correctly:
> 
> 1) Since dm-snap has no concept of the free space on the underlying file
> system any write into the free space will trigger a backup, so using twice the
> space of dm-bow. Changing existing data will create a backup with both
> drivers, but since we have to reserve the space for the backups up-front with
> dm-snap, we would likely only have half the space for that. Either way, it
> seems that dm-bow is likely to double the amount of changes we could make.
> 
> (Might it be possible to dynamically resize the backup file if it is mostly
> used up? This would fix the problem of only having half the space for changing

Yes - the snapshot store can be extended while the snapshot is active.

> existing data. The documentation seems to indicate that you can increase the
> size of the snapshot partition, and it seems like it should be possible to
> grow the underlying file without triggering a lot of writes. OTOH this would
> have to happen in userspace which creates other issues.)
> 
> 2) Similarly, since writes into free space do not trigger a backup in dm-bow,
> dm-bow is likely to have a lower performance overhead in many circumstances.
> On the flip side, dm-bow's backup is in free space and will collide with other
> writes, so this advantage will reduce as free space fills up. But by choosing
> a suitable algorithm for how we use free space we might be able to retain most
> of this advantage.
> 
> I intend to put together a fully working prototype of your suggestion next to
> better compare with dm-bow. But I do believe there is value in tracking free
> space and utilizing it in any such solution.

The snapshot target could be hacked so that it remembers space trimmed 
with REQ_OP_DISCARD and won't reallocate these blocks.

But I suspect that running discard over the whole device would degrade 
performance more than copying some unneeded data.

How much data do you intend to backup with this solution?

Mikulas
