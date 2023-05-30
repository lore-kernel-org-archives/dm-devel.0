Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABE7C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685460509;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EVTMqAR8GVNG8UD7pHuoDESb+KwZS7Jz9OJPhUJIlts=;
	b=E1s77vyV/jBO/hfdEstPkJcrmqiDesvBfYNFIOADluSQBBKNg9J36F0vEU8Mir0/q4zSEF
	T6s2Pi1uTt3o4RqIrt30nWbUxslWwYUut8hHvPC2pWmlqXgeLV0MsOck+l4LapC7bDNs8m
	6eInPqpAw0DOgitoT/CM4hQuKW0xqeY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-gvf_v0COMNuj-cO0uAcu3A-1; Tue, 30 May 2023 11:28:25 -0400
X-MC-Unique: gvf_v0COMNuj-cO0uAcu3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CC3585A5BB;
	Tue, 30 May 2023 15:28:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA5B02166B25;
	Tue, 30 May 2023 15:28:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C1A6219465A0;
	Tue, 30 May 2023 15:28:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3D6B1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 15:28:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 441AE492B0A; Tue, 30 May 2023 15:28:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C301492B0B
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:28:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF9CF811E92
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:28:08 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-SLIJqfZAO5W5M55mFmr_wg-1; Tue, 30 May 2023 11:28:02 -0400
X-MC-Unique: SLIJqfZAO5W5M55mFmr_wg-1
Received: by mail-qv1-f53.google.com with SMTP id
 6a1803df08f44-62614f2eee1so15888266d6.0
 for <dm-devel@redhat.com>; Tue, 30 May 2023 08:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685460482; x=1688052482;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=YR3Dr4CMzNNzM1c3LGHePU3pSGMOwf2n9BmkTIJqoZY=;
 b=T63aamuK01+yBTl3WFXN4dTXrwXJrywZNlYAhq7OhoPPrmQH52wtD17qL5DVXknc/0
 +hw5S6u/uZU0cPIM8eWkl/U0K7MCFMyV1+gO01uUM2/H+ayuXKq12BGubnCVE41VWbIT
 qMOid4lFtEqr/Xk9wUA3QbVupajCcmG0/ptcOBJ77z8MpjjH196QL/JaXLsJKSm8CjPx
 zgv9Kqnt4jc2LOn2NMr7x7uZ+DSH+bqprP6FHp9w9r2CTyqYTh0yqz9CqAou1uqnGzHJ
 S22/rZL1NShLlJzvXv9IFDO1u2C+qRGQsRi1o3+/toOmy/8Q1yAuS9kvfNuFzj2GEWHR
 k/mw==
X-Gm-Message-State: AC+VfDxQVp8k/W2eaRnVQQm68xcuRxYugJZB9XWVGUOOVQ/NUoB7anrX
 gwFS0aM0z/bwK8rAWqhIafPARdI=
X-Google-Smtp-Source: ACHHUZ55tRVn6w2eePAhc6/qm8CJME6WENqz9zraKI3ZQacG7/5mnhJynvxY+ok00f1xtu5eZcDZQA==
X-Received: by 2002:ad4:5ae4:0:b0:625:aa1a:9384 with SMTP id
 c4-20020ad45ae4000000b00625aa1a9384mr2941055qvh.64.1685460482224; 
 Tue, 30 May 2023 08:28:02 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o12-20020a05620a15cc00b0074d489e517csm4106298qkm.24.2023.05.30.08.28.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 May 2023 08:28:01 -0700 (PDT)
Date: Tue, 30 May 2023 11:28:00 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <ZHYWAGmKhwwmTjW/@redhat.com>
References: <ZGzIJlCE2pcqQRFJ@bfoster> <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG+KoxDMeyogq4J0@bfoster>
 <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Dave Chinner <david@fromorbit.com>,
 linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMzAgMjAyMyBhdCAxMDo1NVAgLTA0MDAsCkpvZSBUaG9ybmJlciA8dGhvcm5i
ZXJAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+IE9uIFR1ZSwgTWF5IDMwLCAyMDIzIGF0IDM6MDLigK9Q
TSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAa2VybmVsLm9yZz4gd3JvdGU6Cj4gCj4gPgo+ID4gQWxz
byBKb2UsIGZvciB5b3UgcHJvcG9zZWQgZG0tdGhpbnAgZGVzaWduIHdoZXJlIHlvdSBkaXN0aW5x
dWlzaAo+ID4gYmV0d2VlbiAicHJvdmlzaW9uIiBhbmQgInJlc2VydmUiOiBXb3VsZCBpdCBtYWtl
IHNlbnNlIGZvciBSRVFfTUVUQQo+ID4gKGUuZy4gYWxsIFhGUyBtZXRhZGF0YSkgd2l0aCBSRVFf
UFJPVklTSU9OIHRvIGJlIHRyZWF0ZWQgYXMgYW4KPiA+IExCQS1zcGVjaWZpYyBoYXJkIHJlcXVl
c3Q/ICBXaGVyZWFzIFJFUV9QUk9WSVNJT04gb24gaXRzIG93biBwcm92aWRlcwo+ID4gbW9yZSBm
cmVlZG9tIHRvIGp1c3QgcmVzZXJ2ZSB0aGUgbGVuZ3RoIG9mIGJsb2Nrcz8gKGUuZy4gZm9yIFhG
Uwo+ID4gZGVsYWxsb2Mgd2hlcmUgTEJBIHJhbmdlIGlzIHVua25vd24sIGJ1dCBkbS10aGlucCBj
YW4gYmUgYXNrZWQgdG8KPiA+IHJlc2VydmUgc3BhY2UgdG8gYWNjb21vZGF0ZSBpdCkuCj4gPgo+
IAo+IE15IHByb3Bvc2FsIG9ubHkgaW52b2x2ZXMgJ3Jlc2VydmUnLiAgUHJvdmlzaW9uaW5nIHdp
bGwgYmUgZG9uZSBhcyBwYXJ0IG9mCj4gdGhlIHVzdWFsIGlvIHBhdGguCgpPSywgSSB0aGluayB3
ZSdkIGRvIHdlbGwgdG8gcGluIGRvd24gdGhlIHRvcC1sZXZlbCBibG9jayBpbnRlcmZhY2VzIGlu
CnF1ZXN0aW9uLiBCZWNhdXNlIHRoaXMgcGF0Y2hzZXQncyBibG9jayBpbnRlcmZhY2UgcGF0Y2gg
KDIvNSkgaGVhZGVyCnNheXM6CgoiVGhpcyBwYXRjaCBhbHNvIGFkZHMgdGhlIGNhcGFiaWxpdHkg
dG8gY2FsbCBmYWxsb2NhdGUoKSBpbiBtb2RlIDAKb24gYmxvY2sgZGV2aWNlcywgd2hpY2ggd2ls
bCBzZW5kIFJFUV9PUF9QUk9WSVNJT04gdG8gdGhlIGJsb2NrCmRldmljZSBmb3IgdGhlIHNwZWNp
ZmllZCByYW5nZSwiCgpTbyBpdCB3aXJlcyB1cCBibGtkZXZfZmFsbG9jYXRlKCkgdG8gY2FsbCBi
bGtkZXZfaXNzdWVfcHJvdmlzaW9uKCkuIEEKdXNlciBvZiBYRlMgY291bGQgdGhlbiB1c2UgZmFs
bG9jYXRlKCkgZm9yIHVzZXIgZGF0YSAtLSB3aGljaCB3b3VsZApjYXVzZSB0aGlucCdzIHJlc2Vy
dmUgdG8gX25vdF8gYmUgdXNlZCBmb3IgY3JpdGljYWwgbWV0YWRhdGEuCgpUaGUgb25seSB3YXkg
dG8gZGlzdGlucXVpc2ggdGhlIGNhbGxlciAoYmV0d2VlbiBvbi1iZWhhbGYgb2YgdXNlciBkYXRh
CnZzIFhGUyBtZXRhZGF0YSkgd291bGQgYmUgUkVRX01FVEE/CgpTbyBzaG91bGQgZG0tdGhpbnAg
aGF2ZSBhIFJFUV9NRVRBLWJhc2VkIGRpc3RpbmN0aW9uPyBPciBqdXN0IHRyZWF0CmFsbCBSRVFf
T1BfUFJPVklTSU9OIHRoZSBzYW1lPwoKTWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

