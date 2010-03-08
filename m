From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH] dm_ioctl: Introduce DM_UEVENT_GENERATED_FLAG
Date: Mon, 08 Mar 2010 08:07:08 +0100
Message-ID: <4B94A21C.3060306@redhat.com>
References: <4B8B7A65.3020301@redhat.com>
	<20100305193223.GR27852@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100305193223.GR27852@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

On 03/05/2010 08:32 PM, Alasdair G Kergon wrote:
> On Mon, Mar 01, 2010 at 09:27:17AM +0100, Peter Rajnoha wrote:
>> diff -purN linux-2.6.33-rc8.orig/drivers/md/dm-ioctl.c linux-2.6.33-rc8/drivers/md/dm-ioctl.c
> 
>> @@ -736,10 +738,10 @@ static int dev_remove(struct dm_ioctl *p
>   
>>  	dm_put(md);
>> -	param->data_size = 0;
>>  	return 0;
> 
> Why is that line removed?

That's because of the copy_to_user in the outer ctl_ioctl fn
so it copies back the result (with the new flag). We had nothing
in return before...

Peter
