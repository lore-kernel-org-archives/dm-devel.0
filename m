From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: dm cache metadata: Fix loading discard bitset
Date: Wed, 17 Apr 2019 17:54:35 +0300
Message-ID: <fd71b234-7201-66f3-be74-69fe9f1707cb@arrikto.com>
References: <20190417141918.10648-1-ntsironis@arrikto.com>
	<20190417143542.GA28069@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190417143542.GA28069@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 4/17/19 5:35 PM, Mike Snitzer wrote:
> On Wed, Apr 17 2019 at 10:19am -0400,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> Add missing dm_bitset_cursor_next() to properly advance the bitset
>> cursor.
>>
>> Otherwise, the discarded state of all blocks is set according to the
>> discarded state of the first block.
>>
>> Fixes: ae4a46a1f6 ("dm cache metadata: use bitset cursor api to load discard bitset")
>> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> 
> Nice catch, I'll obviously mark this for stable@ too.
> 
> One comment below.
> 
>> ---
>>  drivers/md/dm-cache-metadata.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
>> index 6fc93834da44..151aa95775be 100644
>> --- a/drivers/md/dm-cache-metadata.c
>> +++ b/drivers/md/dm-cache-metadata.c
>> @@ -1167,11 +1167,18 @@ static int __load_discards(struct dm_cache_metadata *cmd,
>>  		if (r)
>>  			return r;
>>  
>> -		for (b = 0; b < from_dblock(cmd->discard_nr_blocks); b++) {
>> +		for (b = 0; ; b++) {
>>  			r = fn(context, cmd->discard_block_size, to_dblock(b),
>>  			       dm_bitset_cursor_get_value(&c));
>>  			if (r)
>>  				break;
>> +
>> +			if (b >= (from_dblock(cmd->discard_nr_blocks) - 1))
>> +				break;
> 
> Not understanding why you moved the conditional inside the loop, I'd
> rather keep it in the for().  Or did you have some reason for this?
> 

After processing the last block, i.e., b == (from_dblock(cmd->discard_nr_blocks) - 1),
dm_bitset_cursor_next() will return -ENODATA. It seemed to me simpler to move the
conditional inside the loop, rather than check explicitly for -ENODATA and handle
it differently, e.g., set r = 0, if r == -ENODATA.

Nikos.

>> +
>> +			r = dm_bitset_cursor_next(&c);
>> +			if (r)
>> +				break;
>>  		}
>>  
>>  		dm_bitset_cursor_end(&c);
>> -- 
>> 2.11.0
>>
