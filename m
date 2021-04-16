Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085F0C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 14:01:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B9D360FEE
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 14:01:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B9D360FEE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-ubwWtuPTMFibHe1m88s4JQ-1; Fri, 16 Apr 2021 10:01:19 -0400
X-MC-Unique: ubwWtuPTMFibHe1m88s4JQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 248D787A82A;
	Fri, 16 Apr 2021 14:01:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C69FB610F1;
	Fri, 16 Apr 2021 14:01:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EC1B31806D0F;
	Fri, 16 Apr 2021 14:01:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GE19xu032247 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 10:01:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A691621BBFA5; Fri, 16 Apr 2021 14:01:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A193C21BBFA4
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 14:01:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61E4385A5B5
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 14:01:06 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-458-MiSYe7IvOB-xRodIgwupmA-1;
	Fri, 16 Apr 2021 10:01:02 -0400
X-MC-Unique: MiSYe7IvOB-xRodIgwupmA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 0484EB12D;
	Fri, 16 Apr 2021 14:01:01 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-3-snitzer@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <da184561-2c97-5807-5c5b-9cc6593693c6@suse.de>
Date: Fri, 16 Apr 2021 16:01:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210415231530.95464-3-snitzer@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13GE19xu032247
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	Chao Leng <lengchao@huawei.com>, linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v2 2/4] nvme: allow local retry for requests
 with REQ_FAILFAST_TRANSPORT set
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8xNi8yMSAxOjE1IEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gRnJvbTogQ2hhbyBMZW5n
IDxsZW5nY2hhb0BodWF3ZWkuY29tPgo+IAo+IFJFUV9GQUlMRkFTVF9UUkFOU1BPUlQgd2FzIGRl
c2lnbmVkIGZvciBTQ1NJLCBiZWNhdXNlIHRoZSBTQ1NJIHByb3RvY29sCj4gZG9lcyBub3QgZGVm
aW5lIHRoZSBsb2NhbCByZXRyeSBtZWNoYW5pc20uIFNDU0kgaW1wbGVtZW50cyBhIGZ1enp5Cj4g
bG9jYWwgcmV0cnkgbWVjaGFuaXNtLCBzbyBSRVFfRkFJTEZBU1RfVFJBTlNQT1JUIGlzIG5lZWRl
ZCB0byBhbGxvdwo+IGhpZ2hlci1sZXZlbCBtdWx0aXBhdGhpbmcgc29mdHdhcmUgdG8gcGVyZm9y
bSBmYWlsb3Zlci9yZXRyeS4KPiAKPiBOVk1lIGlzIGRpZmZlcmVudCB3aXRoIFNDU0kgYWJvdXQg
dGhpcy4gSXQgZGVmaW5lcyBhIGxvY2FsIHJldHJ5Cj4gbWVjaGFuaXNtIGFuZCBwYXRoIGVycm9y
IGNvZGVzLCBzbyBOVk1lIHNob3VsZCByZXRyeSBsb2NhbCBmb3Igbm9uCj4gcGF0aCBlcnJvci4g
SWYgcGF0aCByZWxhdGVkIGVycm9yLCB3aGV0aGVyIHRvIHJldHJ5IGFuZCBob3cgdG8gcmV0cnkK
PiBpcyBzdGlsbCBkZXRlcm1pbmVkIGJ5IGhpZ2hlci1sZXZlbCBtdWx0aXBhdGhpbmcncyBmYWls
b3Zlci4KPiAKPiBVbmxpa2UgU0NTSSwgTlZNZSBzaG91bGRuJ3QgcHJldmVudCByZXRyeSBpZiBS
RVFfRkFJTEZBU1RfVFJBTlNQT1JUCj4gYmVjYXVzZSBOVk1lJ3MgbG9jYWwgcmV0cnkgaXMgbmVl
ZGVkIC0tIGFzIGlzIE5WTWUgc3BlY2lmaWMgbG9naWMgdG8KPiBjYXRlZ29yaXplIHdoZXRoZXIg
YW4gZXJyb3IgaXMgcGF0aCByZWxhdGVkLgo+IAo+IEluIHRoaXMgd2F5LCB0aGUgbWVjaGFuaXNt
IG9mIE5WTWUgbXVsdGlwYXRoIG9yIG90aGVyIG11bHRpcGF0aCBhcmUKPiBub3cgZXF1aXZhbGVu
dC4gVGhlIG1lY2hhbmlzbSBpczogbm9uIHBhdGggcmVsYXRlZCBlcnJvciB3aWxsIGJlCj4gcmV0
cmllZCBsb2NhbGx5LCBwYXRoIHJlbGF0ZWQgZXJyb3IgaXMgaGFuZGxlZCBieSBtdWx0aXBhdGgu
Cj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hhbyBMZW5nIDxsZW5nY2hhb0BodWF3ZWkuY29tPgo+IFtz
bml0emVyOiBlZGl0ZWQgaGVhZGVyIGZvciBncmFtbWFyIGFuZCBjbGFyaXR5LCBhbHNvIGFkZGVk
IGNvZGUgY29tbWVudF0KPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAcmVk
aGF0LmNvbT4KPiAtLS0KPiAgZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIHwgOSArKysrKysrKy0K
PiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMgYi9kcml2ZXJzL252bWUvaG9zdC9j
b3JlLmMKPiBpbmRleCA1NDBkNmZkOGZmZWYuLjQxMzRjZjNjN2U0OCAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPiArKysgYi9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMK
PiBAQCAtMzA2LDcgKzMwNiwxNCBAQCBzdGF0aWMgaW5saW5lIGVudW0gbnZtZV9kaXNwb3NpdGlv
biBudm1lX2RlY2lkZV9kaXNwb3NpdGlvbihzdHJ1Y3QgcmVxdWVzdCAqcmVxKQo+ICAJaWYgKGxp
a2VseShudm1lX3JlcShyZXEpLT5zdGF0dXMgPT0gMCkpCj4gIAkJcmV0dXJuIENPTVBMRVRFOwo+
ICAKPiAtCWlmIChibGtfbm9yZXRyeV9yZXF1ZXN0KHJlcSkgfHwKPiArCS8qCj4gKwkgKiBSRVFf
RkFJTEZBU1RfVFJBTlNQT1JUIGlzIHNldCBieSB1cHBlciBsYXllciBzb2Z0d2FyZSB0aGF0Cj4g
KwkgKiBoYW5kbGVzIG11bHRpcGF0aGluZy4gVW5saWtlIFNDU0ksIE5WTWUncyBlcnJvciBoYW5k
bGluZyB3YXMKPiArCSAqIHNwZWNpZmljYWxseSBkZXNpZ25lZCB0byBoYW5kbGUgbG9jYWwgcmV0
cnkgZm9yIG5vbi1wYXRoIGVycm9ycy4KPiArCSAqIEFzIHN1Y2gsIGFsbG93IE5WTWUncyBsb2Nh
bCByZXRyeSBtZWNoYW5pc20gdG8gYmUgdXNlZCBmb3IKPiArCSAqIHJlcXVlc3RzIG1hcmtlZCB3
aXRoIFJFUV9GQUlMRkFTVF9UUkFOU1BPUlQuCj4gKwkgKi8KPiArCWlmICgocmVxLT5jbWRfZmxh
Z3MgJiAoUkVRX0ZBSUxGQVNUX0RFViB8IFJFUV9GQUlMRkFTVF9EUklWRVIpKSB8fAo+ICAJICAg
IChudm1lX3JlcShyZXEpLT5zdGF0dXMgJiBOVk1FX1NDX0ROUikgfHwKPiAgCSAgICBudm1lX3Jl
cShyZXEpLT5yZXRyaWVzID49IG52bWVfbWF4X3JldHJpZXMpCj4gIAkJcmV0dXJuIENPTVBMRVRF
Owo+IApIdWg/CgojZGVmaW5lIGJsa19ub3JldHJ5X3JlcXVlc3QocnEpIFwKICAgICAgICAoKHJx
KS0+Y21kX2ZsYWdzICYgKFJFUV9GQUlMRkFTVF9ERVZ8UkVRX0ZBSUxGQVNUX1RSQU5TUE9SVHwg
XAogICAgICAgICAgICAgICAgICAgICAgICAgICAgIFJFUV9GQUlMRkFTVF9EUklWRVIpKQoKbWFr
aW5nIHRoZSBvbmx5IF9hY3R1YWxfIGNoYW5nZSBpbiB5b3VyIHBhdGNoIF9ub3RfIGV2YWx1YXRp
bmcgdGhlClJFUV9GQUlMRkFTVF9EUklWRVIsIHdoaWNoIGluY2lkZW50YWxseSBpcyBvbmx5IHVz
ZWQgYnkgdGhlIE5WTWUgY29yZS4KU28gd2hhdCBpcyBpdCB5b3UncmUgdHJ5aW5nIHRvIHNvbHZl
PwoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkgICAgICAgIEtlcm5l
bCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTEx
IDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgsIDkwNDA5IE7D
vHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZykKCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

