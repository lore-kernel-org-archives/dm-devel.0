Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5851C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 00:01:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-QRHrt9qkNNWt_8luOFjYIQ-1; Sat, 08 Jan 2022 19:00:54 -0500
X-MC-Unique: QRHrt9qkNNWt_8luOFjYIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED59D344B0;
	Sun,  9 Jan 2022 00:00:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C9655E4A9;
	Sun,  9 Jan 2022 00:00:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A7BC91809CB8;
	Sun,  9 Jan 2022 00:00:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20900gbX025666 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 8 Jan 2022 19:00:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1DC091120AB8; Sun,  9 Jan 2022 00:00:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1752A1121319
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 00:00:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 928B685A5AA
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 00:00:36 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-155-rx7FqvryMQuW507vAqg8lg-1; Sat, 08 Jan 2022 19:00:35 -0500
X-MC-Unique: rx7FqvryMQuW507vAqg8lg-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
	[212.227.17.184]) with ESMTPSA (Nemesis) id 1MVvPD-1myx8k1kJR-00Ro3e;
	Sun, 09 Jan 2022 00:55:28 +0100
Message-ID: <5ffc44f1-7e82-bc85-fbb1-a4f89711ae8f@gmx.com>
Date: Sun, 9 Jan 2022 07:55:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
To: Lukas Straub <lukasstraub2@web.de>
References: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
	<20220108195259.33e9bdf0@gecko> <20220108202922.6b00de19@gecko>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220108202922.6b00de19@gecko>
X-Provags-ID: V03:K1:BVRGUUZIO9w0zpfZKPOWTlrdRKy2XP9MQupgHUM5oIewSBjhOs4
	svXluN/0+v3ESSi3sLWhSM0N0A9E2ysoTIY7HPb4OAT2PHYDcmuvIFAadI8HBL5jnLwetek
	LJC9VWzhP+VjyYCTQ/GDykKGquQwn8P3/UEftFjJ4zpTU2In8Gu+7lOk+BoC0vqHs3Hus75
	Pri2/mZl15MwyxoTis1Ag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wawrTWtXEbc=:1cPYUNvxgCZkyFe2enk0cQ
	bmYyc0QrpmvWZWvqz099ZdO1T8wMKKOuB0MLI31AAlx+boIDnYeziyVj6qjZ5UQMYTtXcpzzQ
	39t8Bho1we25QcqZW2GWO3O5H6hSfC6GxvNaGX6hubnD87sXnFIxKyngHoLBO7zaxCM7OtDpd
	HdWELnNOVcYWgRlSAA3k8kzjxUy/C/6C0ZP0ztxTBo4J/8RD2LvbpXzwVc2c1RCGNoWb0mYn9
	CVmrqgLTZIoiY9nSOsHIigdm6PhPO9QkunTKe0YzAREs8lyDslnuxUCMHQABgNYB5EO2gI8e0
	suXPz1/bMGJ1W24jYjnClehjsaCMg+mnZU1VrKHqpoBwigulqRBbPZZqWcmc6nOE5E0Byc6eV
	z3kRz+HI8s1qwlU6fs5sSY3I7eSdCKTh6PDKQm0MnOdrt0jgzSJ2dE/BLVjnM7TdKg9EqcV6F
	1/05Mcyp3njkiakAw22RrTFesUoX8ZFkGrCPfxFDxrJIMBZK5bS69vmkBlM0R7FDqzNdoZl2i
	kAwSyy1CJGG/D3W+pKetjxS30Lm4n9/H3mHQmKH8Jiq879YgioQJkHaQoYAal/uz/vZRtpZuV
	y8cHqY9BM5Wso375hhKBtHWemqxaGwZY2ysEuX9tlzSLcdsapXBttoxQ1WhX3zT/y+5K83Xkn
	SyYiRhDcurBHDuWzjbiPfqqPd+2SJfWc3xUoStNsJGoh9VgDKUfiUgTga4VdKchjHCWLQ5Ung
	QKp4JN9vLHKoUG9iLMFEopBOVKP2PtIpSxuRzh4mHhnAEfQ/s9JiVaE91cIhzP7yTgx9NvF8M
	MHY7+y/jxlu8ioKDDfJkfO9UyaD946xfT1U+i7j5ONBEzwerDbVdZRtV/Jnbi40fzlMkj1hfQ
	ZzMEsUvQsF9AB7aReqnjQC/vdBBAIam1oFgdME0X3UvU4iayRlztutkrMFxU3K2PoGuqd+f3t
	8wbTcDn3enUxlJFoGqVuG0gXy3+RjANyMWq8mfG3nYmEebvC22DNPYJWZSltOWHxr5gL4rj5r
	QjbC5p2lGarFI6nRixGv8bBZvWmsqMhaB2MzIm76PDcS141oenG0TmjgdGvqG6YwLODMQvBIn
	fVysItcszwpvgc=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20900gbX025666
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, linux-raid@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2022/1/9 04:29, Lukas Straub wrote:
> On Sat, 8 Jan 2022 19:52:59 +0000
> Lukas Straub <lukasstraub2@web.de> wrote:
>
>> CC'ing linux-raid mailing list, where md raid development happens.
>> dm-raid is just a different interface to md raid.
>>
>> On Fri, 7 Jan 2022 10:30:56 +0800
>> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>> Hi,
>>>
>>> Recently I'm working on refactor btrfs raid56 (with long term objective
>>> to add proper journal to solve write-hole), and the coverage of current
>>> fstests for btrfs RAID56 is not that ideal.
>>>
>>> Is there any project testing dm/md RAID456 for things like
>>> re-silvering/write-hole problems?
>>>
>>> And how you dm guys do the tests for stacked RAID456?
>>>
>>> I really hope to learn some tricks from the existing, tried-and-true
>>> RAID456 implementations, and hopefully to solve the known write-hole
>>> bugs in btrfs.
>
> Just some thoughts:
> Besides the journal to mitigate the write-hole, md raid has another
> trick:
> The Partial Parity Log
> https://www.kernel.org/doc/html/latest/driver-api/md/raid5-ppl.html
>
> When a stripe is partially updated with new data, PPL ensures that the
> old data in the stripe will not be corrupted by the write-hole. The new
> data on the other hand is still affected by the write hole, but for
> btrfs that is no problem.
>
> But there is a even simpler solution for btrfs: It could just not touch
> stripes that already contain data.

That would waste a lot of space, if the fs is fragemented.

Or we have to write into data stripes when free space is low.

That's why I'm trying to implement a PPL-like journal for btrfs RAID56.

Thanks,
Qu

>
> The big problem will be NOCOW files, since a write to an already
> allocated extent will necessarily touch a stripe with old data in it
> and the new data also needs to be protected from the write-hole.
>
> Regards,
> Lukas Straub
>
>>> Thanks,
>>> Qu
>>>
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://listman.redhat.com/mailman/listinfo/dm-devel
>>>
>>
>>
>>
>
>
>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

