Return-Path: <SRS0=sUdA=LQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7218C2B9F4
	for <dm-devel@archiver.kernel.org>; Tue, 22 Jun 2021 16:10:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 792426109E
	for <dm-devel@archiver.kernel.org>; Tue, 22 Jun 2021 16:10:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 792426109E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-SoL8fgMHO4uUMY2Ahf9lsQ-1; Tue, 22 Jun 2021 12:10:51 -0400
X-MC-Unique: SoL8fgMHO4uUMY2Ahf9lsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93903802928;
	Tue, 22 Jun 2021 16:10:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78FCB60854;
	Tue, 22 Jun 2021 16:10:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D99DF1809C99;
	Tue, 22 Jun 2021 16:10:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15MGAdDf030242 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Jun 2021 12:10:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 18748204402D; Tue, 22 Jun 2021 16:10:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 119BB204402E
	for <dm-devel@redhat.com>; Tue, 22 Jun 2021 16:10:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED917919DC2
	for <dm-devel@redhat.com>; Tue, 22 Jun 2021 16:10:35 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-526-f60wZpkrNz-7fywmVVYVKA-1; Tue, 22 Jun 2021 12:10:33 -0400
X-MC-Unique: f60wZpkrNz-7fywmVVYVKA-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB9A12196C;
	Tue, 22 Jun 2021 16:10:31 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 7861111A97;
	Tue, 22 Jun 2021 16:10:28 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id dotLC3QL0mDIHgAALh3uQQ
	(envelope-from <colyli@suse.de>); Tue, 22 Jun 2021 16:10:28 +0000
To: Xianting Tian <xianting_tian@126.com>
References: <1624377241-8642-1-git-send-email-xianting_tian@126.com>
From: Coly Li <colyli@suse.de>
Message-ID: <930e7a23-a22e-409f-e058-0b1576c5d9d0@suse.de>
Date: Wed, 23 Jun 2021 00:10:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624377241-8642-1-git-send-email-xianting_tian@126.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15MGAdDf030242
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, snitzer@redhat.com,
	Xianting Tian <xianting.tian@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	song@kernel.org, linux-bcache@vger.kernel.org,
	kent.overstreet@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] md: use BLK_STS_OK instead of hardcode
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNi8yMi8yMSAxMTo1NCBQTSwgWGlhbnRpbmcgVGlhbiB3cm90ZToKPiBXaGVuIHNldHRpbmcg
aW8gc3RhdHVzLCBzb21ldGltZXMgaXQgdXNlcyBCTEtfU1RTXyosIHNvbWV0aW1lcywKPiBpdCB1
c2VzIGhhcmRjb2RlIDAuCj4gVXNlIHRoZSBtYWNybyB0byByZXBsYWNlIGhhcmRjb2RlIGluIG11
bHRpcGxlIHBsYWNlcy4KPgo+IFNpZ25lZC1vZmYtYnk6IFhpYW50aW5nIFRpYW4gPHhpYW50aW5n
LnRpYW5AbGludXguYWxpYmFiYS5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvbWQvYmNhY2hlL3JlcXVl
c3QuYyAgfCAyICstCj4gIGRyaXZlcnMvbWQvZG0tY2xvbmUtdGFyZ2V0LmMgfCAyICstCj4gIGRy
aXZlcnMvbWQvZG0taW50ZWdyaXR5LmMgICAgfCAyICstCj4gIGRyaXZlcnMvbWQvZG0tbXBhdGgu
YyAgICAgICAgfCAyICstCj4gIGRyaXZlcnMvbWQvZG0tcmFpZDEuYyAgICAgICAgfCAyICstCj4g
IGRyaXZlcnMvbWQvZG0uYyAgICAgICAgICAgICAgfCAyICstCj4gIGRyaXZlcnMvbWQvcmFpZDEu
YyAgICAgICAgICAgfCA0ICsrLS0KPiAgZHJpdmVycy9tZC9yYWlkMTAuYyAgICAgICAgICB8IDIg
Ky0KPiAgOCBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCj4K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jIGIvZHJpdmVycy9tZC9i
Y2FjaGUvcmVxdWVzdC5jCj4gaW5kZXggNmQxZGU4OC4uNzNiYTVhNiAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMKPiArKysgYi9kcml2ZXJzL21kL2JjYWNoZS9yZXF1
ZXN0LmMKPiBAQCAtNzkwLDcgKzc5MCw3IEBAIHN0YXRpYyB2b2lkIGNhY2hlZF9kZXZfcmVhZF9l
cnJvcihzdHJ1Y3QgY2xvc3VyZSAqY2wpCj4gIAkJLyogUmV0cnkgZnJvbSB0aGUgYmFja2luZyBk
ZXZpY2U6ICovCj4gIAkJdHJhY2VfYmNhY2hlX3JlYWRfcmV0cnkocy0+b3JpZ19iaW8pOwo+ICAK
PiAtCQlzLT5pb3Auc3RhdHVzID0gMDsKPiArCQlzLT5pb3Auc3RhdHVzID0gQkxLX1NUU19PSzsK
PiAgCQlkb19iaW9faG9vayhzLCBzLT5vcmlnX2JpbywgYmFja2luZ19yZXF1ZXN0X2VuZGlvKTsK
PiAgCj4gIAkJLyogWFhYOiBpbnZhbGlkYXRlIGNhY2hlICovCgpIaSBYaWFudGluZywKCk5BQ0sg
Zm9yIGJjYWNoZSBwYXJ0LgoKVGhlIGNoYW5nZSBpcyBpbmNvbXBsZXRlLCBpZiB5b3Ugd2FudCB0
byByZXBsYWNlIDAgYnkgQkxLX1NUU19PSywgeW91CnNob3VsZCBjaGVjayBhbGwgbG9jYXRpb25z
CndoZXJlIHMtPmlvcC5zdGF0dXMgaXMgY2hlY2tlZCBhbmQgcmVwbGFjZSB3aXRoIEJMS19TVFNf
T0sgd2hlbiBuZWNlc3NhcnkuCgpPbmUgYnV0IG5vdCB0aGUgb25seSBvbmUgZXhhbXBsZSBpcywK
ODcxwqDCoMKgwqDCoMKgwqDCoCBpZiAocy0+aW9wLnN0YXR1cykKODcywqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY29udGludWVfYXRfbm9iYXJyaWVyKGNsLCBjYWNoZWRfZGV2X3Jl
YWRfZXJyb3IsCmJjYWNoZV93cSk7Ck1heWJlIHlvdSBzaG91bGQgY2hhbmdlIHRvCsKgwqDCoCDC
oMKgwqAgaWYgKHMtPmlvcC5zdGF0dXMgIT0gQkxLX1NUU19PSykKwqDCoMKgIMKgwqDCoCDCoMKg
wqAgwqDCoMKgIMKgwqDCoCBjb250aW51ZV9hdF9ub2JhcnJpZXIoY2wsIGNhY2hlZF9kZXZfcmVh
ZF9lcnJvciwKYmNhY2hlX3dxKTsKCgpKdXN0IEZZSS4KCkNvbHkgTGkKCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

