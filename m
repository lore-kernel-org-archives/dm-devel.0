Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83415C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=r7+PaaVHDW6Lj5PNbs1uhNwgcvZ2ZyHO1jSSrm4E6qk=;
	b=JZyeNtUx1myjhfwdAXFPFtfIdGhnZGXH6BQKnxlTMm43IZ/+ROlRR7J1HF8YwPdp1wT9B+
	6wmQBahRhYEr0FOnHou8GDYEJvFD2gPTRqxBPmI46cHNZ0tb9LF5A49S3WY0OeH8Ox23Ak
	ybU+WyQCZnncQGM+ClfE6j/SfmFpDOE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-Ls6GPgWAPFiv7orELJQcUA-1; Wed, 24 May 2023 00:50:35 -0400
X-MC-Unique: Ls6GPgWAPFiv7orELJQcUA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EC303801EF2;
	Wed, 24 May 2023 04:50:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05D5E140E95D;
	Wed, 24 May 2023 04:50:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D99E619465B6;
	Wed, 24 May 2023 04:50:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B05F19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 18:30:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 695CB20296C8; Tue, 23 May 2023 18:30:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 612B620296C6
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:30:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E001E801182
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:30:28 +0000 (UTC)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com
 [209.85.218.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-5gLzJo2mNn-kMzIyvEkcmA-1; Tue, 23 May 2023 14:30:26 -0400
X-MC-Unique: 5gLzJo2mNn-kMzIyvEkcmA-1
Received: by mail-ej1-f48.google.com with SMTP id
 a640c23a62f3a-96f66fbd770so118333466b.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 11:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684866625; x=1687458625;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=GfbS4pJKMPIQHwf0r8ONmf3iSeCg8srHtIH+ip6lF6w=;
 b=ePLY2W2DCjKJgRTMzeWb0tJ+LjyM9NGNUTlp+D2wli6SEXibXLf61+uUIQQRImxQap
 pkCqRSF/vqAluRyvlIrL0hOWSbvQ8NdVUTbatJbz+UzKvtwSw4+3/cSZSoK/NNPSKP3O
 T0yavCr2OWoSVM7Vw0IpgAZjGNaD//sZKaYRJK+cXZEhlVLNrDuOusui5xLBeJTzfeni
 RklRK1006GFchZ+aY5FOd8M+cIXROXXPNUY4W+024JXK6BjLfJTqbu99IYQSS9pJyPZ5
 pSVa5/8LOlWEMvRTWc/28aZt99a9qNIZLWw/qH0C0pavQ/6SIUSYvGUlwchgtQY/IvaY
 +I0A==
X-Gm-Message-State: AC+VfDzq3eRFUXXrtB4SlVF1YJK+4fc1EJjpzGc20MIB1dse2WF5E99y
 reYWS3sdPoqBBRLMJFU0+rHRQLrkEqR1pja4Hdc=
X-Google-Smtp-Source: ACHHUZ66A+UCP5ILB6WJL7gRZr76fIg5QdK7B+g3Ms7DfUP8/uUNDY//3EMNEWFb62fc2+afiPxc0qNLsKcnm/cWsh8=
X-Received: by 2002:a17:906:77d8:b0:959:37cc:190e with SMTP id
 m24-20020a17090677d800b0095937cc190emr13117908ejn.3.1684866625139; Tue, 23
 May 2023 11:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-4-hch@lst.de>
In-Reply-To: <20230523074535.249802-4-hch@lst.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 23 May 2023 20:30:13 +0200
Message-ID: <CAJZ5v0i2eXi+UEqm0W2eiadjUw5AHT-c1OHTQkemacfL0-jo2A@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: Re: [dm-devel] [PATCH 03/24] PM: hibernate: remove the global
 snapshot_test variable
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMjMsIDIwMjMgYXQgOTo0NeKAr0FNIENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKPgo+IFBhc3NpbmcgY2FsbCBkZXBlbmRlbnQgdmFyaWFibGUgaW4gZ2xv
YmFsIHZhcmlhYmxlcyBpcyBhIGh1Z2UKPiBhbnRpcGF0dGVybi4gIEZpeCBpdCB1cC4KPgo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgoKQWNrZWQtYnk6IFJh
ZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWxAa2VybmVsLm9yZz4KCj4gLS0tCj4gIGtlcm5lbC9wb3dl
ci9oaWJlcm5hdGUuYyB8IDE3ICsrKysrKy0tLS0tLS0tLS0tCj4gIGtlcm5lbC9wb3dlci9wb3dl
ci5oICAgICB8ICAzICstLQo+ICBrZXJuZWwvcG93ZXIvc3dhcC5jICAgICAgfCAgMiArLQo+ICAz
IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCj4KPiBkaWZm
IC0tZ2l0IGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jIGIva2VybmVsL3Bvd2VyL2hpYmVybmF0
ZS5jCj4gaW5kZXggMDcyNzk1MDYzNjYyNTUuLjc4Njk2YWEwNGY1Y2EzIDEwMDY0NAo+IC0tLSBh
L2tlcm5lbC9wb3dlci9oaWJlcm5hdGUuYwo+ICsrKyBiL2tlcm5lbC9wb3dlci9oaWJlcm5hdGUu
Ywo+IEBAIC02NCw3ICs2NCw2IEBAIGVudW0gewo+ICBzdGF0aWMgaW50IGhpYmVybmF0aW9uX21v
ZGUgPSBISUJFUk5BVElPTl9TSFVURE9XTjsKPgo+ICBib29sIGZyZWV6ZXJfdGVzdF9kb25lOwo+
IC1ib29sIHNuYXBzaG90X3Rlc3Q7Cj4KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBwbGF0Zm9ybV9o
aWJlcm5hdGlvbl9vcHMgKmhpYmVybmF0aW9uX29wczsKPgo+IEBAIC02ODQsNyArNjgzLDcgQEAg
c3RhdGljIHZvaWQgcG93ZXJfZG93bih2b2lkKQo+ICAgICAgICAgICAgICAgICBjcHVfcmVsYXgo
KTsKPiAgfQo+Cj4gLXN0YXRpYyBpbnQgbG9hZF9pbWFnZV9hbmRfcmVzdG9yZSh2b2lkKQo+ICtz
dGF0aWMgaW50IGxvYWRfaW1hZ2VfYW5kX3Jlc3RvcmUoYm9vbCBzbmFwc2hvdF90ZXN0KQo+ICB7
Cj4gICAgICAgICBpbnQgZXJyb3I7Cj4gICAgICAgICB1bnNpZ25lZCBpbnQgZmxhZ3M7Cj4gQEAg
LTcyMSw2ICs3MjAsNyBAQCBzdGF0aWMgaW50IGxvYWRfaW1hZ2VfYW5kX3Jlc3RvcmUodm9pZCkK
PiAgICovCj4gIGludCBoaWJlcm5hdGUodm9pZCkKPiAgewo+ICsgICAgICAgYm9vbCBzbmFwc2hv
dF90ZXN0ID0gZmFsc2U7Cj4gICAgICAgICB1bnNpZ25lZCBpbnQgc2xlZXBfZmxhZ3M7Cj4gICAg
ICAgICBpbnQgZXJyb3I7Cj4KPiBAQCAtNzQ4LDkgKzc0OCw2IEBAIGludCBoaWJlcm5hdGUodm9p
ZCkKPiAgICAgICAgIGlmIChlcnJvcikKPiAgICAgICAgICAgICAgICAgZ290byBFeGl0Owo+Cj4g
LSAgICAgICAvKiBwcm90ZWN0ZWQgYnkgc3lzdGVtX3RyYW5zaXRpb25fbXV0ZXggKi8KPiAtICAg
ICAgIHNuYXBzaG90X3Rlc3QgPSBmYWxzZTsKPiAtCj4gICAgICAgICBsb2NrX2RldmljZV9ob3Rw
bHVnKCk7Cj4gICAgICAgICAvKiBBbGxvY2F0ZSBtZW1vcnkgbWFuYWdlbWVudCBzdHJ1Y3R1cmVz
ICovCj4gICAgICAgICBlcnJvciA9IGNyZWF0ZV9iYXNpY19tZW1vcnlfYml0bWFwcygpOwo+IEBA
IC03OTIsOSArNzg5LDkgQEAgaW50IGhpYmVybmF0ZSh2b2lkKQo+ICAgICAgICAgdW5sb2NrX2Rl
dmljZV9ob3RwbHVnKCk7Cj4gICAgICAgICBpZiAoc25hcHNob3RfdGVzdCkgewo+ICAgICAgICAg
ICAgICAgICBwbV9wcl9kYmcoIkNoZWNraW5nIGhpYmVybmF0aW9uIGltYWdlXG4iKTsKPiAtICAg
ICAgICAgICAgICAgZXJyb3IgPSBzd3N1c3BfY2hlY2soKTsKPiArICAgICAgICAgICAgICAgZXJy
b3IgPSBzd3N1c3BfY2hlY2soc25hcHNob3RfdGVzdCk7Cj4gICAgICAgICAgICAgICAgIGlmICgh
ZXJyb3IpCj4gLSAgICAgICAgICAgICAgICAgICAgICAgZXJyb3IgPSBsb2FkX2ltYWdlX2FuZF9y
ZXN0b3JlKCk7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgZXJyb3IgPSBsb2FkX2ltYWdlX2Fu
ZF9yZXN0b3JlKHNuYXBzaG90X3Rlc3QpOwo+ICAgICAgICAgfQo+ICAgICAgICAgdGhhd19wcm9j
ZXNzZXMoKTsKPgo+IEBAIC05ODIsOCArOTc5LDYgQEAgc3RhdGljIGludCBzb2Z0d2FyZV9yZXN1
bWUodm9pZCkKPiAgICAgICAgICAqLwo+ICAgICAgICAgbXV0ZXhfbG9ja19uZXN0ZWQoJnN5c3Rl
bV90cmFuc2l0aW9uX211dGV4LCBTSU5HTEVfREVQVEhfTkVTVElORyk7Cj4KPiAtICAgICAgIHNu
YXBzaG90X3Rlc3QgPSBmYWxzZTsKPiAtCj4gICAgICAgICBpZiAoIXN3c3VzcF9yZXN1bWVfZGV2
aWNlKSB7Cj4gICAgICAgICAgICAgICAgIGVycm9yID0gZmluZF9yZXN1bWVfZGV2aWNlKCk7Cj4g
ICAgICAgICAgICAgICAgIGlmIChlcnJvcikKPiBAQCAtOTk0LDcgKzk4OSw3IEBAIHN0YXRpYyBp
bnQgc29mdHdhcmVfcmVzdW1lKHZvaWQpCj4gICAgICAgICAgICAgICAgIE1BSk9SKHN3c3VzcF9y
ZXN1bWVfZGV2aWNlKSwgTUlOT1Ioc3dzdXNwX3Jlc3VtZV9kZXZpY2UpKTsKPgo+ICAgICAgICAg
cG1fcHJfZGJnKCJMb29raW5nIGZvciBoaWJlcm5hdGlvbiBpbWFnZS5cbiIpOwo+IC0gICAgICAg
ZXJyb3IgPSBzd3N1c3BfY2hlY2soKTsKPiArICAgICAgIGVycm9yID0gc3dzdXNwX2NoZWNrKGZh
bHNlKTsKPiAgICAgICAgIGlmIChlcnJvcikKPiAgICAgICAgICAgICAgICAgZ290byBVbmxvY2s7
Cj4KPiBAQCAtMTAyMiw3ICsxMDE3LDcgQEAgc3RhdGljIGludCBzb2Z0d2FyZV9yZXN1bWUodm9p
ZCkKPiAgICAgICAgICAgICAgICAgZ290byBDbG9zZV9GaW5pc2g7Cj4gICAgICAgICB9Cj4KPiAt
ICAgICAgIGVycm9yID0gbG9hZF9pbWFnZV9hbmRfcmVzdG9yZSgpOwo+ICsgICAgICAgZXJyb3Ig
PSBsb2FkX2ltYWdlX2FuZF9yZXN0b3JlKGZhbHNlKTsKPiAgICAgICAgIHRoYXdfcHJvY2Vzc2Vz
KCk7Cj4gICBGaW5pc2g6Cj4gICAgICAgICBwbV9ub3RpZmllcl9jYWxsX2NoYWluKFBNX1BPU1Rf
UkVTVE9SRSk7Cj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9wb3dlci9wb3dlci5oIGIva2VybmVsL3Bv
d2VyL3Bvd2VyLmgKPiBpbmRleCBiODNjOGQ1ZTE4OGRlYy4uOTc4MTg5ZmNhZmQxMjQgMTAwNjQ0
Cj4gLS0tIGEva2VybmVsL3Bvd2VyL3Bvd2VyLmgKPiArKysgYi9rZXJuZWwvcG93ZXIvcG93ZXIu
aAo+IEBAIC01OSw3ICs1OSw2IEBAIGFzbWxpbmthZ2UgaW50IHN3c3VzcF9zYXZlKHZvaWQpOwo+
Cj4gIC8qIGtlcm5lbC9wb3dlci9oaWJlcm5hdGUuYyAqLwo+ICBleHRlcm4gYm9vbCBmcmVlemVy
X3Rlc3RfZG9uZTsKPiAtZXh0ZXJuIGJvb2wgc25hcHNob3RfdGVzdDsKPgo+ICBleHRlcm4gaW50
IGhpYmVybmF0aW9uX3NuYXBzaG90KGludCBwbGF0Zm9ybV9tb2RlKTsKPiAgZXh0ZXJuIGludCBo
aWJlcm5hdGlvbl9yZXN0b3JlKGludCBwbGF0Zm9ybV9tb2RlKTsKPiBAQCAtMTc0LDcgKzE3Myw3
IEBAIGV4dGVybiBpbnQgc3dzdXNwX3N3YXBfaW5fdXNlKHZvaWQpOwo+ICAjZGVmaW5lIFNGX0hX
X1NJRyAgICAgICAgICAgICAgOAo+Cj4gIC8qIGtlcm5lbC9wb3dlci9oaWJlcm5hdGUuYyAqLwo+
IC1leHRlcm4gaW50IHN3c3VzcF9jaGVjayh2b2lkKTsKPiAraW50IHN3c3VzcF9jaGVjayhib29s
IHNuYXBzaG90X3Rlc3QpOwo+ICBleHRlcm4gdm9pZCBzd3N1c3BfZnJlZSh2b2lkKTsKPiAgZXh0
ZXJuIGludCBzd3N1c3BfcmVhZCh1bnNpZ25lZCBpbnQgKmZsYWdzX3ApOwo+ICBleHRlcm4gaW50
IHN3c3VzcF93cml0ZSh1bnNpZ25lZCBpbnQgZmxhZ3MpOwo+IGRpZmYgLS1naXQgYS9rZXJuZWwv
cG93ZXIvc3dhcC5jIGIva2VybmVsL3Bvd2VyL3N3YXAuYwo+IGluZGV4IDkyZTQxZWQyOTJhZGE4
Li5lZmVkMTE1NjhiZmM3MiAxMDA2NDQKPiAtLS0gYS9rZXJuZWwvcG93ZXIvc3dhcC5jCj4gKysr
IGIva2VybmVsL3Bvd2VyL3N3YXAuYwo+IEBAIC0xNTE0LDcgKzE1MTQsNyBAQCBpbnQgc3dzdXNw
X3JlYWQodW5zaWduZWQgaW50ICpmbGFnc19wKQo+ICAgKiAgICAgIHN3c3VzcF9jaGVjayAtIENo
ZWNrIGZvciBzd3N1c3Agc2lnbmF0dXJlIGluIHRoZSByZXN1bWUgZGV2aWNlCj4gICAqLwo+Cj4g
LWludCBzd3N1c3BfY2hlY2sodm9pZCkKPiAraW50IHN3c3VzcF9jaGVjayhib29sIHNuYXBzaG90
X3Rlc3QpCj4gIHsKPiAgICAgICAgIGludCBlcnJvcjsKPiAgICAgICAgIHZvaWQgKmhvbGRlcjsK
PiAtLQo+IDIuMzkuMgo+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

