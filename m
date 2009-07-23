From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/2] dm-bdev-keep-bdev-always-referenced.patch
Date: Thu, 23 Jul 2009 17:52:42 +0900
Message-ID: <4A6824DA.30205@ce.jp.nec.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
	<4A093417.6050007@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A093417.6050007@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair, Mikulas,

I found 2.6.31-rc includes the following commit:
  commit 32a926da5a16c01a8213331e5764472ce2f14a8d
  Author: Mikulas Patocka <mpatocka@redhat.com>
  Date:   Mon Jun 22 10:12:17 2009 +0100

which will introduce a deadlock problem described here:
https://www.redhat.com/archives/dm-devel/2009-May/msg00097.html
(or see below)

Was the problem fixed/worked around somehow?

Jun'ichi Nomura wrote:
> Mikulas Patocka wrote:
>> @@ -1280,8 +1284,7 @@ static int __bind(struct mapped_device *
>>  	if (size != get_capacity(md->disk))
>>  		memset(&md->geometry, 0, sizeof(md->geometry));
>>  
>> -	if (md->bdev)
>> -		__set_size(md, size);
>> +	__set_size(md, size);
>>  
>>  	if (!size) {
>>  		dm_table_destroy(t);
>> @@ -1523,11 +1526,6 @@ int dm_swap_table(struct mapped_device *
>>  	if (!dm_suspended(md))
>>  		goto out;
>>  
>> -	/* without bdev, the device size cannot be changed */
>> -	if (!md->bdev)
>> -		if (get_capacity(md->disk) != dm_table_get_size(table))
>> -			goto out;
>> -
>>  	__unbind(md);
>>  	r = __bind(md, table);
> 
> When the device is suspended with noflush,
> can __set_size() wait forever on i_mutex
> if somebody is waiting for I/O flushing with i_mutex held (e.g. fsync)?
> 
> md->bdev was also used as a marker to tell whether the device was
> suspended with noflush.
> Sorry, the original comment in the code was perhaps not adequate.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
