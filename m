From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [dm- devel][PATCH] vector: return null when realloc
 fails in vector_alloc_slot func
Date: Mon, 10 Aug 2020 21:59:44 +0800
Message-ID: <3f7a8ed9-160e-4230-6d45-90066d7f87cb@huawei.com>
References: <a04e1267-0f1c-3a8b-c163-1697469ffeca@huawei.com>
	<a3a9059d2e5a3dd18bbcc649ecdb9d5564021eb1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a3a9059d2e5a3dd18bbcc649ecdb9d5564021eb1.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, bmarzins@redhat.com, christophe.varoqui@opensvc.com, kabelac@redhat.com
Cc: linfeilong@huawei.com, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids



On 2020/8/10 21:48, Martin Wilck wrote:
> Hello Liu,
> 
> On Fri, 2020-07-31 at 18:41 +0800, Zhiqiang Liu wrote:
>> In vector_alloc_slot func, if REALLOC fails, it means new slot
>> allocation fails. However, it just update v->allocated and then
>> return the old v->slot without new slot. So, the caller will take
>> the last old slot as the new allocated slot, and use it by calling
>> vector_set_slot func. Finally, the data of last slot is lost.
>>
>> Here, if REALLOC or MALLOC fails, we will return NULL.
>>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>> ---
>>  libmultipath/vector.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/libmultipath/vector.c b/libmultipath/vector.c
>> index 501cf4c5..29dc9848 100644
>> --- a/libmultipath/vector.c
>> +++ b/libmultipath/vector.c
>> @@ -49,12 +49,14 @@ vector_alloc_slot(vector v)
>>  	else
>>  		new_slot = (void *) MALLOC(sizeof (void *) * v-
>>> allocated);
>>
>> -	if (!new_slot)
>> +	/* If REALLOC or MALLOC fails, it means new slot allocation
>> fails, so return NULL. */
>> +	if (!new_slot) {
>>  		v->allocated -= VECTOR_DEFAULT_SIZE;
>> -	else
>> -		v->slot = new_slot;
>> +		return NULL;
>> +	}
>>
>> -	return v->slot;
>> +	v->slot = new_slot;
>> +	return v->slot[VECTOR_SIZE(v) - 1];
> 
> This changes the semantics of the function by returning the last 
> element of the vector rather than v->slot. That's dangerous because
> these elements aren't initialized. You might as well return NULL in
> case of success, which would obviously be wrong (actually, new elements
> _should_ be initialized to NULL). As the return value is only ever used
> to check for successful allocation, it might be best to change it into
> a bool, avoiding any ambiguity about its meaning.
> 
> If you want to clean up this function (appreciated!), please do it
> right:
> 
>  - increment v->allocated only after successful allocation,
>  - avoid the "if (v->slot)" conditional by just calling realloc(),
>  - make sure all newly allocated vector elements are set to NULL,
>  - optionally, change return value to bool (see above).
> 
> Regards,
> Martin
> 
Thanks for your suggestion.
I will rewrite and send the v2 patch as your suggestion.

> 
> 
> .
> 
