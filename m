Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A831C64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677520994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1HhEFL/H17jGOFr5LskDZ4/pvSxBqR+2hFYzrfk4c34=;
	b=DxlVCsyYNDJJFlQgYiMioAT22daqg9xfuqaylf2vB+Y/KZJ58oJHrcgGD3MEVSU69yZeoJ
	I2goySZn3nAF8uX6I02Bsqn+KrG/l/0yj1Jaa6F28R88vGS9fAigVY55V9Had92QnM+85W
	Oo0dgQcVltf6yvgU06/dRj/an23Mfec=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-_GaJHVgANWywxMmUVMnUeQ-1; Mon, 27 Feb 2023 13:03:11 -0500
X-MC-Unique: _GaJHVgANWywxMmUVMnUeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2784E87A9E6;
	Mon, 27 Feb 2023 18:03:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9475B404BEC5;
	Mon, 27 Feb 2023 18:03:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DB561946587;
	Mon, 27 Feb 2023 18:03:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1CA5E1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 18:03:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CAC540C945A; Mon, 27 Feb 2023 18:03:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 555CB40C6EC4
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 18:03:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AF6C3C16E82
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 18:03:05 +0000 (UTC)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com
 [209.85.128.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-318-Cr-EYdvcOrSM02f9ef_O5w-1; Mon, 27 Feb 2023 13:03:02 -0500
X-MC-Unique: Cr-EYdvcOrSM02f9ef_O5w-1
Received: by mail-yw1-f171.google.com with SMTP id
 00721157ae682-536af432ee5so200904027b3.0
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 10:03:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ZMv1eFouUXCcfAFyU400XJZ2qVp29WtrfAZjzeWnySg=;
 b=fn6im7sAuUFCNJuxcnTHScAjNcFvP+58sTsGCbt8J+ImW9oTm9zdM2yIJdbKl0kYTl
 9LjCqznf+bmIohMmkpdwL+WmwP2oFVY2zm42Ci34n9oqJDWWJwbzQkdI1UV12/VEMQam
 piLvvFFvfDl1SPIy3tnGbhMXOg5nOFIJCznyD9ZaHSoZo0Xxw5SNvINtYOFpxw/CykD3
 W/60SxDC9DYA9xIy5dudAJ1ocu6I37lU0fKjB5JQQTfi6w8kmzXPTAHUiTz3KVz7aP/4
 NwuahPrWc7IoepMb9JOH27fr/N5DavLCcc9BPT0FLFZUIGRUD2wLNyIY+t5eL1NNrUME
 SuPg==
X-Gm-Message-State: AO0yUKXI5SKwSCjKCK77YzAK5UuoXJL+vQr94jbUcCdnQlSLuFmxkned
 wU5GqZ/KtpW5APOndI0vcKiGRXtgFeg21O61CQ==
X-Google-Smtp-Source: AK7set8M0aKQQM3LAxKLVprZ8hX1TSleZD/its5u/oYrpYPM2RsBE4AruyU4ufMwotb7PEx0g3fttw==
X-Received: by 2002:a05:7500:284f:b0:f9:ae91:353c with SMTP id
 cu15-20020a057500284f00b000f9ae91353cmr509059gab.24.1677520981912; 
 Mon, 27 Feb 2023 10:03:01 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s67-20020a374546000000b007424239e4casm5306592qka.117.2023.02.27.10.03.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Feb 2023 10:03:01 -0800 (PST)
Date: Mon, 27 Feb 2023 13:03:00 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: yangerkun <yangerkun@huaweicloud.com>
Message-ID: <Y/zwVCNDrdAbzC7a@redhat.com>
References: <20230223031947.3717433-1-yangerkun@huaweicloud.com>
 <b7020147-2382-71f6-5237-8501562f8011@acm.org>
 <e69ec125-3636-ab20-ce63-f4b89ac55ffb@huaweicloud.com>
 <Y/zueUWERryoIGA8@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y/zueUWERryoIGA8@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] dm-crypt: fix softlockup in dmcrypt_write
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
Cc: yangerkun@huawei.com, dm-devel@redhat.com,
 Bart Van Assche <bvanassche@acm.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBGZWIgMjcgMjAyMyBhdCAxMjo1NVAgLTA1MDAsCk1pa2UgU25pdHplciA8c25pdHpl
ckBrZXJuZWwub3JnPiB3cm90ZToKCj4gT24gU3VuLCBGZWIgMjYgMjAyMyBhdCAgODozMVAgLTA1
MDAsCj4geWFuZ2Vya3VuIDx5YW5nZXJrdW5AaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiAKPiA+
IAo+ID4gCj4gPiDlnKggMjAyMy8yLzI2IDEwOjAxLCBCYXJ0IFZhbiBBc3NjaGUg5YaZ6YGTOgo+
ID4gPiBPbiAyLzIyLzIzIDE5OjE5LCB5YW5nZXJrdW4gd3JvdGU6Cj4gPiA+ID4gQEAgLTE5MjQs
NiArMTkyNiwxMCBAQCBzdGF0aWMgaW50IGRtY3J5cHRfd3JpdGUodm9pZCAqZGF0YSkKPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgwqAgQlVHX09OKHJiX3BhcmVudCh3cml0ZV90cmVlLnJiX25vZGUp
KTsKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqAgaWYgKHRpbWVfaXNfYmVmb3JlX2ppZmZpZXMoc3Rh
cnRfdGltZSArIEhaKSkgewo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNjaGVkdWxl
KCk7Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RhcnRfdGltZSA9IGppZmZpZXM7
Cj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgIH0KPiA+ID4gCj4gPiA+IFdoeSBzY2hlZHVsZSgpIGlu
c3RlYWQgb2YgY29uZF9yZXNjaGVkKCk/Cj4gPiAKPiA+IGNvbmRfcmVzY2hlZCBtYXkgbm90IHJl
YWxseSBzY2hlZHVsZSwgd2hpY2ggbWF5IHRyaWdnZXIgdGhlIHByb2JsZW0gdG9vLCBidXQKPiA+
IGl0IHNlZW1zIGFmdGVyIDEgc2Vjb25kLCBpdCBtYXkgbmV2ZXIgaGFwcGVuZD8KPiAKPiBJIGhh
ZCB0aGUgc2FtZSBxdWVzdGlvbiBhcyBCYXJ0IHdoZW4gcmV2aWV3aW5nIHlvdXIgaG9tZWdyb3du
Cj4gY29uZGl0aW9uYWwgc2NoZWR1bGUoKS4gIEhvcGVmdWxseSB5b3UgY2FuIHJlcHJvZHVjZSB0
aGlzIGlzc3VlPyAgSWYKPiBzbywgcGxlYXNlIHNlZSBpZiBzaW1wbHkgdXNpbmcgY29uZF9yZXNj
aGVkKCkgZml4ZXMgdGhlIGlzc3VlLgoKVGhpcyBzZWVtcyBsaWtlIGEgbW9yZSBhcHByb3ByaWF0
ZSBwYXRjaDoKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWNyeXB0LmMgYi9kcml2ZXJzL21k
L2RtLWNyeXB0LmMKaW5kZXggODdjNTcwNjEzMWYyLi5mYWJhMWJlNTcyZjkgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWQvZG0tY3J5cHQuYworKysgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKQEAgLTE5
MzcsNiArMTkzNyw3IEBAIHN0YXRpYyBpbnQgZG1jcnlwdF93cml0ZSh2b2lkICpkYXRhKQogCQkJ
aW8gPSBjcnlwdF9pb19mcm9tX25vZGUocmJfZmlyc3QoJndyaXRlX3RyZWUpKTsKIAkJCXJiX2Vy
YXNlKCZpby0+cmJfbm9kZSwgJndyaXRlX3RyZWUpOwogCQkJa2NyeXB0ZF9pb193cml0ZShpbyk7
CisJCQljb25kX3Jlc2NoZWQoKTsKIAkJfSB3aGlsZSAoIVJCX0VNUFRZX1JPT1QoJndyaXRlX3Ry
ZWUpKTsKIAkJYmxrX2ZpbmlzaF9wbHVnKCZwbHVnKTsKIAl9CgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

