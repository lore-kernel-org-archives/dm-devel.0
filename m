Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EE3C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F13D64D9A
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F13D64D9A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-E6WXR1IJPqehgvHC-62NfQ-1; Wed, 17 Feb 2021 10:38:30 -0500
X-MC-Unique: E6WXR1IJPqehgvHC-62NfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F06F679EC1;
	Wed, 17 Feb 2021 15:38:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE70F6F7EA;
	Wed, 17 Feb 2021 15:38:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B06958073;
	Wed, 17 Feb 2021 15:38:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11A2mb2x028182 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 21:48:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 86223A9E5E; Wed, 10 Feb 2021 02:48:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80E78A9EED
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 02:48:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7522185A795
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 02:48:34 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-447-V8OMRT7SP4SqNWY_16oEPg-1; Tue, 09 Feb 2021 21:48:32 -0500
X-MC-Unique: V8OMRT7SP4SqNWY_16oEPg-1
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Db3bD6z5nz7jVC;
	Wed, 10 Feb 2021 10:28:24 +0800 (CST)
Received: from [10.174.177.4] (10.174.177.4) by DGGEMS408-HUB.china.huawei.com
	(10.3.19.208) with Microsoft SMTP Server id 14.3.498.0;
	Wed, 10 Feb 2021 10:29:40 +0800
To: lixiaokeng <lixiaokeng@huawei.com>, Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
	<05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
	<6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
	<7b2c571eb7ff9d54c51037a4fae87796ead1144e.camel@suse.com>
	<3c8f215a-75d5-0f7b-1008-c8c565bb0cf3@huawei.com>
	<11c072c152937004e5f08ecff8dd9ded7d915af6.camel@suse.com>
	<3e0d931e-d0df-69e3-21f7-456b99e5b6f3@huawei.com>
From: "Hexiaowen (Hex, EulerOS)" <hexiaowen@huawei.com>
Message-ID: <d1359701-6c22-f199-8c36-15ea733f7ccc@huawei.com>
Date: Wed, 10 Feb 2021 10:29:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3e0d931e-d0df-69e3-21f7-456b99e5b6f3@huawei.com>
X-Originating-IP: [10.174.177.4]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11A2mb2x028182
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgrlnKggMjAyMS8yLzEwIDEwOjAyLCBsaXhpYW9rZW5nIOWGmemBkzoKPiAKPiAKPj4KPj4gTm93
IEkgZ290IGl0LCBldmVudHVhbGx5IDotKSBUaGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uLiBX
b3VsZCBpdCBiZQo+PiBvc3NpYmxlIGZvciB5b3UgdG8gY2F0ZWdvcml6ZSB0aGUgZGlmZmVyZW50
wqBpc3N1ZXMgYW5kIHByb3ZpZGUgY29yZQo+PiBkdW1wcz8KPj4KPiAKPiBXaGVuIGJsb2NraW5n
IG9mIHRocmVhZCBjYW5jZWxsYXRpb24gZHVyaW5nIHVkZXZfbW9uaXRvcl9yZWNlaXZlX2Rldmlj
ZSgpLAo+IHRoZXJlIGFyZSBqdXN0ID8/KCkgYW5kIHB0aHJlYWRfdGVzdGNhbmNlbCgpIGNyYXNo
Lgo+IFRoZSBzdGFjazEudGd6IGlzID8/KCkgY29yZWR1bXAgYW5kIHRoZSBzdGFjazIudGd6IGlz
IHB0aHJlYWRfdGVzdGNhbmNlbCgpCj4gY29yZWR1bXBzLgo+IAo+PiBZb3UgbWVudGlvbmVkIGlu
IHRoZSBzeXN0ZW1kIGlzc3VlIHRoYXQgeW91IHdlcmUgcGxheWluZyBhcm91bmQgd2l0aAo+PiB0
aGUgZ2NjIC1mZXhjZXB0aW9ucyBmbGFnLiBBcyBJIHJlbWFya2VkIHRoZXJlIC0gaG93IGRpZCBp
dCBnZXQgc2V0IGluCj4+IHRoZSBmaXJzdCBwbGFjZT8gV2hhdCBkaXN0cm8gYXJlIHlvdSB1c2lu
Zz8KPiAKPiBIZSBYaWFvd2VuLCBwbGVhc2UgYW5zd2VyIHRoaXMgcXVlc3Rpb24uCgpXZSB1c2Ug
dGhlIHJlbGVhc2UgdmVyc2lvbiBvcGVuRXVsZXIgMjAuMDMgTFRTIGFuZCB0aGUgc3lzdGVtZCB2
ZXJzaW9uIDI0My4KCkR1cmluZyBSUE1idWlsZCwgYWRkIC1mZXhjZXB0aW9ucyBnbG9iYWxseSB0
byBDRkxBR1MuCgo+IAo+IFJlZ2FyZHMsCj4gTGl4aWFva2VuZwo+IAoKCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

