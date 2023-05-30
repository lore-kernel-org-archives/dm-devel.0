Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C254C7EE31
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685455389;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NzbQPhmHD5YrBkb2gaGlzUmnNSbfHVP7wcW6eAt4DcU=;
	b=JfLMGHrpYOD1tkLZcdR/0k1JTIr3zs+PCH+6X7l3S+Ty/oxKfmL5+VmzdUus9/Lk9tV59G
	tgeBFgRvvhechc7mCxxUQNffAYu08fy7IsHrOjwex/pSQxeIK66RAMhMyv8QMBJpBUUNx2
	gXojJ0QmmxSl0WSsQFyRzlDXNc/dEi0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-pRWXRtfgMGqgonhik-xanQ-1; Tue, 30 May 2023 10:02:59 -0400
X-MC-Unique: pRWXRtfgMGqgonhik-xanQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4DA62812954;
	Tue, 30 May 2023 14:02:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A321E112132D;
	Tue, 30 May 2023 14:02:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C81319465A0;
	Tue, 30 May 2023 14:02:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B7111946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 14:02:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23EFC40C6CCC; Tue, 30 May 2023 14:02:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CBEC40C6CD8
 for <dm-devel@redhat.com>; Tue, 30 May 2023 14:02:45 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC8A58032FF
 for <dm-devel@redhat.com>; Tue, 30 May 2023 14:02:44 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-69AqJABENvWHZHMYIBSxyQ-1; Tue, 30 May 2023 10:02:42 -0400
X-MC-Unique: 69AqJABENvWHZHMYIBSxyQ-1
Received: by mail-qv1-f46.google.com with SMTP id
 6a1803df08f44-62615694bb9so13806306d6.0
 for <dm-devel@redhat.com>; Tue, 30 May 2023 07:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685455361; x=1688047361;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=SLXZZ4okt0cYFY/QNAJJGFsPl/H71jdcBcEpr3wA2kw=;
 b=QrqfQP3lUiC6c6LroTX3jZmJwBm+rdNcnRGct16G4nPiSc2xzz+3M+bDxnWS8AbcRh
 d6VfmpK6R2VYys7RB9bKIKUb7XdLsSL8fOObwVLD++mcsc7TjWeG+tuKqEZ46d6/MEmJ
 VzMOy2x3sQh0hK9R6kTuEs92KXpyUs0VHBHsIU7OfzhKB9ILQxQjSRbZLVzz30KXEULv
 HCOQUe10da7rifBOjO7770fmvu/H9TfB0fTdruc99gEu/1aEiZS8M8JqpN/dESGc4zl2
 nwxjtXMx+8+Q0Qvy244mWfGc0hjQezMDKBPbglqfabNepMHBcZApFYV/DNfLPBspyFym
 ZsGA==
X-Gm-Message-State: AC+VfDxW4IAWxNSoIobKt3D8pzfVRuOS82SgVZyeMHqfVSmOtuTnZuTv
 xZ/j7ZGlwjv9/MGr9R6cFP3FkiY=
X-Google-Smtp-Source: ACHHUZ7c+L67lbfSXpLgK/LYE2fkMm11TxLSTkagmUtFWm5173a2X+RzwOCM3DIH+r9HCG6yNT7q6w==
X-Received: by 2002:a05:6214:40a:b0:626:299b:68ee with SMTP id
 z10-20020a056214040a00b00626299b68eemr2306743qvx.55.1685455361523; 
 Tue, 30 May 2023 07:02:41 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 jh18-20020a0562141fd200b0062382e1e228sm4619878qvb.49.2023.05.30.07.02.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 May 2023 07:02:40 -0700 (PDT)
Date: Tue, 30 May 2023 10:02:39 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Joe Thornber <thornber@redhat.com>
Message-ID: <ZHYB/6l5Wi+xwkbQ@redhat.com>
References: <ZGgBQhsbU9b0RiT1@dread.disaster.area>
 <ZGu0LaQfREvOQO4h@redhat.com> <ZGzIJlCE2pcqQRFJ@bfoster>
 <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area> <ZG+KoxDMeyogq4J0@bfoster>
 <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, Sarthak Kukreti <sarthakkukreti@chromium.org>,
 dm-devel@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Dave Chinner <david@fromorbit.com>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMzAgMjAyMyBhdCAgMzoyN1AgLTA0MDAsCkpvZSBUaG9ybmJlciA8dGhvcm5i
ZXJAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+IE9uIFNhdCwgTWF5IDI3LCAyMDIzIGF0IDEyOjQ14oCv
QU0gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToKPiAKPiA+IE9uIEZy
aSwgTWF5IDI2LCAyMDIzIGF0IDEyOjA0OjAyUE0gKzAxMDAsIEpvZSBUaG9ybmJlciB3cm90ZToK
PiA+Cj4gPiA+IDEpIFdlIGhhdmUgYW4gYXBpIChpb2N0bCwgYmlvIGZsYWcsIHdoYXRldmVyKSB0
aGF0IGxldHMgeW91Cj4gPiA+IHJlc2VydmUvZ3VhcmFudGVlIGEgcmVnaW9uOgo+ID4gPgo+ID4g
PiAgIGludCByZXNlcnZlX3JlZ2lvbihkZXYsIHNlY3Rvcl90IGJlZ2luLCBzZWN0b3JfdCBlbmQp
Owo+ID4KPiA+IEEgQy1iYXNlZCBpbnRlcmZhY2UgaXMgbm90IHN1ZmZpY2llbnQgYmVjYXVzZSB0
aGUgbGF5ZXIgdGhhdCBtdXN0IGRvCj4gPiBwcm92c2lvbmluZyBpcyBub3QgZ3VhcmFudGVlZCB0
byBiZSBkaXJlY3RseSB1bmRlciB0aGUgZmlsZXN5c3RlbS4KPiA+IFdlIG11c3QgYmUgYWJsZSB0
byBwcm9wYWdhdGUgdGhlIHJlcXVlc3QgZG93biB0byB0aGUgbGF5ZXJzIHRoYXQKPiA+IG5lZWQg
dG8gcHJvdmlzaW9uIHN0b3JhZ2UsIGFuZCB0aGF0IGluY2x1ZGVzIGhhcmR3YXJlIGRldmljZXMu
Cj4gPgo+ID4gZS5nLiBkbS10aGluIHdvdWxkIGhhdmUgdG8gaXNzdWUgUkVRX1BST1ZJU0lPTiBv
biB0aGUgTEJBIHJhbmdlcyBpdAo+ID4gYWxsb2NhdGVzIGluIGl0J3MgYmFja2luZyBkZXZpY2Ug
dG8gZ3VhcmFudGVlIHRoYXQgdGhlIHByb3Zpc2lvbmVkCj4gPiBMQkEgcmFuZ2UgaXQgYWxsb2Nh
dGVzIGlzIGFsc28gZnVsbHkgcHJvdmlzaW9uZWQgYnkgdGhlIHN0b3JhZ2UKPiA+IGJlbG93IGl0
Li4uLgo+ID4KPiAKPiBGaW5lLCBiaW8gZmxhZyBpdCBpcy4KPiAKPiAKPiA+Cj4gPiA+ICAgVGhp
cyBhcGkgc2hvdWxkIGJlIHVzZWQgbWluaW1hbGx5LCBlZywgY3JpdGljYWwgRlMgbWV0YWRhdGEg
b25seS4KPiA+Cj4gPgo+ID4KPiA+IFBsYW4gZm9yIGhhdmluZyB0byBzdXBwb3J0IHRlbnMgb2Yg
R0JzIG9mIHByb3Zpc2lvbmVkIHNwYWNlIGluCj4gPiBmaWxlc3lzdGVtcywgbm90IHRlbnMgb2Yg
TUJzLi4uLgo+ID4KPiAKPiBBbHNvIGZpbmUuCj4gCj4gCj4gSSB0aGluayB0aGVyZSdzIGEgMi0z
IHNvbGlkIGRheXMgb2YgY29kaW5nIHRvIGZ1bGx5IGltcGxlbWVudAo+ID4gUkVRX1BST1ZJU0lP
TiBzdXBwb3J0IGluIFhGUywgaW5jbHVkaW5nIHVzZXJzcGFjZSB0b29sIHN1cHBvcnQuCj4gPiBN
YXliZSBhIGNvdXBsZSBvZiB3ZWVrcyBtb3JlIHRvIGZsdXNoIHRoZSBidWdzIG91dCBiZWZvcmUg
aXQncwo+ID4gbGFyZ2VseSByZWFkeSB0byBnby4KPiA+Cj4gPiBTbyBpZiB0aGVyZSdzIGJ1eSBp
biBmcm9tIHRoZSBibG9jayBsYXllciBhbmQgRE0gcGVvcGxlIGZvcgo+ID4gUkVRX1BST1ZJU0lP
TiBhcyBkZXNjcmliZWQsIHRoZW4gSSdsbCBkZWZpbml0ZWx5IGhhdmUgWEZTIHN1cHBvcnQKPiA+
IHJlYWR5IGZvciB5b3UgdG8gdGVzdCB3aGVuZXZlciBkbS10aGlucCBpcyByZWFkeSB0byBnby4K
PiA+Cj4gCj4gR3JlYXQsIHRoaXMgaXMgd2hhdCBJIHdhbnRlZCB0byBoZWFyLiAgSSBndWVzcyB3
ZSBuZWVkIGFuIGFjayBmcm9tIHRoZQo+IGJsb2NrIGd1eXMgYW5kIHRoZW4gSSdsbCBnZXQgc3Rh
cnRlZC4KClRoZSBibG9jayBwb3J0aW9uIGlzIHdoZXJlIHRoaXMgZGlzY3Vzc2lvbiBzdGFydGVk
IChpbiB0aGUgY29udGV4dCBvZgp0aGlzIHRocmVhZCdzIHBhdGNoc2V0LCBub3cgYXQgdjcpLgoK
RHVyaW5nIG91ciBkaXNjdXNzaW9uIEkgdGhpbmsgdGhlcmUgd2VyZSAyIGdhcHMgaWRlbnRpZmll
ZCB3aXRoIHRoaXMKcGF0Y2hzZXQ6CgoxKSBwcm92aXNpb25pbmcgc2hvdWxkIGJlIG9wdC1pbiwg
YW5kIHdlIG5lZWQgYSBjbGVhciBmbGFnIHRoYXQgdXBwZXIKICAgbGF5ZXJzIGxvb2sgZm9yIHRv
IGtub3cgaWYgUkVRX1BST1ZJU0lPTiBhdmFpbGFibGUKICAgLSB3ZSBkbyBnZXQgdGhpcyB3aXRo
IHRoZSBtYXhfcHJvdmlzaW9uX3NlY3RvcnMgPSAwIGRlZmF1bHQsIGlzCiAgICAgY2hlY2tpbmcg
cXVldWVfbGltaXRzICh2aWEgcXVldWVfbWF4X3Byb3Zpc2lvbl9zZWN0b3JzKQogICAgIHN1ZmZp
Y2llbnQgZm9yIHVwcGVyIGxheWVycyBsaWtlIHhmcz8KCjIpIERNIHRoaW5wIG5lZWRzIFJFUV9Q
Uk9WSVNJT04gcGFzc2Rvd24gc3VwcG9ydAogICAtIGFsc28gZG1fdGFibGVfc3VwcG9ydHNfcHJv
dmlzaW9uKCkgbmVlZHMgdG8gYmUgc3RyaWN0ZXIgYnkKICAgICByZXF1aXJpbmcgX2FsbF8gdW5k
ZXJseWluZyBkZXZpY2VzIHN1cHBvcnQgcHJvdmlzaW9uaW5nPwoKQm9udXMgZG0tdGhpbnAgd29y
azogYWRkIHJhbmdlZCBSRVFfUFJPVklTSU9OIHN1cHBvcnQgdG8gcmVkdWNlIG51bWJlcgpvZiBj
YWxscyAoYW5kIGJpb3MpIGJsb2NrIGNvcmUgbmVlZHMgdG8gcGFzcyB0byBkbSB0aGlucC4KCkFs
c28gSm9lLCBmb3IgeW91IHByb3Bvc2VkIGRtLXRoaW5wIGRlc2lnbiB3aGVyZSB5b3UgZGlzdGlu
cXVpc2gKYmV0d2VlbiAicHJvdmlzaW9uIiBhbmQgInJlc2VydmUiOiBXb3VsZCBpdCBtYWtlIHNl
bnNlIGZvciBSRVFfTUVUQQooZS5nLiBhbGwgWEZTIG1ldGFkYXRhKSB3aXRoIFJFUV9QUk9WSVNJ
T04gdG8gYmUgdHJlYXRlZCBhcyBhbgpMQkEtc3BlY2lmaWMgaGFyZCByZXF1ZXN0PyAgV2hlcmVh
cyBSRVFfUFJPVklTSU9OIG9uIGl0cyBvd24gcHJvdmlkZXMKbW9yZSBmcmVlZG9tIHRvIGp1c3Qg
cmVzZXJ2ZSB0aGUgbGVuZ3RoIG9mIGJsb2Nrcz8gKGUuZy4gZm9yIFhGUwpkZWxhbGxvYyB3aGVy
ZSBMQkEgcmFuZ2UgaXMgdW5rbm93biwgYnV0IGRtLXRoaW5wIGNhbiBiZSBhc2tlZCB0bwpyZXNl
cnZlIHNwYWNlIHRvIGFjY29tb2RhdGUgaXQpLgoKTWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

