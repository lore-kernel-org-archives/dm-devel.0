From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: Reject sector_size feature if device
 length is not aligned to it
Date: Wed, 4 Oct 2017 08:45:01 +0200
Message-ID: <704e2665-2dc2-54a4-a35e-0c04350f4d8c@gmail.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
	<20171003120508.GA9979@agk-dp.fab.redhat.com>
	<20171003180804.GA25465@redhat.com>
	<20171003190934.GB9979@agk-dp.fab.redhat.com>
	<alpine.LRH.2.02.1710031606140.8739@file01.intranet.prod.int.rdu2.redhat.com>
	<ddef2346-99af-c20d-903f-f77af35925b6@gmail.com>
	<20171003211815.GA26406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171003211815.GA26406@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 10/03/2017 11:18 PM, Mike Snitzer wrote:
> On Tue, Oct 03 2017 at  4:33pm -0400,
> Milan Broz <gmazyland@gmail.com> wrote:
> 
>> On 10/03/2017 10:08 PM, Mikulas Patocka wrote:
>>>
>>> It would be interesting to know, why Milan wants the table load to fail.
>>
>> I mentioned this on IRC:
>> the only situation I care about in load is that size (dm-table length) is unaligned to optional sector_size.
>> create fails in this case, load should imho fail as well. 
>> ...
>> if we say that dmsetup table output is always directly usable (as a mapping table),
>> then why should there be an exception for dmsetup table --inactive? (now it can print apparently invalid mapping)
> 
> The .ctr should validate the inactive table and that'll cause load to
> fail.

And that's exactly what is the former patch doing - we introduced a new parameter that
has new limitations, we should fix constructor. That's all I want :-)

> Or dm-crypt could publish block_limits that reflect this optional
> sector_size and we'll get create (resume) failure.. which I assume is
> what you want to avoid.

I think it is doing it already, that's why Mikulas patch works
(it validates reported device physical sector sizes, not the internal encryption block parameter).

>> Anyway, I am ok if it fails in resume - but do not keep the device suspended after the fail!
> 
> Sounds like we need a patch to resume after failed inactive table load.
> Might cause lvm2 to try to resume when there is no need.  But the user
> would've already had to suspend and then resume to try to load the
> inactive table.  If we resume with the original (working) table it may
> surprise the user... will certainly cause lvm2 to fail its table
> comparison tests if the resume to old working table is done without
> erroring out.
> 
> So we'd need to still return error but resume with old table if it
> exists... and who is asking for this again?  Just us devs who think
> leaving the device suspended is bad form?
> 
> The user caused the problem by requesting a malformed table get
> used... I'm not sure how I feel about covering for such imprecise users.

IMHO there are some basic principles that should be invariant.
We can say, in a specific case, that we intentionally violate it, because the risk is negligible.

But we should not be trapped in "normalization of deviation".
The rule "only developers (or imprecise users) report this so it is not serious problem yet"
sounds like this approach.

For me, these are invariants (must be enforced in kernel) that still make sense:

1) Target constructor must validate table and must fail if options are incompatible.

2) The "dmsetup table [--inactive]" (active and inactive table in-kernel) must not
contain incompatible options.
(I am not saying anything about in-table devices attributes validation, these can change before resume.)

It implies that it should be *load* operation that fails and not resume, causing that invalid
inactive table is never accepted.

Resume still can fail later for other reasons (underlying device disappeared and similar).

And this is *different* problem - should it reactivate old table if possible? Dunno.
I just can cay that suspended device are nasty and causes many problems so
I prefer our tools minimize situations when it happens.


For the reported problem - there are no users yet, only developers (me) did that mistake
and can report it.

I can imagine that the same mistake can be seen in scripts that automatically reacts
to device size changes. Up to now, there were no limitations to device size alignment.
I have no idea how many scripts people invented. I have fixed cryptsetup only.
If an unmodified script fails and keeps underlying device in suspended state,
for administrator, it would be really irritating - it should fail and not block the device.

Sorry for the rant but I couldn't resist. Back in quiet mode now ;-)

Milan
