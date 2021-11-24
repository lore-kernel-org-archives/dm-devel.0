Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDE5C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 07:39:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-C1VeKCMcNbyYkrTG8sdlGQ-1; Wed, 24 Nov 2021 02:39:55 -0500
X-MC-Unique: C1VeKCMcNbyYkrTG8sdlGQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 409C481CCB9;
	Wed, 24 Nov 2021 07:39:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EDCD5D6CF;
	Wed, 24 Nov 2021 07:39:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 96C634BB7C;
	Wed, 24 Nov 2021 07:39:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO7dk52007405 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 02:39:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CEA232026D7F; Wed, 24 Nov 2021 07:39:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9C942026D6A
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:39:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF284106655E
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 07:39:43 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-294-ZICh8_kXOqqpLjnddunuqg-1; Wed, 24 Nov 2021 02:39:41 -0500
X-MC-Unique: ZICh8_kXOqqpLjnddunuqg-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
	[212.227.17.184]) with ESMTPSA (Nemesis) id 1M4JqV-1mpVtY1alN-000OyQ;
	Wed, 24 Nov 2021 08:39:38 +0100
Message-ID: <60ecb6a2-da19-6876-8c43-42011b4e374d@gmx.com>
Date: Wed, 24 Nov 2021 15:39:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: Naohiro Aota <Naohiro.Aota@wdc.com>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
	<YZz6jAVXun8yC/6k@infradead.org>
	<133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
	<20211124072533.tleak7xavj3tqxly@naota-xeon>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20211124072533.tleak7xavj3tqxly@naota-xeon>
X-Provags-ID: V03:K1:NgpZeP8KvC3VenFhqM7eEmUrzBFdXC23+SMhYpRI9j3GdNb72WZ
	bLn0Yb0+EI/SEEscvpMcvbievmzSZ5FPICNRYeKG9f/ZB+MACVPgUMYDM0IcLjRAOnzic0n
	/6Ip/mqoQbDUUTNzlyj4auPW4Ec1WOGG1p1qx6U/0BA2lhI+QAisEQ3x0gWy7Hd/NBhe1k0
	+NQ0nNrgE5BR01I8cu8JA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:dnNVMEhUHSA=:/jsYaBkS6kH5uU3jUFArc/
	PvLJy1ZvRmbnZjrvdGTTq/kSVoUSTzZI5bqTf6JpAIM/MKay148fpfiPZtrG6c8wnhKf75fGB
	nvcqCoCQyh/HPjKHawN91Sb1GSpc+jITWvYCx1EZRQx+Gc8ujA2HIhmx9mVVPMrRmoaIw/lig
	bzLVoqaQJca5DdROJFFkd0oqqv6cxrngX+Mm+o54sDD8SJ6BrLMWurjc6buE2KwTCoA5BzEdY
	GwMbLn5KVZLMTcBvV2rtkxFmCUMKzlvzjpP3Z84h/ZvgNd/6Z98qRoVuIJCSVCQc1OUdgB3Sv
	n/rnS+WM0gN9t3rKNgZ7ftHJMUwXjweHXJ4cRRJ+eY7bJyl84QX+M/587lDlkvjWUwJ6dQzW9
	Xef6oIN3aGozyMHcOrvRwTAMOSM1S3Ij2BF29IR3gDWtLluhDnxRU7d6CiAbzrAHG9HQK/bQQ
	96RXdKYkRnndgS4e8rvmxU5CrDF3kfsHL+DZZyjqST/7znncTv1K7WXhEfnBx9S+F8DBci65z
	1dXcefG0XXbeJK36ql/7cvD7oFB7yoTesKK3Auzhi/RXQrhPXYtUU4qeqCP9zVgWY7npB9SO/
	fQOIkGx/wt90hMMXHBsOLnpKv4/Ziz5ew0EHLEC2gpzZv8mlVeZKmZJ6XTV88pBFGLtOr/bKZ
	fzYX30iSrzaXgux9exSBSb+IwigXhIL56s3RFZm6aCb7cK6mNZa6MPD3vk70LryRIMVlVtaDO
	p08J1jJcnW1w8f8YMohew8UhrHUYBEJVRzhBWAxewYj4cvxjerHCenmzTIq8QEHyks9X9IvYy
	xPHJZ3Ss1/2rgNsEXKMrcgEh/BWCR19V1hXnUHvP0Lqf9z99KR2zH4+ZRT8eKrviyjwHIjw+i
	l37Mi9A8wikc+naCxEqfILOfyYCp60haIqVjIWZN/2shuoTLfcYdTLFBBiZh9rxyxBv8hohRU
	PL/6yFnagalLsltcBq4rpd5V4axyeO14zdVeE35r7viK9yQYWNU690Hc5BXlnt42mGGRSyd+a
	Ee4zi6Qo/ykFT5VmAKwVFuhq2JFSMLieLxNjXDKvSjY/S6cqgJ4QzFxskBRRk8dIXa9HCpgPc
	4UVx7ZQ7xbBnaE=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AO7dk52007405
X-loop: dm-devel@redhat.com
Cc: "hch@infradead.org" <hch@infradead.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/11/24 15:25, Naohiro Aota wrote:
> On Wed, Nov 24, 2021 at 07:07:18AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2021/11/23 22:28, hch@infradead.org wrote:
>>> On Tue, Nov 23, 2021 at 11:39:11AM +0000, Johannes Thumshirn wrote:
>>>> I think we have to differentiate two cases here:
>>>> A "regular" REQ_OP_ZONE_APPEND bio and a RAID stripe REQ_OP_ZONE_APPEND
>>>> bio. The 1st one (i.e. the regular REQ_OP_ZONE_APPEND bio) can't be split
>>>> because we cannot guarantee the order the device writes the data to disk.
>>
>> That's correct.
>>
>> But if we want to move all bio split into chunk layer, we want a initial
>> bio without any limitation, and then using that bio to create real
>> REQ_OP_ZONE_APPEND bios with proper size limitations.
>>
>>>> For the RAID stripe bio we can split it into the two (or more) parts that
>>>> will end up on _different_ devices. All we need to do is a) ensure it
>>>> doesn't cross the device's zone append limit and b) clamp all
>>>> bi_iter.bi_sector down to the start of the target zone, a.k.a sticking to
>>>> the rules of REQ_OP_ZONE_APPEND.
>>>
>>> Exactly.  A stacking driver must never split a REQ_OP_ZONE_APPEND bio.
>>> But the file system itself can of course split it as long as each split
>>> off bio has it's own bi_end_io handler to record where it has been
>>> written to.
>>>
>>
>> This makes me wonder, can we really forget the zone thing for the
>> initial bio so we just create a plain bio without any special
>> limitation, and let every split condition be handled in the lower layer?
>>
>> Including raid stripe boundary, zone limitations etc.
>
> What really matters is to ensure the "one bio (for real zoned device)
> == one ordered extent" rule. When a device rewrites ZONE_APPEND bio's
> sector address, we rewrite the ordered extent's logical address
> accordingly in the end_io process. For ensuring the rewriting works,
> one extent must be composed with one contiguous bio.
>
> So, if we can split an ordered extent at the bio splitting process,
> that will be fine. Or, it is also fine if we can split an ordered
> extent at end_bio process. But, I think it is difficult because
> someone can be already waiting for the ordered extent, and splitting
> it at that point will break some assumptions in the code.

OK, I see the problem now.

It's extract_ordered_extent() relying on the zoned append bio to split
the ordered extents.

Not the opposite, thus it will be still more complex than I thought to
split bio in chunk layer.

I'll leave the zoned part untouched for now until I have a better solution.

Thanks,
Qu
>
>> (yeah, it's still not pure stacking driver, but it's more
>> stacking-driver like).
>>
>> In that case, the missing piece seems to be a way to convert a splitted
>> plain bio into a REQ_OP_ZONE_APPEND bio.
>>
>> Can this be done without slow bvec copying?
>>
>> Thanks,
>> Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

