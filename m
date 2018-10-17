From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/3] dm zoned: metadata: use refcount_t for
 dm zoned reference counters
Date: Wed, 17 Oct 2018 02:59:06 +0000
Message-ID: <BN3PR0401MB1640A014065FE283DDB64F61E7FF0@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20180823173557.19665-1-jpittman@redhat.com>
	<20180823173557.19665-3-jpittman@redhat.com>
	<BN3PR0401MB1640A8B0BA57BD0FCBE691DCE7370@BN3PR0401MB1640.namprd04.prod.outlook.com>
	<20181016183355.GA27563@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, John Pittman <jpittman@redhat.com>
List-Id: dm-devel.ids

Mike,

On 2018/10/17 3:34, Mike Snitzer wrote:
> On Thu, Aug 23 2018 at  6:12pm -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> John,
>>
>> On 2018/08/23 10:37, John Pittman wrote:
>>> The API surrounding refcount_t should be used in place of atomic_t
>>> when variables are being used as reference counters.  This API can
>>> prevent issues such as counter overflows and use-after-free
>>> conditions.  Within the dm zoned metadata stack, the atomic_t API
>>> is used for mblk->ref and zone->refcount.  Change these to use
>>> refcount_t, avoiding the issues mentioned.
>>>
>>> Signed-off-by: John Pittman <jpittman@redhat.com>
>>> ---
>>>  drivers/md/dm-zoned-metadata.c | 25 +++++++++++++------------
>>>  drivers/md/dm-zoned.h          |  2 +-
>>>  2 files changed, 14 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>>> index 969954915566..92e635749414 100644
>>> --- a/drivers/md/dm-zoned-metadata.c
>>> +++ b/drivers/md/dm-zoned-metadata.c
>>> @@ -99,7 +99,7 @@ struct dmz_mblock {
>>>  	struct rb_node		node;
>>>  	struct list_head	link;
>>>  	sector_t		no;
>>> -	atomic_t		ref;
>>> +	refcount_t		ref;
>>
>> While reviewing your patch, I realized that this ref is always manipulated under
>> the zmd->mblk_lock spinlock. So there is no need for it to be an atomic or a
>> refcount. An unsigned int would do as well and be faster. My fault.
>>
>> I will send a patch to go on top of yours to fix that.
> 
> Hi Damien,
> 
> Given what you've said I'm not seeing the point in the intermediate
> refcount_t conversion. 
> 
> I'd rather you just send a patch that switches atomic_t to int.

OK. Will send that shortly (and thanks for reminding me, I completely forgot
about this !).

Best regards.

-- 
Damien Le Moal
Western Digital Research
