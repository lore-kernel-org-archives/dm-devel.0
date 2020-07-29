From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] libmultipath: fix a memory leak in
 disassemble_status func
Date: Wed, 29 Jul 2020 09:47:50 +0800
Message-ID: <c07e2946-0355-6317-943d-02774f88840c@huawei.com>
References: <9bc76686-747f-e85b-d25f-db5a056cf869@huawei.com>
	<20200728162000.GP11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200728162000.GP11089@octiron.msp.redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "lixiaokeng@huawei.com >> lixiaokeng" <lixiaokeng@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, mwilck@suse.com
List-Id: dm-devel.ids



On 2020/7/29 0:20, Benjamin Marzinski wrote:
> On Tue, Jul 28, 2020 at 09:48:06PM +0800, Zhiqiang Liu wrote:
>>
>> In disassemble_status func, for dealing with selector args,
>> word is allocated by get_word func. However, word is not freed.
>> Then a memory leak occurs.
>>
>> Here, we call FREE(word) to free word.
> 
> Err... At the risk of sounding stupid, There is a least-pending
> selector?  Hannes, you added this code (commit 35ad40b4 "leastpending IO
> loadbalancing is not displayed properly"). Was this a Suse thing?  Is it
> still a Suse thing, or have queue-length and service-time replaced it?
> 
Thanks for your reply.
I am sorry that I cannot answer these questions. I found the memory leak through
code review.
In addition, I forget to add a check of whether work is null. I will send the
v2 patch.

> At any rate, for the patch itself (assuming that the correct answer
> isn't to just delete the least-pending code),
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>  
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>> ---
>>  libmultipath/dmparser.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
>> index 3dc77242..a4a989b2 100644
>> --- a/libmultipath/dmparser.c
>> +++ b/libmultipath/dmparser.c
>> @@ -584,6 +584,7 @@ int disassemble_status(char *params, struct multipath *mpp)
>>  						   &def_minio) == 1 &&
>>  					    def_minio != mpp->minio)
>>  							mpp->minio = def_minio;
>> +					FREE(word);
>>  				} else
>>  					p += get_word(p, NULL);
>>  			}
>> -- 
>> 2.24.0.windows.2
>>
> 
> 
> .
> 
