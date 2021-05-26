Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F796C47082
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 06:40:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0CDCC613F4
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 06:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CDCC613F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-IrVpPE9UMYWZKKOBUPJPhw-1; Wed, 26 May 2021 02:40:22 -0400
X-MC-Unique: IrVpPE9UMYWZKKOBUPJPhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8717B802938;
	Wed, 26 May 2021 06:40:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F3871001B2C;
	Wed, 26 May 2021 06:40:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF6A5180B463;
	Wed, 26 May 2021 06:40:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q6eFm9013565 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 May 2021 02:40:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 17841208AB8B; Wed, 26 May 2021 06:40:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11247208AB80
	for <dm-devel@redhat.com>; Wed, 26 May 2021 06:40:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B3D6833959
	for <dm-devel@redhat.com>; Wed, 26 May 2021 06:40:12 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-404-CzbD7IszPI2k8cIfOlqHpQ-1;
	Wed, 26 May 2021 02:40:07 -0400
X-MC-Unique: CzbD7IszPI2k8cIfOlqHpQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4F375B2A1;
	Wed, 26 May 2021 06:40:06 +0000 (UTC)
To: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<20210525212501.226888-11-damien.lemoal@wdc.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <308fa8bd-83a7-0c08-a26e-91fe03d12afd@suse.de>
Date: Wed, 26 May 2021 08:40:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210525212501.226888-11-damien.lemoal@wdc.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14Q6eFm9013565
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v5 10/11] dm: introduce zone append emulation
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yNS8yMSAxMToyNSBQTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gRm9yIHpvbmVkIHRh
cmdldHMgdGhhdCBjYW5ub3Qgc3VwcG9ydCB6b25lIGFwcGVuZCBvcGVyYXRpb25zLCBpbXBsZW1l
bnQKPiBhbiBlbXVsYXRpb24gdXNpbmcgcmVndWxhciB3cml0ZSBvcGVyYXRpb25zLiBJZiB0aGUg
b3JpZ2luYWwgQklPCj4gc3VibWl0dGVkIGJ5IHRoZSB1c2VyIGlzIGEgem9uZSBhcHBlbmQgb3Bl
cmF0aW9uLCBjaGFuZ2UgaXRzIGNsb25lIGludG8KPiBhIHJlZ3VsYXIgd3JpdGUgb3BlcmF0aW9u
IGRpcmVjdGVkIGF0IHRoZSB0YXJnZXQgem9uZSB3cml0ZSBwb2ludGVyCj4gcG9zaXRpb24uCj4g
Cj4gVG8gZG8gc28sIGFuIGFycmF5IG9mIHdyaXRlIHBvaW50ZXIgb2Zmc2V0cyAod3JpdGUgcG9p
bnRlciBwb3NpdGlvbgo+IHJlbGF0aXZlIHRvIHRoZSBzdGFydCBvZiBhIHpvbmUpIGlzIGFkZGVk
IHRvIHN0cnVjdCBtYXBwZWRfZGV2aWNlLiBBbGwKPiBvcGVyYXRpb25zIHRoYXQgbW9kaWZ5IGEg
c2VxdWVudGlhbCB6b25lIHdyaXRlIHBvaW50ZXIgKHdyaXRlcywgem9uZQo+IHJlc2V0LCB6b25l
IGZpbmlzaCBhbmQgem9uZSBhcHBlbmQpIGFyZSBpbnRlcnNlcHRlZCBpbiBfX21hcF9iaW8oKSBh
bmQKPiBwcm9jZXNzZWQgdXNpbmcgdGhlIG5ldyBmdW5jdGlvbnMgZG1fem9uZV9tYXBfYmlvKCku
Cj4gCj4gRGV0ZWN0aW9uIG9mIHRoZSB0YXJnZXQgYWJpbGl0eSB0byBuYXRpdmVseSBzdXBwb3J0
IHpvbmUgYXBwZW5kCj4gb3BlcmF0aW9ucyBpcyBkb25lIGZyb20gZG1fdGFibGVfc2V0X3Jlc3Ry
aWN0aW9ucygpIGJ5IGNhbGxpbmcgdGhlCj4gZnVuY3Rpb24gZG1fc2V0X3pvbmVzX3Jlc3RyaWN0
aW9ucygpLiBBIHRhcmdldCB0aGF0IGRvZXMgbm90IHN1cHBvcnQKPiB6b25lIGFwcGVuZCBvcGVy
YXRpb24sIGVpdGhlciBieSBleHBsaWNpdGx5IGRlY2xhcmluZyBpdCB1c2luZyB0aGUgbmV3Cj4g
c3RydWN0IGRtX3RhcmdldCBmaWVsZCB6b25lX2FwcGVuZF9ub3Rfc3VwcG9ydGVkLCBvciBiZWNh
dXNlIHRoZSBkZXZpY2UKPiB0YWJsZSBjb250YWlucyBhIG5vbi16b25lZCBkZXZpY2UsIGhhcyBp
dHMgbWFwcGVkIGRldmljZSBtYXJrZWQgd2l0aCB0aGUKPiBuZXcgZmxhZyBETUZfWk9ORV9BUFBF
TkRfRU1VTEFURUQuIFRoZSBoZWxwZXIgZnVuY3Rpb24KPiBkbV9lbXVsYXRlX3pvbmVfYXBwZW5k
KCkgaXMgaW50cm9kdWNlZCB0byB0ZXN0IGEgbWFwcGVkIGRldmljZSBmb3IgdGhpcwo+IG5ldyBm
bGFnLgo+IAo+IEF0b21pY2l0eSBvZiB0aGUgem9uZXMgd3JpdGUgcG9pbnRlciB0cmFja2luZyBh
bmQgdXBkYXRlcyBpcyBkb25lIHVzaW5nCj4gYSB6b25lIHdyaXRlIGxvY2tpbmcgbWVjaGFuaXNt
IGJhc2VkIG9uIGEgYml0bWFwLiBUaGlzIGlzIHNpbWlsYXIgdG8KPiB0aGUgYmxvY2sgbGF5ZXIg
bWV0aG9kIGJ1dCBiYXNlZCBvbiBCSU9zIHJhdGhlciB0aGFuIHN0cnVjdCByZXF1ZXN0Lgo+IEEg
em9uZSB3cml0ZSBsb2NrIGlzIHRha2VuIGluIGRtX3pvbmVfbWFwX2JpbygpIGZvciBhbnkgY2xv
bmUgQklPIHdpdGgKPiBhbiBvcGVyYXRpb24gdHlwZSB0aGF0IGNoYW5nZXMgdGhlIEJJTyB0YXJn
ZXQgem9uZSB3cml0ZSBwb2ludGVyCj4gcG9zaXRpb24uIFRoZSB6b25lIHdyaXRlIGxvY2sgaXMg
cmVsZWFzZWQgaWYgdGhlIGNsb25lIEJJTyBpcyBmYWlsZWQKPiBiZWZvcmUgc3VibWlzc2lvbiBv
ciB3aGVuIGRtX3pvbmVfZW5kaW8oKSBpcyBjYWxsZWQgd2hlbiB0aGUgY2xvbmUgQklPCj4gY29t
cGxldGVzLgo+IAo+IFRoZSB6b25lIHdyaXRlIGxvY2sgYml0bWFwIG9mIHRoZSBtYXBwZWQgZGV2
aWNlLCB0b2dldGhlciB3aXRoIGEgYml0bWFwCj4gaW5kaWNhdGluZyB6b25lIHR5cGVzIChjb252
X3pvbmVzX2JpdG1hcCkgYW5kIHRoZSB3cml0ZSBwb2ludGVyIG9mZnNldAo+IGFycmF5ICh6d3Bf
b2Zmc2V0KSBhcmUgYWxsb2NhdGVkIGFuZCBpbml0aWFsaXplZCB3aXRoIGEgZnVsbCBkZXZpY2Ug
em9uZQo+IHJlcG9ydCBpbiBkbV9zZXRfem9uZXNfcmVzdHJpY3Rpb25zKCkgdXNpbmcgdGhlIGZ1
bmN0aW9uCj4gZG1fcmV2YWxpZGF0ZV96b25lcygpLgo+IAo+IEZvciBmYWlsZWQgb3BlcmF0aW9u
cyB0aGF0IG1heSBoYXZlIG1vZGlmaWVkIGEgem9uZSB3cml0ZSBwb2ludGVyLCB0aGUKPiB6b25l
IHdyaXRlIHBvaW50ZXIgb2Zmc2V0IGlzIG1hcmtlZCBhcyBpbnZhbGlkIGluIGRtX3pvbmVfZW5k
aW8oKS4KPiBab25lcyB3aXRoIGFuIGludmFsaWQgd3JpdGUgcG9pbnRlciBvZmZzZXQgYXJlIGNo
ZWNrZWQgYW5kIHRoZSB3cml0ZQo+IHBvaW50ZXIgdXBkYXRlZCB1c2luZyBhbiBpbnRlcm5hbCBy
ZXBvcnQgem9uZSBvcGVyYXRpb24gd2hlbiB0aGUKPiBmYXVsdHkgem9uZSBpcyBhY2Nlc3NlZCBh
Z2FpbiBieSB0aGUgdXNlci4KPiAKPiBBbGwgZnVuY3Rpb25zIGFkZGVkIGZvciB0aGlzIGVtdWxh
dGlvbiBoYXZlIGEgbWluaW1hbCBvdmVyaGVhZCBmb3IKPiB6b25lZCB0YXJnZXRzIG5hdGl2ZWx5
IHN1cHBvcnRpbmcgem9uZSBhcHBlbmQgb3BlcmF0aW9ucy4gUmVndWxhcgo+IGRldmljZSB0YXJn
ZXRzIGFyZSBhbHNvIG5vdCBhZmZlY3RlZC4gVGhlIGFkZGVkIGNvZGUgYWxzbyBkb2VzIG5vdAo+
IGltcGFjdCBidWlsZHMgd2l0aCBDT05GSUdfQkxLX0RFVl9aT05FRCBkaXNhYmxlZCBieSBzdHVi
YmluZyBvdXQgYWxsCj4gZG0gem9uZSByZWxhdGVkIGZ1bmN0aW9ucy4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxlbW9hbEB3ZGMuY29tPgo+IFJldmlld2VkLWJ5
OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+Cj4gLS0tCj4g
ICBkcml2ZXJzL21kL2RtLWNvcmUuaCAgICAgICAgICB8ICAxMyArCj4gICBkcml2ZXJzL21kL2Rt
LXRhYmxlLmMgICAgICAgICB8ICAxOSArLQo+ICAgZHJpdmVycy9tZC9kbS16b25lLmMgICAgICAg
ICAgfCA1ODAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQo+ICAgZHJpdmVycy9t
ZC9kbS5jICAgICAgICAgICAgICAgfCAgMzggKystCj4gICBkcml2ZXJzL21kL2RtLmggICAgICAg
ICAgICAgICB8ICAxNiArLQo+ICAgaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggfCAgIDYg
Kwo+ICAgNiBmaWxlcyBjaGFuZ2VkLCA2MTggaW5zZXJ0aW9ucygrKSwgNTQgZGVsZXRpb25zKC0p
Cj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywK
Ckhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3Rv
cmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0
ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0
c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=

