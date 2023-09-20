Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD54CE79D1
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695219091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PE4JfA4QMEQVO2tltrBmri+YgYgRRbws4i3T6D/CiUg=;
	b=VRnfTpjOj7rza4cW63gdQLo+KB5tf8GopVSxaLMbAcq7dmhrzwmwWxWfXY9BWHnsLFra0w
	+HGax5tzIDHkgga94PkDS/PmMjeFRvUUPNxoMiojpO7C0peRcghhQbOqsbzq3SkkX2HFTL
	jN/3WV+ECPD06gvYIIEkdYnJrUlI9AY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-erJYiEtVMWC7Hk2Z5_ZP0A-1; Wed, 20 Sep 2023 10:11:28 -0400
X-MC-Unique: erJYiEtVMWC7Hk2Z5_ZP0A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C32A5801779;
	Wed, 20 Sep 2023 14:11:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4227C20268CF;
	Wed, 20 Sep 2023 14:11:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DD8A71946594;
	Wed, 20 Sep 2023 14:11:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C37FA1946594
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 14:07:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7340C40C6EC0; Wed, 20 Sep 2023 14:07:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C83F40C6EBF
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 14:07:04 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E38385A5BD
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 14:07:04 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-9CRQ3VodNkifPQO347kuww-1; Wed,
 20 Sep 2023 10:07:01 -0400
X-MC-Unique: 9CRQ3VodNkifPQO347kuww-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id CFBC621AFC;
 Wed, 20 Sep 2023 14:06:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 19CC61333E;
 Wed, 20 Sep 2023 14:06:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +tDyKoL8CmXfFgAAMHmgww
 (envelope-from <hare@suse.de>); Wed, 20 Sep 2023 14:06:58 +0000
Message-ID: <c7818967-1fea-45da-9713-20de4bcb1c44@suse.de>
Date: Wed, 20 Sep 2023 16:06:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Fedor Pchelkin <pchelkin@ispras.ru>, Mike Snitzer <snitzer@kernel.org>
References: <20230920105119.21276-1-pchelkin@ispras.ru>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230920105119.21276-1-pchelkin@ispras.ru>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] dm-zoned: free dmz->ddev array in
 dmz_put_zoned_device
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
Cc: lvc-project@linuxtesting.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
 Alexey Khoroshilov <khoroshilov@ispras.ru>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS8yMC8yMyAxMjo1MSwgRmVkb3IgUGNoZWxraW4gd3JvdGU6Cj4gQ29tbWl0IDRkYmExMjg4
MWY4OCAoImRtIHpvbmVkOiBzdXBwb3J0IGFyYml0cmFyeSBudW1iZXIgb2YgZGV2aWNlcyIpCj4g
bWFkZSB0aGUgcG9pbnRlcnMgdG8gYWRkaXRpb25hbCB6b25lZCBkZXZpY2VzIHRvIGJlIHN0b3Jl
ZCBpbiBhCj4gZHluYW1pY2FsbHkgYWxsb2NhdGVkIGRtei0+ZGRldiBhcnJheS4gSG93ZXZlciwg
dGhpcyBhcnJheSBpcyBub3QgZnJlZWQuCj4gCj4gRnJlZSBpdCB3aGVuIGNsZWFuaW5nIHVwIHpv
bmVkIGRldmljZSBpbmZvcm1hdGlvbiBpbnNpZGUKPiBkbXpfcHV0X3pvbmVkX2RldmljZSgpLiBB
c3NpZ25pbmcgTlVMTCB0byBkbXotPmRkZXYgZWxlbWVudHMgZG9lc24ndCBtYWtlCj4gc2Vuc2Ug
dGhlcmUgYXMgdGhleSBhcmUgbm90IHN1cHBvc2VkIHRvIGJlIHJldXNlZCBsYXRlciBhbmQgdGhl
IHdob2xlIGRtego+IHRhcmdldCBzdHJ1Y3R1cmUgaXMgYmVpbmcgY2xlYW5lZCBhbnl3YXkuCj4g
Cj4gRm91bmQgYnkgTGludXggVmVyaWZpY2F0aW9uIENlbnRlciAobGludXh0ZXN0aW5nLm9yZyku
Cj4gCj4gRml4ZXM6IDRkYmExMjg4MWY4OCAoImRtIHpvbmVkOiBzdXBwb3J0IGFyYml0cmFyeSBu
dW1iZXIgb2YgZGV2aWNlcyIpCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKPiBTaWduZWQt
b2ZmLWJ5OiBGZWRvciBQY2hlbGtpbiA8cGNoZWxraW5AaXNwcmFzLnJ1Pgo+IC0tLQo+ICAgZHJp
dmVycy9tZC9kbS16b25lZC10YXJnZXQuYyB8IDggKysrLS0tLS0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCAzIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMgYi9kcml2ZXJzL21kL2RtLXpvbmVkLXRhcmdldC5jCj4g
aW5kZXggYWQ4ZTY3MGEyZjliLi5lMjVjZDlkYjYyNzUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9t
ZC9kbS16b25lZC10YXJnZXQuYwo+ICsrKyBiL2RyaXZlcnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMK
PiBAQCAtNzUzLDEyICs3NTMsMTAgQEAgc3RhdGljIHZvaWQgZG16X3B1dF96b25lZF9kZXZpY2Uo
c3RydWN0IGRtX3RhcmdldCAqdGkpCj4gICAJc3RydWN0IGRtel90YXJnZXQgKmRteiA9IHRpLT5w
cml2YXRlOwo+ICAgCWludCBpOwo+ICAgCj4gLQlmb3IgKGkgPSAwOyBpIDwgZG16LT5ucl9kZGV2
czsgaSsrKSB7Cj4gLQkJaWYgKGRtei0+ZGRldltpXSkgewo+ICsJZm9yIChpID0gMDsgaSA8IGRt
ei0+bnJfZGRldnM7IGkrKykKPiArCQlpZiAoZG16LT5kZGV2W2ldKQo+ICAgCQkJZG1fcHV0X2Rl
dmljZSh0aSwgZG16LT5kZGV2W2ldKTsKPiAtCQkJZG16LT5kZGV2W2ldID0gTlVMTDsKPiAtCQl9
Cj4gLQl9Cj4gKwlrZnJlZShkbXotPmRkZXYpOwo+ICAgfQo+ICAgCj4gICBzdGF0aWMgaW50IGRt
el9maXh1cF9kZXZpY2VzKHN0cnVjdCBkbV90YXJnZXQgKnRpKQoKSG1tLiBJJ20gbm90IHRoYXQg
aGFwcHkgd2l0aCBpdDsgZG16X3B1dF96b25lZF9kZXZpY2UoKSBpcyB1c2luZyAKZG1fdGFyZ2V0
IGFzIGFuIGFyZ3VtZW50LCB3aGVyZWFzIGFsbCBvZiB0aGUgZnVuY3Rpb25zIHN1cnJvdW5kaW5n
IHRoZSAKY2FsbCBzaXRlcyBpcyB1c2luZyB0aGUgZG16X3RhcmdldCBkaXJlY3RseS4KCk1pbmQg
dG8gbW9kaWZ5IHRoZSBmdW5jdGlvbiB0byB1c2UgJ3N0cnVjdCBkbXpfdGFyZ2V0JyBhcyBhbiBh
cmd1bWVudD8KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAg
ICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlv
bnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8
cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRy
ZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

