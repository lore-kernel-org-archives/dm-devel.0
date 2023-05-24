Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C60C77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998754;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eUZtgunYWlQZF/Xg/I9j8JRl6tnsOdA0A2FfaHSszyg=;
	b=ZFrG4mdU7hwoi2n42doe21WcNUyeHBg5QskbSyCy6QzhwAObpujPR4tU4wcw/0qWv1EbF9
	zscMdzb1CIUDhqSPqaVH4dqga+No3ltFg3MdoHz1la1kGtrBkMcHqJFKE5WxE+Rl8/qK8l
	wRqN5gtd4Ta/Y2J/v3lGcUOuDqqiQm8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-hboAbleAPgy9Fsx7_l4v_A-1; Thu, 25 May 2023 03:12:30 -0400
X-MC-Unique: hboAbleAPgy9Fsx7_l4v_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AAD63C01D98;
	Thu, 25 May 2023 07:12:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43D0140C6CDD;
	Thu, 25 May 2023 07:12:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DDD2119465A4;
	Thu, 25 May 2023 07:12:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 459BA19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 11:06:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24EAA40C6EC4; Wed, 24 May 2023 11:06:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DBDF40C6CCC
 for <dm-devel@redhat.com>; Wed, 24 May 2023 11:06:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0319F185A78F
 for <dm-devel@redhat.com>; Wed, 24 May 2023 11:06:54 +0000 (UTC)
Received: from out30-101.freemail.mail.aliyun.com
 (out30-101.freemail.mail.aliyun.com [115.124.30.101]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-582-zccgeF24OBS3nRuMm0pvqg-1; Wed, 24 May 2023 07:06:52 -0400
X-MC-Unique: zccgeF24OBS3nRuMm0pvqg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VjNqYwK_1684926406
Received: from 30.97.48.247(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VjNqYwK_1684926406) by smtp.aliyun-inc.com;
 Wed, 24 May 2023 19:06:47 +0800
Message-ID: <f9958544-e9e9-d0f0-ceff-30e73d119bad@linux.alibaba.com>
Date: Wed, 24 May 2023 19:06:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Giuseppe Scrivano <gscrivan@redhat.com>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
 <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
 <fd4d0429-4da3-8217-6c13-14fd8a198920@linux.alibaba.com>
 <87r0r6ywri.fsf@redhat.com>
 <02524ece-956f-f5d8-fb21-adc4e5617dc6@linux.alibaba.com>
 <87mt1uyphw.fsf@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <87mt1uyphw.fsf@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 25 May 2023 07:12:27 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: Aleksa Sarai <cyphar@cyphar.com>, Du Rui <durui@linux.alibaba.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Alexander Larsson <alexl@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/5/24 03:48, Giuseppe Scrivano wrote:
> Gao Xiang <hsiangkao@linux.alibaba.com> writes:
> 
>> Hi Giuseppe,
>>
>> On 2023/5/24 01:11, Giuseppe Scrivano wrote:
>>> Gao Xiang <hsiangkao@linux.alibaba.com> writes:
>>>
>>
>> ...
>>
>>>> Agreed, I hope you guys could actually sit down and evaluate a proper
>>>> solution on the next OCI v2, currently I know there are:
>>>>
>>>>    - Composefs
>>>>    - (e)stargz   https://github.com/containerd/stargz-snapshotter
>>>>    - Nydus       https://github.com/containerd/nydus-snapshotter
>>>>    - OverlayBD   https://github.com/containerd/accelerated-container-image
>>>>    - SOCI        https://github.com/awslabs/soci-snapshotter
>>>>    - Tarfs
>>>>    - (maybe even more..)
>>>>
>>>> Honestly, I do think OSTree/Composefs is the best approach for now for
>>>> deduplication and page cache sharing (due to kernel limitation of page
>>>> cache sharing and overlayfs copyup limitation).  I'm too tired of
>>>> container image stuffs honestly.  Too much unnecessary manpower waste.
>>> for a file-based storage model, I am not sure a new format would
>>> really
>>> buy us much or it can be significantly different.
>>> Without a proper support from the kernel, a new format would still
>>> need
>>> to create the layout overlay expects, so it won't be much different than
>>> what we have now.
>>
>> I've seen lot efforts on this, for example,
>> https://docs.google.com/presentation/d/1lBKVrYzm9JEYuw-gIEsrcePSK0jL1Boe/edit#slide=id.p22
>>
>> Merging the writable layer and read-only layers with overlayfs is
>> feasible. I mean, at least for composefs model on backing XFS/btrfs, we
>> could merge these layers with overlayfs so that I guess reflink could
>> be done to avoid full copyup as well?  I do think that's a net win.
>>
>>> The current OCI format, with some tweaks like (e)stargz or
>>> zstd:chunked,
>>> already make its content addressable and a client can retrieve only the
>>> subset of the files that are needed.  At the same time we maintain the
>>> simplicity of a tarball and it won't break existing clients.
>>
>> (e)stargz or zstd:chunked still needs to be converted by the publisher
>> and not all exist OCI images are stored in this way.  But apart from
>> detailed comparsion, disk mapping image approaches seems really a
>> drawback at least on my side.
> 
> these images can be treated as if all their files are missing and the
> checksum is calculated on the receiver side.  They will still be stored
> locally indexed by their checksum.  We lose the possibility to pull only
> the missing files but we maintain the other advantages at runtime.  In
> this way moving to a new format can be done incrementally without
> breaking what we have now.

Yeah, that is on-demand loading stuffs (another story) but my
opinion was that I could see a win of composefs model is that
you could use EROFS + overlayfs + XFS/btrfs to do partial copyup
by using clone_file_range() to copy up within the same fs (since
all layers including the writable layer are actually landed
in the same fs so overlayfs will just clone_file_range()).

In principle, we could do some hack to do clone_file_range()
across different fses which are actually backed by the same
fs for other approaches, but that approach cannot be not
easily landed upstream TBH.

Thanks,
Gao Xiang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

