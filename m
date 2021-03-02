Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B128C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 11:07:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8A1464F11
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 11:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8A1464F11
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-9W3PcMndMSudAC1FSzncxg-1; Tue, 02 Mar 2021 06:07:49 -0500
X-MC-Unique: 9W3PcMndMSudAC1FSzncxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28FD08799EB;
	Tue,  2 Mar 2021 11:07:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD7DA60DA1;
	Tue,  2 Mar 2021 11:07:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 649C94EEF6;
	Tue,  2 Mar 2021 11:07:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122B7c7r022661 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 06:07:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D37F610439AA; Tue,  2 Mar 2021 11:07:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF92E10336E3
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 11:07:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6F359595C6
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 11:07:35 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-127-rvJJTz3FP3-pMwh_U68oHg-1;
	Tue, 02 Mar 2021 06:07:33 -0500
X-MC-Unique: rvJJTz3FP3-pMwh_U68oHg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5F170AAC5;
	Tue,  2 Mar 2021 11:07:32 +0000 (UTC)
Message-ID: <65e13db2fa187efab241f09c00ae80777f139b56.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 02 Mar 2021 12:07:31 +0100
In-Reply-To: <86bee89e-6d5b-2138-2621-77848e668690@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
	<86bee89e-6d5b-2138-2621-77848e668690@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 122B7c7r022661
X-loop: dm-devel@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDIxLTAzLTAyIGF0IDE2OjQxICswODAwLCBsaXhpYW9rZW5nIHdyb3RlOgo+IAo+
ID4gCj4gPiBIaSBNYXJ0aW46Cj4gPiDCoMKgIEhlcmUgSSBhZGQgY29uZGxvZygyLCAic3RhcnQg
ZnVuY25hbWUiKSwKPiA+IHB0aHJlYWRfY2xlYW51cF9wdXNoKGZ1bmNfcHJpbnQsIE5VTEwpCj4g
PiBpbiBldmVyeSBwdGhyZWFkX2NyZWF0ZSBmdW5jLiBXaGVuIHRoZXNlIHR3byBjb3JlIGhhcHBl
bmVkLCAiZXhpdAo+ID4gdHVyX3RocmVhZCIKPiA+IGFyZSBsZXNzIHRoYW4gInN0YXJ0IHR1cl90
aHJlYWQiLiBTbyB0aGUgdHJvdWJsZSBtYXkgYmUgaW4KPiA+IHR1cl90aHJlYWQuCj4gPiAKPiAK
PiBJZiBJIG1hZGUgbm8gbWlzdGFrZSwgdGhlc2UgY29yZWR1bXBzIGhhcHBlbmVkIHdoZW4gdGhl
Cj4gdHVyX3RocmVhZCh3aGljaCBpcwo+IGxpYmNoZWNrX3RocmVhZCBpbiBsYXRlc3QgY29kZSkg
d2FzIG5vdCBmaW5pc2hlZCBidXQgY2hlY2tlcu+8iHR1cu+8iXdhcwo+IGNsZWFyZWQgYnkgY2xl
YW51cF9jaGVja2Vycy4gQnV0IEkgY2FuJ3QgdW5kZXJzdGFuZCB0aGlzLCBiZWNhdXNlIHRoZQo+
IGN0eAo+IGluIHR1cl90aHJlYWQgd2Fzbid0IGZyZWVkIGJ5IGNsZWFudXBfY2hlY2tlcnMuCj4g
Cj4gUGxlYXNlIGdpdmUgbWUgc29tZSBoZWxwcywgdGhhbmtzLgoKU28geW91IHRoaW5rIHRoZSBj
cmFzaGluZyB0aHJlYWQgaXMgbGliY2hlY2tfdGhyZWFkPyBEbyB5b3UgaGF2ZSBhIGNvcmUKZHVt
cCBmcm9tIHRoaXMgc2l0dWF0aW9uPwoKRG9lcyB0aGUgY29kZSB5b3UgdXNlIGluY2x1ZGUgY29t
bWl0IDM4ZmZkODkgKCJsaWJtdWx0aXBhdGg6IHByZXZlbnQKRFNPIHVubG9hZGluZyB3aXRoIGFz
dHJheSBjaGVja2VyIHRocmVhZHMiKT8KCk1hcnRpbgoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs

