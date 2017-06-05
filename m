From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 0/4] dm: zoned block device fixes
Date: Mon, 5 Jun 2017 19:48:36 +0900
Message-ID: <9749b12d-e232-5386-0894-511bb45758e7@wdc.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
	<20170530202031.GA52190@redhat.com>
	<46ec84af-0700-70f9-f990-d87a63cc18b0@wdc.com>
	<20170531143910.GA16671@redhat.com> <20170602003617.GB25647@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170602003617.GB25647@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

Thank you very much for the very detailed review and all the cleanup.

On 6/2/17 09:36, Mike Snitzer wrote:
> On Wed, May 31 2017 at 10:39am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>  
>> FYI: my review of dm-zoned will be focused on DM target correctness
>> (suspend/resume quirks, no allocations in the IO path that aren't backed
>> by a mempool, coding style nits, etc).  I don't know enough about zoned
>> block devices to weigh-in on those details.  Ultimately I'll be
>> deferring to you, others on your team, and others in the community that
>> are more invested in zoned block devices to steer and stabilize this
>> target.
>>
>> Anyway, hopefully my review will be fairly quick and I can get dm-zoned
>> staged for 4.13 by end of day tomorrow.
> 
> I made a go of it but I'm getting hung up on quite a lot of code that
> doesn't conform to, what I'd like to think is, the cleaner nature of how
> DM targets that are split across multiple files should be.
> 
> You basically slammed everything into 'struct dmz_target' and passed dmz
> everywhere.  I tried to split out a 'struct dmz_metadata' (and got quite
> far!) but finally gave up because affecting that churn was killing me
> slowly.  Anyway, here is where I left off:
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-zoned
> 
> In hindsight, maybe I should've just responded with the laundry list of
> things I saw so that you could fix them.  But if you see changes that
> you like in that branch feel free to pull them in to a new version of
> dm-zoned that you resubmit.
> 
> As for splitting out a 'struct dmz_metadata'.. I'd really prefer _some_
> separation but there is little point with doing so if we're going to
> just half-ass it and add in a back-pointer to the 'struct dmz_target' to
> access certain members.  I was left unhappy with my attempt.. again, was
> a shit-show of churn.

I continued and finished the separation. There is no back-pointer
anymore. All functions in dm-zoned-metadata.c take the metadata struct
pointer as argument. Other functions in dm-zoned-target.c and
dm-zoned-reclaim.c take the dmz_target pointer as argument. To do this,
I had to add a "struct dmz_dev" to store the static information about
the device being used (bdev, name, capacity, number of zones, zone
size). This does cleanup further the initialization and tear-down path.
I also moved around and renamed some functions to further cleanup the
code and make it easier to read. At this point, I think it would be easy
to also separate all fields needed for reclaim from the dmz_target
structure. But I have not pushed changes this far as the amount of data
needed for reclaim is rather small.

> I think this target needs a more critical eye on the various places IO
> is being submitted and where allocations are occuring.  I allowed myself
> to get hung up on code movement when I should've focused on more
> constructive design choices you made.

I did address some of the "FIXME" notes you added. The main one is the
BIO cloning in the I/O path. I removed most of that and added a .end_io
method for completion processing. The only place were I do not see how
to remove the call to bio_clone() is during read BIO processing: since a
read BIO may end up being split between buffer zone, sequential zone and
simple buffer zero-out, fragmentation of the read BIO is sometimes
necessary and so need a clone.

There is one "FIXME" that I did not address: the allocation of metadata
blocks on cache miss. This is in the I/O path, but called only from the
context of the chunk workers, so a different context than the BIO submit
one. I do not see a problem with this. Please let me know if you would
prefer another solution.

I am running tests against the new version created with all these
changes. If everything goes well, I will send it out tomorrow.

Best regards.

-- 
Damien Le Moal,
Western Digital
