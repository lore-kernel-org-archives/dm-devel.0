Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B0EC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Mar 2022 04:04:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-c9t6xZwZMiC4ZdmGMW6uQA-1; Mon, 07 Mar 2022 23:04:07 -0500
X-MC-Unique: c9t6xZwZMiC4ZdmGMW6uQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D30AC185A79C;
	Tue,  8 Mar 2022 04:04:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A0F4C08F24;
	Tue,  8 Mar 2022 04:03:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 764D2194F4B3;
	Tue,  8 Mar 2022 04:03:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B2D0194E109
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 04:03:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A01DE40CFD21; Tue,  8 Mar 2022 04:03:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BD5240CFD12
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 04:03:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83FB3185A7B2
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 04:03:55 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-S1w-yjrdOiyCyeLRvjNZjQ-1; Mon, 07 Mar 2022 23:03:51 -0500
X-MC-Unique: S1w-yjrdOiyCyeLRvjNZjQ-1
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KCM8b1GbszBrQq;
 Tue,  8 Mar 2022 12:01:51 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 12:03:45 +0800
Received: from [10.174.176.127] (10.174.176.127) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 12:03:44 +0800
To: Edward Thornber <thornber@redhat.com>
References: <20220228141354.1091687-1-luomeng12@huawei.com>
 <YhzsJKjj4VK1wK/W@redhat.com>
 <f73ee01c-49be-a0d3-3646-0afdf166720a@huawei.com>
 <CAJ0trDYi5SUHd3fnLL9sKf4rKMyuhDOtD1ASwkd9F9_EczjSfg@mail.gmail.com>
From: luomeng <luomeng12@huawei.com>
Message-ID: <ccfed436-95f6-3c87-f476-59a6af37bb52@huawei.com>
Date: Tue, 8 Mar 2022 12:03:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAJ0trDYi5SUHd3fnLL9sKf4rKMyuhDOtD1ASwkd9F9_EczjSfg@mail.gmail.com>
X-Originating-IP: [10.174.176.127]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] Revert "dm space maps: don't reset space map
 allocation cursor when committing"
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
Cc: yukuai3@huawei.com, "development,
 device-mapper" <dm-devel@redhat.com>, agk <agk@redhat.com>,
 Mike Snitzer <snitzer@redhat.com>, ejt <ejt@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

ClllcywgcmFtZGlzayBpdHNlbGYgaXMgYSB0aGlubHkgcHJvdmlzaW9uZWQgZGV2aWNlLiBCdXQg
V2UgY2FuJ3QgCnJlc3RyaWN0IHdoYXQgZGlza3MgdXNlcnMgdXNlLiBTbyBpZiBkaXNrIGRvZXNu
J3Qgc3VwcG9ydCBkaXNjYXJkLCBpdCAKd2lsbCBjYXVzZSB0aGlzIHByb2JsZW0uCuWcqCAyMDIy
LzMvMiAwOjA2LCBFZHdhcmQgVGhvcm5iZXIg5YaZ6YGTOgo+IEknbSBoYXZpbmcgdHJvdWJsZSB1
bmRlcnN0YW5kaW5nIHlvdXIgaXNzdWUuwqAgRG9lcyB5b3VyIHJhbWRpc2sgb25seSAKPiBhbGxv
Y2F0ZSBiYWNraW5nIG1lbW9yeSBvbiBkZW1hbmQ/wqAgKGllLiBpcyB0aGUgcmFtZGlzayBpdHNl
bGYgYSB0aGlubHkgCj4gcHJvdmlzaW9uZWQgZGV2aWNlPykuwqAgSWYgc28sIG5vdCBzdXBwb3J0
aW5nIGRpc2NhcmQgc2VlbXMgdG8gYmUgdGhlIAo+IHByb2JsZW0uCj4gCj4gVGhpbnAgbWFrZXMg
bm8gcHJvbWlzZXMgYWJvdXQgd2hlcmUgaXQgd2lsbCBhbGxvY2F0ZSB5b3VyIGRhdGEuwqAgSWYg
eW91IAo+IHdyaXRlIGEgZmlsZSwgZGVsZXRlIGl0LCBkaXNjYXJkIGFuZCB0aGVuIHJld3JpdGUg
dGhlIGZpbGUgdGhlcmUgaXMgbm8gCj4gZ3VhcmFudGVlIHRoYXQgdGhlIGZpbGUgd2lsbCBiZSB3
cml0dGVuIHRvIHRoZSBzYW1lIGxvY2F0aW9uLgo+IAo+IE9uIFR1ZSwgTWFyIDEsIDIwMjIgYXQg
MjowOCBQTSBsdW9tZW5nIDxsdW9tZW5nMTJAaHVhd2VpLmNvbSAKPiA8bWFpbHRvOmx1b21lbmcx
MkBodWF3ZWkuY29tPj4gd3JvdGU6Cj4gCj4gICAgIEJlY2F1c2UgdGhpbi1wb29sIGlzIHN0b3Jh
Z2Ugb3Zlci1jb21taXRtZW50LCBvbmUgb2YgdGhlIGZvbGxvd2luZwo+ICAgICBzY2VuYXJpb3Mg
ZXhpc3RzOiBjb25zdGFudGx5IGNyZWF0ZSBhbmQgZGVsZXRlIGZpbGUsIHRoZW4gdGhlIHNlYXJj
aAo+ICAgICBkb2Vzbid0IGhpdCB0aGUgZW5kIG9mIHRoZSBtZXRhZGF0YSBkZXZpY2UsIGJ1dCBy
YW1kaXNrIGhpdHMgdGhlIGVuZAo+ICAgICAobm90IHN1cHBvcnQgZGlzY2FyZCkuIFNvIHRoZSBj
dXJzb3IgZG9lc24ndCByZXNldC4KPiAKPiAgICAg5ZyoIDIwMjIvMi8yOCAyMzozNywgTWlrZSBT
bml0emVyIOWGmemBkzoKPiAgICAgID4gV2hhdCB5b3UncmUgc2F5aW5nIGRvZXNuJ3QgbWFrZSBh
bnkgc2Vuc2UuwqAgRXNwZWNpYWxseSB3aGVuIHlvdQo+ICAgICAgPiBjb25zaWRlciB0aGlzIGxh
c3QgcGFydCBvZiB0aGUgY29tbWl0IG1lc3NhZ2U6Cj4gICAgICA+ICJGaXggdGhlc2UgaXNzdWVz
IGJ5IGxlYXZpbmcgdGhlIGN1cnNvciBhbG9uZSwgb25seSByZXNldHRpbmcKPiAgICAgd2hlbiB0
aGUKPiAgICAgID7CoCDCoHNlYXJjaCBoaXRzIHRoZSBlbmQgb2YgdGhlIG1ldGFkYXRhIGRldmlj
ZS4iCj4gCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

