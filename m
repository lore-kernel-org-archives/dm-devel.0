From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 0/4] dm: zoned block device fixes
Date: Fri, 9 Jun 2017 13:25:07 +0900
Message-ID: <f471a900-66eb-d073-69f1-09ca7da19582@wdc.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
	<20170530202031.GA52190@redhat.com>
	<46ec84af-0700-70f9-f990-d87a63cc18b0@wdc.com>
	<20170531143910.GA16671@redhat.com> <20170602003617.GB25647@redhat.com>
	<9749b12d-e232-5386-0894-511bb45758e7@wdc.com>
	<20170608202146.GB6747@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170608202146.GB6747@redhat.com>
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

On 6/9/17 05:21, Mike Snitzer wrote:
> On Mon, Jun 05 2017 at  6:48am -0400,
> Damien Le Moal <damien.lemoal@wdc.com> wrote:
>  
>> I did address some of the "FIXME" notes you added. The main one is the
>> BIO cloning in the I/O path. I removed most of that and added a .end_io
>> method for completion processing. The only place were I do not see how
>> to remove the call to bio_clone() is during read BIO processing: since a
>> read BIO may end up being split between buffer zone, sequential zone and
>> simple buffer zero-out, fragmentation of the read BIO is sometimes
>> necessary and so need a clone.
> 
> So shouldn't it be possible to not allow a given bio to cross zone
> boundaries by using dm_accept_partial_bio()?
> 
> Like you're already doing in dmz_map() actually... so why do you need to
> account for crossing zone boundaries on read later on in
> dmz_submit_read_bio()?

It is not crossing of zone or chunk boundaries that is being delt with
here. When the read BIO is being processed, we already know that it does
not cross chunk boundaries thanks to dmz_map(). Since chunks are mapped
to entire zones, the BIO does not cross a zone boundary either.

But the blocks to read within the chunk may be (1) invalid if they were
never written, (2) valid in the chunk data zone or (3) valid in the
chunk write buffer zone (this case exists only if the chunk is mapped to
a sequential zone.
So we need to examine the zones block bitmaps to discover this and
eventually split the BIO in several fragments if needed. Hence the need
for bio_clone().

If this processing was done within the context of dmz_map(), we could of
course use dm_accept_partial_bio() for splitting the BIO. But I avoided
this method as access to the zone bitmap may trigger metadata I/Os,
which is not very nice in the context of the user bio_submit(). There is
also the fact that dm-zoned does not have per zone locks to deal with
concurrent accesses to the same chunk. All BIO processing for a chunk
get serialized in the chunk work. This is mandatory to ensure sequential
write to sequential zones whenever possible.

> Is it that these zones aren't easily known up front (in dmz_map)?

dmz_map() does the mapping discovery using the mapping table that is
pinned-down in memory. So no metadata I/O trigger. But doing more than
that could trigger metadata I/Os, which I wanted to avoid.

On another note, I just posted an additional small patch for fixing 2
problems: an overflow in the target length calculation and a bad mistake
in the patch with the suspend method setup that caused compilation
error. My apologies for these mistakes. They were not in my local tree
when I tested. I think I messed up with the merging of all my local patches.

I checked your tree again and can confirm now that I am in sync. I will
keep testing anyway to make sure I did not do anything else wrong.

Thank you.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr Manager, System Software Group,
Western Digital Research
Damien.LeMoal@wdc.com
Tel: (+81) 0466-98-3593 (Ext. 51-3593)
1 kirihara-cho, Fujisawa, Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
