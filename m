Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5B3C43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 23:31:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-8og-1h1BMWamqtr03KADyg-1; Thu, 16 Jun 2022 19:30:59 -0400
X-MC-Unique: 8og-1h1BMWamqtr03KADyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B585185A79C;
	Thu, 16 Jun 2022 23:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2484118EAC;
	Thu, 16 Jun 2022 23:30:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B72C0194705F;
	Thu, 16 Jun 2022 23:30:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25BC7194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 23:30:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E27440CF8E4; Thu, 16 Jun 2022 23:30:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09A42401015E
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:30:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E632C802D1F
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:30:55 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-BhyViYRDN6a3epx0FCrHdQ-1; Thu, 16 Jun 2022 19:30:53 -0400
X-MC-Unique: BhyViYRDN6a3epx0FCrHdQ-1
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; d="scan'208";a="202082441"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2022 07:30:52 +0800
IronPort-SDR: I2g6MHoCvj9ZN4iebl9tu3DgQA9igfyhUiGH9G+j4/5pcHjdmKrHWLLRXXEsTnMWIrjdWvSLzV
 zIOHAiYah7qQlkvUDGFWHHvdANlYqNP7KXglUv42g6svmlAt4wcqO5BgizLdJP7lYSvMJzclVp
 wkAls5xSi+ZQlavhb8pMXbp0O/ZqGzHyDAwNf+QiYOMD8I9895JLjbGDK6NiLuVcs1G/tnEvc+
 WnAydvsWqlSJmIuUA+1DmaMrt+fU03vynGw7MWqCVKVXL+tHFv0RtFSf6iOQQPgNOW9FOBnyFG
 XjIw2VGntVXR1Oypc1tu0ULK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 15:53:28 -0700
IronPort-SDR: WM7JEoIc4rTu79o2W1AtpX/vnrDlX5LMcFcZgirX6jo21azGW4hOGTQKug2PSKXtPzkX7oG8bw
 Et0lxlM1v/rYZ5blFQPDfEd/psgqwFXOwxMGGgylEvJJt3u+wGcfbmrLECe3Urkr905eVO6I/H
 /kehGigUovEgkSV8WEx55vj7vz3nBC5a5RLhZw6T9MjbknyuhxESNrk7MHqlMmvhS5Y7sDpXSc
 4+E6oTMgY7LCHSbEjuO3PWK8lSiinTYCTm4T6r/k1/Xi5G//JOC6URiphRMTfqe6HrIlbudf3r
 eLk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 16:30:53 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LPJMJ0S4Bz1SVpB
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 16:30:51 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 7Bhv4z2lfoWh for <dm-devel@redhat.com>;
 Thu, 16 Jun 2022 16:30:50 -0700 (PDT)
Received: from [10.225.163.84] (unknown [10.225.163.84])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LPJMC59mkz1Rvlc;
 Thu, 16 Jun 2022 16:30:47 -0700 (PDT)
Message-ID: <ab75c1ca-986f-c3af-6c8c-c2c5b7e40bbd@opensource.wdc.com>
Date: Fri, 17 Jun 2022 08:30:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, Bart Van Assche
 <bvanassche@acm.org>, hch@lst.de, snitzer@redhat.com, axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb@eucas1p1.samsung.com>
 <20220615101920.329421-3-p.raghav@samsung.com>
 <857c444a-02b9-9cef-0c5b-2ecdb2fd46f6@acm.org>
 <e04db101-5628-2a1d-6b5c-997090484d7d@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <e04db101-5628-2a1d-6b5c-997090484d7d@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 02/13] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNi8xNi8yMiAxOTowOSwgUGFua2FqIFJhZ2hhdiB3cm90ZToKPiBPbiAyMDIyLTA2LTE1IDIy
OjI4LCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6Cj4gaXNrX25hbWUsIHpvbmUtPmxlbik7Cj4+PiAr
wqDCoMKgwqDCoMKgwqAgaWYgKHpvbmUtPmxlbiA9PSAwKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBwcl93YXJuKCIlczogSW52YWxpZCB6b25lIHNpemUiLCBkaXNrLT5kaXNrX25hbWUp
Owo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9ERVY7Cj4+PiArwqDCoMKg
wqDCoMKgwqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+PiArwqDCoMKgwqDCoMKg
wqDCoCAqIERvbid0IGFsbG93IHpvbmVkIGRldmljZSB3aXRoIG5vbiBwb3dlcl9vZl8yIHpvbmUg
c2l6ZSB3aXRoCj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIHpvbmUgY2FwYWNpdHkgbGVzcyB0aGFu
IHpvbmUgc2l6ZS4KPj4+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4+Cj4gCj4+IFBsZWFzZSBjaGFu
Z2UgInBvd2VyX29mXzIiIGludG8gInBvd2VyLW9mLTIiLgo+Pgo+IE9rLgo+Pj4gK8KgwqDCoMKg
wqDCoMKgIGlmICghaXNfcG93ZXJfb2ZfMih6b25lLT5sZW4pICYmIHpvbmUtPmNhcGFjaXR5IDwg
em9uZS0+bGVuKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcl93YXJuKCIlczogSW52
YWxpZCB6b25lIGNhcGFjaXR5IGZvciBub24gcG93ZXIgb2YgMgo+Pj4gem9uZSBzaXplIiwKPj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGlzay0+ZGlza19uYW1lKTsKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRU5PREVWOwo+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgIH0KPj4KPj4gVGhlIGFib3ZlIGNoZWNrIHNlZW1zIHdyb25nIHRvIG1lLiBJIGRvbid0
IHNlZSB3aHkgZGV2aWNlcyB0aGF0IHJlcG9ydCBhCj4+IGNhcGFjaXR5IHRoYXQgaXMgbGVzcyB0
aGFuIHRoZSB6b25lIHNpemUgc2hvdWxkIGJlIHJlamVjdGVkLgo+Pgo+IFRoaXMgd2FzIGJyb3Vn
aHQgdXAgYnkgRGFtaWVuIGR1cmluZyBwcmV2aW91cyByZXZpZXdzLiBUaGUgYXJndW1lbnQgd2Fz
Cj4gdGhhdCB0aGUgcmVhc29uIHRvIGFsbG93IG5vbiBwb3dlci1vZi0yIHpvbmVkIGRldmljZSBp
cyB0byByZW1vdmUgdGhlCj4gZ2FwcyBiZXR3ZWVuIHpvbmUgc2l6ZSBhbmQgem9uZSBjYXBhY2l0
eS4gQWxsb3dpbmcgYSBucG8yIHpvbmUgc2l6ZSB3aXRoCj4gYSBkaWZmZXJlbnQgY2FwYWNpdHks
IGV2ZW4gdGhvdWdoIGl0IGlzIHRlY2huaWNhbGx5IHBvc3NpYmxlLCBpdCBkb2VzCj4gbm90IG1h
a2UgYW55IHByYWN0aWNhbCBzZW5zZS4gVGhhdCBpcyB3aHkgdGhpcyBjaGVjayB3YXMgaW50cm9k
dWNlZC4KPiBEb2VzIHRoYXQgYW5zd2VyIHlvdXIgcXVlc3Rpb24/CgpBZGQgYSBjb21tZW50IGV4
cGxhaW5pbmcgdGhpcyByZXN0cmljdGlvbiwgY2xlYXJseSBtZW50aW9uaW5nIHRoYXQgaXQgaXMg
YQpMaW51eCByZXN0cmljdGlvbnMgYW5kIG5vdCBtYW5kYXRlZCBieSB0aGUgc3BlY2lmaWNhdGlv
bnMuCgo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qCj4+PiArwqDCoMKgwqDCoMKgwqDCoCAqIERpdmlz
aW9uIGlzIHVzZWQgdG8gY2FsY3VsYXRlIG5yX3pvbmVzIGZvciBib3RoIHBvd2VyX29mXzIKPj4+
ICvCoMKgwqDCoMKgwqDCoMKgICogYW5kIG5vbiBwb3dlcl9vZl8yIHpvbmUgc2l6ZXMgYXMgaXQg
aXMgbm90IGluIHRoZSBob3QgcGF0aC4KPj4+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4+Cj4+IFNo
b3VsZG4ndCB0aGUgYWJvdmUgY29tbWVudCBiZSBtb3ZlZCB0byB0aGUgcGF0Y2ggZGVzY3JpcHRp
b24/IEknbSBub3QKPj4gc3VyZSB3aGV0aGVyIGhhdmluZyBzdWNoIGEgY29tbWVudCBpbiB0aGUg
c291cmNlIGNvZGUgaXMgdmFsdWFibGUuCj4+Cj4gWWVhaCwgSSB3aWxsIHJlbW92ZSBpdC4gTWF5
YmUgaXQgaXMgdmVyeSBvYnZpb3VzIGF0IHRoaXMgcG9pbnQuCj4+PiArc3RhdGljIGlubGluZSBz
ZWN0b3JfdCBibGtfcXVldWVfb2Zmc2V0X2Zyb21fem9uZV9zdGFydChzdHJ1Y3QKPj4+IHJlcXVl
c3RfcXVldWUgKnEsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHNlY3Rvcl90IHNlYykKPj4+ICt7Cj4+PiArwqDCoMKgIHNlY3Rvcl90
IHpvbmVfc2VjdG9ycyA9IGJsa19xdWV1ZV96b25lX3NlY3RvcnMocSk7Cj4+PiArwqDCoMKgIHU2
NCByZW1haW5kZXIgPSAwOwo+Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoIWJsa19xdWV1ZV9pc196b25l
ZChxKSkKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gZmFsc2U7Cj4+Cj4+ICJyZXR1cm4gZmFs
c2UiIHNob3VsZCBvbmx5IG9jY3VyIGluIGZ1bmN0aW9ucyByZXR1cm5pbmcgYSBib29sZWFuLiBU
aGlzCj4+IGZ1bmN0aW9uIHJldHVybnMgdHlwZSBzZWN0b3JfdC4KPj4KPiBHb29kIGNhdGNoLiBJ
dCB3YXMgYSBjb3B5IHBhc3RlIG1pc3Rha2UuIEZpeGVkIGl0Lgo+PiBUaGFua3MsCj4+Cj4+IEJh
cnQuCj4gCj4gLS0KPiBkbS1kZXZlbCBtYWlsaW5nIGxpc3QKPiBkbS1kZXZlbEByZWRoYXQuY29t
Cj4gaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAoK
Ci0tIApEYW1pZW4gTGUgTW9hbApXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gKCi0tCmRtLWRldmVs
IG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

