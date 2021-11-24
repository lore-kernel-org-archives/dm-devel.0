Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878D1C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 06:20:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-PPe8neBIO-KKy92VLZKKHA-1; Wed, 24 Nov 2021 01:20:25 -0500
X-MC-Unique: PPe8neBIO-KKy92VLZKKHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0332A1030C22;
	Wed, 24 Nov 2021 06:20:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6E9D794A2;
	Wed, 24 Nov 2021 06:20:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4F8D1809C89;
	Wed, 24 Nov 2021 06:20:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO6IGdO032722 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 01:18:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6BD51121318; Wed, 24 Nov 2021 06:18:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B29821121315
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:18:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9811A185A794
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:18:13 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-349-ed6Seev1NeGblBvXIjGJtw-1; Wed, 24 Nov 2021 01:18:11 -0500
X-MC-Unique: ed6Seev1NeGblBvXIjGJtw-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
	[212.227.17.184]) with ESMTPSA (Nemesis) id 1MWRRZ-1n9mX02bb1-00XrAu;
	Wed, 24 Nov 2021 07:18:06 +0100
Message-ID: <e3fce9af-429c-a1e3-3f0b-4d90fa061d94@gmx.com>
Date: Wed, 24 Nov 2021 14:18:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: "hch@infradead.org" <hch@infradead.org>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
	<cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
	<PH0PR04MB74169757F9CF740289B790C49B609@PH0PR04MB7416.namprd04.prod.outlook.com>
	<YZz6jAVXun8yC/6k@infradead.org>
	<133792e9-b89b-bc82-04fe-41202c3453a5@gmx.com>
	<YZ3XH2PWwrIl/XMy@infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YZ3XH2PWwrIl/XMy@infradead.org>
X-Provags-ID: V03:K1:ZxeW4fJ7S5g/EUK+d5QXEFC182bf1PlurcjtsWZRReag8gJgaTQ
	WTvu1uZm/uhZXTkXL/puyXAqIJpf2YyYP4o5qQrxRjeVeK8i6LT1VF449mq/tQBJ0ThUiKH
	fEtg2oRg51Tvg08PS6L4Gm9uRvu7K+Zt1DqmlnlcQia5Y+geaQSAMD/jvUsghoxaPmox1tF
	bzEg5YJtOhpbxWsPfcVlA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bAzBGslp/jM=:kkpMcgLlLndXSNdeIchiCx
	pIR6pFjsyX1M4YrTNq63w5Mgv1GOUf7bBllfDTYhM5jx8FIIVLoHJuPYsFSa6FAbKgTNN0EVt
	QMVpUH8ppvcGBtgcu+8pXfhz/n1XOCMJezr8M8ChRSTnA4O+QgL4YTnpevVeEWWeYt6NegRIV
	NrtfTg21n5m/NIj+SzRU/BfTWAJ839qVLzDfwxGPXM392U52+Y2G8OM4I0SUA2m+3NPQVpaUt
	UGpDL1edhXtaAYJLAKuuBQ9JfRyyJ0byR0Sy/eoxgcj38ZRuQjnnXOyBfAy5bhrzhAm6ok4Ul
	GAot0c3NLL7dWSYjeN6G6WhRFOXMVf4GPkkEiEdGl2kvk8MuWaA25TeFnEaK4qN5xYzuozCWo
	d3z7GNufCJKUSDUlzwFIQWjj3yv1ys6yC+bpOdR6E4KZg0QpEyjWYNecy1ufAT6Au4yOvkDdi
	oS125Wl2PwxnbTpFUm6MfeTxK2hatGZ0UCppAHKcT3BTVldfanL2ubbX5CcNZ3pYNuI97t4Ke
	8h62Iix1Zs+9/qrDYW05O4PCDFecwiNgFRDRWT6N3PelYJLQER+iIc6WgwEfUbuuM3MN9lRSz
	k1BqejtqFDhQLlAUemXXkC8vPmNU8k951f5jH2CAxz1YUfTY7W+nFGZEojyrb/wg+mKNNG2hC
	dZULNm5MjwW+bCscpAbAmHJUzAP3I/XZ0EVxgAWmP4oWa71ikH28sxbOInQzuQdDGDzu69csc
	YqYKtO5T5y7RqVb1++uJZEU3tcGKy9/UnzrMyqYM8G0I+NLkEi+Sy0WwoGg7jE3525nhVNV+F
	OA06h5mYi9b4bWn/RgBmli65bu9PpsZrYgG+kbVB+sOzitqiOErZkCjnEJ5SKXI+HIqcE9a7R
	c7W9fvxSPbluB05bJSww+ZGwhccrB46V0cI1Xi1VFkzYK6bebX2G0rCotMyW73TNZ6TrvNCDC
	bOYldivwFoAtwutXQl1bDdnUtbkiZgi42DeeraTGxlJ3cBs2LowrY06UK/b5IKD2jyc4S8WW6
	3LuJyN6y0abbH/o7YdqclJE3gA/o39lKL5ywLpABTITwzXYPXns7Z0lkG2o8a/kn0lNuxdj7s
	oHOM4f1JMXULaU=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AO6IGdO032722
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/11/24 14:09, hch@infradead.org wrote:
> On Wed, Nov 24, 2021 at 07:07:18AM +0800, Qu Wenruo wrote:
>> In that case, the missing piece seems to be a way to convert a splitted
>> plain bio into a REQ_OP_ZONE_APPEND bio.
>>
>> Can this be done without slow bvec copying?
>
> Yes.  I have a WIP stacking driver that converts writes to zone appends
> and it does just that:
>
> 	sector_t orig_sector = bio->bi_iter.bi_sector;
> 	unsigned int bio_flags = bio->bi_opf & ~REQ_OP_MASK;
>
> 	...
>
> 	clone = bio_clone_fast(bio, GFP_NOIO, &bdev->write_bio_set);
>
> 	...
>
> 	clone->bi_opf = REQ_OP_ZONE_APPEND | REQ_NOMERGE | bio_flags;

Just so simple? Then that's super awesome.

But I'm a little concerned about the bio_add_hw_page() call in
bio_add_zoned_append().

It's not exactly the same as bio_add_page().

Does it mean as long as our splitted bio doesn't exceed zone limit, we
can do the convert without any further problem?

Thanks,
Qu
> 	bio_set_dev(clone, dev->lower_bdev);
> 	clone->bi_iter.bi_sector = zone_sector;
> 	trace_block_bio_remap(clone, disk_devt(disk), orig_sector);
>
>>
>> Thanks,
>> Qu
> ---end quoted text---
>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

