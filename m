Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD525C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 22 Apr 2022 06:36:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-lDRH7vr3Mju6i8pDqmAdVw-1; Fri, 22 Apr 2022 02:35:24 -0400
X-MC-Unique: lDRH7vr3Mju6i8pDqmAdVw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3096983396F;
	Fri, 22 Apr 2022 06:35:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50098145BA51;
	Fri, 22 Apr 2022 06:35:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E71A51940350;
	Fri, 22 Apr 2022 06:35:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C350194034C
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Apr 2022 06:35:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5C6B440D2820; Fri, 22 Apr 2022 06:35:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5499040C128B
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 06:35:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C4221014A6C
 for <dm-devel@redhat.com>; Fri, 22 Apr 2022 06:35:20 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-sKipsRVYORqEjVf7Rs2w8Q-1; Fri, 22 Apr 2022 02:34:38 -0400
X-MC-Unique: sKipsRVYORqEjVf7Rs2w8Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 74582B82A89;
 Fri, 22 Apr 2022 06:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B3FC385A4;
 Fri, 22 Apr 2022 06:27:19 +0000 (UTC)
Date: Thu, 21 Apr 2022 23:27:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YmJKxsqV5k+vKA+h@sol.localdomain>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de>
 <YmBiAQ/IZbFhRc6o@sol.localdomain> <20220421142535.GA21025@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220421142535.GA21025@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 2/2] blk-crypto: fix the blk_crypto_profile
 liftime
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
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
 linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mike Snitzer <snitzer@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
 Ritesh Harjani <riteshh@codeaurora.org>, linux-block@vger.kernel.org,
 Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
 Alim Akhtar <alim.akhtar@samsung.com>, linux-mmc@vger.kernel.org,
 Asutosh Das <asutoshd@codeaurora.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBBcHIgMjEsIDIwMjIgYXQgMDQ6MjU6MzVQTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gT24gV2VkLCBBcHIgMjAsIDIwMjIgYXQgMTI6NDE6NTNQTSAtMDcwMCwgRXJp
YyBCaWdnZXJzIHdyb3RlOgo+ID4gQ2FuIHlvdSBlbGFib3JhdGUgb24gd2hhdCB5b3UgdGhpbmsg
dGhlIGFjdHVhbCBwcm9ibGVtIGlzIGhlcmU/ICBUaGUgbGlmZXRpbWUgb2YKPiA+IHRoZSBibGtf
Y3J5cHRvX3Byb2ZpbGUgbWF0Y2hlcyB0aGF0IG9mIHRoZSBob3N0IGNvbnRyb2xsZXIga29iamVj
dCwgYW5kIEkKPiA+IHRob3VnaHQgdGhhdCBpdCBpcyBub3QgZGVzdHJveWVkIHVudGlsIGFmdGVy
IGhpZ2hlci1sZXZlbCBvYmplY3RzIHN1Y2ggYXMKPiA+IGdlbmRpc2tzIGFuZCByZXF1ZXN0X3F1
ZXVlcyBhcmUgZGVzdHJveWVkLgo+IAo+IEkgZG9uJ3QgdGhpbmsgYWxsIGRyaXZlciBhdXRob3Jz
IGFncmVlIHdpdGggdGhhdCBhc3N1bXB0aW9uIChhbmQgaXQgaXNuJ3QKPiBkb2N1bWVudGVkIGFu
eXdoZXJlKS4gCj4gCj4gVGhlIG1vc3QgdHJpdmlhbCBjYXNlIGlzIGRldmljZSBtYXBwZXIsIHdo
ZXJlIHRoZSBjcnlwdG8gcHJvZtGWbGUgaXMgZnJlZWQKPiBiZWZvcmUgcHV0dGluZyB0aGUgZ2Vu
ZGlzayByZWZlcmVuY2UgYWNxdWlyZWQgYnkgYmxrX2FsbG9jX2Rpc2suICBTbwo+IGFueW9uZSB3
aG8gb3BlbmVkIHRoZSBzeXNmcyBmaWxlIGF0IHNvbWUgcG9pbnQgYmVmb3JlIHRoZSBkZWxldGUg
Y2FuCj4gc3RpbGwgaGF2ZSBpdCBvcGVuIGFuZCB0cml2aWFsbCBhY2Nlc3MgZnJlZWQgbWVtb3J5
IHdoZW4gdGhlbiBkb2luZwo+IGEgcmVhZCBvbiBpdCBhZnRlciB0aGUgZG0gdGFibGUgaXMgZnJl
ZWQuCj4gCj4gRm9yIFVGUyB0aGluZ3Mgc2VlbSB0byB3b3JrIG91dCBvayBiZWNhdXNlIHRoZSB1
ZnNfaGJhIGlzIHBhcnQgb2YKPiB0aGUgU2NzaV9Ib3N0LCB3aGljaCBpcyB0aGUgcGFyZW50IGRl
dmljZSBvZiB0aGUgZ2VuZGlzay4KCkkgdHJpZWQgdG8gcmVwcm9kdWNlIGEgdXNlLWFmdGVyLWZy
ZWUgaW4gdGhlIGRldmljZS1tYXBwZXIgY2FzZSwgYW5kIGl0IGRvZXNuJ3QKc2VlbSB0byBiZSBw
b3NzaWJsZS4gIFdoYXQgYWN0dWFsbHkgaGFwcGVucyBpcyB0aGF0IGJlZm9yZSBmcmVlaW5nIHRo
ZSBjcnlwdG8KcHJvZmlsZSwgY2xlYW51cF9tYXBwZWRfZGV2aWNlKCkgY2FsbHMgZGVsX2dlbmRp
c2soKSwgd2hpY2ggZGVsZXRlcyB0aGUgZGlzawprb2JqZWN0IGFuZCBldmVyeXRoaW5nIHVuZGVy
bmVhdGggaXQuICBUaGF0IG5vdCBvbmx5IGRlbGV0ZXMgdGhlIGNvcnJlc3BvbmRpbmcKc3lzZnMg
aGllcmFyY2h5LCBidXQgYWxzbyAiZGVhY3RpdmF0ZXMiIGl0IHN1Y2ggdGhhdCBldmVuIGlmIGEg
ZmlsZSBkZXNjcmlwdG9yCmlzIG9wZW4gdG8gb25lIG9mIHRoZSBmaWxlcywgYXR0ZW1wdHMgdG8g
cmVhZCBmcm9tIGl0IGZhaWwgd2l0aCBFTk9ERVYuICAgKEl0CmFsc28gd2FpdHMgZm9yIGFueSBv
bmdvaW5nIHJlYWRzIHRvIGNvbXBsZXRlLikKClRoZSByZWZlcmVuY2UgdG8gdGhlIGRpc2sga29i
amVjdCBpcyBpbmRlZWQgcmVsZWFzZWQgYWZ0ZXIgdGhlIGNyeXB0byBwcm9maWxlIGlzCmZyZWVk
LCBidXQgdGhhdCBkb2Vzbid0IG1hdHRlciBhcyBmYXIgYXMgc3lzZnMgaXMgY29uY2VybmVkLgoK
SXQgZG9lc24ndCBhcHBlYXIgdGhhdCBjb25jdXJyZW50IEkvTyBjYW4gYmUgYSBwcm9ibGVtIGVp
dGhlciwgYXMgdGhlCmRldmljZS1tYXBwZXIgc3Vic3lzdGVtIGRvZXNuJ3QgYWxsb3cgZGV2aWNl
cyB0byBiZSBkZWxldGVkIHdoaWxlIHRoZXkgYXJlIG9wZW4uCgpJdCdzIHByb2JhYmx5IHN0aWxs
IHdvcnRoIGZsaXBwaW5nIHRoZSBvcmRlciBvZgpkbV9xdWV1ZV9kZXN0cm95X2NyeXB0b19wcm9m
aWxlKCkgYW5kIGJsa19jbGVhbnVwX2Rpc2soKSBhbnl3YXkgc28gdGhhdCBpdCdzCmxlc3MgZnJh
Z2lsZSBhbmQgbW9yZSBzaW1pbGFyIHRvIHRoZSByZWFsIGRldmljZSBkcml2ZXJzLCB0aG91Z2gu
Cgo+ID4gU2ltaWxhciBhc3N1bXB0aW9ucyBhcmUgbWFkZSBieSB0aGUKPiA+IHF1ZXVlIGtvYmpl
Y3QsIHdoaWNoIGFzc3VtZXMgaXQgaXMgc2FmZSB0byBhY2Nlc3MgdGhlIGdlbmRpc2ssIGFuZCBi
eSB0aGUKPiA+IGluZGVwZW5kZW50X2FjY2Vzc19yYW5nZXMga29iamVjdCB3aGljaCBhc3N1bWVz
IGl0IGlzIHNhZmUgdG8gYWNjZXNzIHRoZSBxdWV1ZS4KPiAKPiBZZXMsIGV2ZXJ5IHF1ZXVlLyBv
YmplY3QgdGhhdCByZWZlcmVuY2VzIHRoZSBnZW5kaXNrIGhhcyBhIHByb2JsZW0gSSB0aGluay4K
PiBJJ3ZlIGJlZW4gd2FkaW5nIHRocm91Z2ggdGhpcyBjb2RlIGFuZCB0cnlpbmcgdG8gZml4IGl0
LCB3aGljaCBtYWRlIG1lCj4gbm90aWNlIHRoaXMgY29kZS4KCkJhc2VkIG9uIGhvdyBzeXNmcyB3
b3JrcyBhYm92ZSwgd2l0aCB0aGUgZW50aXJlIGhpZXJhcmNoeSBiZWluZyBkZWFjdGl2YXRlZCBi
eQpkZWxfZ2VuZGlzaygpLCBJJ20gbm90IHN1cmUgdGhpcyBpcyByZWFsbHkgYSBwcm9ibGVtIGVp
dGhlci4KCj4gPiBJbiBhbnkgY2FzZSwgdGhpcyBwcm9wb3NhbCBpcyBub3QgY29ycmVjdCBzaW5j
ZSBpdCBpcyBhc3N1bWluZyB0aGF0IGVhY2gKPiA+IGJsa19jcnlwdG9fcHJvZmlsZSBpcyByZWZl
cmVuY2VkIGJ5IG9ubHkgb25lIHJlcXVlc3RfcXVldWUsIHdoaWNoIGlzIG5vdAo+ID4gbmVjZXNz
YXJpbHkgdGhlIGNhc2Ugc2luY2UgYSBob3N0IGNvbnRyb2xsZXIgY2FuIGhhdmUgbXVsdGlwbGUg
ZGlza3MuCj4gPiBUaGUgc2FtZSBrb2JqZWN0IGNhbid0IGJlIGFkZGVkIHRvIG11bHRpcGxlIHBs
YWNlcyBpbiB0aGUgaGllcmFyY2h5Lgo+IAo+IEluZGVlZC4KPiAKPiA+IElmIHdlIGRpZCBuZWVk
IHRvIGRvIHNvbWV0aGluZyBkaWZmZXJlbnRseSBoZXJlLCBJIHRoaW5rIHdlJ2QgZWl0aGVyIG5l
ZWQgdG8gcHV0Cj4gPiB0aGUgYmxrX2NyeXB0b19wcm9maWxlIGtvYmplY3QgdW5kZXIgdGhlIGhv
c3QgY29udHJvbGxlciBvbmUgYW5kIGxpbmsgdG8gaXQgZnJvbQo+ID4gdGhlIHF1ZXVlIGRpcmVj
dG9yaWVzICh3aGljaCBJIG1lbnRpb25lZCBpbiBjb21taXQgMjBmMDFmMTYzMjAzIGFzIGFuCj4g
PiBhbHRlcm5hdGl2ZSBjb25zaWRlcmVkKSwgb3IgZHVwbGljYXRlIHRoZSBjcnlwdG8gY2FwYWJp
bGl0aWVzIGluIGVhY2gKPiA+IHJlcXVlc3RfcXVldWUgYW5kIG9ubHkgc2hhcmUgdGhlIGFjdHVh
bCBrZXlzbG90IG1hbmFnZW1lbnQgZGF0YSBzdHJ1Y3R1cmVzLgo+IAo+IERvIHdlIGV2ZW4gbmVl
ZCB0aGUgbGluayBpbnN0ZWFkIG9mIGxldHRpbmcgdGhlIHVzZXIgd2FsayBkb3duIHRoZQo+IGRp
cmVjdG9yeSBoaWVyYWNoeT8gIEJ1dCB5ZXMsIGhhdmluZyB0aGUgc3lzZnMgYXR0cmlidXRlcyBv
biB0aGUKPiBhY3R1YWwgb2JqZWN0IGlzIGEgbXVjaCBiZXR0ZXIgaWRlYS4KClRoZSBkaXJlY3Rv
cmllcyB3b3VsZCBiZSBpbiBkaWZmZXJlbnQgcGxhY2VzIGZvciBkaWZmZXJlbnQga2luZCBvZiBk
ZXZpY2VzIChkbSwKdWZzLCBtbWMsIGV0Yy4pLiAgSSB0aGluayB3ZSByZWFsbHkgZG8gbmVlZCB0
aGUgY3J5cHRvIHByb3BlcnRpZXMgaW4gdGhlIHF1ZXVlCmRpcmVjdG9yeSwgb3RoZXJ3aXNlIGl0
IHdvdWxkIGJlIGEgcGFpbiBmb3IgdXNlcnNwYWNlIHRvIGFjdHVhbGx5IHVzZSB0aGVtLiAgKEl0
CmNvdWxkIGFsc28gYmUgdGhlIGRpc2sgZGlyZWN0b3J5LCBidXQgdGhlIHF1ZXVlIGRpcmVjdG9y
eSBpcyB3aGF0IEkgY2hvc2Ugc2luY2UKdGhhdCdzIHdoZXJlIG1vc3Qgb2YgdGhlIG90aGVyIGdl
bmVyaWMgYmxvY2sgcHJvcGVydGllcyByZWxhdGVkIHRvIEkvTyBhcmUuKQoKSWYgd2UgZGlkIGFk
ZCB0aGUgcHJvcGVydGllcyB0byB0aGUgZGV2aWNlIGRpcmVjdG9yaWVzIChkbSwgdWZzLCBtbWMs
IGV0Yy4pIHRvbywKd2UnZCBhbHNvIGhhdmUgdG8gc3VwcG9ydCB0aGVtIHRoZXJlIGZvcmV2ZXIg
aW4gY2FzZSBzb21lb25lIHN0YXJ0ZWQgdXNpbmcgdGhlbQood2hpY2ggd291bGQgYmUgdW5jb21t
b24gc2luY2UgdGhleSB3b3VsZCBiZSBhIHBhaW4gdG8gdXNlLCBidXQgc29tZW9uZSB3aWxsIGRv
Cml0IGFueXdheSksIHNvIHdlIHNob3VsZCBiZSBjYXJlZnVsIGFib3V0IHRoYXQuICBJIHRoaW5r
IGdlbmVyaWMgYmxvY2sgbGF5ZXIKYXR0cmlidXRlcyBhcmUgcmVhbGx5IHRoZSByaWdodCB3YXkg
dG8gZ28gaGVyZS4KCi0gRXJpYwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

