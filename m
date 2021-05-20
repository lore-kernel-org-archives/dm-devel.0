Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554BBC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:05:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA84661186
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA84661186
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-KYGMjGgYO4SGBXtShKJg0w-1; Thu, 20 May 2021 02:05:48 -0400
X-MC-Unique: KYGMjGgYO4SGBXtShKJg0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A356A8015C6;
	Thu, 20 May 2021 06:05:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AA145D740;
	Thu, 20 May 2021 06:05:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 639F2180B463;
	Thu, 20 May 2021 06:05:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5snpQ015099 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:54:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7D652107695; Thu, 20 May 2021 05:54:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 791D5107690
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:54:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2AE5858F0D
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:54:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-346-y8XQVb0bMo24_bqmJ1LFqA-1;
	Thu, 20 May 2021 01:54:44 -0400
X-MC-Unique: y8XQVb0bMo24_bqmJ1LFqA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CBCB6AF95;
	Thu, 20 May 2021 05:54:42 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-7-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <00de9606-1ce2-0258-e376-2e3e29438c9d@suse.de>
Date: Thu, 20 May 2021 07:54:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-7-damien.lemoal@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5snpQ015099
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 06/11] dm: move zone related code to
	dm-zone.c
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBNb3ZlIGNvcmUgYW5k
IHRhYmxlIGNvZGUgdXNlZCBmb3Igem9uZWQgdGFyZ2V0cyBhbmQgY29uZGl0aW9uYWxseQo+IGRl
ZmluZWQgd2l0aCAjaWZkZWYgQ09ORklHX0JMS19ERVZfWk9ORUQgdG8gdGhlIG5ldyBmaWxlIGRt
LXpvbmUuYy4KPiBUaGlzIGZpbGUgaXMgY29uZGl0aW9uYWxseSBjb21waWxlZCBkZXBlbmRpbmcg
b24gQ09ORklHX0JMS19ERVZfWk9ORUQuCj4gVGhlIHNtYWxsIGhlbHBlciBkbV9zZXRfem9uZXNf
cmVzdHJpY3Rpb25zKCkgaXMgaW50cm9kdWNlZCB0bwo+IGluaXRpYWxpemUgYSBtYXBwZWQgZGV2
aWNlIHJlcXVlc3QgcXVldWUgem9uZSBhdHRyaWJ1dGVzIGluCj4gZG1fdGFibGVfc2V0X3Jlc3Ry
aWN0aW9ucygpLgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhbWllbiBMZSBNb2FsIDxkYW1pZW4ubGVt
b2FsQHdkYy5jb20+Cj4gUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL21kL01ha2VmaWxlICAgfCAgIDQg
KysKPiAgIGRyaXZlcnMvbWQvZG0tdGFibGUuYyB8ICAxNCArKy0tLS0KPiAgIGRyaXZlcnMvbWQv
ZG0tem9uZS5jICB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysKPiAgIGRyaXZlcnMvbWQvZG0uYyAgICAgICB8ICA3OCAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQo+ICAgZHJpdmVycy9tZC9kbS5oICAgICAgIHwgIDExICsrKysrCj4gICA1IGZp
bGVzIGNoYW5nZWQsIDEyMCBpbnNlcnRpb25zKCspLCA4OSBkZWxldGlvbnMoLSkKPiAgIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2RtLXpvbmUuYwo+IFJldmlld2VkLWJ5OiBIYW5uZXMg
UmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBS
ZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNl
LmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBT
b2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhS
QiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7Zy
ZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

