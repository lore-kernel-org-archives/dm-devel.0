From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: Reject sector_size feature if
 device length is not aligned to it
Date: Tue, 3 Oct 2017 08:27:29 +0200
Message-ID: <a2447b97-d4d9-7fb8-3241-c13fac9e558f@gmail.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 10/02/2017 04:43 PM, Mikulas Patocka wrote:
> 
> 
> On Sat, 30 Sep 2017, Milan Broz wrote:
> 
>> On 09/13/2017 03:45 PM, Milan Broz wrote:
>>> If a crypt mapping uses optional sector_size feature, additional
>>> restrictions to mapped device segment size must be applied in constructor,
>>> otherwise the device activation will fail later.
>>
>> Hi,
>>
>> we had some discussion with Mikulas if this check should be better in generic DM code.
>>
>> I think that for this case it is not a good idea - dm-crypt can increase
>> encryption sector size during load (it is stupid to do, but I see no reason why to block it).
>> And then only constructor of the target itself know what is possible and what should be rejected.
> 
> The same argument also applies to verity, integrity and zoned target. I 
> think it should be tested in the generic dm code, not duplicated in these 
> targets.
> 
> Here I send a patch that checks invalid limits when the table is loaded 
> and aborts the table load ioctl with an error.

ok, I thought it does not work if we change sector size between active and inactive table,
but your approach apparently works even for this case.

> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: dm: check invalid limits when table is created
> 
> Device mapper checks invalid limits when resuming a device and swapping a 
> table, however it may be too late becuase it makes the resume ioctl fail. 
> This patch checks the limits when a table is loaded, so that the table 
> load ioctl will fail.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Tested-by: Milan Broz <gmazyland@gmail.com>

Thanks!

Milan

> 
> ---
>  drivers/md/dm-ioctl.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/drivers/md/dm-ioctl.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-ioctl.c
> +++ linux-2.6/drivers/md/dm-ioctl.c
> @@ -1308,6 +1308,7 @@ static int table_load(struct file *filp,
>  	struct dm_table *t, *old_map = NULL;
>  	struct mapped_device *md;
>  	struct target_type *immutable_target_type;
> +	struct queue_limits dummy_limits;
>  
>  	md = find_device(param);
>  	if (!md)
> @@ -1349,6 +1350,10 @@ static int table_load(struct file *filp,
>  		goto err_unlock_md_type;
>  	}
>  
> +	r = dm_calculate_queue_limits(t, &dummy_limits);
> +	if (r)
> +		goto err_unlock_md_type;
> +
>  	dm_unlock_md_type(md);
>  
>  	/* stage inactive table */
> 
