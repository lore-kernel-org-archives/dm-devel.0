Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE12C7EE33
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 04:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685335921;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vOxGkbeGxd0js9BG6T95Qx+y8jyx/M9KLG3qLmLKuI8=;
	b=YtkdwQrlBoWJdrgrQUJnD0LLzDZAIavMR8kd4i3XWF8SyjRBHcLGpuJpS0f36RsESqsvyF
	DNAVriQYFblpOIe0qomf6jtXcKfhQa+lP3haSuj8ZNQw+p1lWVaqMtVInpJCBEmuNzeaXy
	3GDB8hpcvEAYixuMpDvm4BVLCsGzpZ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-sPhf6QHWOXizcgXKTaCxkQ-1; Mon, 29 May 2023 00:51:57 -0400
X-MC-Unique: sPhf6QHWOXizcgXKTaCxkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FE162A59565;
	Mon, 29 May 2023 04:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3469240C6CDA;
	Mon, 29 May 2023 04:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B61F419451C6;
	Mon, 29 May 2023 04:51:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB13A19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 16:44:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7D4E2166B2B; Fri, 26 May 2023 16:44:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF94E2166B2E
 for <dm-devel@redhat.com>; Fri, 26 May 2023 16:44:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E355101A55C
 for <dm-devel@redhat.com>; Fri, 26 May 2023 16:44:02 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com
 (out30-133.freemail.mail.aliyun.com [115.124.30.133]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-623-DvZdxG1SMPe3uuJ0NEl3jA-1; Fri, 26 May 2023 12:43:58 -0400
X-MC-Unique: DvZdxG1SMPe3uuJ0NEl3jA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjX7bdM_1685119431
Received: from 192.168.2.5(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VjX7bdM_1685119431) by smtp.aliyun-inc.com;
 Sat, 27 May 2023 00:43:53 +0800
Message-ID: <ac8519fd-85f4-e778-0c6c-b2e893a37628@linux.alibaba.com>
Date: Sat, 27 May 2023 00:43:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Du Rui <durui@linux.alibaba.com>, alexl@redhat.com
References: <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
 <20230526102633.31160-1-durui@linux.alibaba.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20230526102633.31160-1-durui@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Mon, 29 May 2023 04:51:50 +0000
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
Cc: gscrivan@redhat.com, dm-devel@redhat.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/5/26 03:26, Du Rui wrote:
> Hi Alexander,
> 
>> all the lvm volume changes and mounts during runtime caused
>> weird behaviour (especially at scale) that was painful to manage (just
>> search the docker issue tracker for devmapper backend). In the end
>> everyone moved to a filesystem based implementation (overlayfs based).
> 
> Yes, we had exactly the same experience. This is another reason why
> this proposal is for dm and lvm, not for container.
> (BTW, we are using TCMU and ublk for overlaybd in production. They are awesome.)
> 
> 
>> This solution doesn't even allow page cache sharing between shared
>> layers (like current containers do), much less between independent
>> layers.
> 
> Page cache sharing can be realized with DAX support of the dm targets
> (and the inner file system), together with virtual pmem device backend.

First, here I'd suggest you could learn some kernel knowledge of what
DAX is and what page cache is before you explain to a kernel mailing
list.  For example, DAX memory cannot be reclaimed at all.

Block drivers has nothing to do on filesystem page cache stuffs, also
currently your approach has nothing to do with pmem stuffs (If you must
mention "DAX" to proposal your "page cache sharing", please _here_
write down your detailed design first and explain how it could work to
ours if you really want to do.)

Apart from unable to share page cache among filesystems, even with
your approach all I/Os are duplicated among your qcow2-like layers.

For example, there are 3 qcow2-like layers: A, B, C:

filesystem 1:  A + B
filesystem 2:  A + B + C

Filesystem 1 and 2 are runtimely independent filesystems and your block
driver can do nothing help: both duplicated I/Os and page cache for any
data and metadata of layer A, B.

If those container layers are even more (dozens or hundreds), your
approach is more inefficient on duplicated I/Os.

You could implement some internal block cache, but block level cache is
not flexible compared with page cache on kernel memory reclaim and page
migration.

> 
>> Erofs already has some block-level support for container images
> 
> It is interesting. Erofs runs insider a block device in the first place,
> like what many file systems do. But do you konw why it implements another
> "some block-level support" by itself?
> 

That is funny honestly.  As for container image use cases, although OCI
image tgz is unseekable but actually ext4 and btrfs images are seekable
and on-demand load could be done with these raw images directly. In
principle, you could dump your container image stuffs from tgz to raw
ext4, btrfs, erofs, whatever.  Or if you like, you could dump to some
"qcow2", "vhdx", "vmdx" wildly-used format, their ecosystem is more
mature but all the above don't help on page cache sharing stuffs.

Please don't say "I like erofs" and at the same time "why it implements
another some block-level support" by itself".  Local filesystems must
do their block-mapping theirselves: ext4 (extents or blockmap), XFS
(extents), etc.

I've explained internally to your team multiple times as a kernel
developer, personally I don't want to repeat here again and again to
your guys.

Thanks,
Gao Xiang

>> And this new approach doesn't help
> No. It is intended for dm and lvm.> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

