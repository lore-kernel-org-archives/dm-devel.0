Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE814C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 15:50:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2340964F11
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 15:50:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2340964F11
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-YpuiNfakMbqAj3BYDJynqA-1; Tue, 02 Mar 2021 10:50:29 -0500
X-MC-Unique: YpuiNfakMbqAj3BYDJynqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17DD3100CCC2;
	Tue,  2 Mar 2021 15:50:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B155F5D766;
	Tue,  2 Mar 2021 15:50:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09D5A18095CB;
	Tue,  2 Mar 2021 15:50:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122FoKNR021934 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 10:50:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DFA2C10CD6A8; Tue,  2 Mar 2021 15:50:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB65410BBCD5
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 15:50:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EB9D9595D8
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 15:50:18 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-123-VimBqMyKPn-4X5mW-rbXHg-1; Tue, 02 Mar 2021 10:50:15 -0500
X-MC-Unique: VimBqMyKPn-4X5mW-rbXHg-1
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqhP62PXmz16Fmx;
	Tue,  2 Mar 2021 23:48:26 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 2 Mar 2021 23:49:57 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
	<86bee89e-6d5b-2138-2621-77848e668690@huawei.com>
	<65e13db2fa187efab241f09c00ae80777f139b56.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <63935643-c76a-a991-6095-e75b0dfd8c25@huawei.com>
Date: Tue, 2 Mar 2021 23:49:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <65e13db2fa187efab241f09c00ae80777f139b56.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 122FoKNR021934
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgpPbiAyMDIxLzMvMiAxOTowNywgTWFydGluIFdpbGNrIHdyb3RlOgo+IE9uIFR1ZSwgMjAyMS0w
My0wMiBhdCAxNjo0MSArMDgwMCwgbGl4aWFva2VuZyB3cm90ZToKPj4KPj4+Cj4+PiBIaSBNYXJ0
aW46Cj4+PiDCoMKgIEhlcmUgSSBhZGQgY29uZGxvZygyLCAic3RhcnQgZnVuY25hbWUiKSwKPj4+
IHB0aHJlYWRfY2xlYW51cF9wdXNoKGZ1bmNfcHJpbnQsIE5VTEwpCj4+PiBpbiBldmVyeSBwdGhy
ZWFkX2NyZWF0ZSBmdW5jLiBXaGVuIHRoZXNlIHR3byBjb3JlIGhhcHBlbmVkLCAiZXhpdAo+Pj4g
dHVyX3RocmVhZCIKPj4+IGFyZSBsZXNzIHRoYW4gInN0YXJ0IHR1cl90aHJlYWQiLiBTbyB0aGUg
dHJvdWJsZSBtYXkgYmUgaW4KPj4+IHR1cl90aHJlYWQuCj4+Pgo+Pgo+PiBJZiBJIG1hZGUgbm8g
bWlzdGFrZSwgdGhlc2UgY29yZWR1bXBzIGhhcHBlbmVkIHdoZW4gdGhlCj4+IHR1cl90aHJlYWQo
d2hpY2ggaXMKPj4gbGliY2hlY2tfdGhyZWFkIGluIGxhdGVzdCBjb2RlKSB3YXMgbm90IGZpbmlz
aGVkIGJ1dCBjaGVja2Vy77yIdHVy77yJd2FzCj4+IGNsZWFyZWQgYnkgY2xlYW51cF9jaGVja2Vy
cy4gQnV0IEkgY2FuJ3QgdW5kZXJzdGFuZCB0aGlzLCBiZWNhdXNlIHRoZQo+PiBjdHgKPj4gaW4g
dHVyX3RocmVhZCB3YXNuJ3QgZnJlZWQgYnkgY2xlYW51cF9jaGVja2Vycy4KPj4KPj4gUGxlYXNl
IGdpdmUgbWUgc29tZSBoZWxwcywgdGhhbmtzLgo+IAo+IFNvIHlvdSB0aGluayB0aGUgY3Jhc2hp
bmcgdGhyZWFkIGlzIGxpYmNoZWNrX3RocmVhZD8gRG8geW91IGhhdmUgYSBjb3JlCj4gZHVtcCBm
cm9tIHRoaXMgc2l0dWF0aW9uPwo+IAo+IERvZXMgdGhlIGNvZGUgeW91IHVzZSBpbmNsdWRlIGNv
bW1pdCAzOGZmZDg5ICgibGlibXVsdGlwYXRoOiBwcmV2ZW50Cj4gRFNPIHVubG9hZGluZyB3aXRo
IGFzdHJheSBjaGVja2VyIHRocmVhZHMiKT8KPiAKPiBNYXJ0aW4KPiAKCkhpIE1hcnRpbiwKCiAg
IEkgYW0gc29ycnkuIEkgdGVzdCBjb2RlIGRvZXNuJ3QgaW5jbHVkZSBjb21taXQgMzhmZmQ4OS4g
SSBjb25mdXNlCnRoZSBtYXN0ZXIgYW5kIHF1ZXVlIGJyYW5jaGVzLiBJIGp1c3QgdGVzdCAwLjcu
NyBhbmQgMC44LjUgbWFzdGVyLgpQbGVhc2UgaWdub3JlIGxpYmNoZWNrX3RocmVhZCBhbmQgZm9j
dXMgb24gbGFzdCBlbWFpbCB3aXRoIHRocmVhZAppbmZvLgoKUmVnYXJkcywKTGl4aWFva2VuZwoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

