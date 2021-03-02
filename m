Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CFFC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 08:42:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BBAC664D9C
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 08:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBAC664D9C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-hpyp1O83PiCoZ-ruz3B6fQ-1; Tue, 02 Mar 2021 03:42:13 -0500
X-MC-Unique: hpyp1O83PiCoZ-ruz3B6fQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA0C73E740;
	Tue,  2 Mar 2021 08:42:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 173155D9E3;
	Tue,  2 Mar 2021 08:42:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F20C64E58D;
	Tue,  2 Mar 2021 08:41:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1228flgl005380 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 03:41:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 333822026D3A; Tue,  2 Mar 2021 08:41:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E1F72026D14
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 08:41:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A57BC800050
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 08:41:44 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-302-dP3Byl-3M9ec6v5AvuBcUA-1; Tue, 02 Mar 2021 03:41:41 -0500
X-MC-Unique: dP3Byl-3M9ec6v5AvuBcUA-1
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DqVtZ51TgzjVSN;
	Tue,  2 Mar 2021 16:39:50 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 2 Mar 2021 16:41:25 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
Message-ID: <86bee89e-6d5b-2138-2621-77848e668690@huawei.com>
Date: Tue, 2 Mar 2021 16:41:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1228flgl005380
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Cj4gCj4gSGkgTWFydGluOgo+ICAgIEhlcmUgSSBhZGQgY29uZGxvZygyLCAic3RhcnQgZnVuY25h
bWUiKSwgcHRocmVhZF9jbGVhbnVwX3B1c2goZnVuY19wcmludCwgTlVMTCkKPiBpbiBldmVyeSBw
dGhyZWFkX2NyZWF0ZSBmdW5jLiBXaGVuIHRoZXNlIHR3byBjb3JlIGhhcHBlbmVkLCAiZXhpdCB0
dXJfdGhyZWFkIgo+IGFyZSBsZXNzIHRoYW4gInN0YXJ0IHR1cl90aHJlYWQiLiBTbyB0aGUgdHJv
dWJsZSBtYXkgYmUgaW4gdHVyX3RocmVhZC4KPiAKCklmIEkgbWFkZSBubyBtaXN0YWtlLCB0aGVz
ZSBjb3JlZHVtcHMgaGFwcGVuZWQgd2hlbiB0aGUgdHVyX3RocmVhZCh3aGljaCBpcwpsaWJjaGVj
a190aHJlYWQgaW4gbGF0ZXN0IGNvZGUpIHdhcyBub3QgZmluaXNoZWQgYnV0IGNoZWNrZXLvvIh0
dXLvvIl3YXMKY2xlYXJlZCBieSBjbGVhbnVwX2NoZWNrZXJzLiBCdXQgSSBjYW4ndCB1bmRlcnN0
YW5kIHRoaXMsIGJlY2F1c2UgdGhlIGN0eAppbiB0dXJfdGhyZWFkIHdhc24ndCBmcmVlZCBieSBj
bGVhbnVwX2NoZWNrZXJzLgoKUGxlYXNlIGdpdmUgbWUgc29tZSBoZWxwcywgdGhhbmtzLgoKUmVn
YXJkcywKTGl4aWFva2VuZwoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWw=

