Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5BDC77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 00:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681952058;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=54vqZf1tkuEIwsUn63fiUW9abrQ3KBxisJgyppDq8BY=;
	b=JhQ7410MuCwnhNUlnmjycG+6tImeyiG9Gic2bMuP2/3YNmMQDuLqN4wVMGeo+hw14x+h+X
	BbvbbMwH4goa2t4sUfmPu6xv3oCrsz82C+8e/YrencTvngpJREN5sJ4t9ocxiBgh0Hclyz
	o7YRmqyCAJEvP6BgaeaDsyTzARYy8tg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-lwv6SFeVMTuZUBY9cVmfww-1; Wed, 19 Apr 2023 20:54:15 -0400
X-MC-Unique: lwv6SFeVMTuZUBY9cVmfww-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEFB31C09043;
	Thu, 20 Apr 2023 00:54:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22650492C3F;
	Thu, 20 Apr 2023 00:54:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B071A1946A40;
	Thu, 20 Apr 2023 00:54:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E9A919465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 00:54:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 40CE5492B05; Thu, 20 Apr 2023 00:54:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38B79492C3F
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 00:54:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A859101A551
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 00:54:12 +0000 (UTC)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-MoJbSL4nNGOYjTvsHX6_wA-1; Wed, 19 Apr 2023 20:54:10 -0400
X-MC-Unique: MoJbSL4nNGOYjTvsHX6_wA-1
Received: by mail-ej1-f43.google.com with SMTP id
 a640c23a62f3a-94f32588c13so26803766b.2
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 17:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681952049; x=1684544049;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=CEZZksfYsGWpaWEP90hGUd/QDkimEQeeLBa7ojWXyLA=;
 b=l3lyKmnMXzNhslTdIC3/Iow/OAmVrFDkJwqtBaNzO/2PZVXWi9ohFpXu7ORgCDSvrb
 S2vflHJsJfvcD8VgQ2ll7PduKkjRD41A0tAahEEcg2gX4S3hJfwRG6bP9Lv3AvRFlhWv
 GEFBMNDy0+WiTtghG0aJiLgrxtT5enamM2yDvRKD+TkdsOy+1jvd1sLcrsGlu5jyUUeS
 c/Fy/nFNVJDJ0D77CXMT9+ujO84/oe8GHkgST6cdOTmFZXFaaQIvPyBmRbmD7IlxtKcf
 3ymVuTg483n9zKiUM8ES5B00rqdLmxsshCicSjc34R0gqOxqLW7xZDwcd2bSAc2zQwax
 SRPg==
X-Gm-Message-State: AAQBX9fWqBswPThXmNdUGbHBUlWdWrTaUiNlE/OlqL3wJkbunhrVxjff
 bxapUWsbrWbzS4TTKoe9mQq//oUwY1vPWiyScpQLyg==
X-Google-Smtp-Source: AKy350YAC+sf3TWZtlZrZvPaKG0+dzlZ7DQ7BVfpG5/0uqvM2SXFWEF2eIB5c1sxQ1bKurWeSP65JttCPBnGIFCMuXg=
X-Received: by 2002:a05:6402:406:b0:504:9ae7:f73b with SMTP id
 q6-20020a056402040600b005049ae7f73bmr7162959edv.2.1681952049439; Wed, 19 Apr
 2023 17:54:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
 <20230419153611.GE360885@frogsfrogsfrogs> <ZEAUHnWqt9cIiJRb@redhat.com>
 <20230419172602.GE360881@frogsfrogsfrogs>
 <20230419232118.GL447837@dread.disaster.area>
In-Reply-To: <20230419232118.GL447837@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Wed, 19 Apr 2023 17:53:58 -0700
Message-ID: <CAG9=OMNYp+uY9VG5VVB=-cjFBJj5iXbsiNWN5KxMXtwnGDFfbw@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 1/4] block: Introduce provisioning
 primitives
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
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBBcHIgMTksIDIwMjMgYXQgNDoyMeKAr1BNIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJv
bW9yYml0LmNvbT4gd3JvdGU6Cj4KPiBPbiBXZWQsIEFwciAxOSwgMjAyMyBhdCAxMDoyNjowMkFN
IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6Cj4gPiBPbiBXZWQsIEFwciAxOSwgMjAyMyBh
dCAxMjoxNzozNFBNIC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gPiA+IChBbmQgb2J2aW91
c2x5IG5lZWRzIGZpeGluZyBpbmRlcGVuZGVudCBvZiB0aGlzIHBhdGNoc2V0KQo+ID4gPgo+ID4g
PiBTaG91bGRuJ3QgbWtmcyBmaXJzdCBjaGVjayB0aGF0IHRoZSB1bmRlcmx5aW5nIHN0b3JhZ2Ug
c3VwcG9ydHMKPiA+ID4gUkVRX09QX1BST1ZJU0lPTiBieSB2ZXJpZnlpbmcKPiA+ID4gL3N5cy9i
bG9jay88ZGV2Pi9xdWV1ZS9wcm92aXNpb25fbWF4X2J5dGVzIGV4aXN0cyBhbmQgaXMgbm90IDA/
Cj4gPiA+IChKdXN0IHNheWluZywgd2UgbmVlZCB0byBhZGQgbmV3IGZlYXR1cmVzIG1vcmUgZGVm
ZW5zaXZlbHkuLiB5b3UganVzdAo+ID4gPiBtYWRlIHRoZSBjYXNlIGJhc2VkIG9uIHRoaXMgc2Nl
bmFyaW8ncyBpbXBsaWNhdGlvbnMgYWxvbmUpCj4gPgo+ID4gTm90IGZvciBmYWxsb2NhdGUgLS0g
Zm9yIHJlZ3VsYXIgZmlsZXMsIHRoZXJlJ3Mgbm8gd2F5IHRvIGNoZWNrIGlmIHRoZQo+ID4gZmls
ZXN5c3RlbSBhY3R1YWxseSBzdXBwb3J0cyB0aGUgb3BlcmF0aW9uIHJlcXVlc3RlZCBvdGhlciB0
aGFuIHRvIHRyeQo+ID4gaXQgYW5kIHNlZSBpZiBpdCBzdWNjZWVkcy4gIFdlIHByb2JhYmx5IHNo
b3VsZCd2ZSBkZWZpbmVkIGEgRFJZX1JVTiBmbGFnCj4gPiBmb3IgdGhhdCBwdXJwb3NlIGJhY2sg
d2hlbiBpdCB3YXMgaW50cm9kdWNlZC4KPgo+IFRoYXQgaWdub3JlcyB0aGUgZmFjdCB0aGF0IGZh
bGxvY2F0ZSgpIHdhcyBuZXZlciBpbnRlbmRlZCB0bwo+IGd1YXJhbnRlZSBpdCB3aWxsIHdvcmsg
aW4gYWxsIGNvbnRleHRzIC0gaXQncyBhbiBhZHZpc29yeSBpbnRlcmZhY2UKPiBhdCBpdCdzIG1v
c3QgYmFzaWMgbGV2ZWwuIElmIHRoZSBjYWxsIHN1Y2NlZWRzLCB0aGVuIGdyZWF0LCBpdCBkb2Vz
Cj4gd2hhdCBpcyBzYXlzIG9uIHRoZSBib3gsIGJ1dCBpZiBpdCBmYWlscyB0aGVuIGl0IHNob3Vs
ZCBoYXZlIG5vCj4gdmlzaWJsZSBlZmZlY3Qgb24gdXNlciBkYXRhIGF0IGFsbCBhbmQgdGhlIGFw
cGxpY2F0aW9uIHN0aWxsIG5lZWRzCj4gdG8gcGVyZm9ybSB3aGF0ZXZlciBtb2RpZmljYXRpb24g
aXQgbmVlZGVkIGRvbmUgaW4gc29tZSBvdGhlciB3YXkuCj4KPiBJT1dzLCBjYWxsaW5nIGl0IG9u
ZSBhIGJsb2NrIGRldmljZSB3aXRob3V0IGZpcnN0IGNoZWNraW5nIGlmIHRoZQo+IGJsb2NrIGRl
dmljZSBzdXBwb3J0cyB0aGF0IGZhbGxvY2F0ZSBvcGVyYXRpb24gaXMgZXhhY3RseSBob3cgaXQg
aXMKPiBzdXBwb3NlZCB0byBiZSB1c2VkLiBJZiB0aGUga2VybmVsIGNhbid0IGhhbmRsZSB0aGlz
IGdyYWNlZnVsbHkKPiB3aXRob3V0IGNvcnJ1cHRpbmcgZGF0YSwgdGhlbiB0aGF0J3MgYSBrZXJu
ZWwgYnVnIGFuZCBub3QgYW4KPiBhcHBsaWNhdGlvbiBwcm9ibGVtLgo+Cj4gPiBGb3IgZmFsbG9j
YXRlIGNhbGxzIHRvIGJsb2NrIGRldmljZXMsIHllcywgdGhlIHByb2dyYW0gY2FuIGNoZWNrIHRo
ZQo+ID4gcXVldWUgbGltaXRzIGluIHN5c2ZzIGlmIGZzdGF0IHNheXMgdGhlIHN1cHBsaWVkIHBh
dGggaXMgYSBibG9jayBkZXZpY2UsCj4gPiBidXQgSSBkb24ndCBrbm93IHRoYXQgbW9zdCBwcm9n
cmFtcyBhcmUgdGhhdCB0aG9yb3VnaC4gIFRoZSBmYWxsb2NhdGUoMSkKPiA+IENMSSBwcm9ncmFt
IGRvZXMgbm90IGNoZWNrLgo+Cj4gUmlnaHQuIGZhbGxvY2F0ZSgpIHdhcyBpbnRlbmRlZCB0byBq
dXN0IGRvIHRoZSByaWdodCB0aGluZyB3aXRob3V0Cj4gdGhlIGFwcGxpY2F0aW9uIGhhdmluZyB0
byBqdW1wIHRocm93biBhbiB1bmtub3duIG51bWJlciBvZiBob29wcyB0bwo+IGRldGVybWluZSBp
ZiBmYWxsb2NhdGUoKSBjYW4gYmUgdXNlZCBvciBub3QgaW4gdGhlIGNvbnRleHQgaXQgaXMKPiBl
eGVjdXRpbmcgaW4uICBUaGUga2VybmVsIGltcGxlbWVudGF0aW9uIGlzIHN1cHBvc2VkIHRvIGFi
c3RyYWN0IGFsbCB0aGF0Cj4gY29udGV4dC1kZXBlbmRlbnQgYmVoYXZpb3VyIGF3YXkgZnJvbSB0
aGUgYXBwbGljYXRpb247IGFsbCB0aGUKPiBhcHBsaWNhdGlvbiBoYXMgdG8gZG8gaXMgaW1wbGVt
ZW50IHRoZSBmYWxsb2NhdGUoKSBmYXN0IHBhdGggYW5kIGEKPiBzaW5nbGUgZ2VuZXJpYyAiZG8g
dGhlIHJpZ2h0IHRoaW5nIHRoZSBzbG93IHdheSIgZmFsbGJhY2sgd2hlbiB0aGUKPiBmYWxsb2Nh
dGUoKSBtZXRob2QgaXQgY2FsbGVkIGlzIG5vdCBzdXBwb3J0ZWQuLi4KPgpJIGFkZGVkIGEgc2Vw
YXJhdGUgY29tbWl0WzFdIHRvIGZpeCB0aGlzIHNvIHRoYXQgd2Ugb25seQp0cnVuY2F0ZV9iZGV2
X3JhbmdlKCkgaWZmIHdlIGFyZSBpbiBhIHN1cHBvcnRlZCBkZS1hbGxvY2F0ZSBtb2RlIGNhbGwu
ClN1YnNlcXVlbnRseSwgdGhlIFJFUV9PUF9QUk9WSVNJT04gcGF0Y2ggaXMgYSBiaXQgc2ltcGxl
ciB3aGVuIHJlYmFzZWQKb24gdG9wLgoKWzFdIGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3Rz
L2tlcm5lbC9tc2c0NzY1Njg4Lmh0bWwKCkJlc3QKU2FydGhhawoKPiAtRGF2ZS4KPiAtLQo+IERh
dmUgQ2hpbm5lcgo+IGRhdmlkQGZyb21vcmJpdC5jb20KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

