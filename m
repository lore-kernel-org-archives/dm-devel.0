From: Helen Koike <helen.koike@collabora.com>
Subject: Re: dm ioctl: fix hang in early create error condition
Date: Wed, 15 May 2019 13:12:03 -0300
Message-ID: <78dda04b-925f-49eb-f88a-6d940bcc4754@collabora.com>
References: <20190513192530.1167-1-helen.koike@collabora.com>
 <20190514013716.GA10260@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514013716.GA10260@lobo>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, kernel@collabora.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

On 5/13/19 10:37 PM, Mike Snitzer wrote:
> On Mon, May 13 2019 at  3:25P -0400,
> Helen Koike <helen.koike@collabora.com> wrote:
> 
>> The dm_early_create() function (which deals with "dm-mod.create=" kernel
>> command line option) calls dm_hash_insert() who gets an extra reference
>> to the md object.
>>
>> In case of failure, this reference wasn't being released, causing
>> dm_destroy() to hang, thus hanging the whole boot process.
>>
>> Fix this by calling __hash_remove() in the error path.
>>
>> Fixes: 6bbc923dfcf57d ("dm: add support to directly boot to a mapped device")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>
>> ---
>> Hi,
>>
>> I tested this patch by adding a new test case in the following test
>> script:
>>
>> https://gitlab.collabora.com/koike/dm-cmdline-test/commit/d2d7a0ee4a49931cdb59f08a837b516c2d5d743d
>>
>> This test was failing, but with this patch it works correctly.
>>
>> Thanks
>> Helen
> 
> Thanks for the patch but I'd prefer the following simpler fix.  What do
> you think?
> 
> That said, I can provide a follow-on patch (inspired by the patch you
> provided) that encourages more code sharing between dm_early_create()
> and dev_create() by factoring out __dev_create().

Sounds great.

> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index c740153b4e52..0eb0b462c736 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -2117,6 +2117,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
>  err_destroy_table:
>  	dm_table_destroy(t);
>  err_destroy_dm:
> +	(void) __hash_remove(__find_device_hash_cell(dmi));
>  	dm_put(md);
>  	dm_destroy(md);
>  	return r;
> 

This doesn't really work for two reasons:

1) __find_device_hash_cell() requires a mutual exclusivity between name,
uuid and dev. In dm_early_create(), dmi can have more then one of these.

2) I can fix (1) by calling __get_name_cell(), as the name is mandatory
anyway, but this function also grabs another reference to the md object,
so I need to add an extra dm_put(md) there:

 err_destroy_table:
        dm_table_destroy(t);
+err_hash_remove:
+       (void) __hash_remove(__get_name_cell(dmi->name));
+       dm_put(md);
 err_destroy_dm:
        dm_put(md);
        dm_destroy(md);


What do you think? Is this ok?

Thanks
Helen
