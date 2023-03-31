Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB85FC77B6D
	for <dm-devel@archiver.kernel.org>; Mon,  3 Apr 2023 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680504270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mbJ+MH3xSEmQNd1tU34riraRlxw7M4IHdjIIvVlnzeg=;
	b=geVt4eoAIAW48kqZhuUyeZSxFIGox4mweXXaFoIkgFCdauaV2FjV8ztf3Y+qeYu5Csg/Ou
	MRlu0Tt1Lr2Ez+m1JsSYHDhaKTgf8dF+WUymgqhNT8QvB9/2wyvyO4L2i12RP9L1R8L8S0
	cDfSjCrcvrri+6Z0zxcUfnGgLjcudTA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-kxJMKtA9O06QSjgBwklDiQ-1; Mon, 03 Apr 2023 02:44:26 -0400
X-MC-Unique: kxJMKtA9O06QSjgBwklDiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEA0F8030CD;
	Mon,  3 Apr 2023 06:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 514CAC15BA0;
	Mon,  3 Apr 2023 06:44:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E7FAB19472CD;
	Mon,  3 Apr 2023 06:44:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 466DC19465BC
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 17:55:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E71BA492B00; Fri, 31 Mar 2023 17:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF0E492B02
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 17:55:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C560D855304
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 17:55:48 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-SmQREoIZO3KaTe8HILkftw-1; Fri, 31 Mar 2023 13:55:46 -0400
X-MC-Unique: SmQREoIZO3KaTe8HILkftw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 7412DCE3081;
 Fri, 31 Mar 2023 17:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFA1C433A1;
 Fri, 31 Mar 2023 17:47:53 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id y20so29960497lfj.2;
 Fri, 31 Mar 2023 10:47:53 -0700 (PDT)
X-Gm-Message-State: AAQBX9e+zKPOs+r3LiO0QKbLonckLQYClTelJ5PU8iUAOYbo20WYNwaN
 DYk+bgFAGmr1qpALhzTkrg/+aNYErflzrW9frrc=
X-Google-Smtp-Source: AKy350aTqP2YrCOlXYcmu46Ms0g6qdRMyCTAq79Tt/w62oXAGnJ0At25MIChWLEF5VS5bhZp5mINAfnbMMsd5bIOwyY=
X-Received: by 2002:a05:6512:102b:b0:4ea:f9d4:9393 with SMTP id
 r11-20020a056512102b00b004eaf9d49393mr8226521lfr.3.1680284871209; Fri, 31 Mar
 2023 10:47:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <d406d7e205f7c7e701275674f77c7e21b93ae7a5.1680172791.git.johannes.thumshirn@wdc.com>
In-Reply-To: <d406d7e205f7c7e701275674f77c7e21b93ae7a5.1680172791.git.johannes.thumshirn@wdc.com>
From: Song Liu <song@kernel.org>
Date: Fri, 31 Mar 2023 10:47:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6WUKpMawtw-RE_PsfTcPCtUeTEF5YOEwmVNT+wM7OofQ@mail.gmail.com>
Message-ID: <CAPhsuW6WUKpMawtw-RE_PsfTcPCtUeTEF5YOEwmVNT+wM7OofQ@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH v2 06/19] md: raid5-log: use __bio_add_page
 to add single page
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBNYXIgMzAsIDIwMjMgYXQgMzo0NOKAr0FNIEpvaGFubmVzIFRodW1zaGlybgo8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+Cj4gVGhlIHJhaWQ1IGxvZyBtZXRhZGF0
YSBzdWJtaXNzaW9uIGNvZGUgdXNlcyBiaW9fYWRkX3BhZ2UoKSB0byBhZGQgYSBwYWdlCj4gdG8g
YSBuZXdseSBjcmVhdGVkIGJpby4gYmlvX2FkZF9wYWdlKCkgY2FuIGZhaWwsIGJ1dCB0aGUgcmV0
dXJuIHZhbHVlIGlzCj4gbmV2ZXIgY2hlY2tlZC4KPgo+IFVzZSBfX2Jpb19hZGRfcGFnZSgpIGFz
IGFkZGluZyBhIHNpbmdsZSBwYWdlIHRvIGEgbmV3bHkgY3JlYXRlZCBiaW8gaXMKPiBndWFyYW50
ZWVkIHRvIHN1Y2NlZWQuCj4KPiBUaGlzIGJyaW5ncyB1cyBhIHN0ZXAgY2xvc2VyIHRvIG1hcmtp
bmcgYmlvX2FkZF9wYWdlKCkgYXMgX19tdXN0X2NoZWNrLgo+Cj4gU2lnbmVkLW9mZi1ieTogSm9o
YW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNvbT4KPiBSZXZpZXdlZC1i
eTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxAb3BlbnNvdXJjZS53ZGMuY29tPgoKQWNr
ZWQtYnk6IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

