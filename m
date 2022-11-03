Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8798FC43217
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 18:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667499272;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=38DzRTme6xKIjEYQmDG5DGCb/Dnqjxvx8IdnUvjp09c=;
	b=GzfHLH7dizNb8heEFRpvR5qReDvxlPhrBpaBXMD/IqktjQC+nTan/jKoZc9hArPweZLBN6
	yI48iMnNSsnJeshtvg8pqOZ3EZpNkKUk9BLIjgIGjQXHJTsDnVbaMa/PjTSmp1Ut5rF/P5
	/qwEBjNP/IRvihD9SXezSL4fCEAWBCM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-emjHz3m9NfuCShiVevWJUg-1; Thu, 03 Nov 2022 14:14:30 -0400
X-MC-Unique: emjHz3m9NfuCShiVevWJUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24F8299E753;
	Thu,  3 Nov 2022 18:14:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A3662166B26;
	Thu,  3 Nov 2022 18:14:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC22A1946597;
	Thu,  3 Nov 2022 18:14:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7AA451946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 18:14:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BB16C01555; Thu,  3 Nov 2022 18:14:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6437EC15BA4
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 18:14:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A20E185A794
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 18:14:24 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-YLonoPqTNO-z9SBzrltdHw-1; Thu, 03 Nov 2022 14:14:22 -0400
X-MC-Unique: YLonoPqTNO-z9SBzrltdHw-1
Received: by mail-pj1-f54.google.com with SMTP id
 r61-20020a17090a43c300b00212f4e9cccdso5999534pjg.5
 for <dm-devel@redhat.com>; Thu, 03 Nov 2022 11:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=AAumLxLnWfAM18CUZyhLKrEQTBxFDu0Nq3UHPT8n9DM=;
 b=dKhcXeYa17fHzgLRbm6O/KQ6kn1r3aKe2TXyom0BlH17tAThTfnojT6dfrlJbP+Zby
 8afh3GK8A44/C6KJXoL/94EndVTM9SGuEk8mFvZd8+3YGFtRhweZ6+gYA0getvf+R2je
 KKnBBtI1pNYZgki/McqW54zu2THBgwfXMRgZ2DFRtJ9Ye4bv+qhDFMxY0w3VVoOegU7x
 ApiQ9gAIJ2SuXaf9FnFSAA84MFI5O6/xv6mXhQH/7Unfg5hJItdranow8TJP1GXXp7ER
 GapDLBeAQWny6VUuNruXwqvHTo/LMP8XbyeSH7S7OkoPa8mGZHcvOPRbmhC1Zdkpp5AR
 mNnw==
X-Gm-Message-State: ACrzQf0I1a01oVfHIEaA+Bo+SM9y9dJIBcpxuZ4O35o9R5ceTnxbLJ4a
 Xepnbzrs2OzJJuAbhut+sZ4=
X-Google-Smtp-Source: AMsMyM7EErA8tHxPvzrZVcpD4tDFhNKSgLTGblrV/zcW9vCOr6QKeDAhLbttK1YYZeyphS7cjxvfow==
X-Received: by 2002:a17:90b:4d0e:b0:1f7:ae99:4d7f with SMTP id
 mw14-20020a17090b4d0e00b001f7ae994d7fmr49029090pjb.200.1667499261396; 
 Thu, 03 Nov 2022 11:14:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:881a:8a80:fdae:8683?
 ([2620:15c:211:201:881a:8a80:fdae:8683])
 by smtp.gmail.com with ESMTPSA id
 q17-20020a17090311d100b00178b77b7e71sm958760plh.188.2022.11.03.11.14.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 11:14:20 -0700 (PDT)
Message-ID: <84af9938-81bc-7c58-2210-7da935312d6a@acm.org>
Date: Thu, 3 Nov 2022 11:14:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To: Mike Christie <michael.christie@oracle.com>, hch@lst.de,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
 <0123db70-6217-135a-4101-0609512e723b@acm.org>
 <7b8cdc82-0aca-2f41-2eed-299dacf95771@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7b8cdc82-0aca-2f41-2eed-299dacf95771@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v3 03/19] scsi: Move sd_pr_type to header to
 share
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMi8yMiAxOToxMywgTWlrZSBDaHJpc3RpZSB3cm90ZToKPiBPbiAxMS8yLzIyIDU6NDcg
UE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPj4gT24gMTAvMjYvMjIgMTY6MTksIE1pa2UgQ2hy
aXN0aWUgd3JvdGU6Cj4+PiArc3RhdGljIGlubGluZSBlbnVtIHNjc2lfcHJfdHlwZSBibG9ja19w
cl90eXBlX3RvX3Njc2koZW51bSBwcl90eXBlIHR5cGUpCj4+PiArewo+Pj4gK8KgwqDCoCBzd2l0
Y2ggKHR5cGUpIHsKPj4+ICvCoMKgwqAgY2FzZSBQUl9XUklURV9FWENMVVNJVkU6Cj4+PiArwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfV1JJVEVfRVhDTFVTSVZFOwo+Pj4gK8KgwqDCoCBj
YXNlIFBSX0VYQ0xVU0lWRV9BQ0NFU1M6Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lf
UFJfRVhDTFVTSVZFX0FDQ0VTUzsKPj4+ICvCoMKgwqAgY2FzZSBQUl9XUklURV9FWENMVVNJVkVf
UkVHX09OTFk6Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfV1JJVEVfRVhDTFVT
SVZFX1JFR19PTkxZOwo+Pj4gK8KgwqDCoCBjYXNlIFBSX0VYQ0xVU0lWRV9BQ0NFU1NfUkVHX09O
TFk6Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfRVhDTFVTSVZFX0FDQ0VTU19S
RUdfT05MWTsKPj4+ICvCoMKgwqAgY2FzZSBQUl9XUklURV9FWENMVVNJVkVfQUxMX1JFR1M6Cj4+
PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfV1JJVEVfRVhDTFVTSVZFX0FMTF9SRUdT
Owo+Pj4gK8KgwqDCoCBjYXNlIFBSX0VYQ0xVU0lWRV9BQ0NFU1NfQUxMX1JFR1M6Cj4+PiArwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIFNDU0lfUFJfRVhDTFVTSVZFX0FDQ0VTU19BTExfUkVHUzsKPj4+
ICvCoMKgwqAgZGVmYXVsdDoKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsKPj4+ICvCoMKg
wqAgfQo+Pj4gK307Cj4+Cj4+IFBsZWFzZSBsZWF2ZSBvdXQgImRlZmF1bHQ6IHJldHVybiAwOyIg
ZnJvbSB0aGUgc3dpdGNoIHN0YXRlbWVudCBhbmQgYWRkICJyZXR1cm4gMDsiIGFmdGVyIHRoZSBz
d2l0Y2ggc3RhdGVtZW50LiBUaGF0IHdpbGwgbWFrZSB0aGUgY29tcGlsZXIgZW1pdCBhIHdhcm5p
bmcgaWYgYSB2YWx1ZSBpcyBhZGRlZCBpbiBlbnVtIHByX3R5cGUgYnV0IG5vdCBpbiB0aGUgYWJv
dmUgZnVuY3Rpb24uCj4gCj4gRGlkIHlvdSB3YW50IHRoYXQgY29tcGlsZXIgd2FybmluZyBmdW5j
dGlvbmFsaXR5IGluIHRoZSBmdXR1cmUgY29kZQo+IG9yIGFyZSB5b3UgYXNraW5nIG1lIHRvIGRv
IHRoZSBhYm92ZSBvbmx5IGlmIHdlIGdvIHRoZSBzd2l0Y2ggYmFzZWQKPiByb3V0ZT8KPiAKPiBD
aGFpdGFueWEgcmVxdWVzdGVkIG1lIHRvIG1ha2UgdGhpcyBhcnJheSBiYXNlZCBpbiBudm1lL3Nj
c2kuIEZvciB0aGlzCj4gYXBwcm9hY2gsIEkgY2FuIGFkZCBhIFdBUk4gb3IgcHJpbnRrIHdhcm5p
bmcgaWYgdGhlIHByX3R5cGUgcGFzc2VkIGluCj4gZG9lcyBub3QgbWF0Y2ggYSB2YWx1ZSBpbiB0
aGUgYXJyYXkuIEkgZG9uJ3QgdGhpbmsgSSBjYW4gZG8gYSBjb21waWxlcgo+IHdhcm5pbmcgdGhv
dWdoLgo+IAo+IEkgZGlkbid0IGNhcmUsIGJ1dCBJIHRoaW5rIHRoZSBjb21waWxlciB3YXJuaW5n
IHJvdXRlIG1pZ2h0IGJlIGJldHRlcgo+IHRob3VnaC4KCkhpIE1pa2UsCgpBbHRob3VnaCBJIGRv
IG5vdCBoYXZlIGEgc3Ryb25nIG9waW5pb24gYWJvdXQgdGhpcywga2VlcGluZyB0aGUgc3dpdGNo
IApzdGF0ZW1lbnQgYW5kIG1vdmluZyB0aGUgcmV0dXJuIHN0YXRlbWVudCBvdXQgb2YgdGhlIHN3
aXRjaCBzdGF0ZW1lbnQgCmhhcyB0aGUgYWR2YW50YWdlIHRoYXQgdGhlIGNvbXBpbGVyIHdpbGwg
d2FybiBpZiB0aGUgc3dpdGNoIHN0YXRlbWVudCBpcyAKaW5jb21wbGV0ZS4gSSBkb24ndCB0aGlu
ayB0aGF0IGEgc2ltaWxhciB3YXJuaW5nIHdvdWxkIGJlIGVtaXR0ZWQgaWYgdGhlIApzd2l0Y2gg
c3RhdGVtZW50IHdvdWxkIGJlIGNvbnZlcnRlZCBpbnRvIGFuIGFycmF5IGxvb2t1cC4KClRoYW5r
cywKCkJhcnQuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

