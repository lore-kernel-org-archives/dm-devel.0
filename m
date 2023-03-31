Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2DEC761A6
	for <dm-devel@archiver.kernel.org>; Mon,  3 Apr 2023 06:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680504267;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x8FMdxodk0bojL6VGS+Pyh1sva+/pn9dZixNhlD3A5M=;
	b=WSeYBDOjV3/6FrOjMLCHnm5HuNpRPn8uI0S8zn8vEdr18z19OsGYlnrGlUbXSRid9ZFpeb
	qwC8k0csco7LNp06i4/tazh0LUWcf9g2Dns0R8XWUWc4EEYS4uL0s4RxDdo9t/Y24osV8d
	9pyxcNkGrsmV5z+HZoM3wcgdpHrbsDQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-NaFzs0hIP8aeGe480TFntg-1; Mon, 03 Apr 2023 02:44:26 -0400
X-MC-Unique: NaFzs0hIP8aeGe480TFntg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD5A0100DEB3;
	Mon,  3 Apr 2023 06:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6CD62166B29;
	Mon,  3 Apr 2023 06:44:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 951F41946A61;
	Mon,  3 Apr 2023 06:44:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CEA819465BC
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 18:00:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 505EF492B02; Fri, 31 Mar 2023 18:00:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 492B5492B00
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 18:00:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DDE480280D
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 18:00:18 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-WG6TfqBdNXWkkTl2yMjUSw-1; Fri, 31 Mar 2023 14:00:13 -0400
X-MC-Unique: WG6TfqBdNXWkkTl2yMjUSw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC1162B1C;
 Fri, 31 Mar 2023 18:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3283FC433A0;
 Fri, 31 Mar 2023 18:00:11 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id by14so4745549ljb.12;
 Fri, 31 Mar 2023 11:00:11 -0700 (PDT)
X-Gm-Message-State: AAQBX9ed7IGL4n7rTElWrSv38z3vGB8Fhzl7/DjQYS4BJle3ZopAVDSi
 2zk+/8MBf9rf0SvbUhoKWWNluNadOvWn9HLodXg=
X-Google-Smtp-Source: AKy350ZgbNojOjOEEz2nHphY2xJCW9wwsXYrrgwE3PRrjnKQvmDG5MKMnwlOL72DBVmaW0fPmBMmrb5gTNKFPGLQqzY=
X-Received: by 2002:a2e:a556:0:b0:29b:d43f:f68f with SMTP id
 e22-20020a2ea556000000b0029bd43ff68fmr5465915ljn.5.1680285609272; Fri, 31 Mar
 2023 11:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <4c9eaedd34f80d3477a5049f49610a8da8859744.1680172791.git.johannes.thumshirn@wdc.com>
In-Reply-To: <4c9eaedd34f80d3477a5049f49610a8da8859744.1680172791.git.johannes.thumshirn@wdc.com>
From: Song Liu <song@kernel.org>
Date: Fri, 31 Mar 2023 10:59:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7AAKXuPtvfjR-UBq=QCbHOkqCQQk=GTAWZH0ysVxhECQ@mail.gmail.com>
Message-ID: <CAPhsuW7AAKXuPtvfjR-UBq=QCbHOkqCQQk=GTAWZH0ysVxhECQ@mail.gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Mon, 03 Apr 2023 06:44:20 +0000
Subject: Re: [dm-devel] [PATCH v2 16/19] md: raid1: use __bio_add_page for
 adding single page to bio
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Dave Kleikamp <shaggy@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMzAsIDIwMjMgYXQgMzo0NOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+Cj4gVGhlIHN5bmMgcmVxdWVzdCBjb2Rl
IHVzZXMgYmlvX2FkZF9wYWdlKCkgdG8gYWRkIGEgcGFnZSB0byBhIG5ld2x5IGNyZWF0ZWQgYmlv
Lgo+IGJpb19hZGRfcGFnZSgpIGNhbiBmYWlsLCBidXQgdGhlIHJldHVybiB2YWx1ZSBpcyBuZXZl
ciBjaGVja2VkLgo+Cj4gVXNlIF9fYmlvX2FkZF9wYWdlKCkgYXMgYWRkaW5nIGEgc2luZ2xlIHBh
Z2UgdG8gYSBuZXdseSBjcmVhdGVkIGJpbyBpcwo+IGd1YXJhbnRlZWQgdG8gc3VjY2VlZC4KPgo+
IFRoaXMgYnJpbmdzIHVzIGEgc3RlcCBjbG9zZXIgdG8gbWFya2luZyBiaW9fYWRkX3BhZ2UoKSBh
cyBfX211c3RfY2hlY2suCj4KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpv
aGFubmVzLnRodW1zaGlybkB3ZGMuY29tPgo+IFJldmlld2VkLWJ5OiBEYW1pZW4gTGUgTW9hbCA8
ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+CgpBY2tlZC1ieTogU29uZyBMaXUgPHNv
bmdAa2VybmVsLm9yZz4KClRoYW5rcyEKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

