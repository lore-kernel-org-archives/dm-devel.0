Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7ABC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 11:09:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-d9rMsLpuP9mnn-h0JNjaNg-1; Tue, 23 Nov 2021 06:09:48 -0500
X-MC-Unique: d9rMsLpuP9mnn-h0JNjaNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F8A58735C3;
	Tue, 23 Nov 2021 11:09:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77CBD60862;
	Tue, 23 Nov 2021 11:09:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 279754E58F;
	Tue, 23 Nov 2021 11:09:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANB9f0t014433 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 06:09:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3861F4047279; Tue, 23 Nov 2021 11:09:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 321194047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:09:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18461811767
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:09:41 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-445-yEoKslFeO_a-qWigrgkL8w-1; Tue, 23 Nov 2021 06:09:39 -0500
X-MC-Unique: yEoKslFeO_a-qWigrgkL8w-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
	[212.227.17.184]) with ESMTPSA (Nemesis) id 1MnJlW-1mNscN3N9o-00jJ6Q;
	Tue, 23 Nov 2021 12:09:36 +0100
Message-ID: <cca20bcb-1674-f99d-d504-b7fc928e227a@gmx.com>
Date: Tue, 23 Nov 2021 19:09:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: Christoph Hellwig <hch@infradead.org>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
	<79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
	<YZyiuFxAeKE/WMrR@infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YZyiuFxAeKE/WMrR@infradead.org>
X-Provags-ID: V03:K1:HN//ZkQPKk205NHjFSinz9cJfVRdC850H1mx05Acxk53rparwCi
	THWLh7ECQl09R8O3i2SHZfue9ctPG7sMtzbjQdU1NXvOwem1mCixxmIY4h/368gE88m1g6i
	xa0qPj2B9c76RgCnDjDrwbKdW+yA3ROIVDFMVUVehUnWWmGVptPGVcgS0vE/60msg661avu
	DwVXVrnGCMRCpuZ4beLlA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9uqijgn8QXY=:smpjZLHq/cyEW3Ror2zHlo
	CHI2OaQcspc0mNJiqVe6T5sqqzWrf0j43BEzk5OyjXDKotnZWT/bvxYuGbjNbtUjW7eOnwdCg
	zSILJ3rHytgmxxjYOjfEAfbnyZ+2wvP5GtexpGxxHrspTkp/hIHlpr2JCvwHhPftUhBrMQtj7
	WwewyxJ0z+q9fQqkH9O4Q6Uy/N8jbGT2cffrV+90Stat2QTChOFdThnhcOQ4Bb+eWUtzwb6bF
	kE+Rfsp7Igde9SGTcCJf/0HfL6eqHApgbadneQUysbB+m/+xitvLN8S8atNsz/1PwvLz0DnCA
	TXEtzJpS6tnTx7X0TsH2gu4TpodpYy5tUoXqAZlTTtL0FQP+YUhb4nOATiAxNLJlPDEIvEeel
	da5qYse1xKhk9ru8vEn4EV40YOY1G1rnzS8RIwi/HYL8b3G9pY6FHhBtMXzpwE+RmKwu5bjRw
	C1bSCQ05qi6FAeT84lPnlTFGtotOXtBCk0vNtLIg219eFARg4xQiPkefU/buCyyXvDBi3yNsG
	M0VxXK6a7BVeX8zLUjKA3/NkJhfvEVLKSOQwWURRLZMUuL/IekgKGBhrOQd8iGwQKq5EpCil8
	RxIyFNfCfTAppS8C5iUoSvAo9PotD4lrjWVCawleBDw7hMvHUFdbmLvRF5ru3W/cHovmUeClQ
	rdkM5PDL3BsRij3Bl4aXmMKh2G6yfBAMpAKB8t2yTDa9Q+dPKCTn+9/1JiEw4Bm3TcbHObzYd
	k2wZeVqzcwFMrLNs9GINSMurbMsNirjUMsrswLuPdWVO0NqAkHLIgIiud1AlVWI98Li5VI+MW
	N0Nb5pMUPTMfgMtA+ZKX6Q7+eb6Y7fbR8PZmbuEGMdQIAGVB82taJx7uY7Ms0lu3nk1B8mwFW
	R436fY59baX0pWDrTo+UKbvdflCIadXBPuNValyGz1QssiPoyZWjO+pekypHXwYjhq2X5Nrq4
	ITb+ylQ2ZpoieGyRmgMEWp/ekEq7+gb/5tesvA3DRo+GMp9kZ65QvXCGpCJfPXmXzPoa0SSpD
	w4k3MS21d6bAvSHlUfSL/Vxuj4m915VDLGqN1bL+RMsFh1ufZblH21llnLaRSFjrzmf8jKJpT
	Hk1SIa8cE1MjBs=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ANB9f0t014433
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/11/23 16:13, Christoph Hellwig wrote:
> On Tue, Nov 23, 2021 at 04:10:35PM +0800, Qu Wenruo wrote:
>> Without bio_chain() sounds pretty good, as we can still utilize
>> bi_end_io and bi_private.
>>
>> But this also means, we're now responsible not to release the source bio
>> since it has the real bi_io_vec.
>
> Just call bio_inc_remaining before submitting the cloned bio, and then
> call bio_endio on the root bio every time a clone completes.
>
Yeah, that sounds pretty good for regular usage.

But there is another very tricky case involved.

For btrfs, it supports zoned device, thus we have special calls sites to
switch between bio_add_page() and bio_add_zoned_append_page().

But zoned write can't not be split, nor there is an easy way to directly
convert a regular bio into a bio with zoned append pages.

Currently if we go the slow path, by allocating a new bio, then add
pages from original bio, and advance the original bio, we're able to do
the conversion from regular bio to zoned append bio.

Any idea on this corner case?

Thanks,
Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

