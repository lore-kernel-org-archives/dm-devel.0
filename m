Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60200C001E0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692032177;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IowFGxV/RiXoe4yD1Y4wjHR9LB5tzjH5oZPm+c9dbOc=;
	b=G9Yq/QofE6tm1tDTX7foicR/nQh0PJAElBnpH9g34Mjy9F+9tvCoqWlfKqcv/Hun29yjDE
	p07P5mwdbHwsvhWlt4xbPjf1prd7It3pN8/fHd1+rEg/E9WfDMKsF8EYJIILTBoig1RlyV
	jZaWHXqjZ89GrrK15t/WqWN/f0XirXg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-wkkdahnePmmC3MJwbjJVsw-1; Mon, 14 Aug 2023 12:56:15 -0400
X-MC-Unique: wkkdahnePmmC3MJwbjJVsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 156E580557B;
	Mon, 14 Aug 2023 16:56:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6CE49140E91C;
	Mon, 14 Aug 2023 16:56:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BAD11946587;
	Mon, 14 Aug 2023 16:56:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D45C51946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 16:56:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B23D840D283A; Mon, 14 Aug 2023 16:56:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA5A440D2839
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 16:56:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FDDD80557B
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 16:56:09 +0000 (UTC)
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com
 [209.85.161.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364--tdROmR9Pay6weDVDiPHVg-1; Mon, 14 Aug 2023 12:56:06 -0400
X-MC-Unique: -tdROmR9Pay6weDVDiPHVg-1
Received: by mail-oo1-f47.google.com with SMTP id
 006d021491bc7-56ca9a337caso2906751eaf.1; 
 Mon, 14 Aug 2023 09:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1692032166; x=1692636966;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=f9O7uVavugQIWG4+/30ol/uNZ+vUipg1yWncf1HB7Z8=;
 b=NnWZDgKKjj6p7jScF7Zfv3kxzdVsnDk/VQ8BE01AIsC1BnNtZ3pX2GvQqOQ9rqPE9a
 NDXMwShdUxW8nBqH6VySqXstVpAkrWDA8R6KrV8nkrzmg5zaEnI9mOlEcOf8YOP6sQIO
 3/4dY+NECYOlL+I1JmMMFrCO8vR5hqnvHIx+lN7N6KJdY6u3wNj0MnnMA9MHHmE9/85l
 x+9XHyMP5bOW3bqY0IeNZIwdQbcf3D1WhGb09zxD2/Ny6cTqJ9dG/lWCYGyIazCkmQmO
 TMGfpLhQr3QfIyq+iHjVzM1dpnHfDJVAa4EwfVv3V4EPEQz0og1hoxxmQl6eUN/T13fp
 +uwg==
X-Gm-Message-State: AOJu0YwDTqn+fwtF1elu1MRKSJJ5wo+igDMjYWbq+EFfdkShwEVZ61xD
 CWzfuzKJvzW6yyXHa093RFfeWeHzBIgIy6E93M2MCj4f+vo=
X-Google-Smtp-Source: AGHT+IGRiUAbrBbY9Vni9Tn8QSBhVGIX9TfUXofBqPCsNnEmk1YYklY4fqhqnWDK5MhusbsyCSnQmJcr7FbUisha/AQ=
X-Received: by 2002:a05:6358:9212:b0:134:e952:16a8 with SMTP id
 d18-20020a056358921200b00134e95216a8mr6760283rwb.24.1692032165879; Mon, 14
 Aug 2023 09:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230811105627epcas5p1aa1ef0e58bcd0fc05a072c8b40dcfb96@epcas5p1.samsung.com>
 <20230811105300.15889-1-nj.shetty@samsung.com>
 <2cc56fb5-ddba-b6d0-f66b-aa8fffa42af0@acm.org>
In-Reply-To: <2cc56fb5-ddba-b6d0-f66b-aa8fffa42af0@acm.org>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Mon, 14 Aug 2023 22:25:54 +0530
Message-ID: <CAOSviJ1b5ySAugzKExa_ZQgOzvQAOWB3D-ZRMQeGmNpQbaoBSQ@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v14 00/11] Implement copy offload support
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, linux-doc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Alasdair Kergon <agk@redhat.com>,
 mcgrof@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCBBdWcgMTIsIDIwMjMgYXQgMzo0MuKAr0FNIEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFz
c2NoZUBhY20ub3JnPiB3cm90ZToKPgo+IE9uIDgvMTEvMjMgMDM6NTIsIE5pdGVzaCBTaGV0dHkg
d3JvdGU6Cj4gPiBXZSBhY2hpZXZlIGNvcHkgb2ZmbG9hZCBieSBzZW5kaW5nIDIgYmlvJ3Mgd2l0
aCBzb3VyY2UgYW5kIGRlc3RpbmF0aW9uCj4gPiBpbmZvIGFuZCBtZXJnZSB0aGVtIHRvIGZvcm0g
YSByZXF1ZXN0LiBUaGlzIHJlcXVlc3QgaXMgc2VudCB0byBkcml2ZXIuCj4gPiBTbyB0aGlzIGRl
c2lnbiB3b3JrcyBvbmx5IGZvciByZXF1ZXN0IGJhc2VkIHN0b3JhZ2UgZHJpdmVycy4KPgo+IFsg
Li4uIF0KPgo+ID4gT3ZlcmFsbCBzZXJpZXMgc3VwcG9ydHM6Cj4gPiA9PT09PT09PT09PT09PT09
PT09PT09PT0KPiA+ICAgICAgIDEuIERyaXZlcgo+ID4gICAgICAgICAgICAgICAtIE5WTWUgQ29w
eSBjb21tYW5kIChzaW5nbGUgTlMsIFRQIDQwNjUpLCBpbmNsdWRpbmcgc3VwcG9ydAo+ID4gICAg
ICAgICAgICAgICBpbiBudm1lLXRhcmdldCAoZm9yIGJsb2NrIGFuZCBmaWxlIGJhY2sgZW5kKS4K
PiA+Cj4gPiAgICAgICAyLiBCbG9jayBsYXllcgo+ID4gICAgICAgICAgICAgICAtIEJsb2NrLWdl
bmVyaWMgY29weSAoUkVRX09QX0NPUFlfRFNUL1NSQyksIG9wZXJhdGlvbiB3aXRoCj4gPiAgICAg
ICAgICAgICAgICAgICAgaW50ZXJmYWNlIGFjY29tbW9kYXRpbmcgdHdvIGJsb2NrLWRldnMKPiA+
ICAgICAgICAgICAgICAgICAgLSBNZXJnaW5nIGNvcHkgcmVxdWVzdHMgaW4gcmVxdWVzdCBsYXll
cgo+ID4gICAgICAgICAgICAgICAtIEVtdWxhdGlvbiwgZm9yIGluLWtlcm5lbCB1c2VyIHdoZW4g
b2ZmbG9hZCBpcyBuYXRpdmVseQo+ID4gICAgICAgICAgICAgICAgICBhYnNlbnQKPiA+ICAgICAg
ICAgICAgICAgLSBkbS1saW5lYXIgc3VwcG9ydCAoZm9yIGNhc2VzIG5vdCByZXF1aXJpbmcgc3Bs
aXQpCj4gPgo+ID4gICAgICAgMy4gVXNlci1pbnRlcmZhY2UKPiA+ICAgICAgICAgICAgICAgLSBj
b3B5X2ZpbGVfcmFuZ2UKPgo+IElzIHRoaXMgc3VmZmljaWVudD8gVGhlIGNvbWJpbmF0aW9uIG9m
IGRtLWNyeXB0LCBkbS1saW5lYXIgYW5kIHRoZSBOVk1lCj4gZHJpdmVyIGlzIHZlcnkgY29tbW9u
LiBXaGF0IGlzIHRoZSBwbGFuIGZvciBzdXBwb3J0aW5nIGRtLWNyeXB0PwoKUGxhbiBpcyB0byBh
ZGQgb2ZmbG9hZCBzdXBwb3J0IGZvciBvdGhlciBkbSB0YXJnZXRzIGFzIHBhcnQgb2Ygc3Vic2Vx
dWVudApzZXJpZXMgb25jZSBjdXJyZW50IHBhdGNoc2V0IG1lcmdlcywgZG0gdGFyZ2V0cyBjYW4g
dXNlIGVtdWxhdGlvbiB0bwphY2hpZXZlIHRoZSBzYW1lIGF0IHByZXNlbnQuCgo+IFNob3VsZG4n
dCBiaW8gc3BsaXR0aW5nIGJlIHN1cHBvcnRlZCBmb3IgZG0tbGluZWFyPwpIYW5kbGluZyBzcGxp
dCBpcyB0cmlja3kgaW4gdGhpcyBjYXNlLCBpZiB3ZSBhbGxvdyBzcGxpdHRpbmcsIHRoZXJlIGlz
Cm5vIGVhc3kgd2F5CnRvIG1hdGNoL21lcmdlIGRpZmZlcmVudCBzcmMvZHN0IGJpbydzLiBPbmNl
IHdlIGhhdmUgbXVsdGkgcmFuZ2Ugc3VwcG9ydCB0aGVuCndlIGZlZWwgYXQgbGVhc3Qgc3JjIGJp
bydzIGNhbiBiZSBzcGxpdC4gQnV0IHRoaXMgc2VyaWVzIHNwbGl0IHdvbid0IHdvcmsuCgpUaGFu
ayB5b3UsCk5pdGVzaCBTaGV0dHkKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEBy
ZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwK

