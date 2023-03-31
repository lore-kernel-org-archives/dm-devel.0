Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79C3AC76196
	for <dm-devel@archiver.kernel.org>; Mon,  3 Apr 2023 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680504269;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Drn8i3oEIjhr30ZVib2zk+BdTIpZOfq62NrM1R3PgWE=;
	b=fJXNPXyqpcDCa/wlXc1tLUoZIOnTbAJ3331GfhpqCfP4s9ES+HmQyFbwMPcM3zJZIkSBDu
	FN+OJnPfsb6M7hQQhg+sI/304AdNfuVd4gB9TF+MB81F2e+QABGJtoSBJiC2qBlZdwzCtV
	AkwumQ9GbwW6UvX5ND/K/m05ts72HcU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-4aOvvPpcOBWKxzjfWOFHng-1; Mon, 03 Apr 2023 02:44:26 -0400
X-MC-Unique: 4aOvvPpcOBWKxzjfWOFHng-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD4138030D0;
	Mon,  3 Apr 2023 06:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 991D2483EC1;
	Mon,  3 Apr 2023 06:44:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A85F19465A3;
	Mon,  3 Apr 2023 06:44:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D0A6E19465BC
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 17:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B257B2027042; Fri, 31 Mar 2023 17:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AAFE62027040
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 17:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 893DC3C00088
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 17:54:31 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-hLslg4RSO3y_qZQY_56vwA-1; Fri, 31 Mar 2023 13:54:28 -0400
X-MC-Unique: hLslg4RSO3y_qZQY_56vwA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id F19A3B83137;
 Fri, 31 Mar 2023 17:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A440C433A4;
 Fri, 31 Mar 2023 17:48:09 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id h11so22953688lfu.8;
 Fri, 31 Mar 2023 10:48:09 -0700 (PDT)
X-Gm-Message-State: AAQBX9fOrfgmltab3YBzl8Ops+I2K6xku59PU16aBIFYwEgvaMu0ZOAK
 vPh0x+4e0qnexacPEgsD17gmcc33GqLX91oy00c=
X-Google-Smtp-Source: AKy350aGmAaw8YhQDsMHFPqOZHOf0YFrm6+Qrmu1o39ibtrUhRAoJ2hJNrBTR72DBPR1w52lhQ7Kxsz8Es6oFrG/it4=
X-Received: by 2002:ac2:5d72:0:b0:4ea:e296:fead with SMTP id
 h18-20020ac25d72000000b004eae296feadmr8226352lft.3.1680284887179; Fri, 31 Mar
 2023 10:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <29a2488aa641319199c597d1dc1151c700e32430.1680172791.git.johannes.thumshirn@wdc.com>
In-Reply-To: <29a2488aa641319199c597d1dc1151c700e32430.1680172791.git.johannes.thumshirn@wdc.com>
From: Song Liu <song@kernel.org>
Date: Fri, 31 Mar 2023 10:47:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7HoY_0fW12egZuirTX22LTQJvBw49MEaT5_sh4ty+xCw@mail.gmail.com>
Message-ID: <CAPhsuW7HoY_0fW12egZuirTX22LTQJvBw49MEaT5_sh4ty+xCw@mail.gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 03 Apr 2023 06:44:20 +0000
Subject: Re: [dm-devel] [PATCH v2 07/19] md: raid5: use __bio_add_page to
 add single page to new bio
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMzAsIDIwMjMgYXQgMzo0NOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+Cj4gVGhlIHJhaWQ1LXBwbCBzdWJtaXNz
aW9uIGNvZGUgdXNlcyBiaW9fYWRkX3BhZ2UoKSB0byBhZGQgYSBwYWdlIHRvIGEKPiBuZXdseSBj
cmVhdGVkIGJpby4gYmlvX2FkZF9wYWdlKCkgY2FuIGZhaWwsIGJ1dCB0aGUgcmV0dXJuIHZhbHVl
IGlzIG5ldmVyCj4gY2hlY2tlZC4gRm9yIGFkZGluZyBjb25zZWN1dGl2ZSBwYWdlcywgdGhlIHJl
dHVybiBpcyBhY3R1YWxseSBjaGVja2VkIGFuZAo+IGEgbmV3IGJpbyBpcyBhbGxvY2F0ZWQgaWYg
YWRkaW5nIHRoZSBwYWdlIGZhaWxzLgo+Cj4gVXNlIF9fYmlvX2FkZF9wYWdlKCkgYXMgYWRkaW5n
IGEgc2luZ2xlIHBhZ2UgdG8gYSBuZXdseSBjcmVhdGVkIGJpbyBpcwo+IGd1YXJhbnRlZWQgdG8g
c3VjY2VlZC4KPgo+IFRoaXMgYnJpbmdzIHVzIGEgc3RlcCBjbG9zZXIgdG8gbWFya2luZyBiaW9f
YWRkX3BhZ2UoKSBhcyBfX211c3RfY2hlY2suCj4KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBU
aHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGlybkB3ZGMuY29tPgo+IFJldmlld2VkLWJ5OiBEYW1p
ZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+CgpBY2tlZC1ieTog
U29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

