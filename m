Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327F6C001B0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692032319;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YWsHmFB2MZdHu0aoSj5jVm5Hd6Qg+ppaz3nxy5u2nCg=;
	b=JHxL9UjoYYS0bLd1O3aEiGLAr3DsGzu6tOloOe47RTQub/MOS8XbvV4FFsiUSBH7w/1VIH
	h+8UNuRT7wRCAQ1VScRNLcjLIgbTBVcI7nOMxqa3T9QWFl0goA0x5x8D+bisuEy9DiaTLK
	GLnwc30Z+E1xoiti50eBDO34ZVdxHQc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-aZqt9c3fPKakWg7ZEWLJow-1; Mon, 14 Aug 2023 12:58:35 -0400
X-MC-Unique: aZqt9c3fPKakWg7ZEWLJow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B123B1C07580;
	Mon, 14 Aug 2023 16:58:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D40DC15BAD;
	Mon, 14 Aug 2023 16:58:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 37D8D1946587;
	Mon, 14 Aug 2023 16:58:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E0CB1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 16:58:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68AA5C15BAE; Mon, 14 Aug 2023 16:58:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60C7EC15BAD
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 16:58:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4551E8015AB
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 16:58:32 +0000 (UTC)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-jSpgpHJZM3G8zgrMkiLI9Q-1; Mon, 14 Aug 2023 12:58:30 -0400
X-MC-Unique: jSpgpHJZM3G8zgrMkiLI9Q-1
Received: by mail-ot1-f47.google.com with SMTP id
 46e09a7af769-6bd0425ad4fso3881203a34.2; 
 Mon, 14 Aug 2023 09:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692032309; x=1692637109;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=3UJyFzkhfPV1LXyzB0ge0qlS62RRiQrpMwsiRYTQDRI=;
 b=Xpx3ZbO6yWnnwr//6jdPRg79JYM1T4+VTJhupDxcT/U88ynG25jlM5W15EAxdrEpCt
 TJs85YuXWHOY6XsaSDptywQxUh99WAdOaVWPejuEELBZssohsVVfVWLlN2+JAP282bPt
 0o774DrUPrmqWOSOeazIEMupw8kJuC7IRdoxiAEuRGOCfFnG/bBTa5EFJA09ayGD6LvB
 qFyzm3/atcoWZwNcS+4o3VSRMTfCSzwHAeM0f2R2oEbLMJdDmYMFYVRBZ9IjJJW7Dic2
 oA+urY5tclUgfbdidUHakeNQwbRGIM+yBtadCHBHTpeKgyqMTSrHFII9FX1l5ZfOTnyB
 sZuw==
X-Gm-Message-State: AOJu0YwgmFEwh2RFxuQo6Hfxn3BMp1bZuQ2VniZvtjl8mBlukzOz0tuW
 81vHN1zUSmoVO7M8tdNVGuAz6c9KBScf4Hc4NAM=
X-Google-Smtp-Source: AGHT+IE9LDZ83v2hgug7emDF5KyYh5EtftbM06X5OK/zdRBDKO/Jg4fRYrCeL75t5wx91fwlfKtCCIuFBCXTW1QrU9s=
X-Received: by 2002:a05:6830:4dc:b0:6b9:bd9d:e333 with SMTP id
 s28-20020a05683004dc00b006b9bd9de333mr10451524otd.3.1692032309587; Mon, 14
 Aug 2023 09:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105713epcas5p3b5323a0c553006e60671dde6c72fc4c6@epcas5p3.samsung.com>
 <20230811105300.15889-5-nj.shetty@samsung.com>
 <57558d7b-4444-b709-60bf-5a061cd6c3e9@acm.org>
In-Reply-To: <57558d7b-4444-b709-60bf-5a061cd6c3e9@acm.org>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Mon, 14 Aug 2023 22:28:18 +0530
Message-ID: <CAOSviJ13RJd4gTL2dzXrijXLaPUCB-pGG6x+_8ouW=7REO6e7g@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v14 04/11] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, linux-doc@vger.kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dlemoal@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCBBdWcgMTIsIDIwMjMgYXQgNDoyNeKAr0FNIEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFz
c2NoZUBhY20ub3JnPiB3cm90ZToKPgo+IE9uIDgvMTEvMjMgMDM6NTIsIE5pdGVzaCBTaGV0dHkg
d3JvdGU6Cj4gPiArICAgICBzY2hlZHVsZV93b3JrKCZlbXVsYXRpb25faW8tPmVtdWxhdGlvbl93
b3JrKTsKPgo+IHNjaGVkdWxlX3dvcmsoKSB1c2VzIHN5c3RlbV93cS4gVGhpcyB3b24ndCB3b3Jr
IGZvciBhbGwgdXNlcnMgc2luY2UKPiB0aGVyZSBhcmUgbm8gbGF0ZW5jeSBndWFyYW50ZWVzIGZv
ciBzeXN0ZW1fd3EuCj4KQXQgcHJlc2VudCBjb3B5IGlzIHRyZWF0ZWQgYXMgYmFja2dyb3VuZCBv
cGVyYXRpb24sIHNvIHdlbnQgYWhlYWQKd2l0aCB0aGUgY3VycmVudCBhcHByb2FjaC4KClRoYW5r
IHlvdSwKTml0ZXNoIFNoZXR0eQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

