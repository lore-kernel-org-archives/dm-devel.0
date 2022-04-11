Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFA6C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 13:06:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-bK-FPZomMwevuXXjoqU1ig-1; Mon, 11 Apr 2022 09:06:17 -0400
X-MC-Unique: bK-FPZomMwevuXXjoqU1ig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECB7E381D8B7;
	Mon, 11 Apr 2022 13:06:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA1C240EC009;
	Mon, 11 Apr 2022 13:06:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E1A119451F2;
	Mon, 11 Apr 2022 13:06:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B5E119466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 13:06:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08645145B992; Mon, 11 Apr 2022 13:06:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 047881427B16
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 13:06:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC1922A59549
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 13:06:04 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-HO_cNCr3OiO8HV1BKOkLdw-2; Mon, 11 Apr 2022 09:06:03 -0400
X-MC-Unique: HO_cNCr3OiO8HV1BKOkLdw-2
X-IronPort-AV: E=Sophos;i="5.90,251,1643644800"; d="scan'208";a="198526122"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 21:06:02 +0800
IronPort-SDR: p6blzI91jYCHTBW/ULbnnQBwoqdywQfZO6k/Fda6+HWfFm4Fk6UQgDu4jh+HKuIjLStJT46gtF
 JKxt2f3DYzZyBjhRduGjHKxn6b/ZI4U/qMQnOa3cQtbF/p+AJ6dpqcd6nIL1mVYOC53OvBOgqo
 Cr8LKNVgrTDYEzCptqEf1F+fZ6b3JVdZECrho/zHNe/BqLtKJ0tS4k5WJVaC8GzqOTR8N6NHJT
 4XTdhq4NTJhuRJh4TGv16qjE+80/oqCdsiZ5zFUOzPr5PsKizQnlpf5bv7Ux4PNP4CoRdEHe+a
 DuESyeQS0Df8APs2ddQDXdWL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 05:37:18 -0700
IronPort-SDR: iUsUP0J1ZXu26/DSXc6kO7pZBUHmTQEYC9G24mLeAOApHPTnFqzeSbqZ+jay8XusLwY1u1iNHd
 PtTfdSY15yHXTdnVqpbTCyXy1VnSl7ngnAdWHi65MdrVZi5uVuNxrP/DIjP4Z+eURdn5H2Wwmg
 G2NRJJFUvxWm4GYzt0LcAalhLPZ3atS32YNtWpVZ9TT2xj4mQYCbEevgpwRd5FdFr9Kk2T3pbG
 tGOmQ3JByUolSIMNkrAJz3EXdqIUDEeWbI3lLu1O0j3MBSifn7HGjGeSR7UmN26N2B9uyyETR2
 RFs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 06:06:02 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KcTcn0KB3z1SHwl
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 06:06:01 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id t52T2S8EGX4b for <dm-devel@redhat.com>;
 Mon, 11 Apr 2022 06:06:00 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KcTcm0ptDz1Rvlx;
 Mon, 11 Apr 2022 06:05:59 -0700 (PDT)
Message-ID: <dbadaa68-517e-adbc-26e6-7e8be0513f72@opensource.wdc.com>
Date: Mon, 11 Apr 2022 22:05:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>
References: <20220411093838.1729001-1-damien.lemoal@opensource.wdc.com>
 <YlQmzcUmkwzi6meS@T590>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlQmzcUmkwzi6meS@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] dm: dm-zone: Fix NULL pointer dereference in
 dm_zone_map_bio()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/22 22:02, Ming Lei wrote:
> On Mon, Apr 11, 2022 at 06:38:38PM +0900, Damien Le Moal wrote:
>> Commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface") changed
>> the alloc_io() function to delay the initialization of struct dm_io
>> orig_bio field, leaving this field as NULL until the first call to
>> __split_and_process_bio() is executed for the user submitted BIO. This
>> change causes a NULL pointer dereference in dm_zone_map_bio() when the
>> original user BIO is inspected to detect the need for zone append
>> command emulation.
>>
>> Avoid this problem by adding a struct clone_info *ci argument to the
>> __map_bio() function and a struct bio *orig_bio argument to
>> dm_zone_map_bio(). Doing so, the call to dm_zone_map_bio() can be passed
>> directly a pointer to the original user BIO using the bio field of
>> struct clone_info.
>>
>> Fixes: 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>  drivers/md/dm-zone.c |  3 +--
>>  drivers/md/dm.c      | 10 +++++-----
>>  drivers/md/dm.h      |  5 +++--
>>  3 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
>> index c1ca9be4b79e..772161f0b029 100644
>> --- a/drivers/md/dm-zone.c
>> +++ b/drivers/md/dm-zone.c
>> @@ -513,13 +513,12 @@ static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
>>  /*
>>   * Special IO mapping for targets needing zone append emulation.
>>   */
>> -int dm_zone_map_bio(struct dm_target_io *tio)
>> +int dm_zone_map_bio(struct dm_target_io *tio, struct bio *orig_bio)
>>  {
>>  	struct dm_io *io = tio->io;
>>  	struct dm_target *ti = tio->ti;
>>  	struct mapped_device *md = io->md;
>>  	struct request_queue *q = md->queue;
>> -	struct bio *orig_bio = io->orig_bio;
>>  	struct bio *clone = &tio->clone;
>>  	unsigned int zno;
>>  	blk_status_t sts;
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 3c5fad7c4ee6..1d8f24f04c7d 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1258,7 +1258,7 @@ static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
>>  	mutex_unlock(&md->swap_bios_lock);
>>  }
>>  
>> -static void __map_bio(struct bio *clone)
>> +static void __map_bio(struct clone_info *ci, struct bio *clone)
>>  {
>>  	struct dm_target_io *tio = clone_to_tio(clone);
>>  	int r;
>> @@ -1287,7 +1287,7 @@ static void __map_bio(struct bio *clone)
>>  	 * map operation.
>>  	 */
>>  	if (dm_emulate_zone_append(io->md))
>> -		r = dm_zone_map_bio(tio);
>> +		r = dm_zone_map_bio(tio, ci->bio);
> 
> It depends if bio_split() in dm_split_and_process_bio() can be triggered
> for dm-zone. If it can be triggered, here the actual original bio should
> be the one returned from bio_split().

It was like this before commit 0fbb4d93b38b... I will check again though.

> 
> Thanks,
> Ming
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

