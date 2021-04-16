Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48088C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 15:23:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F0A3611ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 15:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F0A3611ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-lJqMBToxN3-vg2bbPbEOag-1; Fri, 16 Apr 2021 11:23:48 -0400
X-MC-Unique: lJqMBToxN3-vg2bbPbEOag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3A15802575;
	Fri, 16 Apr 2021 15:23:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FA1C107D5C1;
	Fri, 16 Apr 2021 15:23:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8711C1806D0F;
	Fri, 16 Apr 2021 15:23:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GFKFra006857 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 11:20:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D6AE620F8C18; Fri, 16 Apr 2021 15:20:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D11A020F8C17
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 15:20:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84EBE185A79C
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 15:20:13 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-586-Jl34nGA7Mt6twHDlSjI3gw-1;
	Fri, 16 Apr 2021 11:20:11 -0400
X-MC-Unique: Jl34nGA7Mt6twHDlSjI3gw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id EB32AAEF8;
	Fri, 16 Apr 2021 15:20:09 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-3-snitzer@redhat.com>
	<da184561-2c97-5807-5c5b-9cc6593693c6@suse.de>
	<20210416145340.GB16047@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <3c5d6257-5f49-877e-91c2-c6d7687b002b@suse.de>
Date: Fri, 16 Apr 2021 17:20:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210416145340.GB16047@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13GFKFra006857
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Chao Leng <lengchao@huawei.com>, Christoph Hellwig <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8xNi8yMSA0OjUzIFBNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gT24gRnJpLCBBcHIgMTYg
MjAyMSBhdCAxMDowMWFtIC0wNDAwLAo+IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPiB3
cm90ZToKPiAKPj4gT24gNC8xNi8yMSAxOjE1IEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4+PiBG
cm9tOiBDaGFvIExlbmcgPGxlbmdjaGFvQGh1YXdlaS5jb20+Cj4+Pgo+Pj4gUkVRX0ZBSUxGQVNU
X1RSQU5TUE9SVCB3YXMgZGVzaWduZWQgZm9yIFNDU0ksIGJlY2F1c2UgdGhlIFNDU0kgcHJvdG9j
b2wKPj4+IGRvZXMgbm90IGRlZmluZSB0aGUgbG9jYWwgcmV0cnkgbWVjaGFuaXNtLiBTQ1NJIGlt
cGxlbWVudHMgYSBmdXp6eQo+Pj4gbG9jYWwgcmV0cnkgbWVjaGFuaXNtLCBzbyBSRVFfRkFJTEZB
U1RfVFJBTlNQT1JUIGlzIG5lZWRlZCB0byBhbGxvdwo+Pj4gaGlnaGVyLWxldmVsIG11bHRpcGF0
aGluZyBzb2Z0d2FyZSB0byBwZXJmb3JtIGZhaWxvdmVyL3JldHJ5Lgo+Pj4KPj4+IE5WTWUgaXMg
ZGlmZmVyZW50IHdpdGggU0NTSSBhYm91dCB0aGlzLiBJdCBkZWZpbmVzIGEgbG9jYWwgcmV0cnkK
Pj4+IG1lY2hhbmlzbSBhbmQgcGF0aCBlcnJvciBjb2Rlcywgc28gTlZNZSBzaG91bGQgcmV0cnkg
bG9jYWwgZm9yIG5vbgo+Pj4gcGF0aCBlcnJvci4gSWYgcGF0aCByZWxhdGVkIGVycm9yLCB3aGV0
aGVyIHRvIHJldHJ5IGFuZCBob3cgdG8gcmV0cnkKPj4+IGlzIHN0aWxsIGRldGVybWluZWQgYnkg
aGlnaGVyLWxldmVsIG11bHRpcGF0aGluZydzIGZhaWxvdmVyLgo+Pj4KPj4+IFVubGlrZSBTQ1NJ
LCBOVk1lIHNob3VsZG4ndCBwcmV2ZW50IHJldHJ5IGlmIFJFUV9GQUlMRkFTVF9UUkFOU1BPUlQK
Pj4+IGJlY2F1c2UgTlZNZSdzIGxvY2FsIHJldHJ5IGlzIG5lZWRlZCAtLSBhcyBpcyBOVk1lIHNw
ZWNpZmljIGxvZ2ljIHRvCj4+PiBjYXRlZ29yaXplIHdoZXRoZXIgYW4gZXJyb3IgaXMgcGF0aCBy
ZWxhdGVkLgo+Pj4KPj4+IEluIHRoaXMgd2F5LCB0aGUgbWVjaGFuaXNtIG9mIE5WTWUgbXVsdGlw
YXRoIG9yIG90aGVyIG11bHRpcGF0aCBhcmUKPj4+IG5vdyBlcXVpdmFsZW50LiBUaGUgbWVjaGFu
aXNtIGlzOiBub24gcGF0aCByZWxhdGVkIGVycm9yIHdpbGwgYmUKPj4+IHJldHJpZWQgbG9jYWxs
eSwgcGF0aCByZWxhdGVkIGVycm9yIGlzIGhhbmRsZWQgYnkgbXVsdGlwYXRoLgo+Pj4KPj4+IFNp
Z25lZC1vZmYtYnk6IENoYW8gTGVuZyA8bGVuZ2NoYW9AaHVhd2VpLmNvbT4KPj4+IFtzbml0emVy
OiBlZGl0ZWQgaGVhZGVyIGZvciBncmFtbWFyIGFuZCBjbGFyaXR5LCBhbHNvIGFkZGVkIGNvZGUg
Y29tbWVudF0KPj4+IFNpZ25lZC1vZmYtYnk6IE1pa2UgU25pdHplciA8c25pdHplckByZWRoYXQu
Y29tPgo+Pj4gLS0tCj4+PiAgZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIHwgOSArKysrKysrKy0K
Pj4+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Pgo+
Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZtZS9o
b3N0L2NvcmUuYwo+Pj4gaW5kZXggNTQwZDZmZDhmZmVmLi40MTM0Y2YzYzdlNDggMTAwNjQ0Cj4+
PiAtLS0gYS9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPj4+ICsrKyBiL2RyaXZlcnMvbnZtZS9o
b3N0L2NvcmUuYwo+Pj4gQEAgLTMwNiw3ICszMDYsMTQgQEAgc3RhdGljIGlubGluZSBlbnVtIG52
bWVfZGlzcG9zaXRpb24gbnZtZV9kZWNpZGVfZGlzcG9zaXRpb24oc3RydWN0IHJlcXVlc3QgKnJl
cSkKPj4+ICAJaWYgKGxpa2VseShudm1lX3JlcShyZXEpLT5zdGF0dXMgPT0gMCkpCj4+PiAgCQly
ZXR1cm4gQ09NUExFVEU7Cj4+PiAgCj4+PiAtCWlmIChibGtfbm9yZXRyeV9yZXF1ZXN0KHJlcSkg
fHwKPj4+ICsJLyoKPj4+ICsJICogUkVRX0ZBSUxGQVNUX1RSQU5TUE9SVCBpcyBzZXQgYnkgdXBw
ZXIgbGF5ZXIgc29mdHdhcmUgdGhhdAo+Pj4gKwkgKiBoYW5kbGVzIG11bHRpcGF0aGluZy4gVW5s
aWtlIFNDU0ksIE5WTWUncyBlcnJvciBoYW5kbGluZyB3YXMKPj4+ICsJICogc3BlY2lmaWNhbGx5
IGRlc2lnbmVkIHRvIGhhbmRsZSBsb2NhbCByZXRyeSBmb3Igbm9uLXBhdGggZXJyb3JzLgo+Pj4g
KwkgKiBBcyBzdWNoLCBhbGxvdyBOVk1lJ3MgbG9jYWwgcmV0cnkgbWVjaGFuaXNtIHRvIGJlIHVz
ZWQgZm9yCj4+PiArCSAqIHJlcXVlc3RzIG1hcmtlZCB3aXRoIFJFUV9GQUlMRkFTVF9UUkFOU1BP
UlQuCj4+PiArCSAqLwo+Pj4gKwlpZiAoKHJlcS0+Y21kX2ZsYWdzICYgKFJFUV9GQUlMRkFTVF9E
RVYgfCBSRVFfRkFJTEZBU1RfRFJJVkVSKSkgfHwKPj4+ICAJICAgIChudm1lX3JlcShyZXEpLT5z
dGF0dXMgJiBOVk1FX1NDX0ROUikgfHwKPj4+ICAJICAgIG52bWVfcmVxKHJlcSktPnJldHJpZXMg
Pj0gbnZtZV9tYXhfcmV0cmllcykKPj4+ICAJCXJldHVybiBDT01QTEVURTsKPj4+Cj4+IEh1aD8K
Pj4KPj4gI2RlZmluZSBibGtfbm9yZXRyeV9yZXF1ZXN0KHJxKSBcCj4+ICAgICAgICAgKChycSkt
PmNtZF9mbGFncyAmIChSRVFfRkFJTEZBU1RfREVWfFJFUV9GQUlMRkFTVF9UUkFOU1BPUlR8IFwK
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBSRVFfRkFJTEZBU1RfRFJJVkVSKSkKPj4K
Pj4gbWFraW5nIHRoZSBvbmx5IF9hY3R1YWxfIGNoYW5nZSBpbiB5b3VyIHBhdGNoIF9ub3RfIGV2
YWx1YXRpbmcgdGhlCj4+IFJFUV9GQUlMRkFTVF9EUklWRVIsIHdoaWNoIGluY2lkZW50YWxseSBp
cyBvbmx5IHVzZWQgYnkgdGhlIE5WTWUgY29yZS4KPiAKPiBObywgbm90IHN1cmUgaG93IHlvdSBn
b3QgdGhlcmUuIEknZCBoYXZlIHRob3VnaHQgdGhlIDUgcmVmZXJlbmNlcyB0bwo+ICJSRVFfRkFJ
TEZBU1RfVFJBTlNQT1JUIiB3b3VsZCd2ZSBiZWVuIHN1ZmZpY2llbnQgOykKPiAKCkFoLiBNaXNy
ZWFkIHN0dWZmLiBZb3UncmUgZXhjbHVkaW5nIHRoZSBSRVFfRkFJTEZBU1RfVFJBTlNQT1JUIGhl
cmUuCkJ1dCB0aGVuIGl0J3MgX2FjdHVhbGx5XyBzaW1pbGFyIHRvIHRoZSBuZXh0IHBhdGNoICh3
aGljaCBJJ3ZlIGFsc28KY29tbWVudGVkKS4KCldvdWxkbid0IGl0IGJlIGJldHRlciB0byBmb2xk
IHRoZW0gaW50byBvbmUgcGF0Y2ggYW5kIGRpc2N1c3MgdGhpbmdzCnRvZ2V0aGVyOyBlc3BlY2lh
bGx5IGFzIG15IGNvbW1lbnQgdG8gdGhlIG5leHQgb25lIG1pZ2h0IGFjdHVhbGx5CmFjaGlldmUg
dGhlIHNhbWUgdGhpbmc/CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJ
CSAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZQkJCSAgICAgICAg
ICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkg
R21iSCwgOTA0MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEhSQiAzNjgwOSAoQUcg
TsO8cm5iZXJnKQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

