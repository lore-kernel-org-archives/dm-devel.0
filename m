Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D88C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:02:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5D41C61186
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 06:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D41C61186
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-S_VPvmSOPdGaCGjO9cjj7A-1; Thu, 20 May 2021 02:02:12 -0400
X-MC-Unique: S_VPvmSOPdGaCGjO9cjj7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7952FEC1A5;
	Thu, 20 May 2021 06:02:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D6E60CCC;
	Thu, 20 May 2021 06:02:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D55F180B463;
	Thu, 20 May 2021 06:02:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K5s37c015046 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 01:54:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 993F1202BFA0; Thu, 20 May 2021 05:54:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94CF020287DE
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:54:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BED5101D221
	for <dm-devel@redhat.com>; Thu, 20 May 2021 05:54:00 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-317-k8AaJejbPjaElS3abirE0A-1;
	Thu, 20 May 2021 01:53:53 -0400
X-MC-Unique: k8AaJejbPjaElS3abirE0A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3C4DAAD71;
	Thu, 20 May 2021 05:53:52 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
	<20210520042228.974083-6-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <493fffd5-c5fe-f5ae-c4ba-7eeef299772e@suse.de>
Date: Thu, 20 May 2021 07:53:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520042228.974083-6-damien.lemoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14K5s37c015046
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 05/11] dm: cleanup device_area_is_invalid()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMC8yMSA2OjIyIEFNLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPiBJbiBkZXZpY2VfYXJl
YV9pc19pbnZhbGlkKCksIHVzZSBiZGV2X2lzX3pvbmVkKCkgaW5zdGVhZCBvZiBvcGVuCj4gY29k
aW5nIHRoZSB0ZXN0IG9uIHRoZSB6b25lZCBtb2RlbCByZXR1cm5lZCBieSBiZGV2X3pvbmVkX21v
ZGVsKCkuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFtaWVuIExlIE1vYWwgPGRhbWllbi5sZW1vYWxA
d2RjLmNvbT4KPiBSZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVt
c2hpcm5Ad2RjLmNvbT4KPiAtLS0KPiAgIGRyaXZlcnMvbWQvZG0tdGFibGUuYyB8IDIgKy0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL21kL2RtLXRhYmxlLmMgYi9kcml2ZXJzL21kL2RtLXRhYmxlLmMKPiBp
bmRleCBlZTQ3YTMzMmI0NjIuLjIxZmQ5Y2Q0ZGEzMiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21k
L2RtLXRhYmxlLmMKPiArKysgYi9kcml2ZXJzL21kL2RtLXRhYmxlLmMKPiBAQCAtMjQ5LDcgKzI0
OSw3IEBAIHN0YXRpYyBpbnQgZGV2aWNlX2FyZWFfaXNfaW52YWxpZChzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aSwgc3RydWN0IGRtX2RldiAqZGV2LAo+ICAgCSAqIElmIHRoZSB0YXJnZXQgaXMgbWFwcGVk
IHRvIHpvbmVkIGJsb2NrIGRldmljZShzKSwgY2hlY2sKPiAgIAkgKiB0aGF0IHRoZSB6b25lcyBh
cmUgbm90IHBhcnRpYWxseSBtYXBwZWQuCj4gICAJICovCj4gLQlpZiAoYmRldl96b25lZF9tb2Rl
bChiZGV2KSAhPSBCTEtfWk9ORURfTk9ORSkgewo+ICsJaWYgKGJkZXZfaXNfem9uZWQoYmRldikp
IHsKPiAgIAkJdW5zaWduZWQgaW50IHpvbmVfc2VjdG9ycyA9IGJkZXZfem9uZV9zZWN0b3JzKGJk
ZXYpOwo+ICAgCj4gICAJCWlmIChzdGFydCAmICh6b25lX3NlY3RvcnMgLSAxKSkgewo+IApSZXZp
ZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMK
LS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJj
aGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEg
NzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkw
NDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVy
OiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs

