From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: Getting mapped device namw
Date: Mon, 06 Jul 2015 12:49:56 +0300
Message-ID: <559A4F44.6050200@siteground.com>
References: <DUB115-W139FD64ED5BB7A83E674F2696930@phx.gbl>,
	<559A4B31.9000509@kyup.com>
	<DUB115-W711C5EDD3B9DD92DCD95F796930@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DUB115-W711C5EDD3B9DD92DCD95F796930@phx.gbl>
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
List-Id: dm-devel.ids



On 07/06/2015 12:40 PM, Gili B wrote:
> Thanks
> hash_cell is defined privately in dm_ioctl.c , so I cannot access it.
The beauty of open source software is that you can always export it for
you own needs :)

> also dm_get_mdptr ,is not extern so I can't access it neither.
The function is exposed via device_mapper.h so you can just include this
header. Poke the code around you might come up with an even better idea.
But generally you wouldn't want to use the name the user provided.
Instead, use the name of the block device being created e.g. dm-1. This
can be obtained from the  dm_get_device function and using the dm_dev struct

>  
> Thanks
> -gili
>  
>> Date: Mon, 6 Jul 2015 12:32:33 +0300
>> From: kernel@kyup.com
>> To: dm-devel@redhat.com
>> Subject: Re: [dm-devel] Getting mapped device namw
>>
>>
>> On 07/06/2015 12:20 PM, Gili B wrote:
>>> hi
>>> when a user run :
>>> dmsetup create [device name] ....
>>> Can a device mapper target find out the device name that the user entered ?
>>
>> Apparently the name is being associated with a hash_cell object, which
>> in turn is associated with struct mapped_device in dm_hash_insert
>> (called from dev_create, which is invoked as part of the create IOCTL).
>> So presumably if you get an instance of struct mapped_device and then
>> invoke dm_get_mdptr(md). What you'd get is a pointer to struct hash_cell
>>
>>> I need it for creating entries in proc for example.
>>>  
>>> Thanks
>>> -gili
>>>  		 	   		  
>>>
>>>
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>  		 	   		  
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
