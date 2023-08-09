Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CD0C001E0
	for <dm-devel@archiver.kernel.org>; Wed,  9 Aug 2023 06:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691563807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a327s+BN/Yc3jiRbbfMvVkUCm6hrtiKHCR2WeBdCfMo=;
	b=bglYJGGUrOIKz74MW0ABzuMNIZGgay3bYJK81hWb8RDE2mHhZKwKb+dkxlAGAH9gQfDKY/
	k2sicUWzXtzUE8+tpY8rqNsL49GHckdYXT0uLwwQaMujBSml75C7lhwwqFZD6ThXPidhrQ
	sBDB7B/qCe/5dweQ8oVNCeleR0QaN9o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-o-HsnsZpMMeIWGTAJd4_rA-1; Wed, 09 Aug 2023 02:50:04 -0400
X-MC-Unique: o-HsnsZpMMeIWGTAJd4_rA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23D1180CC34;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D94FB2026D4B;
	Wed,  9 Aug 2023 06:49:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 944B61946588;
	Wed,  9 Aug 2023 06:49:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B37321946586
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Aug 2023 03:03:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A14BF1121315; Wed,  9 Aug 2023 03:03:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 991FB1121314
 for <dm-devel@redhat.com>; Wed,  9 Aug 2023 03:03:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AA3C8015AA
 for <dm-devel@redhat.com>; Wed,  9 Aug 2023 03:03:19 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-_xDFUkDYNv-n7CuZE3z-Ig-1; Tue, 08 Aug 2023 23:03:17 -0400
X-MC-Unique: _xDFUkDYNv-n7CuZE3z-Ig-1
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RLFCM6BLRztSCq;
 Wed,  9 Aug 2023 10:59:43 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 11:03:12 +0800
To: Hugo Villeneuve <hugo@hugovil.com>
References: <20230808150301.45196-1-yuehaibing@huawei.com>
 <20230808130333.2207c675d008fa6c808a472f@hugovil.com>
From: Yue Haibing <yuehaibing@huawei.com>
Message-ID: <2c73f603-4c0b-36d8-df9f-be33db589c69@huawei.com>
Date: Wed, 9 Aug 2023 11:03:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20230808130333.2207c675d008fa6c808a472f@hugovil.com>
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 09 Aug 2023 06:49:58 +0000
Subject: Re: [dm-devel] [PATCH -next] dm: Remove unused declaration
 dm_get_rq_mapinfo()
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
Cc: heinzm@redhat.com, dm-devel@redhat.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMy84LzkgMTowMywgSHVnbyBWaWxsZW5ldXZlIHdyb3RlOgo+IE9uIFR1ZSwgOCBBdWcg
MjAyMyAyMzowMzowMSArMDgwMAo+IFl1ZSBIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+
IHdyb3RlOgo+IAo+IEhpLAo+IAo+PiBDb21taXQgYWU2YWQ3NWU1YzNjICgiZG06IHJlbW92ZSB1
bnVzZWQgZG1fZ2V0X3JxX21hcGluZm8oKSIpCj4+IHJlbW92ZWQgdGhlIGltcGxlbWVudGF0aW9u
IGJ1dCBsZWF2ZSBkZWNsYXJhdGlvbi4KPiAKPiBNYXliZSBjaGFuZ2UgdG8gInJlbW92ZWQgdGhl
IGltcGxlbWVudGF0aW9uIGJ1dCBub3QgdGhlIGRlY2xhcmF0aW9uLiIKClRoYW5rc++8jCB3aWxs
IGRvIHRoaXMgaW4gdjIuCgo+IAo+IEh1Z28gVmlsbGVuZXV2ZS4KPiAKPiAKPj4gU2lnbmVkLW9m
Zi1ieTogWXVlIEhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4KPj4gLS0tCj4+ICBpbmNs
dWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaCB8IDEgLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDEgZGVs
ZXRpb24oLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5o
IGIvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmgKPj4gaW5kZXggNjlkMDQzNWM3ZWJiLi41
YmM2OWM2YTY0ZTAgMTAwNjQ0Cj4+IC0tLSBhL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5o
Cj4+ICsrKyBiL2luY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBlci5oCj4+IEBAIC01MDIsNyArNTAy
LDYgQEAgaW50IGRtX3Bvc3Rfc3VzcGVuZGluZyhzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSk7Cj4+ICBp
bnQgZG1fbm9mbHVzaF9zdXNwZW5kaW5nKHN0cnVjdCBkbV90YXJnZXQgKnRpKTsKPj4gIHZvaWQg
ZG1fYWNjZXB0X3BhcnRpYWxfYmlvKHN0cnVjdCBiaW8gKmJpbywgdW5zaWduZWQgaW50IG5fc2Vj
dG9ycyk7Cj4+ICB2b2lkIGRtX3N1Ym1pdF9iaW9fcmVtYXAoc3RydWN0IGJpbyAqY2xvbmUsIHN0
cnVjdCBiaW8gKnRndF9jbG9uZSk7Cj4+IC11bmlvbiBtYXBfaW5mbyAqZG1fZ2V0X3JxX21hcGlu
Zm8oc3RydWN0IHJlcXVlc3QgKnJxKTsKPj4gIAo+PiAgI2lmZGVmIENPTkZJR19CTEtfREVWX1pP
TkVECj4+ICBzdHJ1Y3QgZG1fcmVwb3J0X3pvbmVzX2FyZ3Mgewo+PiAtLSAKPj4gMi4zNC4xCj4+
Cj4gCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

