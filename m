Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FE2C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 01:10:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-Z8t-ikRzNQqGATTkh5d1fw-1; Sun, 10 Apr 2022 21:10:09 -0400
X-MC-Unique: Z8t-ikRzNQqGATTkh5d1fw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6243D29DD996;
	Mon, 11 Apr 2022 01:10:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 500F1141511B;
	Mon, 11 Apr 2022 01:10:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 072E119451F1;
	Mon, 11 Apr 2022 01:10:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C2D9719466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 01:10:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B283E40149B2; Mon, 11 Apr 2022 01:10:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ADDD440C128B
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 01:10:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 626F885A5BC
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 01:10:06 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-oHOq0BRBMV6TgHLI3YdhMQ-1; Sun, 10 Apr 2022 21:10:05 -0400
X-MC-Unique: oHOq0BRBMV6TgHLI3YdhMQ-1
X-IronPort-AV: E=Sophos;i="5.90,250,1643644800"; d="scan'208";a="301758347"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 09:09:00 +0800
IronPort-SDR: ovOrO/0abVZ2XautH7ru5mZoyyxmF9/sT9aiogyGD26/LNTBHq9Hf7F3fIOSmlJfYBrIr3UDzf
 Bj5LxslSqXDeqQ2g+cFAZ7uCnchXGvmO+l/SJjq15/ykasDnENLgKMcfjF6AVxo8m8WC9D3Kah
 dO8IfRB0uqzxYp9c+7zX9kxX3mhegHavB3VTz4Q9F3TYyTx9Kwvdz9GPdI28rMKDJio1Lhdf3r
 5LaRxqbe+vDI2dZXPkwyJRghU1P0s+QASxW09kIJQtcFtVGT1UE4tIZTHjcHMy/DMtFqkknduD
 2mz8NTfR5neDa5VoTFHj3fxX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Apr 2022 17:39:30 -0700
IronPort-SDR: kEGOOskWFk+n+ya9TRpAbmHHt6x8blZWM29pGoBSbdga2eJ69f+9hc+D6Ut4C/hkOx1I7LY+m3
 /ch3p/C8FAlpUbSKYh51B5vja6L9eB/b2F9pMh4jVnWFOyGUxRb2V61lOIro1zDmr7sqJibk9f
 0vabC0VnmDH9ywaE07kMsSlRDtDTr1qooEx5UCpLOB++febAiSP/75Je7BLQEZoim6psxTKa+n
 IrJ2LnyftodFY71Q+jNtnwIWHc5JJWQn75gSp7pn7Uai++yL6ak57bJFTP6fYA1YZCVKWmtlyI
 Nms=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Apr 2022 18:09:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kc9jS2Ds3z1SVp1
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 18:09:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id yChVn8K38oW9 for <dm-devel@redhat.com>;
 Sun, 10 Apr 2022 18:08:59 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kc9jQ52jNz1Rvlx;
 Sun, 10 Apr 2022 18:08:58 -0700 (PDT)
Message-ID: <2b87bb7c-1840-acb1-dbe4-ab7fb29b429a@opensource.wdc.com>
Date: Mon, 11 Apr 2022 10:08:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
 <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
 <YlN4BC2qbGODxbVz@T590>
 <95d8a8ed-27f8-0d88-a543-16910dca83e3@opensource.wdc.com>
 <YlN+plgvwZQdPBGj@T590>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlN+plgvwZQdPBGj@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/22 10:04, Ming Lei wrote:
> On Mon, Apr 11, 2022 at 09:50:57AM +0900, Damien Le Moal wrote:
>> On 4/11/22 09:36, Ming Lei wrote:
>>> On Mon, Apr 11, 2022 at 09:18:56AM +0900, Damien Le Moal wrote:
>>>> On 4/9/22 02:12, Ming Lei wrote:
>>>>> dm_zone_map_bio() is only called from __map_bio in which the io's
>>>>> reference is grabbed already, and the reference won't be released
>>>>> until the bio is submitted, so no necessary to do it dm_zone_map_bio
>>>>> any more.
>>>>
>>>> I do not think that this patch is correct. Removing the extra reference on
>>>> the io can lead to problems if the io is completed in the target
>>>> ->map(ti, clone) call or before dm_zone_map_bio_end() is called for the
>>>> DM_MAPIO_SUBMITTED or DM_MAPIO_REMAPPED cases. dm_zone_map_bio_end() needs
>>>
>>> __map_bio():
>>> 	...
>>> 	dm_io_inc_pending(io);
>>> 	...
>>> 	dm_zone_map_bio(tio);
>>> 	...
>>
>> dm-crypt (for instance) may terminate the clone bio immediately in its
>> ->map() function context, resulting in the bio_endio()clone) ->
>> clone_endio() -> dm_io_dec_pending() call chain.
>>
>> With that, the io is gone and dm_zone_map_bio_end() will not have a valid
>> reference on the orig bio.
> 
> Any target can complete io during ->map. Here looks nothing is special with
> dm-crypt or dm-zone, why does only dm zone need extra reference?
> 
> The reference counter is initialized as 1 in init_clone_info(), dm_io_inc_pending()
> in __map_bio() increases it to 2, so after the above call chain you mentioned is done,
> the counter becomes 1. The original bio can't be completed until dm_io_dec_pending()
> in dm_split_and_process_bio() is called.
> 
> Or maybe I miss any extra requirement from dm-zone?

I added that extra reference as I discovered it was needed when testing
zone append emulation with dm-crypt, back when it was implemented (the
emulation, not dm-crypt :)). Let me revisit this.

> 
> 
> thanks,
> Ming
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

