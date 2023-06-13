Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3B0C7EE29
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jun 2023 06:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686637560;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mV4fiox5r2qdB4mWKGwt1fx8L0elRsrKuvyrbjJg29E=;
	b=EL3gIh1chMHzD8h9FwZSza/ZjPJ+7hxVT3qMIA0vugMhVX8evSzlIXKzP5g75g37+HjrKk
	mUtkG9TTLoKh0Ni0Ytp2oO4ErWbdpyLER5LSfBgC5hll3Jc6rbarfEyPZbm/j2gPO+7RG1
	QjnpnDww3HMtbFb8uxhEg/5+K1P0rm4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-hTvsETN3PG-XxtjFyJGl1A-1; Tue, 13 Jun 2023 02:25:57 -0400
X-MC-Unique: hTvsETN3PG-XxtjFyJGl1A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED53811E7C;
	Tue, 13 Jun 2023 06:25:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A211492C1B;
	Tue, 13 Jun 2023 06:25:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A3DA119465BA;
	Tue, 13 Jun 2023 06:25:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E2ADF194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Jun 2023 06:25:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DE05C1604F; Tue, 13 Jun 2023 06:25:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 765D2C1604D
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 06:25:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56E343801FEE
 for <dm-devel@redhat.com>; Tue, 13 Jun 2023 06:25:49 +0000 (UTC)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-HS7egth7MqyB-Bqnxz6Ghw-1; Tue, 13 Jun 2023 02:25:48 -0400
X-MC-Unique: HS7egth7MqyB-Bqnxz6Ghw-1
Received: by mail-pf1-f197.google.com with SMTP id
 d2e1a72fcca58-653bbc6e2fdso2874291b3a.0
 for <dm-devel@redhat.com>; Mon, 12 Jun 2023 23:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686637547; x=1689229547;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=Dk4w/dlhnM14+5Pc/Gjm/pjDzAHKz0WKmVblyd15aqY=;
 b=YSmTOtnCcI3m7QpgUKz4mSDzP0u3DC80Fz2o4rtKGZkGu8lafXa/sA53kQacuM6lpq
 JWc6l395qLteZrwBjHpugkUvJQZJVR4R41NzPvVs2t9rc+bDoNLme73Q4CvOObYKhBwL
 i9IbN1fBEuVEET9e5JB4Gl9mPn+u/s9+EsecHjN7gSVG1FhMh3U8UaWdr4+PTfWOeWpU
 +Xm4X5Ht0ey5hqbZ/8hpi6ziy7WyOfOXt+zgJSEC0+7lwOyPAT9LHHOtbPVCzt5Cd8Am
 BWePVxxBLJQ8yNc020aAfe3LerPoeVBqBnOcLvuExIJ2ncZElzcAv+aTLDLqgDngvcPq
 y35Q==
X-Gm-Message-State: AC+VfDwvE0bzI5Dz4Efwnl+WU48PZjVlw5N0mM5n5awXMLQIPlfc5Vaa
 ji5F8cgHswbRfY1EeXG8+Qfx/8y3KpUIzhJ+UwDw/SYH/9RLbAE5wsyobcfOdOUMO0vNwloNus2
 +HogLtAYrbIcyfDg=
X-Received: by 2002:a05:6a20:a5a8:b0:10b:6b1f:c8c8 with SMTP id
 bc40-20020a056a20a5a800b0010b6b1fc8c8mr9951062pzb.31.1686637547090; 
 Mon, 12 Jun 2023 23:25:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4u3LPIN5hkek6lUp2dJz1pyTMTONqTlT2y5JtlLRtJ1OFqReJODea6RGuFRUGvABTUi5JnGQ==
X-Received: by 2002:a05:6a20:a5a8:b0:10b:6b1f:c8c8 with SMTP id
 bc40-20020a056a20a5a800b0010b6b1fc8c8mr9951043pzb.31.1686637546719; 
 Mon, 12 Jun 2023 23:25:46 -0700 (PDT)
Received: from [10.72.13.126] ([43.228.180.230])
 by smtp.gmail.com with ESMTPSA id
 a10-20020aa780ca000000b00640f1e4a811sm7868913pfn.22.2023.06.12.23.25.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 12 Jun 2023 23:25:46 -0700 (PDT)
Message-ID: <2d9f34b1-48e1-73a7-8548-bfd1843d3a0a@redhat.com>
Date: Tue, 13 Jun 2023 14:25:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
To: Yu Kuai <yukuai1@huaweicloud.com>, guoqing.jiang@linux.dev,
 agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20230529132037.2124527-2-yukuai1@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH -next v2 1/6] Revert "md: unlock mddev before
 reap sync_thread in action_store"
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CuWcqCAyMDIzLzUvMjkg5LiL5Y2IOToyMCwgWXUgS3VhaSDlhpnpgZM6Cj4gRnJvbTogWXUgS3Vh
aSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+Cj4gVGhpcyByZXZlcnRzIGNvbW1pdCA5ZGZiZGFmZGEz
YjM0ZTI2MmU0M2U3ODYwNzdiYWI4ZTQ3NmE4OWQxLgo+Cj4gQmVjYXVzZSBpdCB3aWxsIGludHJv
ZHVjZSBhIGRlZmVjdCB0aGF0IHN5bmNfdGhyZWFkIGNhbiBiZSBydW5uaW5nIHdoaWxlCj4gTURf
UkVDT1ZFUllfUlVOTklORyBpcyBjbGVhcmVkLCB3aGljaCB3aWxsIGNhdXNlIHNvbWUgdW5leHBl
Y3RlZCBwcm9ibGVtcywKPiBmb3IgZXhhbXBsZToKPgo+IGxpc3RfYWRkIGNvcnJ1cHRpb24uIHBy
ZXYtPm5leHQgc2hvdWxkIGJlIG5leHQgKGZmZmYwMDAxYWMxZGFiYTApLCBidXQgd2FzIGZmZmYw
MDAwY2UxYTAyYTAuIChwcmV2PWZmZmYwMDAwY2UxYTAyYTApLgo+IENhbGwgdHJhY2U6Cj4gICBf
X2xpc3RfYWRkX3ZhbGlkKzB4ZmMvMHgxNDAKPiAgIGluc2VydF93b3JrKzB4NzgvMHgxYTAKPiAg
IF9fcXVldWVfd29yaysweDUwMC8weGNmNAo+ICAgcXVldWVfd29ya19vbisweGU4LzB4MTJjCj4g
ICBtZF9jaGVja19yZWNvdmVyeSsweGEzNC8weGYzMAo+ICAgcmFpZDEwZCsweGI4LzB4OTAwIFty
YWlkMTBdCj4gICBtZF90aHJlYWQrMHgxNmMvMHgyY2MKPiAgIGt0aHJlYWQrMHgxYTQvMHgxZWMK
PiAgIHJldF9mcm9tX2ZvcmsrMHgxMC8weDE4Cj4KPiBUaGlzIGlzIGJlY2F1c2Ugd29yayBpcyBy
ZXF1ZXVlZCB3aGlsZSBpdCdzIHN0aWxsIGluc2lkZSB3b3JrcXVldWU6Cj4KPiB0MToJCQl0MjoK
PiBhY3Rpb25fc3RvcmUKPiAgIG1kZGV2X2xvY2sKPiAgICBpZiAobWRkZXYtPnN5bmNfdGhyZWFk
KQo+ICAgICBtZGRldl91bmxvY2sKPiAgICAgbWRfdW5yZWdpc3Rlcl90aHJlYWQKPiAgICAgLy8g
Zmlyc3Qgc3luY190aHJlYWQgaXMgZG9uZQo+IAkJCW1kX2NoZWNrX3JlY292ZXJ5Cj4gCQkJIG1k
ZGV2X3RyeV9sb2NrCj4gCQkJIC8qCj4gCQkJICAqIG9uY2UgTURfUkVDT1ZFUllfRE9ORSBpcyBz
ZXQsIG5ldyBzeW5jX3RocmVhZAo+IAkJCSAgKiBjYW4gc3RhcnQuCj4gCQkJICAqLwo+IAkJCSBz
ZXRfYml0KE1EX1JFQ09WRVJZX1JVTk5JTkcsICZtZGRldi0+cmVjb3ZlcnkpCj4gCQkJIElOSVRf
V09SSygmbWRkZXYtPmRlbF93b3JrLCBtZF9zdGFydF9zeW5jKQo+IAkJCSBxdWV1ZV93b3JrKG1k
X21pc2Nfd3EsICZtZGRldi0+ZGVsX3dvcmspCj4gCQkJICB0ZXN0X2FuZF9zZXRfYml0KFdPUktf
U1RSVUNUX1BFTkRJTkdfQklULCAuLi4pCj4gCQkJICAvLyBzZXQgcGVuZGluZyBiaXQKPiAJCQkg
IGluc2VydF93b3JrCj4gCQkJICAgbGlzdF9hZGRfdGFpbAo+IAkJCSBtZGRldl91bmxvY2sKPiAg
ICAgbWRkZXZfbG9ja19ub2ludHIKPiAgICAgbWRfcmVhcF9zeW5jX3RocmVhZAo+ICAgICAvLyBN
RF9SRUNPVkVSWV9SVU5OSU5HIGlzIGNsZWFyZWQKPiAgIG1kZGV2X3VubG9jawo+Cj4gdDM6Cj4K
PiAvLyBiZWZvcmUgcXVldWVkIHdvcmsgc3RhcnRlZCBmcm9tIHQyCj4gbWRfY2hlY2tfcmVjb3Zl
cnkKPiAgIC8vIE1EX1JFQ09WRVJZX1JVTk5JTkcgaXMgbm90IHNldCwgYSBuZXcgc3luY190aHJl
YWQgY2FuIGJlIHN0YXJ0ZWQKPiAgIElOSVRfV09SSygmbWRkZXYtPmRlbF93b3JrLCBtZF9zdGFy
dF9zeW5jKQo+ICAgIHdvcmstPmRhdGEgPSAwCj4gICAgLy8gd29yayBwZW5kaW5nIGJpdCBpcyBj
bGVhcmVkCj4gICBxdWV1ZV93b3JrKG1kX21pc2Nfd3EsICZtZGRldi0+ZGVsX3dvcmspCj4gICAg
aW5zZXJ0X3dvcmsKPiAgICAgbGlzdF9hZGRfdGFpbAo+ICAgICAvLyBsaXN0IGlzIGNvcnJ1cHRl
ZAo+Cj4gVGhlIGFib3ZlIGNvbW1pdCBpcyByZXZlcnRlZCB0byBmaXggdGhlIHByb2JsZW0sIHRo
ZSBkZWFkbG9jayB0aGlzCj4gY29tbWl0IHRyaWVzIHRvIGZpeCB3aWxsIGJlIGZpeGVkIGluIGZv
bGxvd2luZyBwYXRjaGVzLgo+Cj4gU2lnbmVkLW9mZi1ieTogWXUgS3VhaSA8eXVrdWFpM0BodWF3
ZWkuY29tPgo+IC0tLQo+ICAgZHJpdmVycy9tZC9kbS1yYWlkLmMgfCAgMSAtCj4gICBkcml2ZXJz
L21kL21kLmMgICAgICB8IDE5ICsrLS0tLS0tLS0tLS0tLS0tLS0KPiAgIDIgZmlsZXMgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL21kL2RtLXJhaWQuYyBiL2RyaXZlcnMvbWQvZG0tcmFpZC5jCj4gaW5kZXggODg0NmJmNTEw
YTM1Li4xZjIyYmVmMjc4NDEgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9kbS1yYWlkLmMKPiAr
KysgYi9kcml2ZXJzL21kL2RtLXJhaWQuYwo+IEBAIC0zNzI1LDcgKzM3MjUsNiBAQCBzdGF0aWMg
aW50IHJhaWRfbWVzc2FnZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgaW50IGFyZ2Ms
IGNoYXIgKiphcmd2LAo+ICAgCWlmICghc3RyY2FzZWNtcChhcmd2WzBdLCAiaWRsZSIpIHx8ICFz
dHJjYXNlY21wKGFyZ3ZbMF0sICJmcm96ZW4iKSkgewo+ICAgCQlpZiAobWRkZXYtPnN5bmNfdGhy
ZWFkKSB7Cj4gICAJCQlzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3Zlcnkp
Owo+IC0JCQltZF91bnJlZ2lzdGVyX3RocmVhZCgmbWRkZXYtPnN5bmNfdGhyZWFkKTsKPiAgIAkJ
CW1kX3JlYXBfc3luY190aHJlYWQobWRkZXYpOwo+ICAgCQl9Cj4gICAJfSBlbHNlIGlmIChkZWNp
cGhlcl9zeW5jX2FjdGlvbihtZGRldiwgbWRkZXYtPnJlY292ZXJ5KSAhPSBzdF9pZGxlKQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPiBpbmRleCBhNWE3
YWYyZjRlNTkuLjliOTc3MzFlMWZlNCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL21kLmMKPiAr
KysgYi9kcml2ZXJzL21kL21kLmMKPiBAQCAtNDc3MiwxOSArNDc3Miw2IEBAIGFjdGlvbl9zdG9y
ZShzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjb25zdCBjaGFyICpwYWdlLCBzaXplX3QgbGVuKQo+ICAg
CQkJaWYgKHdvcmtfcGVuZGluZygmbWRkZXYtPmRlbF93b3JrKSkKPiAgIAkJCQlmbHVzaF93b3Jr
cXVldWUobWRfbWlzY193cSk7Cj4gICAJCQlpZiAobWRkZXYtPnN5bmNfdGhyZWFkKSB7Cj4gLQkJ
CQlzZWN0b3JfdCBzYXZlX3JwID0gbWRkZXYtPnJlc2hhcGVfcG9zaXRpb247Cj4gLQo+IC0JCQkJ
bWRkZXZfdW5sb2NrKG1kZGV2KTsKPiAtCQkJCXNldF9iaXQoTURfUkVDT1ZFUllfSU5UUiwgJm1k
ZGV2LT5yZWNvdmVyeSk7Cj4gLQkJCQltZF91bnJlZ2lzdGVyX3RocmVhZCgmbWRkZXYtPnN5bmNf
dGhyZWFkKTsKPiAtCQkJCW1kZGV2X2xvY2tfbm9pbnRyKG1kZGV2KTsKPiAtCQkJCS8qCj4gLQkJ
CQkgKiBzZXQgUkVDT1ZFUllfSU5UUiBhZ2FpbiBhbmQgcmVzdG9yZSByZXNoYXBlCj4gLQkJCQkg
KiBwb3NpdGlvbiBpbiBjYXNlIG90aGVycyBjaGFuZ2VkIHRoZW0gYWZ0ZXIKPiAtCQkJCSAqIGdv
dCBsb2NrLCBlZywgcmVzaGFwZV9wb3NpdGlvbl9zdG9yZSBhbmQKPiAtCQkJCSAqIG1kX2NoZWNr
X3JlY292ZXJ5Lgo+IC0JCQkJICovCj4gLQkJCQltZGRldi0+cmVzaGFwZV9wb3NpdGlvbiA9IHNh
dmVfcnA7Cj4gICAJCQkJc2V0X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRkZXYtPnJlY292ZXJ5
KTsKPiAgIAkJCQltZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPiAgIAkJCX0KPiBAQCAtNjE4
NCw3ICs2MTcxLDYgQEAgc3RhdGljIHZvaWQgX19tZF9zdG9wX3dyaXRlcyhzdHJ1Y3QgbWRkZXYg
Km1kZGV2KQo+ICAgCQlmbHVzaF93b3JrcXVldWUobWRfbWlzY193cSk7Cj4gICAJaWYgKG1kZGV2
LT5zeW5jX3RocmVhZCkgewo+ICAgCQlzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+
cmVjb3ZlcnkpOwo+IC0JCW1kX3VucmVnaXN0ZXJfdGhyZWFkKCZtZGRldi0+c3luY190aHJlYWQp
Owo+ICAgCQltZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPiAgIAl9Cj4gICAKPiBAQCAtOTMz
Niw3ICs5MzIyLDYgQEAgdm9pZCBtZF9jaGVja19yZWNvdmVyeShzdHJ1Y3QgbWRkZXYgKm1kZGV2
KQo+ICAgCQkJICogLT5zcGFyZV9hY3RpdmUgYW5kIGNsZWFyIHNhdmVkX3JhaWRfZGlzawo+ICAg
CQkJICovCj4gICAJCQlzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3Zlcnkp
Owo+IC0JCQltZF91bnJlZ2lzdGVyX3RocmVhZCgmbWRkZXYtPnN5bmNfdGhyZWFkKTsKPiAgIAkJ
CW1kX3JlYXBfc3luY190aHJlYWQobWRkZXYpOwo+ICAgCQkJY2xlYXJfYml0KE1EX1JFQ09WRVJZ
X1JFQ09WRVIsICZtZGRldi0+cmVjb3ZlcnkpOwo+ICAgCQkJY2xlYXJfYml0KE1EX1JFQ09WRVJZ
X05FRURFRCwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4gQEAgLTkzNzIsNyArOTM1Nyw2IEBAIHZvaWQg
bWRfY2hlY2tfcmVjb3Zlcnkoc3RydWN0IG1kZGV2ICptZGRldikKPiAgIAkJCWdvdG8gdW5sb2Nr
Owo+ICAgCQl9Cj4gICAJCWlmIChtZGRldi0+c3luY190aHJlYWQpIHsKPiAtCQkJbWRfdW5yZWdp
c3Rlcl90aHJlYWQoJm1kZGV2LT5zeW5jX3RocmVhZCk7Cj4gICAJCQltZF9yZWFwX3N5bmNfdGhy
ZWFkKG1kZGV2KTsKPiAgIAkJCWdvdG8gdW5sb2NrOwo+ICAgCQl9Cj4gQEAgLTk0NTIsNyArOTQz
Niw4IEBAIHZvaWQgbWRfcmVhcF9zeW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+ICAg
CXNlY3Rvcl90IG9sZF9kZXZfc2VjdG9ycyA9IG1kZGV2LT5kZXZfc2VjdG9yczsKPiAgIAlib29s
IGlzX3Jlc2hhcGVkID0gZmFsc2U7Cj4gICAKPiAtCS8qIHN5bmNfdGhyZWFkIHNob3VsZCBiZSB1
bnJlZ2lzdGVyZWQsIGNvbGxlY3QgcmVzdWx0ICovCj4gKwkvKiByZXN5bmMgaGFzIGZpbmlzaGVk
LCBjb2xsZWN0IHJlc3VsdCAqLwo+ICsJbWRfdW5yZWdpc3Rlcl90aHJlYWQoJm1kZGV2LT5zeW5j
X3RocmVhZCk7Cj4gICAJaWYgKCF0ZXN0X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRkZXYtPnJl
Y292ZXJ5KSAmJgo+ICAgCSAgICAhdGVzdF9iaXQoTURfUkVDT1ZFUllfUkVRVUVTVEVELCAmbWRk
ZXYtPnJlY292ZXJ5KSAmJgo+ICAgCSAgICBtZGRldi0+ZGVncmFkZWQgIT0gbWRkZXYtPnJhaWRf
ZGlza3MpIHsKCgpIaSBLdWFpCgpUaGFua3MgZm9yIHRoZSBwYXRjaCBhbmQgdGhlIGV4cGxhbmF0
aW9uIGluIFYxLiBJbiB2ZXJzaW9uMSwgSSB0b29rIG11Y2ggCnRpbWUgdG8gdHJ5IHRvIHVuZGVy
c3RhbmQgdGhlIHByb2JsZW0uIE1heWJlIHdlIGNhbiB1c2UgdGhlIHByb2JsZW0KCml0c2VsZiBh
cyB0aGUgc3ViamVjdC4gU29tZXRoaW5nIGxpa2UgIkRvbid0IGFsbG93IHR3byBzeW5jIHByb2Nl
c3NlcyAKcnVubmluZyBhdCB0aGUgc2FtZSB0aW1lIj8gQW5kIGNvdWxkIHlvdSBhZGQgdGhlIHRl
c3Qgc3RlcHMgd2hpY2ggdGFsa2VkIAppbiB2MQoKaW4gdGhlIHBhdGNoPyBJdCBjYW4gaGVscCB0
byB1bmRlcnN0YW5kIHRoZSBwcm9ibGVtIHZlcnkgbXVjaC4KCkJlc3QgUmVnYXJkcwoKWGlhbwoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

