From: "Jason Shamberger" <Jason_Shamberger@Dell.com>
Subject: Re: [PATCH 1/1] dm-mpath: Extend path selectorinterface
	for supporting Dell EqualLogic path selector
Date: Wed, 14 Jul 2010 17:34:18 -0400
Message-ID: <86A3089001A44141B76B882059E7E53B059FDD48@M31.equallogic.com>
References: <86A3089001A44141B76B882059E7E53B01E87A3B@M31.equallogic.com>
	<20100712223449.GP26290@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20100712223449.GP26290@agk-dp.fab.redhat.com>
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
Cc: Parind Shah <Parind_Shah@Dell.com>, Narendran Ganapathy <Narendran_Ganapathy@Dell.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Thanks, all, for the feedback.

We will update our proposed patch to pass individual parameters to the
path
selector instead of the entire struct request *, so it is compatible
with 
either request-based or bio-based usage.  I do feel it makes sense to
define
a struct that will be passed through, now that we have more than just 
nr_bytes.  Mike, you have a  good point about not using a union, this
has 
been removed.

> What other inputs - in addition to offset - will the path selector
need to take
> into account to make its decision and how will it get those inputs?
> Presumably you envisage some sort of semi-static or cached
information,
> and not asking the hardware before every piece of I/O?
 
The additional parameters we would like to pass to the path selectors
are:
-	Start address
-	Whether the IO is a read or write.  This will be stored in a
flags 
field.
-	Timestamp of when the IO started, so the path selector can
calculate 
the latency in end_io()

We understand the full path selector code is necessary before this patch

can be accepted, and will post it in the near future.

> How many ranges are there likely to be in this offset-based routing
table?
> How frequently is the offset-based routing table likely to change?

> As Hannes points out, the dm table layer is already designed to handle
> offset-based routing, so I'll need some convincing there's a need to
duplicate
> part of this inside path selectors.
 
> If this information is rapidly changing - many reconfigurations per
minute,
> then we may need to consider some in-kernel solution.  Otherwise I'll
be
> seeking solutions performing the reconfiguration from userspace first.

We agree with doing much of the work in userspace, such as reading the 
information from the storage array.  The routing table can change at any

time, but is not likely to be changing frequently, so a userspace
solution 
is adequate.  This information will be cached on the host so only a
quick 
lookup is necessary in the IO path.

There are many ranges in our routing table - when we spread data across
the 
arrays in our group, each range is typically only 10s of MB, so it is
typical 
to have thousands of these ranges per LUN. 

Our initial design was to use a single entry in the dm table and a path 
selector that routed amongst paths based on the additional info proposed
above.
Based on Alasdair's and Hannes' feedback we have done some
experimentation 
with the dm table layer offset based routing and it seems a viable
alternative, 
but we hit a couple of problems.  In the current kernel the DM is
rejecting our 
table - the multipath target is request based, and it seems the request
based 
dm only supports tables that have a single target.  We have also tested
on an 
older kernel that uses a bio-based dm-multipath, and are able to load a
table 
with dmsetup.  However, we seem to be bumping into a scalability limit
when 
the table exceeds a few thousand lines.

Thanks,
Jason
