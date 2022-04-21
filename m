Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C90C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 14:25:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-M9syiGmlP0mz2B7EwEg_7w-1; Thu, 21 Apr 2022 10:25:51 -0400
X-MC-Unique: M9syiGmlP0mz2B7EwEg_7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F26A3833FE8;
	Thu, 21 Apr 2022 14:25:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2200C1468940;
	Thu, 21 Apr 2022 14:25:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 361BE1949763;
	Thu, 21 Apr 2022 14:25:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8ED9619451EF
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Apr 2022 14:25:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44585413707; Thu, 21 Apr 2022 14:25:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FDC4572326
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 14:25:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 266871014A60
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 14:25:43 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-WF_GNtZyPq2PduQI841Kig-1; Thu, 21 Apr 2022 10:25:40 -0400
X-MC-Unique: WF_GNtZyPq2PduQI841Kig-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 9CB7B68B05; Thu, 21 Apr 2022 16:25:35 +0200 (CEST)
Date: Thu, 21 Apr 2022 16:25:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <20220421142535.GA21025@lst.de>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de> <YmBiAQ/IZbFhRc6o@sol.localdomain>
MIME-Version: 1.0
In-Reply-To: <YmBiAQ/IZbFhRc6o@sol.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
 Christoph Hellwig <hch@lst.de>, Asutosh Das <asutoshd@codeaurora.org>
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

T24gV2VkLCBBcHIgMjAsIDIwMjIgYXQgMTI6NDE6NTNQTSAtMDcwMCwgRXJpYyBCaWdnZXJzIHdy
b3RlOgo+IENhbiB5b3UgZWxhYm9yYXRlIG9uIHdoYXQgeW91IHRoaW5rIHRoZSBhY3R1YWwgcHJv
YmxlbSBpcyBoZXJlPyAgVGhlIGxpZmV0aW1lIG9mCj4gdGhlIGJsa19jcnlwdG9fcHJvZmlsZSBt
YXRjaGVzIHRoYXQgb2YgdGhlIGhvc3QgY29udHJvbGxlciBrb2JqZWN0LCBhbmQgSQo+IHRob3Vn
aHQgdGhhdCBpdCBpcyBub3QgZGVzdHJveWVkIHVudGlsIGFmdGVyIGhpZ2hlci1sZXZlbCBvYmpl
Y3RzIHN1Y2ggYXMKPiBnZW5kaXNrcyBhbmQgcmVxdWVzdF9xdWV1ZXMgYXJlIGRlc3Ryb3llZC4K
CkkgZG9uJ3QgdGhpbmsgYWxsIGRyaXZlciBhdXRob3JzIGFncmVlIHdpdGggdGhhdCBhc3N1bXB0
aW9uIChhbmQgaXQgaXNuJ3QKZG9jdW1lbnRlZCBhbnl3aGVyZSkuIAoKVGhlIG1vc3QgdHJpdmlh
bCBjYXNlIGlzIGRldmljZSBtYXBwZXIsIHdoZXJlIHRoZSBjcnlwdG8gcHJvZtGWbGUgaXMgZnJl
ZWQKYmVmb3JlIHB1dHRpbmcgdGhlIGdlbmRpc2sgcmVmZXJlbmNlIGFjcXVpcmVkIGJ5IGJsa19h
bGxvY19kaXNrLiAgU28KYW55b25lIHdobyBvcGVuZWQgdGhlIHN5c2ZzIGZpbGUgYXQgc29tZSBw
b2ludCBiZWZvcmUgdGhlIGRlbGV0ZSBjYW4Kc3RpbGwgaGF2ZSBpdCBvcGVuIGFuZCB0cml2aWFs
bCBhY2Nlc3MgZnJlZWQgbWVtb3J5IHdoZW4gdGhlbiBkb2luZwphIHJlYWQgb24gaXQgYWZ0ZXIg
dGhlIGRtIHRhYmxlIGlzIGZyZWVkLgoKRm9yIFVGUyB0aGluZ3Mgc2VlbSB0byB3b3JrIG91dCBv
ayBiZWNhdXNlIHRoZSB1ZnNfaGJhIGlzIHBhcnQgb2YKdGhlIFNjc2lfSG9zdCwgd2hpY2ggaXMg
dGhlIHBhcmVudCBkZXZpY2Ugb2YgdGhlIGdlbmRpc2suCgo+IFNpbWlsYXIgYXNzdW1wdGlvbnMg
YXJlIG1hZGUgYnkgdGhlCj4gcXVldWUga29iamVjdCwgd2hpY2ggYXNzdW1lcyBpdCBpcyBzYWZl
IHRvIGFjY2VzcyB0aGUgZ2VuZGlzaywgYW5kIGJ5IHRoZQo+IGluZGVwZW5kZW50X2FjY2Vzc19y
YW5nZXMga29iamVjdCB3aGljaCBhc3N1bWVzIGl0IGlzIHNhZmUgdG8gYWNjZXNzIHRoZSBxdWV1
ZS4KClllcywgZXZlcnkgcXVldWUvIG9iamVjdCB0aGF0IHJlZmVyZW5jZXMgdGhlIGdlbmRpc2sg
aGFzIGEgcHJvYmxlbSBJIHRoaW5rLgpJJ3ZlIGJlZW4gd2FkaW5nIHRocm91Z2ggdGhpcyBjb2Rl
IGFuZCB0cnlpbmcgdG8gZml4IGl0LCB3aGljaCBtYWRlIG1lCm5vdGljZSB0aGlzIGNvZGUuCgo+
IEluIGFueSBjYXNlLCB0aGlzIHByb3Bvc2FsIGlzIG5vdCBjb3JyZWN0IHNpbmNlIGl0IGlzIGFz
c3VtaW5nIHRoYXQgZWFjaAo+IGJsa19jcnlwdG9fcHJvZmlsZSBpcyByZWZlcmVuY2VkIGJ5IG9u
bHkgb25lIHJlcXVlc3RfcXVldWUsIHdoaWNoIGlzIG5vdAo+IG5lY2Vzc2FyaWx5IHRoZSBjYXNl
IHNpbmNlIGEgaG9zdCBjb250cm9sbGVyIGNhbiBoYXZlIG11bHRpcGxlIGRpc2tzLgo+IFRoZSBz
YW1lIGtvYmplY3QgY2FuJ3QgYmUgYWRkZWQgdG8gbXVsdGlwbGUgcGxhY2VzIGluIHRoZSBoaWVy
YXJjaHkuCgpJbmRlZWQuCgo+IElmIHdlIGRpZCBuZWVkIHRvIGRvIHNvbWV0aGluZyBkaWZmZXJl
bnRseSBoZXJlLCBJIHRoaW5rIHdlJ2QgZWl0aGVyIG5lZWQgdG8gcHV0Cj4gdGhlIGJsa19jcnlw
dG9fcHJvZmlsZSBrb2JqZWN0IHVuZGVyIHRoZSBob3N0IGNvbnRyb2xsZXIgb25lIGFuZCBsaW5r
IHRvIGl0IGZyb20KPiB0aGUgcXVldWUgZGlyZWN0b3JpZXMgKHdoaWNoIEkgbWVudGlvbmVkIGlu
IGNvbW1pdCAyMGYwMWYxNjMyMDMgYXMgYW4KPiBhbHRlcm5hdGl2ZSBjb25zaWRlcmVkKSwgb3Ig
ZHVwbGljYXRlIHRoZSBjcnlwdG8gY2FwYWJpbGl0aWVzIGluIGVhY2gKPiByZXF1ZXN0X3F1ZXVl
IGFuZCBvbmx5IHNoYXJlIHRoZSBhY3R1YWwga2V5c2xvdCBtYW5hZ2VtZW50IGRhdGEgc3RydWN0
dXJlcy4KCkRvIHdlIGV2ZW4gbmVlZCB0aGUgbGluayBpbnN0ZWFkIG9mIGxldHRpbmcgdGhlIHVz
ZXIgd2FsayBkb3duIHRoZQpkaXJlY3RvcnkgaGllcmFjaHk/ICBCdXQgeWVzLCBoYXZpbmcgdGhl
IHN5c2ZzIGF0dHJpYnV0ZXMgb24gdGhlCmFjdHVhbCBvYmplY3QgaXMgYSBtdWNoIGJldHRlciBp
ZGVhLgoKPiAKPiAtIEVyaWMKLS0tZW5kIHF1b3RlZCB0ZXh0LS0tCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

