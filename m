From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] libmultipath: free pgp if add_pathgroup
 fails in disassemble_map func
Date: Thu, 23 Jul 2020 09:25:34 +0800
Message-ID: <238de4fe-6261-ec14-9053-4524da28ac39@huawei.com>
References: <e58b31e0-4f66-072f-b9c6-1047714cf3bf@huawei.com>
	<20200722204843.GJ11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200722204843.GJ11089@octiron.msp.redhat.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Thanks for your review.

On 2020/7/23 4:48, Benjamin Marzinski wrote:
> On Wed, Jul 22, 2020 at 04:36:04PM +0800, Zhiqiang Liu wrote:
>> In disassemble_map func, pgp will be added to mpp->pg by calling
>> add_pathgroup after allocing a pathgroup (pgp) successfully. However,
>> if add_pathgroup fails, the pgp is actually not inserted into mpp->pg.
>> So, calling free_pgvec(mpp->pg) cannot free the pgp, then memory leak
>> problem occurs.
>>
>> disassemble_map:
>> -> pgp = alloc_pathgroup()
>> -> if add_pathgroup(mpp, pgp) fails
>> 	-> goto out
>> out:
>> free_pgvec(mpp->pg, KEEP_PATHS);
>>
>> Here, we will call free_pathgroup(pgp) before going to out tag.
>>
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
>> ---
>>  libmultipath/dmparser.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
>> index ac13ec06..6225838b 100644
>> --- a/libmultipath/dmparser.c
>> +++ b/libmultipath/dmparser.c
>> @@ -268,8 +268,10 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
>>  		if (!pgp)
>>  			goto out;
>>
>> -		if (add_pathgroup(mpp, pgp))
>> +		if (add_pathgroup(mpp, pgp)) {
>> +			free_pathgroup(pgp, KEEP_PATHS);
>>  			goto out;
>> +		}
>>
>>  		p += get_word(p, &word);
>>
>> -- 
>> 2.24.0.windows.2
>>
> 
> 
> .
> 
