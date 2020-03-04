From: Hou Tao <houtao1@huawei.com>
Subject: Re: dm: fix congested_fn for request-based device
Date: Wed, 4 Mar 2020 08:54:50 +0800
Message-ID: <291558e3-4f07-b9a8-f138-91b929fa40c9@huawei.com>
References: <20200303084501.8912-1-houtao1@huawei.com>
	<20200303161535.GA8578@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200303161535.GA8578@redhat.com>
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
Cc: tj@kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Mike,

On 2020/3/4 0:15, Mike Snitzer wrote:
> On Tue, Mar 03 2020 at  3:45am -0500,
> Hou Tao <houtao1@huawei.com> wrote:
> 
>> We neither assign congested_fn for requested-based blk-mq device
>> nor implement it correctly. So fix both.
>>
>> Fixes: 4aa9c692e052 ("bdi: separate out congested state into a separate struct")
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  drivers/md/dm.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index b89f07ee2eff..80b95e21db43 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1784,11 +1784,13 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
>>  
>>  	if (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
>>  		if (dm_request_based(md)) {
>> +			struct backing_dev_info *bdi =
>> +				md->queue->backing_dev_info;
>>  			/*
>>  			 * With request-based DM we only need to check the
>>  			 * top-level queue for congestion.
>>  			 */
>> -			r = md->queue->backing_dev_info->wb.state & bdi_bits;
>> +			r = bdi->wb.congested->state & bdi_bits;
>>  		} else {
>>  			map = dm_get_live_table_fast(md);
>>  			if (map)
> 
> The above change does indeed fix missing conversion that should've
> occurred in commit 4aa9c692e052.
> 
>> @@ -2265,6 +2267,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>>  			DMERR("Cannot initialize queue for request-based dm-mq mapped device");
>>  			return r;
>>  		}
>> +		dm_init_normal_md_queue(md);
>>  		break;
>>  	case DM_TYPE_BIO_BASED:
>>  	case DM_TYPE_DAX_BIO_BASED:
> 
> I've renamed dm_init_normal_md_queue to dm_init_congested_fn and removed
> it's incorrect comment.
> 
Thanks for that.

Regards,
Tao
> Here is the final fix I just staged:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.6&id=974f51e8633f0f3f33e8f86bbb5ae66758aa63c7
> 
> Thanks,
> Mike
> 
> 
> .
> 
