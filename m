From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Lsf] dm-mpath request merging concerns [was: Re:
 It's time to put together the schedule]
Date: Mon, 23 Feb 2015 11:18:36 -0600
Message-ID: <54EB60EC.6080706@cs.wisc.edu>
References: <1424395745.2603.27.camel@HansenPartnership.com>	<54EAD453.6040907@suse.de>
	<20150223135057.GA3362@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150223135057.GA3362@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: lsf@lists.linux-foundation.org, Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2/23/15, 7:50 AM, Mike Snitzer wrote:
> On Mon, Feb 23 2015 at  2:18am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
>
>> On 02/20/2015 02:29 AM, James Bottomley wrote:
>>> In the absence of any strong requests, the Programme Committee has taken
>>> a first stab at an agenda here:
>>>
>>> https://docs.google.com/spreadsheet/pub?key=0ArurRVMVCSnkdEl4a0NrNTgtU2JrWDNtWGRDOWRhZnc
>>>
>>> If there's anything you think should be discussed (or shouldn't be
>>> discussed) speak now ...
>>>
>> Recently we've found a rather worrysome queueing degradation with
>> multipathing, which pointed to a deficiency in the scheduler itself:
>> SAP found that a device with 4 paths had less I/O throughput than a
>> system with 2 paths. When they've reduced the queue depth on the 4
>> path system they managed to increase the throughput somewhat, but
>> still less than they've had with two paths.
>
> The block layer doesn't have any understanding of how many paths are
> behind the top-level dm-mpath request_queue that is supposed to be doing
> the merging.
>
> So from a pure design level it is surprising that 2 vs 4 is impacting
> the merging at all.  I think Jeff Moyer (cc'd) has dealt with SAP
> performance recently too.
>
>> As it turns out, with 4 paths the system rarely did any I/O merging,
>> but rather fired off the 4k requests as fast as possible.
>> With two paths it was able to do some merging, leading to improved
>> performance.
>>
>> I was under the impression that the merging algorithm in the block
>> layer would only unplug the queue once the request had been fully
>> formed, ie after merging has happened. But apparently that is not
>> the case here.
>
> Just because you aren't seeing merging are you sure it has anything to
> do with unpluging?  Would be nice to know more about the workload.
>

I think I remember this problem. In the original request based design we 
hit this issue and Kiyoshi or Jun'ichi did some changes for it.

I think it was related to the busy/dm_lld_busy code in dm.c and 
dm-mpath.c. The problem was that we do the merging in the dm level 
queue. The underlying paths do not merge bios. They just take the 
request sent to them. The change that was done to promote (I do not 
think we ever completely fixed the issue) was that normally the workload 
was heavy enough or the paths slow enough so the busy check would return 
true enough to cause the dm layers queue not dispatch requests so 
quickly. They then had time to sit in the dm queue and merge with other 
bios.

If the device/transport is fast or the workload is low, the 
multipath_busy never returns busy, then we can hit Hannes's issue. For 4 
paths, we just might not be able to fill up the paths and hit the busy 
check. With only 2 paths, we might be slow enough or the workload is 
heavy enough to keep the paths busy and so we hit the busy check and do 
more merging.
