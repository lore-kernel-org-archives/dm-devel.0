Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CA7C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 18:59:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 92338610FD
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 18:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 92338610FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-a61k4bfgOHiZzX3FGZyMdg-1; Wed, 18 Aug 2021 14:59:34 -0400
X-MC-Unique: a61k4bfgOHiZzX3FGZyMdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFA938799EB;
	Wed, 18 Aug 2021 18:59:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 21E9D1970E;
	Wed, 18 Aug 2021 18:59:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 595474BB7C;
	Wed, 18 Aug 2021 18:59:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17IIxPcl004318 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 14:59:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5802B21F1AFF; Wed, 18 Aug 2021 18:59:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5304A21F1AFB
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 18:59:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF01E101A52C
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 18:59:22 +0000 (UTC)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com
	[209.85.218.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-489-2pyc8GeMNe6unqs26qFAfA-1; Wed, 18 Aug 2021 14:59:20 -0400
X-MC-Unique: 2pyc8GeMNe6unqs26qFAfA-1
Received: by mail-ej1-f44.google.com with SMTP id b15so7079081ejg.10
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 11:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=U1zyi1q7r3FuL+wJh5Ih7H/8fdJI5IwoBKaDIus7E2s=;
	b=UhvEdqbVwKYhJgsgvvB4xffch+nNcgQyFtNatSDc8+5c0BzjbO8s+H4O/2Z1kRCknC
	BFcQDiR27C2tHzCgZLa207yyXZEYoaSa3fM5Ss5TD+4tUctsIfKcWg5tFQvBaUGyj/h+
	svMqFXogg0KsOVouFHpUTBm5Bk36zEx64MOq+n0o/Xv7PsoFm8Lzr721M626y01VF5db
	cudLWDJZYr15BNqlHf1Zlikz/gH6NopyqFXp4jUtGOTmlGULMivh++dFfDy8iDmvgQdW
	Dg4CmGoRcHPaTsjjQK2fLn9NekFao7Ez6XxqanFE1JRtMELrnXbaJeEoiMNqrbgiGr+g
	6YUQ==
X-Gm-Message-State: AOAM532V0Gj1QtrzEHfBDLTfInBb+KigOzZYhw08vNkuU1lEbnKGH+/r
	oX3CToYsEtUhfW6riYR7PMV3YwkRNTx+D3Z2qYW+
X-Google-Smtp-Source: ABdhPJw1AZje9L1Ml35RnyfG5pEKMOFRry97/jH8x8P45R8xQa7mBiF5FdtzzWX+UiP8gbrJtRQ0eTIKE4Hhkn77bD8=
X-Received: by 2002:a17:906:488a:: with SMTP id
	v10mr11058189ejq.91.1629313159447; 
	Wed, 18 Aug 2021 11:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
	<20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 18 Aug 2021 14:59:08 -0400
Message-ID: <CAHC9VhRB1iviuOyeqi3L4DC8LNfnkz1HXC3hdqNvqm2sZQYXMQ@mail.gmail.com>
To: =?UTF-8?Q?Michael_Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17IIxPcl004318
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-audit@redhat.com, Casey Schaufler <casey@schaufler-ca.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] dm: introduce audit event module for
	device mapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU2F0LCBBdWcgMTQsIDIwMjEgYXQgMjozNCBQTSBNaWNoYWVsIFdlacOfCjxtaWNoYWVsLndl
aXNzQGFpc2VjLmZyYXVuaG9mZXIuZGU+IHdyb3RlOgo+Cj4gVG8gYmUgYWJsZSB0byBzZW5kIGF1
ZGl0aW5nIGV2ZW50cyB0byB1c2VyIHNwYWNlLCB3ZSBpbnRyb2R1Y2UKPiBhIGdlbmVyaWMgZG0t
YXVkaXQgbW9kdWxlLiBJdCBwcm92aWRlcyBoZWxwZXIgZnVuY3Rpb25zIHRvIGVtaXQKPiBhdWRp
dCBldmVudHMgdGhyb3VnaCB0aGUga2VybmVsIGF1ZGl0IHN1YnN5c3RlbS4gV2UgY2xhaW0gdGhl
Cj4gQVVESVRfRE0gdHlwZT0xMzM2IG91dCBvZiB0aGUgYXVkaXQgZXZlbnQgbWVzc2FnZXMgcmFu
Z2UgaW4gdGhlCj4gY29ycmVzcG9uZGluZyB1c2Vyc3BhY2UgYXBpIGluICdpbmNsdWRlL3VhcGkv
bGludXgvYXVkaXQuaCcgZm9yCj4gdGhvc2UgZXZlbnRzLgo+Cj4gRm9sbG93aW5nIGNvbW1pdHMg
dG8gZGV2aWNlIG1hcHBlciB0YXJnZXRzIGFjdHVhbGx5IHdpbGwgbWFrZQo+IHVzZSBvZiB0aGlz
IHRvIGVtaXQgdGhvc2UgZXZlbnRzIGluIHJlbGV2YW50IGNhc2VzLgo+Cj4gU2lnbmVkLW9mZi1i
eTogTWljaGFlbCBXZWnDnyA8bWljaGFlbC53ZWlzc0BhaXNlYy5mcmF1bmhvZmVyLmRlPgoKSGkg
TWljaGFlbCwKCllvdSB3ZW50IGludG8gbW9yZSBkZXRhaWwgaW4geW91ciBwYXRjaHNldCBjb3Zl
ciBsZXR0ZXIsIGUuZy4gZXhhbXBsZQphdWRpdCByZWNvcmRzLCB3aGljaCBJIHRoaW5rIHdvdWxk
IGJlIGhlbHBmdWwgaGVyZSBpbiB0aGUgY29tbWl0CmRlc2NyaXB0aW9uIHNvIHdlIGhhdmUgaXQg
YXMgcGFydCBvZiB0aGUgZ2l0IGxvZy4gIEkgZG9uJ3Qgd2FudCB0bwpkaXNjb3VyYWdlIHlvdSBm
cm9tIHdyaXRpbmcgY292ZXIgbGV0dGVycywgYnV0IGRvbid0IGZvcmdldCB0aGF0IHRoZQpjb3Zl
ciBsZXR0ZXJzIGNhbiBiZSBsb3N0IHRvIHRoZSBldGhlciBhZnRlciBhIGNvdXBsZSBvZiB5ZWFy
cyB3aGVyZWFzCnRoZSBnaXQgbG9nIGhhcyBhIG11Y2ggbG9uZ2VyIGxpZmV0aW1lICh3ZSBob3Bl
ISkgYW5kIGEgdGlnaHRlcgpiaW5kaW5nIHRvIHRoZSByZWxhdGVkIGNvZGUuCgo+IC0tLQo+ICBk
cml2ZXJzL21kL0tjb25maWcgICAgICAgICB8IDEwICsrKysrKysKPiAgZHJpdmVycy9tZC9NYWtl
ZmlsZSAgICAgICAgfCAgNCArKysKPiAgZHJpdmVycy9tZC9kbS1hdWRpdC5jICAgICAgfCA1OSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICBkcml2ZXJzL21kL2RtLWF1
ZGl0LmggICAgICB8IDMzICsrKysrKysrKysrKysrKysrKysrKwo+ICBpbmNsdWRlL3VhcGkvbGlu
dXgvYXVkaXQuaCB8ICAxICsKPiAgNSBmaWxlcyBjaGFuZ2VkLCAxMDcgaW5zZXJ0aW9ucygrKQo+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRpdC5jCj4gIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0LmgKPgo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L0tjb25maWcgYi9kcml2ZXJzL21kL0tjb25maWcKPiBpbmRleCAwNjAyZTgyYTk1MTYuLjQ4YWRi
ZWMxMjE0OCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL0tjb25maWcKPiArKysgYi9kcml2ZXJz
L21kL0tjb25maWcKPiBAQCAtNjA4LDYgKzYwOCw3IEBAIGNvbmZpZyBETV9JTlRFR1JJVFkKPiAg
ICAgICAgIHNlbGVjdCBDUllQVE8KPiAgICAgICAgIHNlbGVjdCBDUllQVE9fU0tDSVBIRVIKPiAg
ICAgICAgIHNlbGVjdCBBU1lOQ19YT1IKPiArICAgICAgIHNlbGVjdCBETV9BVURJVCBpZiBBVURJ
VAo+ICAgICAgICAgaGVscAo+ICAgICAgICAgICBUaGlzIGRldmljZS1tYXBwZXIgdGFyZ2V0IGVt
dWxhdGVzIGEgYmxvY2sgZGV2aWNlIHRoYXQgaGFzCj4gICAgICAgICAgIGFkZGl0aW9uYWwgcGVy
LXNlY3RvciB0YWdzIHRoYXQgY2FuIGJlIHVzZWQgZm9yIHN0b3JpbmcKPiBAQCAtNjQwLDQgKzY0
MSwxMyBAQCBjb25maWcgRE1fWk9ORUQKPgo+ICAgICAgICAgICBJZiB1bnN1cmUsIHNheSBOLgo+
Cj4gK2NvbmZpZyBETV9BVURJVAo+ICsgICAgICAgYm9vbCAiRE0gYXVkaXQgZXZlbnRzIgo+ICsg
ICAgICAgZGVwZW5kcyBvbiBBVURJVAo+ICsgICAgICAgaGVscAo+ICsgICAgICAgICBHZW5lcmF0
ZSBhdWRpdCBldmVudHMgZm9yIGRldmljZS1tYXBwZXIuCj4gKwo+ICsgICAgICAgICBFbmFibGVz
IGF1ZGl0IGxvZ2dpbmcgb2Ygc2V2ZXJhbCBzZWN1cml0eSByZWxldmFudCBldmVudHMgaW4gdGhl
Cj4gKyAgICAgICAgIHBhcnRpY3VsYXIgZGV2aWNlLW1hcHBlciB0YXJnZXRzLCBlc3BlY2lhbGx5
IHRoZSBpbnRlZ3JpdHkgdGFyZ2V0Lgo+ICsKPiAgZW5kaWYgIyBNRAo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL21kL01ha2VmaWxlIGIvZHJpdmVycy9tZC9NYWtlZmlsZQo+IGluZGV4IGE3NGFhZjhi
MTQ0NS4uNGNkNDc2MjNjNzQyIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbWQvTWFrZWZpbGUKPiAr
KysgYi9kcml2ZXJzL21kL01ha2VmaWxlCj4gQEAgLTEwMywzICsxMDMsNyBAQCBlbmRpZgo+ICBp
ZmVxICgkKENPTkZJR19ETV9WRVJJVFlfVkVSSUZZX1JPT1RIQVNIX1NJRykseSkKPiAgZG0tdmVy
aXR5LW9ianMgICAgICAgICAgICAgICAgICs9IGRtLXZlcml0eS12ZXJpZnktc2lnLm8KPiAgZW5k
aWYKPiArCj4gK2lmZXEgKCQoQ09ORklHX0RNX0FVRElUKSx5KQo+ICtkbS1tb2Qtb2JqcyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICArPSBkbS1hdWRpdC5vCj4gK2VuZGlmCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWQvZG0tYXVkaXQuYyBiL2RyaXZlcnMvbWQvZG0tYXVkaXQuYwo+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0Cj4gaW5kZXggMDAwMDAwMDAwMDAwLi5jN2U1ODI0ODIxYmIKPiAtLS0g
L2Rldi9udWxsCj4gKysrIGIvZHJpdmVycy9tZC9kbS1hdWRpdC5jCj4gQEAgLTAsMCArMSw1OSBA
QAo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+ICsvKgo+ICsgKiBDcmVh
dGluZyBhdWRpdCByZWNvcmRzIGZvciBtYXBwZWQgZGV2aWNlcy4KPiArICoKPiArICogQ29weXJp
Z2h0IChDKSAyMDIxIEZyYXVuaG9mZXIgQUlTRUMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuCj4gKyAq
Cj4gKyAqIEF1dGhvcnM6IE1pY2hhZWwgV2Vpw58gPG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5o
b2Zlci5kZT4KPiArICovCj4gKwo+ICsjaW5jbHVkZSA8bGludXgvYXVkaXQuaD4KPiArI2luY2x1
ZGUgPGxpbnV4L21vZHVsZS5oPgo+ICsjaW5jbHVkZSA8bGludXgvZGV2aWNlLW1hcHBlci5oPgo+
ICsjaW5jbHVkZSA8bGludXgvYmlvLmg+Cj4gKyNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KPiAr
Cj4gKyNpbmNsdWRlICJkbS1hdWRpdC5oIgo+ICsjaW5jbHVkZSAiZG0tY29yZS5oIgo+ICsKPiAr
dm9pZCBkbV9hdWRpdF9sb2dfYmlvKGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNo
YXIgKm9wLAo+ICsgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgYmlvICpiaW8sIHNlY3Rvcl90
IHNlY3RvciwgaW50IHJlc3VsdCkKPiArewo+ICsgICAgICAgc3RydWN0IGF1ZGl0X2J1ZmZlciAq
YWI7Cj4gKwo+ICsgICAgICAgaWYgKGF1ZGl0X2VuYWJsZWQgPT0gQVVESVRfT0ZGKQo+ICsgICAg
ICAgICAgICAgICByZXR1cm47Cj4gKwo+ICsgICAgICAgYWIgPSBhdWRpdF9sb2dfc3RhcnQoYXVk
aXRfY29udGV4dCgpLCBHRlBfS0VSTkVMLCBBVURJVF9ETSk7Cj4gKyAgICAgICBpZiAodW5saWtl
bHkoIWFiKSkKPiArICAgICAgICAgICAgICAgcmV0dXJuOwo+ICsKPiArICAgICAgIGF1ZGl0X2xv
Z19mb3JtYXQoYWIsICJtb2R1bGU9JXMgZGV2PSVkOiVkIG9wPSVzIHNlY3Rvcj0lbGx1IHJlcz0l
ZCIsCj4gKyAgICAgICAgICAgICAgICAgICAgICAgIGRtX21zZ19wcmVmaXgsIE1BSk9SKGJpby0+
YmlfYmRldi0+YmRfZGV2KSwKPiArICAgICAgICAgICAgICAgICAgICAgICAgTUlOT1IoYmlvLT5i
aV9iZGV2LT5iZF9kZXYpLCBvcCwgc2VjdG9yLCByZXN1bHQpOwo+ICsgICAgICAgYXVkaXRfbG9n
X2VuZChhYik7Cj4gK30KPiArRVhQT1JUX1NZTUJPTF9HUEwoZG1fYXVkaXRfbG9nX2Jpbyk7Cj4g
Kwo+ICt2b2lkIGRtX2F1ZGl0X2xvZ190YXJnZXQoY29uc3QgY2hhciAqZG1fbXNnX3ByZWZpeCwg
Y29uc3QgY2hhciAqb3AsCj4gKyAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkbV90YXJn
ZXQgKnRpLCBpbnQgcmVzdWx0KQo+ICt7Cj4gKyAgICAgICBzdHJ1Y3QgYXVkaXRfYnVmZmVyICph
YjsKPiArICAgICAgIHN0cnVjdCBtYXBwZWRfZGV2aWNlICptZCA9IGRtX3RhYmxlX2dldF9tZCh0
aS0+dGFibGUpOwo+ICsKPiArICAgICAgIGlmIChhdWRpdF9lbmFibGVkID09IEFVRElUX09GRikK
PiArICAgICAgICAgICAgICAgcmV0dXJuOwo+ICsKPiArICAgICAgIGFiID0gYXVkaXRfbG9nX3N0
YXJ0KGF1ZGl0X2NvbnRleHQoKSwgR0ZQX0tFUk5FTCwgQVVESVRfRE0pOwo+ICsgICAgICAgaWYg
KHVubGlrZWx5KCFhYikpCj4gKyAgICAgICAgICAgICAgIHJldHVybjsKPiArCj4gKyAgICAgICBh
dWRpdF9sb2dfZm9ybWF0KGFiLCAibW9kdWxlPSVzIGRldj0lcyBvcD0lcyIsCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgIGRtX21zZ19wcmVmaXgsIGRtX2RldmljZV9uYW1lKG1kKSwgb3ApOwo+
ICsKPiArICAgICAgIGlmICghcmVzdWx0ICYmICFzdHJjbXAoImN0ciIsIG9wKSkKPiArICAgICAg
ICAgICAgICAgYXVkaXRfbG9nX2Zvcm1hdChhYiwgIiBlcnJvcl9tc2c9JyVzJyIsIHRpLT5lcnJv
cik7Cj4gKyAgICAgICBhdWRpdF9sb2dfZm9ybWF0KGFiLCAiIHJlcz0lZCIsIHJlc3VsdCk7Cj4g
KyAgICAgICBhdWRpdF9sb2dfZW5kKGFiKTsKPiArfQoKR2VuZXJhbGx5IHNwZWFraW5nIHdlIHRy
eSB0byBrZWVwIGEgY29uc2lzdGVudCBmb3JtYXQgYW5kIG9yZGVyaW5nCndpdGhpbiBhIGdpdmVu
IGF1ZGl0IHJlY29yZCB0eXBlLiAgSG93ZXZlciB5b3UgYXBwZWFyIHRvIGhhdmUgYXQgbGVhc3QK
dGhyZWUgZGlmZmVyZW50IGZvcm1hdHMgZm9yIHRoZSBBVURJVF9ETSByZWNvcmQgaW4gdGhpcyBw
YXRjaDoKCiAgIi4uLiBtb2R1bGU9JXMgZGV2PSVkOiVkIG9wPSVzIHNlY3Rvcj0lbGx1IHJlcz0l
ZCIKICAiLi4uIG1vZHVsZT0lcyBkZXY9JXMgb3A9JXMgZXJyb3JfbXNnPSclcycgcmVzPSVkIgog
ICIuLi4gbW9kdWxlPSVzIGRldj0lcyBvcD0lcyByZXM9JWQiCgpUaGUgZmlyc3QgdGhpbmcgdGhh
dCBqdW1wcyBvdXQgaXMgdGhhdCBzb21lIGZpZWxkcywgZS5nLiAic2VjdG9yIiwgYXJlCm5vdCBh
bHdheXMgcHJlc2VudCBpbiB0aGUgcmVjb3JkOyB3ZSB0eXBpY2FsbHkgaGFuZGxlIHRoaXMgYnkg
dXNpbmcgYQoiPyIgZm9yIHRoZSBmaWVsZCB2YWx1ZSBpbiB0aG9zZSBjYXNlcyB3aGVyZSB5b3Ug
d291bGQgb3RoZXJ3aXNlIGRyb3AKdGhlIGZpZWxkIGZyb20gdGhlIHJlY29yZCwgZm9yIGV4YW1w
bGUgdGhlIGZvbGxvd2luZyByZWNvcmQ6CgogICIuLi4gbW9kdWxlPSVzIGRldj0lcyBvcD0lcyBy
ZXM9JWQiCgouLi4gd291bGQgYmUgcmV3cml0dGVuIGxpa2UgdGhpczoKCiAgIi4uLiBtb2R1bGU9
JXMgZGV2PSVzIG9wPSVzIHNlY3Rvcj0/IHJlcz0lZCIKClRoZSBzZWNvbmQgdGhpbmcgdGhhdCBJ
IG5vdGljZWQgaXMgdGhhdCB0aGUgImRldiIgZmllbGQgY2hhbmdlcyBmcm9tIGEKIm1ham9yOm1p
bm9yIiBudW1iZXIgcmVwcmVzZW50YXRpb24gdG8gYW4gYXJiaXRyYXJ5IHN0cmluZyB2YWx1ZSwg
ZS5nLgoiZGV2PSVzIi4gIFRoaXMgZ2VuZXJhbGx5IGlzbid0IHNvbWV0aGluZyB3ZSBkbyB3aXRo
IGF1ZGl0IHJlY29yZHMsCnBsZWFzZSBzdGljayB0byBhIHNpbmdsZSByZXByZXNlbnRhdGlvbiBm
b3IgYSBnaXZlbiBhdWRpdApyZWNvcmQtdHlwZS9maWVsZCBjb21iaW5hdGlvbi4KCi0tIApwYXVs
IG1vb3JlCnd3dy5wYXVsLW1vb3JlLmNvbQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=

