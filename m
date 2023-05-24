Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F12CC7EE33
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998755;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=asHYKBrQd3/PlMTQDA3I+sSa0k+rJEbSgYr4ekMXk+8=;
	b=hcGjUoqihp2w87vgJzoNZfa2zZF2XREqlOH04E5PuGYT0jrjAFG+x1J6xJPgzEgAG8OYBZ
	EzaYAO3R3TkJxJUDskB4FIy/UMF8Hgb+cDK0TUMN8ukqNVkZRv8jhfg24SkJ39BzWOk/5h
	+/m04FQX7bfHLPKBsROOhKM+/LZys2E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-75G3AqKfOPuublP4hjInoQ-1; Thu, 25 May 2023 03:12:32 -0400
X-MC-Unique: 75G3AqKfOPuublP4hjInoQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C272C3C01C26;
	Thu, 25 May 2023 07:12:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71DE5492B0C;
	Thu, 25 May 2023 07:12:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8946019452C7;
	Thu, 25 May 2023 07:12:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1CF919465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 08:26:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2B16492B00; Wed, 24 May 2023 08:26:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA9E5482060
 for <dm-devel@redhat.com>; Wed, 24 May 2023 08:26:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB93101B05D
 for <dm-devel@redhat.com>; Wed, 24 May 2023 08:26:35 +0000 (UTC)
Received: from out30-112.freemail.mail.aliyun.com
 (out30-112.freemail.mail.aliyun.com [115.124.30.112]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-592-Sytu7vF3MF-lSTyUA9CezA-1; Wed, 24 May 2023 04:26:31 -0400
X-MC-Unique: Sytu7vF3MF-lSTyUA9CezA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R741e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjNOvI8_1684916785
Received: from 30.97.48.247(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VjNOvI8_1684916785) by smtp.aliyun-inc.com;
 Wed, 24 May 2023 16:26:27 +0800
Message-ID: <02524ece-956f-f5d8-fb21-adc4e5617dc6@linux.alibaba.com>
Date: Wed, 24 May 2023 16:26:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Giuseppe Scrivano <gscrivan@redhat.com>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
 <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
 <fd4d0429-4da3-8217-6c13-14fd8a198920@linux.alibaba.com>
 <87r0r6ywri.fsf@redhat.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <87r0r6ywri.fsf@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Giuseppe,

On 2023/5/24 01:11, Giuseppe Scrivano wrote:
> Gao Xiang <hsiangkao@linux.alibaba.com> writes:
> 

...

>> Agreed, I hope you guys could actually sit down and evaluate a proper
>> solution on the next OCI v2, currently I know there are:
>>
>>   - Composefs
>>   - (e)stargz   https://github.com/containerd/stargz-snapshotter
>>   - Nydus       https://github.com/containerd/nydus-snapshotter
>>   - OverlayBD   https://github.com/containerd/accelerated-container-image
>>   - SOCI        https://github.com/awslabs/soci-snapshotter
>>   - Tarfs
>>   - (maybe even more..)
>>
>> Honestly, I do think OSTree/Composefs is the best approach for now for
>> deduplication and page cache sharing (due to kernel limitation of page
>> cache sharing and overlayfs copyup limitation).  I'm too tired of
>> container image stuffs honestly.  Too much unnecessary manpower waste.
> 
> for a file-based storage model, I am not sure a new format would really
> buy us much or it can be significantly different.
> 
> Without a proper support from the kernel, a new format would still need
> to create the layout overlay expects, so it won't be much different than
> what we have now.

I've seen lot efforts on this, for example,
https://docs.google.com/presentation/d/1lBKVrYzm9JEYuw-gIEsrcePSK0jL1Boe/edit#slide=id.p22

Merging the writable layer and read-only layers with overlayfs is
feasible. I mean, at least for composefs model on backing XFS/btrfs, we
could merge these layers with overlayfs so that I guess reflink could
be done to avoid full copyup as well?  I do think that's a net win.

> 
> The current OCI format, with some tweaks like (e)stargz or zstd:chunked,
> already make its content addressable and a client can retrieve only the
> subset of the files that are needed.  At the same time we maintain the
> simplicity of a tarball and it won't break existing clients.

(e)stargz or zstd:chunked still needs to be converted by the publisher
and not all exist OCI images are stored in this way.  But apart from
detailed comparsion, disk mapping image approaches seems really a
drawback at least on my side.

Anyway, I think it's what OCIv2 would like to eventually address
anyway.

> 
> IMO, the most interesting problem is how to store these images locally
> and how the kernel can help with that.

I think composefs model can do both sides. But I'm not sure the final
conclusion, I tend to leave it to the OCI guys.

> 
> The idea behind composefs is to replace the existing storage model used
> for overlay, where each layer has its own directory, with a single
> directory where all the files are stored by their checksum.  The
> expected layout then is recreated at runtime.

Yes, what I'd like to say, without finer page cache sharing mechanism,
the composefs way sounds better to me honestly to the whole system.

Thanks,
Gao Xiang

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

