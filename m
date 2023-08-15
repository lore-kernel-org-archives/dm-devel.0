Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E98C0015E
	for <dm-devel@archiver.kernel.org>; Tue, 15 Aug 2023 07:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692085878;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4sD5/lnwj10l0w00RzWaOYbnJrSKqOQO3R4HW7yMSyE=;
	b=NFE+2kdxPnCE7vpxMMzNx2d/9hrF/wDv/jjYDvk31HuS9gEAaxvixs6s4mPxqpAIGs78gC
	tdOy7ak4FZ+fgQPuQWJ9uEO720RLAuQ4RarKpXjUTqFOegper/NNuaeM3hOsjIwlKIscAm
	eSkeLBb9WYdJVUI8Wi3bUh8ubD0SeTA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-h1Bj7H98OMOPaPwqI4ahWQ-1; Tue, 15 Aug 2023 03:51:15 -0400
X-MC-Unique: h1Bj7H98OMOPaPwqI4ahWQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29BBD3C0E440;
	Tue, 15 Aug 2023 07:51:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10862492C13;
	Tue, 15 Aug 2023 07:51:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC6D3194658D;
	Tue, 15 Aug 2023 07:51:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4B2C1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Aug 2023 07:50:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FA2CC15BAE; Tue, 15 Aug 2023 07:50:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67C4DC15BAD
 for <dm-devel@redhat.com>; Tue, 15 Aug 2023 07:50:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48FF9800CA6
 for <dm-devel@redhat.com>; Tue, 15 Aug 2023 07:50:27 +0000 (UTC)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com
 [209.85.219.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-8Bs9iiSNNw-t5_HhPew-HQ-1; Tue, 15 Aug 2023 03:50:25 -0400
X-MC-Unique: 8Bs9iiSNNw-t5_HhPew-HQ-1
Received: by mail-yb1-f180.google.com with SMTP id
 3f1490d57ef6-d686e41823cso1811526276.3; 
 Tue, 15 Aug 2023 00:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692085824; x=1692690624;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=FA7UNvLh/NtwE8oB7thsQ+ZgxpcPVqBILp5Db1EACXc=;
 b=LpeQ1mLVJ86RyGxRLiR5nU015YYLEgKaE5mfFracpCIsXOI6mBHREY9gG1bXFQ4Wsw
 vDBi6m1Mw4OZJ7wF1mXpCBNFhjLWCYZ/qDTNKQM1aSal6FPZ+vpQ5/e+tKgqu7uj9rNc
 Ziws+XDOz1UDwa6g4rcTozDUkj6cuWOWhp8jvdBvHG4abm97KD7OHFBujyDvg9VPnkux
 v67KVEKz6bmOs4jr7khnAXHo3+rmEb3UUE/z/i5FoKGH3g678iiEQeUXkWynRbVeEbRZ
 +rVmFRaMhXqXOdgZcN8K4xuybMluIt3ZXNECb8pgPxyhkjIBDEmBQjmndsV2hoEber+4
 w+ag==
X-Gm-Message-State: AOJu0YyxFfi1uLb2Gabd+mPwpws4Qgl/3mBrARI5VBeqcF+3JNovkgvZ
 TkwvzTQK+TefWRTyN40+mNNXC3i9uBCd+q908B4=
X-Google-Smtp-Source: AGHT+IHaiDSMY+QkhVwb3BPgUZZO+nmIvLSHf5aXIVOauSuFeN6IaJFsD4dH94ZZRJntrGxxCFrmO4AX2M6byBZ62ig=
X-Received: by 2002:a25:bf86:0:b0:c83:27d4:c0d6 with SMTP id
 l6-20020a25bf86000000b00c8327d4c0d6mr9479331ybk.37.1692085824032; Tue, 15 Aug
 2023 00:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105648epcas5p3ae8b8f6ed341e2aa253e8b4de8920a4d@epcas5p3.samsung.com>
 <20230811105300.15889-3-nj.shetty@samsung.com>
 <3b1da341-1c7f-e28f-d6aa-cecb83188f34@acm.org>
 <20230814121853.ms4acxwr56etf3ph@green245>
 <abad92af-d8b2-0488-cc75-01a3f4e8e270@acm.org>
In-Reply-To: <abad92af-d8b2-0488-cc75-01a3f4e8e270@acm.org>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Tue, 15 Aug 2023 13:20:12 +0530
Message-ID: <CAOSviJ1XL1UyMk2Ur37cJpW5BJAE5Ts6J4BtTSRd2_h_NPtGCQ@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v14 02/11] Add infrastructure for copy
 offload in block and request layer.
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
Cc: linux-doc@vger.kernel.org, linux-nvme@lists.infradead.org,
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 Nitesh Shetty <nj.shetty@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

V2UgaGFkIGtlcHQgdGhpcyBhcyBhIHBhcnQgb2YgYmxrLXR5cGVzLmggYmVjYXVzZSB3ZSBzYXcg
c29tZSBvdGhlciBmdW5jdGlvbnMKdHJ5aW5nIHRvIGRvIHNpbWlsYXIgdGhpbmdzIGluc2lkZSB0
aGlzIGZpbGUgKG9wX2lzX3dyaXRlL2ZsdXNoL2Rpc2NhcmQpLgpCdXQgaXQgc2hvdWxkIGJlIG9r
YXkgZm9yIHVzIHRvIG1vdmUgaXQgdG8gYmxrLW1xLmggaWYgdGhhdOKAmXMgdGhlIHJpZ2h0IHdh
eS4KClRoYW5rIHlvdSwKTml0ZXNoIFNoZXR0eQoKCk9uIE1vbiwgQXVnIDE0LCAyMDIzIGF0IDg6
MjjigK9QTSBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4gd3JvdGU6Cj4KPiBP
biA4LzE0LzIzIDA1OjE4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+ID4gT24gMjMvMDgvMTEgMDI6
MjVQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+ID4+IE9uIDgvMTEvMjMgMDM6NTIsIE5pdGVz
aCBTaGV0dHkgd3JvdGU6Cj4gPj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBl
cy5oIGIvaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaAo+ID4+PiBpbmRleCAwYmFkNjJjY2EzZDAu
LmRlMGFkN2EwZDU3MSAxMDA2NDQKPiA+Pj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBvcF9pc19jb3B5
KGJsa19vcGZfdCBvcCkKPiA+Pj4gK3sKPiA+Pj4gKyAgICByZXR1cm4gKChvcCAmIFJFUV9PUF9N
QVNLKSA9PSBSRVFfT1BfQ09QWV9TUkMgfHwKPiA+Pj4gKyAgICAgICAgKG9wICYgUkVRX09QX01B
U0spID09IFJFUV9PUF9DT1BZX0RTVCk7Cj4gPj4+ICt9Cj4gPj4+ICsKPiA+Pgo+ID4+IFRoZSBh
Ym92ZSBmdW5jdGlvbiBzaG91bGQgYmUgbW92ZWQgaW50byBpbmNsdWRlL2xpbnV4L2Jsay1tcS5o
IGJlbG93IHRoZQo+ID4+IGRlZmluaXRpb24gb2YgcmVxX29wKCkgc3VjaCB0aGF0IGl0IGNhbiB1
c2UgcmVxX29wKCkgaW5zdGVhZCBvZgo+ID4+IG9wZW4tY29kaW5nIGl0Lgo+ID4+Cj4gPiBXZSB1
c2UgdGhpcyBsYXRlciBmb3IgZG0gcGF0Y2hlcyhwYXRjaCA5KSBhcyB3ZWxsLCBhbmQgd2UgZG9u
J3QgaGF2ZQo+ID4gcmVxdWVzdCBhdAo+ID4gdGhhdCB0aW1lLgo+Cj4gTXkgdW5kZXJzdGFuZGlu
ZyBpcyB0aGF0IGluY2x1ZGUvbGludXgvYmxrX3R5cGVzLmggc2hvdWxkIG9ubHkgY29udGFpbgo+
IGRhdGEgdHlwZXMgYW5kIGNvbnN0YW50cyBhbmQgaGVuY2UgdGhhdCBpbmxpbmUgZnVuY3Rpb25z
IGxpa2UKPiBvcF9pc19jb3B5KCkgc2hvdWxkIGJlIG1vdmVkIGVsc2V3aGVyZS4KPgo+IEJhcnQu
Cj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

