Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6E4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 01:30:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623--scdeqwNM4qPRL-nVs2mwg-1; Wed, 12 Jan 2022 20:30:41 -0500
X-MC-Unique: -scdeqwNM4qPRL-nVs2mwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6C2081CCB5;
	Thu, 13 Jan 2022 01:30:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 406D01816C;
	Thu, 13 Jan 2022 01:30:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E7174BB7C;
	Thu, 13 Jan 2022 01:30:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20D1UR1a004725 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 20:30:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C21AC15E73; Thu, 13 Jan 2022 01:30:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87855C15E6F
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 01:30:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64BD61C05155
	for <dm-devel@redhat.com>; Thu, 13 Jan 2022 01:30:27 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-148-Z3cr-YFeOpucS1Sovn3Aqg-1; Wed, 12 Jan 2022 20:30:25 -0500
X-MC-Unique: Z3cr-YFeOpucS1Sovn3Aqg-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
	[212.227.17.184]) with ESMTPSA (Nemesis) id 1Mel7v-1mX7DG1drR-00algE;
	Thu, 13 Jan 2022 02:30:24 +0100
Message-ID: <d8a4ab1f-f6eb-06a3-cdf4-6122a6b3cbf6@gmx.com>
Date: Thu, 13 Jan 2022 09:30:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
To: Lukas Straub <lukasstraub2@web.de>
References: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
	<20220108195259.33e9bdf0@gecko> <20220108202922.6b00de19@gecko>
	<5ffc44f1-7e82-bc85-fbb1-a4f89711ae8f@gmx.com>
	<e209bfe191442846f66d790321f2db672edfb8ca.camel@infradead.org>
	<24998019-960c-0808-78df-72e0d08c904e@gmx.com>
	<20220112155351.5b670d81@gecko>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220112155351.5b670d81@gecko>
X-Provags-ID: V03:K1:UerDNmPKLlus2Pxmptpvr2B2Iop8EYbu1P0Fdu1O8neE5S59DYe
	xT6zzMRJR78JmWf1AmmWm9wYMi69yHPHtxpC73LPZ48//FarAODtB0yNZXkqFE9m0LjfdKy
	nywJDLgHAjmA1H9E6f8wi87Mt1hYOa9s5ibZP3Gx3VMlenhrhYbziZo1LhTg4fEYN1zCuiZ
	k4Wx9Vy423RxIH9tI9a2Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+n/mTaIWfEM=:RhhlemtXcANIxJfX7X6c26
	TZ5ZnwlVkKYxGafYznTogLzddIm9XwfAaZRc+ecS04UfvDGLLL8X6C2usQZ4ZHX1YB+mqsn2t
	UvLkN/v2TwTn7OeS6CK2b0FST5lqWWowJ0htmrZBxcpuo+GumBAJTvwBL6wQXDjrQesjReuM4
	C8EYUwDxyNqPcX3iFRT1alWdFGxKRxOqrRClFxya/PguqpIOsY4WX/DVbdLLyJ2xAzEMf08AN
	0wde98XxP22gzx5bi+ySQiasy6I+QG2RN549G74XAYQY1J1wXeO2iRZ7Y78+6o+FqxW/zZj9X
	1cRlds8fnISxX2ONVxMyAEdP6s5vm1gEGE0dcCMZG57F4ONf7432VsNVbNtGj/s1goHnG9BjD
	xuWhXf12tcYwx5F7blz/A4kdFhWFhN2oXN7ZW0uYZaPirk5TgNMemF78tqZd4K5hCPbHLFMh/
	vA4ij/mCGOmFCgRVsOOpsr9KeXBJo9rzx/0+JinDC88+3qXT/746SVv+Jv7JpdI1CPdUPK7pt
	fUspPLGw3kakqnp841LPxBUB5UZYNlRyPfhkhINbkUYT8LYvVXqpmxPUlkOb789e1YmCE7RBq
	z7iYfOfb0d+SXRa7owIdlghwfub4i5vyYnljMoR9ojSfqaOhXtRG2212DUzKWf0ZGrFRLzGS0
	cRbNq76LNw7G73T1A7icIuifxEI4jXuRw9UQuXuQdfWQ1gawCU8Zp32DUION2vA4/AQR/XWfF
	DXzbAS+p1ohdjh7OmaZKnxn5XsI1bFXVdwPB9W44ZmObNl2dbGWj11LBt6nQRLw2fNVRXG+us
	Bnx7pJH5GLstX9gI96+XEARquP6d4b0VYoz1F7DNfY7a8blAnuEiRlO8VlHWzAntp9n/RLjxe
	UpbCxktkfL5enSrkrgE6ZU7LT5SDzCVivCLOPnsXiXjTzLJBrelgMq10c6PeH23FylbjuAiSI
	Y/nfVfUZpcOYiPhHL8YBObWuz1Tj+/5qQtBQekzRC89OlEB+SkmLECZGvtYLt1Sb5oIlQOJXB
	ePcA7uOy9iZIM8BUhb3AAYGoqEUbks1WPxL9NZ4YcPXqKsqRrIKa1rJe5OJpoTHobmlE6LEhP
	KcCUr5mJn94XWc=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20D1UR1a004725
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>, linux-raid@vger.kernel.org
Subject: Re: [dm-devel] Proper way to test RAID456?
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2022/1/13 00:56, Lukas Straub wrote:
> On Sun, 9 Jan 2022 20:13:36 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>> On 2022/1/9 18:04, David Woodhouse wrote:
>>> On Sun, 2022-01-09 at 07:55 +0800, Qu Wenruo wrote:
>>>> On 2022/1/9 04:29, Lukas Straub wrote:
>>>>> But there is a even simpler solution for btrfs: It could just not touch
>>>>> stripes that already contain data.
>>>>
>>>> That would waste a lot of space, if the fs is fragemented.
>>>>
>>>> Or we have to write into data stripes when free space is low.
>>>>
>>>> That's why I'm trying to implement a PPL-like journal for btrfs RAID56.
>>>
>>> PPL writes the P/Q of the unmodified chunks from the stripe, doesn't
>>> it?
>>
>> Did I miss something or the PPL isn't what I thought?
>>
>> I thought PPL either:
>>
>> a) Just write a metadata entry into the journal to indicate a full
>>      stripe (along with its location) is going to be written.
>>
>> b) Write a metadata entry into the journal about a non-full stripe
>>      write, then write the new data and new P/Q into the journal
>>
>> And this is before we start any data/P/Q write.
>>
>> And after related data/P/Q write is finished, remove corresponding
>> metadata and data entry from the journal.
>>
>> Or PPL have even better solution?
>
> Yes, PPL is a bit better than a journal as you described it (md
> supports both). Because a journal would need to be replicated to
> multiple devices (raid1) in the array while the PPL is only written to
> the drive containing the parity for the particular stripe. And since the
> parity is distributed across all drives, the PPL overhead is also
> distributed across all drives. However, PPL only works for raid5 as
> you'll see.
>
> PPL works like this:
>
> Before any data/parity write either:
>
>   a) Just write a metadata entry into the PPL on the parity drive to
>      indicate a full stripe (along with its location) is going to be
>      written.
>
>   b) Write a metadata entry into the PPL on the parity drive about a
>      non-full stripe write, including which data chunks are going to be
>      modified, then write the XOR of chunks not modified by this write in
>      to the PPL.

This is a little different than I thought, and I guess that's why RAID6
is not supported.

My original assumption would be something like this for one RMW
(X = modified data, | | = unmodified data)

Data 1:    |XXXXXXXXX|   |        |
Data 2:    |         |   |XXXXXXXX|
P(1+2):    |XXXXXXXXX|   |XXXXXXXX|

In that case, modified Data 1 and 2 will go logged into PPL for the
corresponding disks.
Then for P(1+2), only the modified two parts will be logged into the device.

I'm wondering if we go this solution, wouldn't it be able to handle
RAID6 too?
Even we lost two disks, the remaining part in the PPL should still be
enough to recover whatever is lost, as long as the unmodified sectors
are really unmodified on-disk.

Although this would greatly make the PPL management much harder, as
different devices will have different PPL data usage.


>
> To recover a inconsistent array with a lost drive:
>
> In case a), the stripe consists only of newly written data, so it will
> be affected by the write-hole (this is the trade-off that PPL makes) so
> just standard parity recovery.
>
> In case b), XOR what we wrote to the PPL (the XOR of chunks not
> modified) with the modified data chunks to get our new (consistent)
> parity. Then do standard parity recovery. This just works if we lost a
> unmodified data chunk.
> If we lost a modified data chunk this is not possible and just do
> standard parity recovery from the beginning. Again, the newly written
> data is affected by the write-hole but existing data is not.
> If we lost the parity drive (containing the PPL) there is no need to
> recover since all the data chunks are present.
>
> Of course, this was a simplified explanation, see drivers/md/raid5-ppl.c
> for details (it has good comments with examples). This also covers the
> case where a data chunk is only partially modified and the unmodified
> part of the chunk also needs to be protected (by working on a per-block
> basis instead of per-chunk).

Thanks for the detailed explanation.
Qu

>
> The PPL is not possible for raid6 AFAIK, because there it could happen
> that you loose both a modified data chunk and a unmodified data chunk.
>
> Regards,
> Lukas Straub
>
>>>
>>> An alternative in a true file system which can do its own block
>>> allocation is to just calculate the P/Q of the final stripe after it's
>>> been modified, and write those (and) the updated data out to newly-
>>> allocated blocks instead of overwriting the original.
>>
>> This is what Johannes is considering, but for a different purpose.
>> Johannes' idea is to support zoned device. As the physical location a
>> zoned append write will only be known after it's written.
>>
>> So his idea is to maintain another mapping tree for zoned write, so that
>> full stripe update will also happen in that tree.
>>
>> But that idea is still in the future, on the other hand I still prefer
>> some tried-and-true method, as I'm 100% sure there will be new
>> difficulties waiting us for the new mapping tree method.
>>
>> Thanks,
>> Qu
>>
>>>
>>> Then the final step is to free the original data blocks and P/Q.
>>>
>>> This means that your RAID stripes no longer have a fixed topology; you
>>> need metadata to be able to *find* the component data and P/Q chunks...
>>> it ends up being non-trivial, but it has attractive properties if we
>>> can work it out.
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

