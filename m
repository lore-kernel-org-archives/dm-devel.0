Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59923EB64D7
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686668212;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DDnzOPJ9vIAQpBPrHGRFIU9Kbc9cpG7QyNxNZaMccjE=;
	b=RPT+CAusB5hk5iBhn8pKYtEctPkpkdjLgGg7zo4j61XHLx8B+rhF0Mv8pD9PZansI03rPD
	48zWbdeyKBfaHGEcyMtw2DwcIukXyJNR9EZyt3VjK/t20ZGVil4DiIe5dBZR7Vt7pTKfNm
	nGgT7IWuwyu8d8LPOpfLsYqfiQdYwvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-wgeHjfnJNTWLR0qSnhq0Pg-1; Tue, 13 Jun 2023 10:56:35 -0400
X-MC-Unique: wgeHjfnJNTWLR0qSnhq0Pg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B992185A7B3;
	Tue, 13 Jun 2023 14:50:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDE08C1604D;
	Tue, 13 Jun 2023 14:50:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 653F01946A44;
	Tue, 13 Jun 2023 14:50:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B51C194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 14:50:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2B3D02166B26; Tue, 13 Jun 2023 14:50:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22FED2166B27
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 14:50:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02AC5382C96E
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 14:50:49 +0000 (UTC)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-Bfn5hZ8DMA2HdHYJB0o5UA-1; Tue, 13 Jun 2023 10:50:47 -0400
X-MC-Unique: Bfn5hZ8DMA2HdHYJB0o5UA-1
Received: by mail-pg1-f197.google.com with SMTP id
 41be03b00d2f7-54fb5dd787aso478864a12.0
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 07:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686667845; x=1689259845;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=ikgXDkZHBsCjzY+A0qkf0lU60eX77I2cT+RYzCffXOs=;
 b=kvFBWMXUF6N57h99dWW2+3ROxkoT3Nr802awl7lbMYyG39gVj/reEyVj3I87fJGu3r
 xsoHLf0RkqokofH12Ng0t7Cn2FPZebgAulntCK4+wV5GezOsv8iAyTpg8vDB4vm5FQZe
 S3omlp1dAsEFkdsxwRq6mlyPH8BQHudR1n5iE4xHFgT6sfOqnfvRtqY0qoyAqRM95jkG
 ZbN2sk6PkTsdR+VykYah4P2bgOhSoMao0IcpU2KC0/2XUiojPDLkt6iMvqeKnwbptX2/
 6cNddrQEfjj/qyB9ZjJP9MQhQUsuLNmCE+z3Irw/s6os1Sc2d7i28D6TpImmhTNyzztP
 Abzg==
X-Gm-Message-State: AC+VfDxnCHl6RGnIPwASHLTPgwYkINGQXM3pURAV7rz43xYxqOLzmsY4
 mqTQl5cPS6Qvgm8h+pUg5MTJ0zIDqEQsWvipPY2QViu9isR0+iOjrHMRyYT+aP52ho64SJ7MGqk
 R2RJQPhOurQx2XPkGGeXVg3cvOtfh
X-Received: by 2002:a17:90a:194:b0:253:2816:2a12 with SMTP id
 20-20020a17090a019400b0025328162a12mr15317181pjc.14.1686667844893; 
 Tue, 13 Jun 2023 07:50:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Bt2CRY2VUetf0DarnAuK1U13D3rFv/ig4TcfKha1cByA48VHNrec0OAISqzDERasKpJFtkw==
X-Received: by 2002:a17:90a:194:b0:253:2816:2a12 with SMTP id
 20-20020a17090a019400b0025328162a12mr15317162pjc.14.1686667844560; 
 Tue, 13 Jun 2023 07:50:44 -0700 (PDT)
Received: from [10.72.13.126] ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id
 g3-20020a17090a3c8300b0024e33c69ee5sm9324231pjc.5.2023.06.13.07.50.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 13 Jun 2023 07:50:44 -0700 (PDT)
Message-ID: <05aa3b09-7bb9-a65a-6231-4707b4b078a0@redhat.com>
Date: Tue, 13 Jun 2023 22:50:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-5-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-5-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
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
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnpgZM6Cj4gRnJvbTogWXUgS3Vh
aSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Cj4gT3VyIHRlc3QgZm91bmQgYSBmb2xsb3dpbmcgZGVh
ZGxvY2sgaW4gcmFpZDEwOgo+Cj4gMSkgSXNzdWUgYSBub3JtYWwgd3JpdGUsIGFuZCBzdWNoIHdy
aXRlIGZhaWxlZDoKPgo+ICAgIHJhaWQxMF9lbmRfd3JpdGVfcmVxdWVzdAo+ICAgICBzZXRfYml0
KFIxMEJJT19Xcml0ZUVycm9yLCAmcjEwX2Jpby0+c3RhdGUpCj4gICAgIG9uZV93cml0ZV9kb25l
Cj4gICAgICByZXNjaGVkdWxlX3JldHJ5Cj4KPiAgICAvLyBsYXRlciBmcm9tIG1kIHRocmVhZAo+
ICAgIHJhaWQxMGQKPiAgICAgaGFuZGxlX3dyaXRlX2NvbXBsZXRlZAo+ICAgICAgbGlzdF9hZGQo
JnIxMF9iaW8tPnJldHJ5X2xpc3QsICZjb25mLT5iaW9fZW5kX2lvX2xpc3QpCj4KPiAgICAvLyBs
YXRlciBmcm9tIG1kIHRocmVhZAo+ICAgIHJhaWQxMGQKPiAgICAgaWYgKCF0ZXN0X2JpdChNRF9T
Ql9DSEFOR0VfUEVORElORywgJm1kZGV2LT5zYl9mbGFncykpCj4gICAgICBsaXN0X21vdmUoY29u
Zi0+YmlvX2VuZF9pb19saXN0LnByZXYsICZ0bXApCj4gICAgICByMTBfYmlvID0gbGlzdF9maXJz
dF9lbnRyeSgmdG1wLCBzdHJ1Y3QgcjEwYmlvLCByZXRyeV9saXN0KQo+ICAgICAgcmFpZF9lbmRf
YmlvX2lvKHIxMF9iaW8pCj4KPiBEZXBlbmRlbmN5IGNoYWluIDE6IG5vcm1hbCBpbyBpcyB3YWl0
aW5nIGZvciB1cGRhdGluZyBzdXBlcmJsb2NrCgpIaSBLdWFpCgpJdCBsb29rcyBsaWtlIHRoZSBh
Ym92ZSBzaXR1YXRpb24gaXMgbW9yZSBjb21wbGV4LiBJdCBvbmx5IG5lZWRzIGEgCm5vcm1hbCB3
cml0ZSBhbmQgbWRfd3JpdGVfc3RhcnQgbmVlZHMgdG8KCndhaXQgdW50aWwgdGhlIG1ldGFkYXRh
IGlzIHdyaXR0ZW4gdG8gbWVtYmVyIGRpc2tzLCByaWdodD8gSWYgc28sIGl0IApkb2Vzbid0IG5l
ZWQgdG8gaW50cm9kdWNlIHJhaWQxMCB3cml0ZSBmYWlsdXJlCgpoZXJlLiBJIGd1ZXNzLCBpdCBz
aG91bGQgYmUgeW91ciB0ZXN0IGNhc2UuIEl0J3MgbmljZSwgaWYgeW91IGNhbiBwdXQgCnlvdXIg
dGVzdCBzdGVwcyBpbiB0aGUgcGF0Y2guIEJ1dCBmb3IgdGhlIGFuYWx5c2lzCgpvZiB0aGUgZGVh
ZGxvY2sgaGVyZSwgaXQncyBiZXR0ZXIgdG8gYmUgc2ltcGxlLgoKPgo+IDIpIFRyaWdnZXIgYSBy
ZWNvdmVyeToKPgo+ICAgIHJhaWQxMF9zeW5jX3JlcXVlc3QKPiAgICAgcmFpc2VfYmFycmllcgo+
Cj4gRGVwZW5kZW5jeSBjaGFpbiAyOiBzeW5jIHRocmVhZCBpcyB3YWl0aW5nIGZvciBub3JtYWwg
aW8KPgo+IDMpIGVjaG8gaWRsZS9mcm96ZW4gdG8gc3luY19hY3Rpb246Cj4KPiAgICBhY3Rpb25f
c3RvcmUKPiAgICAgbWRkZXZfbG9jawo+ICAgICAgbWRfdW5yZWdpc3Rlcl90aHJlYWQKPiAgICAg
ICBrdGhyZWFkX3N0b3AKPgo+IERlcGVuZGVuY3kgY2hhaW4gMzogZHJvcCAncmVjb25maWdfbXV0
ZXgnIGlzIHdhaXRpbmcgZm9yIHN5bmMgdGhyZWFkCj4KPiA0KSBtZCB0aHJlYWQgY2FuJ3QgdXBk
YXRlIHN1cGVyYmxvY2s6Cj4KPiAgICByYWlkMTBkCj4gICAgIG1kX2NoZWNrX3JlY292ZXJ5Cj4g
ICAgICBpZiAobWRkZXZfdHJ5bG9jayhtZGRldikpCj4gICAgICAgbWRfdXBkYXRlX3NiCj4KPiBE
ZXBlbmRlbmN5IGNoYWluIDQ6IHVwZGF0ZSBzdXBlcmJsb2NrIGlzIHdhaXRpbmcgZm9yICdyZWNv
bmZpZ19tdXRleCcKPgo+IEhlbmNlIGN5Y2xpYyBkZXBlbmRlbmN5IGV4aXN0LCBpbiBvcmRlciB0
byBmaXggdGhlIHByb2JsZW0sIHdlIG11c3QKPiBicmVhayBvbmUgb2YgdGhlbS4gRGVwZW5kZW5j
eSAxIGFuZCAyIGNhbid0IGJlIGJyb2tlbiBiZWNhdXNlIHRoZXkgYXJlCj4gZm91bmRhdGlvbiBk
ZXNpZ24uIERlcGVuZGVuY3kgNCBtYXkgYmUgcG9zc2libGUgaWYgaXQgY2FuIGJlIGd1YXJhbnRl
ZWQKPiB0aGF0IG5vIGlvIGNhbiBiZSBpbmZsaWdodCwgaG93ZXZlciwgdGhpcyByZXF1aXJlcyBh
IG5ldyBtZWNoYW5pc20gd2hpY2gKPiBzZWVtcyBjb21wbGV4LiBEZXBlbmRlbmN5IDMgaXMgYSBn
b29kIGNob2ljZSwgYmVjYXVzZSBpZGxlL2Zyb3plbiBvbmx5Cj4gcmVxdWlyZXMgc3luYyB0aHJl
YWQgdG8gZmluaXNoLCB3aGljaCBjYW4gYmUgZG9uZSBhc3luY2hyb25vdXNseSB0aGF0IGlzCj4g
YWxyZWFkeSBpbXBsZW1lbnRlZCwgYW5kICdyZWNvbmZpZ19tdXRleCcgaXMgbm90IG5lZWRlZCBh
bnltb3JlLgo+Cj4gVGhpcyBwYXRjaCBzd2l0Y2ggJ2lkbGUnIGFuZCAnZnJvemVuJyB0byB3YWl0
IHN5bmMgdGhyZWFkIHRvIGJlIGRvbmUKPiBhc3luY2hyb25vdXNseSwgYW5kIHRoaXMgcGF0Y2gg
YWxzbyBhZGQgYSBzZXF1ZW5jZSBjb3VudGVyIHRvIHJlY29yZCBob3cKPiBtYW55IHRpbWVzIHN5
bmMgdGhyZWFkIGlzIGRvbmUsIHNvIHRoYXQgJ2lkbGUnIHdvbid0IGtlZXAgd2FpdGluZyBvbiBu
ZXcKPiBzdGFydGVkIHN5bmMgdGhyZWFkLgoKSW4gdGhlIHBhdGNoLCBzeW5jX3NlcSBpcyBhZGRl
ZCBpbiBtZF9yZWFwX3N5bmNfdGhyZWFkLiBJbiAKaWRsZV9zeW5jX3RocmVhZCwgaWYgc3luY19z
ZXEgaXNuJ3QgZXF1YWwKCm1kZGV2LT5zeW5jX3NlcSwgaXQgc2hvdWxkIG1lYW4gdGhlcmUgaXMg
c29tZW9uZSB0aGF0IHN0b3BzIHRoZSBzeW5jIAp0aHJlYWQgYWxyZWFkeSwgcmlnaHQ/IFdoeSBk
bwoKeW91IHNheSAnbmV3IHN0YXJ0ZWQgc3luYyB0aHJlYWQnIGhlcmU/CgpSZWdhcmRzCgpYaWFv
CgoKPgo+IE5vdGVkIHRoYXQgcmFpZDQ1NiBoYXMgc2ltaWxpYXIgZGVhZGxvY2soWzFdKSwgYW5k
IGl0J3MgdmVyaWZpZWRbMl0gdGhpcwo+IGRlYWRsb2NrIGNhbiBiZSBmaXhlZCBieSB0aGlzIHBh
dGNoIGFzIHdlbGwuCj4KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmFpZC81
ZWQ1NGZmYy1jZTgyLWJmNjYtNGVmZi0zOTBjYjIzYmMxYWNAbW9sZ2VuLm1wZy5kZS9ULyN0Cj4g
WzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXJhaWQvZTkwNjc0MzgtZDcxMy1mNWYz
LTBkM2QtOWU2YjBlOWVmYTBlQGh1YXdlaWNsb3VkLmNvbS8KPiBTaWduZWQtb2ZmLWJ5OiBZdSBL
dWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL21kLmMgfCAyMyAr
KysrKysrKysrKysrKysrKysrLS0tLQo+ICAgZHJpdmVycy9tZC9tZC5oIHwgIDIgKysKPiAgIDIg
ZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPgo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPiBpbmRleCA2M2E5OTNi
NTJjZDcuLjc5MTJkZTBlNGQxMiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL21kLmMKPiArKysg
Yi9kcml2ZXJzL21kL21kLmMKPiBAQCAtNjUyLDYgKzY1Miw3IEBAIHZvaWQgbWRkZXZfaW5pdChz
dHJ1Y3QgbWRkZXYgKm1kZGV2KQo+ICAgCXRpbWVyX3NldHVwKCZtZGRldi0+c2FmZW1vZGVfdGlt
ZXIsIG1kX3NhZmVtb2RlX3RpbWVvdXQsIDApOwo+ICAgCWF0b21pY19zZXQoJm1kZGV2LT5hY3Rp
dmUsIDEpOwo+ICAgCWF0b21pY19zZXQoJm1kZGV2LT5vcGVuZXJzLCAwKTsKPiArCWF0b21pY19z
ZXQoJm1kZGV2LT5zeW5jX3NlcSwgMCk7Cj4gICAJc3Bpbl9sb2NrX2luaXQoJm1kZGV2LT5sb2Nr
KTsKPiAgIAlhdG9taWNfc2V0KCZtZGRldi0+Zmx1c2hfcGVuZGluZywgMCk7Cj4gICAJaW5pdF93
YWl0cXVldWVfaGVhZCgmbWRkZXYtPnNiX3dhaXQpOwo+IEBAIC00Nzc2LDE5ICs0Nzc3LDI3IEBA
IHN0YXRpYyB2b2lkIHN0b3Bfc3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPiAgIAlp
ZiAod29ya19wZW5kaW5nKCZtZGRldi0+ZGVsX3dvcmspKQo+ICAgCQlmbHVzaF93b3JrcXVldWUo
bWRfbWlzY193cSk7Cj4gICAKPiAtCWlmIChtZGRldi0+c3luY190aHJlYWQpIHsKPiAtCQlzZXRf
Yml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpOwo+IC0JCW1kX3JlYXBfc3lu
Y190aHJlYWQobWRkZXYpOwo+IC0JfQo+ICsJc2V0X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRk
ZXYtPnJlY292ZXJ5KTsKPiArCS8qCj4gKwkgKiBUaHJlYWQgbWlnaHQgYmUgYmxvY2tlZCB3YWl0
aW5nIGZvciBtZXRhZGF0YSB1cGRhdGUgd2hpY2ggd2lsbCBub3cKPiArCSAqIG5ldmVyIGhhcHBl
bgo+ICsJICovCj4gKwltZF93YWtldXBfdGhyZWFkX2RpcmVjdGx5KG1kZGV2LT5zeW5jX3RocmVh
ZCk7Cj4gICAKPiAgIAltZGRldl91bmxvY2sobWRkZXYpOwo+ICAgfQo+ICAgCj4gICBzdGF0aWMg
dm9pZCBpZGxlX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gICB7Cj4gKwlpbnQg
c3luY19zZXEgPSBhdG9taWNfcmVhZCgmbWRkZXYtPnN5bmNfc2VxKTsKPiArCj4gICAJbXV0ZXhf
bG9jaygmbWRkZXYtPnN5bmNfbXV0ZXgpOwo+ICAgCWNsZWFyX2JpdChNRF9SRUNPVkVSWV9GUk9a
RU4sICZtZGRldi0+cmVjb3ZlcnkpOwo+ICAgCXN0b3Bfc3luY190aHJlYWQobWRkZXYpOwo+ICsK
PiArCXdhaXRfZXZlbnQocmVzeW5jX3dhaXQsIHN5bmNfc2VxICE9IGF0b21pY19yZWFkKCZtZGRl
di0+c3luY19zZXEpIHx8Cj4gKwkJCSF0ZXN0X2JpdChNRF9SRUNPVkVSWV9SVU5OSU5HLCAmbWRk
ZXYtPnJlY292ZXJ5KSk7Cj4gKwo+ICAgCW11dGV4X3VubG9jaygmbWRkZXYtPnN5bmNfbXV0ZXgp
Owo+ICAgfQo+ICAgCj4gQEAgLTQ3OTcsNiArNDgwNiwxMCBAQCBzdGF0aWMgdm9pZCBmcm96ZW5f
c3luY190aHJlYWQoc3RydWN0IG1kZGV2ICptZGRldikKPiAgIAltdXRleF9pbml0KCZtZGRldi0+
ZGVsZXRlX211dGV4KTsKPiAgIAlzZXRfYml0KE1EX1JFQ09WRVJZX0ZST1pFTiwgJm1kZGV2LT5y
ZWNvdmVyeSk7Cj4gICAJc3RvcF9zeW5jX3RocmVhZChtZGRldik7Cj4gKwo+ICsJd2FpdF9ldmVu
dChyZXN5bmNfd2FpdCwgbWRkZXYtPnN5bmNfdGhyZWFkID09IE5VTEwgJiYKPiArCQkJIXRlc3Rf
Yml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpKTsKPiArCj4gICAJbXV0
ZXhfdW5sb2NrKCZtZGRldi0+c3luY19tdXRleCk7Cj4gICB9Cj4gICAKPiBAQCAtOTQ3Miw2ICs5
NDg1LDggQEAgdm9pZCBtZF9yZWFwX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4g
ICAKPiAgIAkvKiByZXN5bmMgaGFzIGZpbmlzaGVkLCBjb2xsZWN0IHJlc3VsdCAqLwo+ICAgCW1k
X3VucmVnaXN0ZXJfdGhyZWFkKCZtZGRldi0+c3luY190aHJlYWQpOwo+ICsJYXRvbWljX2luYygm
bWRkZXYtPnN5bmNfc2VxKTsKPiArCj4gICAJaWYgKCF0ZXN0X2JpdChNRF9SRUNPVkVSWV9JTlRS
LCAmbWRkZXYtPnJlY292ZXJ5KSAmJgo+ICAgCSAgICAhdGVzdF9iaXQoTURfUkVDT1ZFUllfUkVR
VUVTVEVELCAmbWRkZXYtPnJlY292ZXJ5KSAmJgo+ICAgCSAgICBtZGRldi0+ZGVncmFkZWQgIT0g
bWRkZXYtPnJhaWRfZGlza3MpIHsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5oIGIvZHJp
dmVycy9tZC9tZC5oCj4gaW5kZXggMmZhOTAzZGU1YmQwLi43Y2FiOWM3YzQ1YjggMTAwNjQ0Cj4g
LS0tIGEvZHJpdmVycy9tZC9tZC5oCj4gKysrIGIvZHJpdmVycy9tZC9tZC5oCj4gQEAgLTUzOSw2
ICs1MzksOCBAQCBzdHJ1Y3QgbWRkZXYgewo+ICAgCj4gICAJLyogVXNlZCB0byBzeW5jaHJvbml6
ZSBpZGxlIGFuZCBmcm96ZW4gZm9yIGFjdGlvbl9zdG9yZSgpICovCj4gICAJc3RydWN0IG11dGV4
CQkJc3luY19tdXRleDsKPiArCS8qIFRoZSBzZXF1ZW5jZSBudW1iZXIgZm9yIHN5bmMgdGhyZWFk
ICovCj4gKwlhdG9taWNfdCBzeW5jX3NlcTsKPiAgIAo+ICAgCWJvb2wJaGFzX3N1cGVyYmxvY2tz
OjE7Cj4gICAJYm9vbAlmYWlsX2xhc3RfZGV2OjE7CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

