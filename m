From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add VIOLIN arrays to
 hardware table
Date: Mon, 17 Oct 2016 16:49:29 +0200
Message-ID: <e6f0fc3a-ef55-88c2-d0ca-e2e746fce44f@gmail.com>
References: <20161015115023.6773-1-xose.vazquez@gmail.com>
	<8a7363a9-43ad-92ac-c237-c6bbe8bcf5b3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8a7363a9-43ad-92ac-c237-c6bbe8bcf5b3@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/16/2016 06:56 PM, Hannes Reinecke wrote:

>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index aca46ab..e34032d 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -944,6 +944,32 @@ static struct hwentry default_hw[] = {
>>          .pgpolicy      = MULTIBUS,
>>          .no_path_retry = 12,
>>      },
>> +    /*
>> +     * Violin Memory
>> +     */
>> +    {
>> +        /* V3000 / V6000 Series */
>> +        .vendor        = "VIOLIN",
>> +        .product       = "SAN ARRAY$",
>> +        .pgpolicy      = GROUP_BY_SERIAL,
>> +        .no_path_retry = 30,
>> +    },
>> +    {
>> +        .vendor        = "VIOLIN",
>> +        .product       = "SAN ARRAY ALUA",
>> +        .hwhandler     = "1 alua",
>> +        .pgpolicy      = GROUP_BY_PRIO,
>> +        .pgfailback    = -FAILBACK_IMMEDIATE,
>> +        .prio_name     = PRIO_ALUA,
>> +        .no_path_retry = 30,
>> +    },
>> +    {
>> +        /* FSP 7000 family */
>> +        .vendor        = "VIOLIN",
>> +        .product       = "CONCERTO ARRAY",
>> +        .pgpolicy      = MULTIBUS,
>> +        .no_path_retry = 30,
>> +    },
>>  #if 0
>>      /*
>>       * Copy this TEMPLATE to add new hardware.
>>
> Where's the point of the first and the third entry?
> They'll be identical to the default settings, no?

for VIOLIN/"SAN ARRAY"      .pgpolicy      = GROUP_BY_SERIAL,
for VIOLIN/"CONCERTO ARRAY" .pgpolicy      = MULTIBUS,

and DEFAULT_PGPOLICY is FAILOVER
