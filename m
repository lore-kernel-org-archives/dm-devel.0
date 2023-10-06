Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69BDE92FD4
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 02:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696559185;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QuRQaBpJkCWwAtG5b6L83O/PormI5KfOvdXooqR9OXU=;
	b=ZUy0FF/zJ8GcA7flAh8NfnzDPwX65Oec0E4UIgMBb1ja2odsCiX1ZJAVQpUfJB8KGGz7Xy
	yuGTgtIN9gbZogjOsxOAoXqO0cAyL3M6RwCJMUZ1PtlBa6WbLnVYCA9LKIRfNuJrJcFQ6K
	VTvOfbzT8SXcCvbtlQQz/xgZmO1yAtg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-04Q42z23N96r6fybweecxw-1; Thu, 05 Oct 2023 22:26:22 -0400
X-MC-Unique: 04Q42z23N96r6fybweecxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6B97185A78E;
	Fri,  6 Oct 2023 02:26:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 408E4140E953;
	Fri,  6 Oct 2023 02:26:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BAC6019465A2;
	Fri,  6 Oct 2023 02:26:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 248F5194658F
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Oct 2023 02:26:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E509DC154CB; Fri,  6 Oct 2023 02:26:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD761C15BB8
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 02:26:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDBC0381170D
 for <dm-devel@redhat.com>; Fri,  6 Oct 2023 02:26:18 +0000 (UTC)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com
 [209.85.222.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-0RmuDshuObK4VVsr4DFJ_g-1; Thu, 05 Oct 2023 22:26:17 -0400
X-MC-Unique: 0RmuDshuObK4VVsr4DFJ_g-1
Received: by mail-qk1-f181.google.com with SMTP id
 af79cd13be357-773ac11de71so98719385a.2
 for <dm-devel@redhat.com>; Thu, 05 Oct 2023 19:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696559176; x=1697163976;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=FfXO766UylwaXpVj/Oq96aej9C9Ew70cll8S/lw9EnM=;
 b=tIqUPmFyQJ7xYM2iKFRqoChJA904gRBjm4cEISl8+Fus6SSsR6tv3UwxEQkCc3KwZl
 8dMNIg7aHvxcLkLh5j+ucxzkeDkORNLvsVLnzku+5E/lhn+xYmegX7tzmENmvvo7xYlL
 jc1nY9qY+ltX0phBPrIPB4dm29Sho2usQx1PhQBbg6werFdvigKH5RCER5c9nsWxC4Cj
 nIWuf7AqUDyrDU2iyB9Fj2npSoqKRaoKKTS0ww+TDXYCty3iKJ9DiqPkjArJQlOGf8Cs
 qVD0lzbrYAMD8+eJ1Nizf8g8lL0cd0+kAHpRC1xS/HN6MZXBOFt+Kls0so/SdeXhavKr
 8oXA==
X-Gm-Message-State: AOJu0YzoYTsiMFUjXr3WBaDd23IFrxEAM3N5VDTGNofKVGvnhVy5spcx
 sRUmvTjyZZi5gbbZXDJh7t1e+bQ=
X-Google-Smtp-Source: AGHT+IEbnZ5An5rfeR8TQKTpHfEHRlPnV15GqqvAmbaV4MRtIXV55yHwkiIiw6qRvj6rDgqFs1thjQ==
X-Received: by 2002:a05:620a:c54:b0:773:c6a1:a4ce with SMTP id
 u20-20020a05620a0c5400b00773c6a1a4cemr7691743qki.36.1696559176408; 
 Thu, 05 Oct 2023 19:26:16 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 du33-20020a05620a47e100b0076db1caab16sm948320qkb.22.2023.10.05.19.26.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 Oct 2023 19:26:15 -0700 (PDT)
Date: Thu, 5 Oct 2023 22:26:14 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <ZR9wRq7Rkz+LocDX@redhat.com>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me> <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
MIME-Version: 1.0
In-Reply-To: <ZR9l446ndB4n1Xl4@gondor.apana.org.au>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] dm crypt: Fix reqsize in crypt_iv_eboiv_gen
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
Cc: Linux Regressions <regressions@lists.linux.dev>,
 Tatu =?iso-8859-1?Q?Heikkil=E4?= <tatu.heikkila@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Device Mapper <dm-devel@redhat.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBPY3QgMDUgMjAyMyBhdCAgOTo0MVAgLTA0MDAsCkhlcmJlcnQgWHUgPGhlcmJlcnRA
Z29uZG9yLmFwYW5hLm9yZy5hdT4gd3JvdGU6Cgo+IE9uIEZyaSwgT2N0IDA2LCAyMDIzIGF0IDA4
OjA0OjE4QU0gKzA3MDAsIEJhZ2FzIFNhbmpheWEgd3JvdGU6Cj4gPgo+ID4gPiBHaXQgYmlzZWN0
IGxlYWQgbWUgdG86Cj4gPiA+ICMgZmlyc3QgYmFkIGNvbW1pdDogW2UzMDIzMDk0ZGZmYjQxNTQw
MzMwZmIwYzc0Y2QzYTAxOWNkNTI1YzJdIGRtIGNyeXB0Ogo+ID4gPiBBdm9pZCB1c2luZyBNQVhf
Q0lQSEVSX0JMT0NLU0laRQo+ID4gPiAKPiA+ID4gSWYgSSBnaXQgcmV2ZXJ0IGUzMDIzMDk0ZGZm
YjQxNTQwMzMwZmIwYzc0Y2QzYTAxOWNkNTI1YzIgb24gY3VycmVudCBMaW51cycKPiA+ID4gZ2l0
IG1hc3RlciwgdGhlIGlzc3VlIGdvZXMgYXdheS4gU28gSSdtIHBlcnNvbmFsbHkgbm90IGFsbCB0
aGF0IGFmZmVjdGVkCj4gPiA+IGFueW1vcmUgKGlmIEknbSByZWFkeSB0byBjb21waWxlIG15IGtl
cm5lbHMgZnJvbSBub3cgb24pLCBhbmQgSSB1bmRlcnN0YW5kCj4gPiA+IHRoYXQgeW91IGhhdmUg
bm8gY2xlYXIgd2F5IHRvIHJlcHJvZHVjZSB0aGlzIGFzIGl0IHNlZW1zIHN0cm9uZ2x5IGJvdW5k
IHRvCj4gPiA+IGhhcmR3YXJlLCBidXQgc2VlbXMgbGlrZSB0aGlzIGNvdWxkIHBvaW50IHRvIGEg
cG90ZW50aWFsbHkgc2VyaW91cyBzZWN1cml0eQo+ID4gPiBpc3N1ZSBzaW5jZSBpdCBpbnZvbHZl
cyBib3RoIGNyeXB0byBhbmQgdW5kZWZpbmVkIGJlaGF2aW91ci4KPiAKPiBUaGFua3MgZm9yIHRo
ZSByZXBvcnQuICBTb3JyeSB0aGlzIGlzIGluZGVlZCBteSBmYXVsdC4gIFRoZSBhbGxvY2F0ZWQK
PiBidWZmZXIgaXMgdG9vIHNtYWxsIGFzIGl0J3MgbWlzc2luZyB0aGUgc2l6ZSBmb3IgdGhlIHJl
cXVlc3Qgb2JqZWN0Cj4gaXRzZWxmLgo+IAo+IE1pa2UsIHdvdWxkIHlvdSBiZSBPSyB3aXRoIG1l
IHBpY2tpbmcgdGhpcyBmaXggdXAgYW5kIHB1c2hpbmcgaXQgdG8KPiBMaW51cz8KPiAKPiBDaGVl
cnMsCj4gCj4gLS0tODwtLS0KPiBBIHNrY2lwaGVyX3JlcXVlc3Qgb2JqZWN0IGlzIG1hZGUgdXAg
b2Ygc3RydWN0IHNrY2lwaGVyX3JlcXVlc3QKPiBmb2xsb3dlZCBieSBhIHZhcmlhYmxlLXNpemVk
IHRyYWlsZXIuICBUaGUgYWxsb2NhdGlvbiBvZiB0aGUKPiBza2NpcGhlcl9yZXF1ZXN0IGFuZCBJ
ViBpbiBjcnlwdF9pdl9lYm9pdl9nZW4gaXMgbWlzc2luZyB0aGUKPiBtZW1vcnkgZm9yIHN0cnVj
dCBza2NpcGhlcl9yZXF1ZXN0LiAgRml4IGl0IGJ5IGFkZGluZyBpdCB0bwo+IHJlcXNpemUuCj4g
Cj4gRml4ZXM6IGUzMDIzMDk0ZGZmYiAoImRtIGNyeXB0OiBBdm9pZCB1c2luZyBNQVhfQ0lQSEVS
X0JMT0NLU0laRSIpCj4gUmVwb3J0ZWQtYnk6IFRhdHUgSGVpa2tpbO+/vSA8dGF0dS5oZWlra2ls
YUBnbWFpbC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3Iu
YXBhbmEub3JnLmF1Pgo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWNyeXB0LmMgYi9k
cml2ZXJzL21kL2RtLWNyeXB0LmMKPiBpbmRleCBmMjY2MmMyMWE2ZGYuLjUzMTVmZDI2MWMyMyAx
MDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPiArKysgYi9kcml2ZXJzL21kL2Rt
LWNyeXB0LmMKPiBAQCAtNzUzLDcgKzc1Myw4IEBAIHN0YXRpYyBpbnQgY3J5cHRfaXZfZWJvaXZf
Z2VuKHN0cnVjdCBjcnlwdF9jb25maWcgKmNjLCB1OCAqaXYsCj4gIAlpbnQgZXJyOwo+ICAJdTgg
KmJ1ZjsKPiAgCj4gLQlyZXFzaXplID0gQUxJR04oY3J5cHRvX3NrY2lwaGVyX3JlcXNpemUodGZt
KSwgX19hbGlnbm9mX18oX19sZTY0KSk7Cj4gKwlyZXFzaXplID0gc2l6ZW9mKCpyZXEpICsgY3J5
cHRvX3NrY2lwaGVyX3JlcXNpemUodGZtKTsKPiArCXJlcXNpemUgPSBBTElHTihyZXFzaXplLCBf
X2FsaWdub2ZfXyhfX2xlNjQpKTsKPiAgCj4gIAlyZXEgPSBrbWFsbG9jKHJlcXNpemUgKyBjYy0+
aXZfc2l6ZSwgR0ZQX05PSU8pOwo+ICAJaWYgKCFyZXEpCgpTdXJlLCBwbGVhc2UgZG8uICBTaG91
bGRuJ3QgeW91ciBoZWFkZXIgQ2M6IHN0YWJsZSBnaXZlbiB0aGF0IHRoZQpGaXhlcyBjb21taXQg
aW1wbGllcyB2Ni41IG5lZWRzIHRoaXMgZml4PwoKKHNvcnJ5IEkgbWlzc2VkIHRoaXMgdGhlIGZp
cnN0IHRpbWUgSSAnUmV2aWV3ZWQtYnknIHRoZSBvcmlnaW5hbApjb21taXQpCgpSZXZpZXdlZC1i
eTogTWlrZSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAa2VybmVsLm9yZz4KClRoYW5rcywKTWlrZQoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

