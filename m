Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CB4C433C1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:20:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9302261989
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:20:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9302261989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-SsYBW-raPfuoq-2Gfx9IgA-1; Tue, 30 Mar 2021 02:20:15 -0400
X-MC-Unique: SsYBW-raPfuoq-2Gfx9IgA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E60180FCA9;
	Tue, 30 Mar 2021 06:20:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 249EB39A66;
	Tue, 30 Mar 2021 06:20:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA25D1809C83;
	Tue, 30 Mar 2021 06:20:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6KATT005478 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:20:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3FE382166BA2; Tue, 30 Mar 2021 06:20:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 394D12166BA3
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:20:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FE8E811E7A
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:20:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-114-zSc75cOBPgO8Oo4DosdpBg-1;
	Tue, 30 Mar 2021 02:20:01 -0400
X-MC-Unique: zSc75cOBPgO8Oo4DosdpBg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C13B0AD9F;
	Tue, 30 Mar 2021 06:19:59 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-5-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57058af9-117d-a781-5e77-835710eb76b4@suse.de>
Date: Tue, 30 Mar 2021 08:19:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-5-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12U6KATT005478
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 04/12] block: add req flag of REQ_POLL_CTX
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
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yOS8yMSA1OjI2IFBNLCBNaW5nIExlaSB3cm90ZToKPiBBZGQgb25lIHJlcSBmbGFnIFJF
UV9QT0xMX0NUWCB3aGljaCB3aWxsIGJlIHVzZWQgaW4gdGhlIGZvbGxvd2luZyBwYXRjaCBmb3IK
PiBzdXBwb3J0aW5nIGJpbyBiYXNlZCBJTyBwb2xsaW5nLgo+IAo+IEV4YWN0bHkgdGhpcyBmbGFn
IGNhbiBoZWxwIHVzIHRvIGRvOgo+IAo+IDEpIHJlcXVlc3QgZmxhZyBpcyBjbG9uZWQgaW4gYmlv
X2Zhc3RfY2xvbmUoKSwgc28gaWYgd2UgbWFyayBvbmUgRlMgYmlvCj4gYXMgUkVRX1BPTExfQ1RY
LCBhbGwgYmlvcyBjbG9uZWQgZnJvbSB0aGlzIEZTIGJpbyB3aWxsIGJlIG1hcmtlZCBhcwo+IFJF
UV9QT0xMX0NUWCB0b28uCj4gCj4gMikgY3JlYXRlIHBlci10YXNrIGlvIHBvbGxpbmcgY29udGV4
dCBpZiB0aGUgYmlvIGJhc2VkIHF1ZXVlIHN1cHBvcnRzCj4gcG9sbGluZyBhbmQgdGhlIHN1Ym1p
dHRlZCBiaW8gaXMgSElQUkkuIFBlci10YXNrIGlvIHBvbGwgY29udGV4dCB3aWxsIGJlCj4gY3Jl
YXRlZCBkdXJpbmcgc3VibWl0X2JpbygpIGJlZm9yZSBtYXJraW5nIHRoaXMgSElQUkkgYmlvIGFz
IFJFUV9QT0xMX0NUWC4KPiBUaGVuIHdlIGNhbiBhdm9pZCB0byBjcmVhdGUgc3VjaCBpbyBwb2xs
aW5nIGNvbnRleHQgaWYgb25lIGNsb25lZCBiaW8gd2l0aAo+IFJFUV9QT0xMX0NUWCBpcyBzdWJt
aXR0ZWQgZnJvbSBhbm90aGVyIGtlcm5lbCBjb250ZXh0Lgo+IAo+IDMpIGZvciBzdXBwb3J0aW5n
IGJpbyBiYXNlZCBpbyBwb2xsaW5nLCB3ZSBuZWVkIHRvIHBvbGwgSU9zIGZyb20gYWxsCj4gdW5k
ZXJseWluZyBxdWV1ZXMgb2YgdGhlIGJpbyBkZXZpY2UsIHRoaXMgd2F5IGhlbHAgdXMgdG8gcmVj
b2duaXplIHdoaWNoCj4gSU8gbmVlZHMgdG8gcG9sbGVkIGluIGJpbyBiYXNlZCBzdHlsZSwgd2hp
Y2ggd2lsbCBiZSBhcHBsaWVkIGluCj4gZm9sbG93aW5nIHBhdGNoLgo+IAo+IFJldmlld2VkLWJ5
OiBKZWZmbGUgWHUgPGplZmZsZXh1QGxpbnV4LmFsaWJhYmEuY29tPgo+IFNpZ25lZC1vZmYtYnk6
IE1pbmcgTGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPgo+IC0tLQo+ICAgYmxvY2svYmxrLWNvcmUu
YyAgICAgICAgICB8IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0KPiAgIGluY2x1ZGUv
bGludXgvYmxrX3R5cGVzLmggfCAgNCArKysrCj4gICAyIGZpbGVzIGNoYW5nZWQsIDMwIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2Ug
PGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAg
ICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBT
b2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAo
QUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZlbGl4IEltZW5kw7ZyZmZlcgoKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

