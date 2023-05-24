Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CFDC7EE3A
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998758;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OyLqBvelkH1q/OMvmBf1QT+xcQX2Ctr7ioybaJbn4+c=;
	b=Axrkdx2ZUbqc9CODjSpuDGScgN8hRW1yKr8EZS7p2z8AUYd9THQYe0joyza3CcVrqGSsFK
	qpLDEN516X1Yr5TL3gZbd/JCLUEstPrizBTpm/vuki1+D5dlLLG4NOC+ylStAeQhjEzfhH
	4NWJFbj1WsJ38pGTiwz3QMnThmXAU1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-VQ1m5cbgN7e6-2s4I52zNQ-1; Thu, 25 May 2023 03:12:35 -0400
X-MC-Unique: VQ1m5cbgN7e6-2s4I52zNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E248101B043;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E6FA40C6CDD;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DB3619465A4;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69FD119465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 10:48:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38838492B0C; Wed, 24 May 2023 10:48:13 +0000 (UTC)
Received: from localhost (unknown [10.39.192.9])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2564492B0A;
 Wed, 24 May 2023 10:48:12 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
 <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
 <fd4d0429-4da3-8217-6c13-14fd8a198920@linux.alibaba.com>
 <87r0r6ywri.fsf@redhat.com>
 <02524ece-956f-f5d8-fb21-adc4e5617dc6@linux.alibaba.com>
Date: Wed, 24 May 2023 12:48:11 +0200
In-Reply-To: <02524ece-956f-f5d8-fb21-adc4e5617dc6@linux.alibaba.com> (Gao
 Xiang's message of "Wed, 24 May 2023 16:26:25 +0800")
Message-ID: <87mt1uyphw.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: Du Rui <durui@linux.alibaba.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Alexander Larsson <alexl@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Gao Xiang <hsiangkao@linux.alibaba.com> writes:

> Hi Giuseppe,
>
> On 2023/5/24 01:11, Giuseppe Scrivano wrote:
>> Gao Xiang <hsiangkao@linux.alibaba.com> writes:
>> 
>
> ...
>
>>> Agreed, I hope you guys could actually sit down and evaluate a proper
>>> solution on the next OCI v2, currently I know there are:
>>>
>>>   - Composefs
>>>   - (e)stargz   https://github.com/containerd/stargz-snapshotter
>>>   - Nydus       https://github.com/containerd/nydus-snapshotter
>>>   - OverlayBD   https://github.com/containerd/accelerated-container-image
>>>   - SOCI        https://github.com/awslabs/soci-snapshotter
>>>   - Tarfs
>>>   - (maybe even more..)
>>>
>>> Honestly, I do think OSTree/Composefs is the best approach for now for
>>> deduplication and page cache sharing (due to kernel limitation of page
>>> cache sharing and overlayfs copyup limitation).  I'm too tired of
>>> container image stuffs honestly.  Too much unnecessary manpower waste.
>> for a file-based storage model, I am not sure a new format would
>> really
>> buy us much or it can be significantly different.
>> Without a proper support from the kernel, a new format would still
>> need
>> to create the layout overlay expects, so it won't be much different than
>> what we have now.
>
> I've seen lot efforts on this, for example,
> https://docs.google.com/presentation/d/1lBKVrYzm9JEYuw-gIEsrcePSK0jL1Boe/edit#slide=id.p22
>
> Merging the writable layer and read-only layers with overlayfs is
> feasible. I mean, at least for composefs model on backing XFS/btrfs, we
> could merge these layers with overlayfs so that I guess reflink could
> be done to avoid full copyup as well?  I do think that's a net win.
>
>> The current OCI format, with some tweaks like (e)stargz or
>> zstd:chunked,
>> already make its content addressable and a client can retrieve only the
>> subset of the files that are needed.  At the same time we maintain the
>> simplicity of a tarball and it won't break existing clients.
>
> (e)stargz or zstd:chunked still needs to be converted by the publisher
> and not all exist OCI images are stored in this way.  But apart from
> detailed comparsion, disk mapping image approaches seems really a
> drawback at least on my side.

these images can be treated as if all their files are missing and the
checksum is calculated on the receiver side.  They will still be stored
locally indexed by their checksum.  We lose the possibility to pull only
the missing files but we maintain the other advantages at runtime.  In
this way moving to a new format can be done incrementally without
breaking what we have now.

> Anyway, I think it's what OCIv2 would like to eventually address
> anyway.
>
>> IMO, the most interesting problem is how to store these images
>> locally
>> and how the kernel can help with that.
>
> I think composefs model can do both sides. But I'm not sure the final
> conclusion, I tend to leave it to the OCI guys.
>
>> The idea behind composefs is to replace the existing storage model
>> used
>> for overlay, where each layer has its own directory, with a single
>> directory where all the files are stored by their checksum.  The
>> expected layout then is recreated at runtime.
>
> Yes, what I'd like to say, without finer page cache sharing mechanism,
> the composefs way sounds better to me honestly to the whole system.
>
> Thanks,
> Gao Xiang
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

