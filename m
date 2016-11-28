From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 28 Nov 2016 17:26:09 +0100
Message-ID: <893401d0-1b0c-393b-e144-05039cdd15fa@redhat.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
	<9c955a41-83e0-12b4-72f6-8de797e93aed@suse.de>
	<20161128160708.GC1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161128160708.GC1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, tang.junhui@zte.com.cn, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

Dne 28.11.2016 v 17:07 Benjamin Marzinski napsal(a):
> On Mon, Nov 28, 2016 at 11:05:29AM +0100, Hannes Reinecke wrote:
>> Hi Junhui,
>>
>> Tricky bit would be to figure out _when_ to stop uevent processing and
>> calling 'ev_add_path'.
>> I guess we'd need to make 'ev_add_path' running in a separate thread;
>> that way we'd be putting pressure off the uevent processing thread and
>> the whole thing should be running far smoother.
>
> I still think that we don't need to force a wait here.
> uevent_dispatch() already pulls off all the queued events in a batch. We
> could just merge over the batch that we are given.  This has the nice
> property that when uevents aren't coming in a storm, we quickly process
> the next event, and when they are, the further multipathd gets behind, the
> larger the list it will merge over.
>


It's worth to mention at this point   - libdevmapper  1.02  is NOT library
with multithread support - there is 'certain' limited set of thread-safe 
functions, but for sure not a whole library.

So any threaded usage of libdevmapper.so would likely require mutex against
access to do library code.

Regards

Zdenek
