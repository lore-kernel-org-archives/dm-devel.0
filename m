Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D4DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 08:16:11 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-6EKToUU2PVyC46QFaZIB-w-1; Tue, 23 Nov 2021 03:16:07 -0500
X-MC-Unique: 6EKToUU2PVyC46QFaZIB-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2CB910168C0;
	Tue, 23 Nov 2021 08:16:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F1FE60C5F;
	Tue, 23 Nov 2021 08:16:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 945301832E7F;
	Tue, 23 Nov 2021 08:16:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN8G0s9030833 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 03:16:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 23DBC40CFD0D; Tue, 23 Nov 2021 08:16:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E87540CFD04
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 08:16:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0387F811E80
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 08:16:00 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-21-NPsL7LgDMR-KSn8eLm8Kng-1; Tue, 23 Nov 2021 03:15:58 -0500
X-MC-Unique: NPsL7LgDMR-KSn8eLm8Kng-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
	[212.227.17.174]) with ESMTPSA (Nemesis) id 1MCsUC-1myCJL3dNA-008ux0;
	Tue, 23 Nov 2021 09:10:40 +0100
Message-ID: <79d38fc2-cd2f-2980-2c4e-408078ce6079@gmx.com>
Date: Tue, 23 Nov 2021 16:10:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
	<YZybvlheyLGAadFF@infradead.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YZybvlheyLGAadFF@infradead.org>
X-Provags-ID: V03:K1:rg/Rm168QvJOdNz5YKh5ZCVWWVBPRkDbZagTO5jwh/m3LDnxxUb
	d8aqhhXb6IAlm5fjBku/tmMeT7iz1fjPcyDV8SESHD2Qlhmo3nr1Nhrkndsxg29ET4gP9nE
	HgxE3eMMF01+Ep0+mCExLAovOCM9Xthd+6fjGroiER2b4GmaXIEOUHNhDUbrmIHzYaH6j7M
	JJB+JfBLhWOEC4sxfeGqQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fMH3b4Dqwxg=:/+0WYyEfN9uxM8AGrEv/JV
	NkUXEl9lV5hmkdOaLf94O9Ge3HsHKR0Ie0Wk0fksc/7qi2RhqlmfKoqy5n6/fMB44wIo6OHGT
	Yw4yM8YFQqbQseOwlKDr9AhxpH2GajxdxXp/ozddbUbGyZor0ZGCWBOpioXAVXZJvh3F4pHTE
	B6VaW+TF6kY0UXZyVqc3Rt4ODeFuWkb9v9xv3CvPHcVuO/v3qBIZRs8Ue9VLDjHxdUahn5HMZ
	LryjazA25EXFD0l8EUX9Ny7DNOIeQ61YfWaRkYJtmTbOzkmEq2D6VRqkf31tLKp/FAwgUabWc
	F5FZjHfiK8RyKTdqICNOkFJbPYpInGslkEWORPb7dT4lbcpZxUYaGRNbs53hXVG1+JLpP3Qq4
	NKSszgKK/nIFVdfbVPl/1x+qmZr5eXtwhkJx04QuyH/qbi9WbmJsVWQ6aAJR3tGrmbP/xsVQz
	cZS77fANcE0HxD/a57AU386ItOq8zVvCYVcolUuMRVOrRELViU9YSnLxkcmCKQKhDU6+w2Sh3
	fB0Cn+kIjWpAj5x5V5tKrqRfd4nY9nV4Cq4NwvXWnbMh5Mp9cVUEd5Ve5jgH6CIBfJwE8oPz5
	Km5gXBeZWYmqSuKtkZYGHIb5ZFu1fMxceB2Gudb25/3DBo3sk1tkMiOws5p2NwWTm4q6iS3Ys
	UvtW0tbCXiaiJRmCmNGDg2sit8beeWFunRW8Fg5Bm60dkH0QvfqkFF66Dj4TZAp1zJzltmIDs
	2azTTOhsk4Vf0suwQHQHtYUzmWaXJS3YOxotOraa5Mg7WjeDdiTO9VnFr/MJW3ykgcbVIA9Tg
	XIVF/rS4UM04XQm3g9iQWewgCcTMee2Axqovj/XRLSYthprHj6UuxC2a4mLqzy3BYkMrwgRZi
	dh5Dwf3qnk5EGuU3WLJDHcsx/iWWCOhn8oUdVhU0d6KjqFeK4uYullLuiTPTkdOYIq7KEd8c7
	POdodO9xIjynDp+qUFfVRHAiStq7y5m0FE5jBq4nzruiMazeQWU78HrGdbA2FfZjl3tgVd7si
	u7YEJknfeRdX5QpFY86XqGAIMTAxvrp8SmsLGNZo0qYoSsrIRjumBcorcI3dsyJuHuAgztw/E
	hAJervrNItbiI4=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AN8G0s9030833
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/11/23 15:43, Christoph Hellwig wrote:
> On Tue, Nov 23, 2021 at 02:44:32PM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> Although there are some out-of-date comments mentions other
>> bio_clone_*() variants, but there isn't really any other bio clone
>> variants other than __bio_clone_fast(), which shares bi_io_vec with the
>> source bio.
>>
>> This limits means we can't free the source bio before the cloned one.
>>
>> Is there any bio_clone variant which do a deep clone, including bi_io_vec?
>
> There is no use case for that, unless the actual data changes like in
> the bounce buffering code.
>
>> That's why the bio_clone thing is involved, there is still some corner
>> cases that we don't want to fail the whole large bio if there is only
>> one stripe failed (mostly for read bio, that we want to salvage as much
>> data as possible)
>>
>> Thus regular bio_split() + bio_chain() solution is not that good here.
>>
>> Any idea why no such bio_clone_slow() or bio_split_slow() provided in
>> block layer?
>>
>> Or really bio_split() + bio_chain() is the only recommended solution?
>
> You can use bio_split witout bio_chain.  You just need your own
> bi_end_io handler that first performs the action you want and then
> contains code equivalent to __bio_chain_endio.  As a bonus you can
> pint bi_private to whatever you want, it does not have to be the parent
> bio, just something that allows you to find it.
>
Without bio_chain() sounds pretty good, as we can still utilize
bi_end_io and bi_private.

But this also means, we're now responsible not to release the source bio
since it has the real bi_io_vec.

Let me explore this and hopefully to align btrfs with dm/md code more.

Thanks,
Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

