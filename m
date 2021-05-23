Return-Path: <SRS0=zCJ6=KS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8256FC4707A
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 08:20:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BD426127A
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 08:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BD426127A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-oUIWICRrNWugatd97lXIMQ-1; Sun, 23 May 2021 04:20:43 -0400
X-MC-Unique: oUIWICRrNWugatd97lXIMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9065107ACE3;
	Sun, 23 May 2021 08:20:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3487862693;
	Sun, 23 May 2021 08:20:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 927D74E9E2;
	Sun, 23 May 2021 08:20:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14N8KZew030197 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 04:20:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4189844050; Sun, 23 May 2021 08:20:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C3094404D
	for <dm-devel@redhat.com>; Sun, 23 May 2021 08:20:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7154101A55F
	for <dm-devel@redhat.com>; Sun, 23 May 2021 08:20:32 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-35-Q0JOM6EPNii5hUvj1HzQJQ-1;
	Sun, 23 May 2021 04:20:30 -0400
X-MC-Unique: Q0JOM6EPNii5hUvj1HzQJQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id B335CAB7C;
	Sun, 23 May 2021 08:20:28 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-19-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <1a771bf9-5083-c440-f0e1-5f6920b5b017@suse.de>
Date: Sun, 23 May 2021 10:20:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-19-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14N8KZew030197
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 18/26] nvme-multipath: convert to
 blk_alloc_disk/blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMS8yMSA3OjUxIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBDb252ZXJ0IHRo
ZSBudm1lLW11bHRpcGF0aCBkcml2ZXIgdG8gdXNlIHRoZSBibGtfYWxsb2NfZGlzayBhbmQKPiBi
bGtfY2xlYW51cF9kaXNrIGhlbHBlcnMgdG8gc2ltcGxpZnkgZ2VuZGlzayBhbmQgcmVxdWVzdF9x
dWV1ZQo+IGFsbG9jYXRpb24uCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJzL252ZGltbS9wbWVtLmMgICAgICAgICB8ICAx
IC0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jIHwgNDUgKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygr
KSwgMzMgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3BtZW0u
YyBiL2RyaXZlcnMvbnZkaW1tL3BtZW0uYwo+IGluZGV4IDlmY2QwNTA4NDU2NC4uMzFmM2M0YmQ2
ZjcyIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZkaW1tL3BtZW0uYwo+ICsrKyBiL2RyaXZlcnMv
bnZkaW1tL3BtZW0uYwo+IEBAIC00NzIsNyArNDcyLDYgQEAgc3RhdGljIGludCBwbWVtX2F0dGFj
aF9kaXNrKHN0cnVjdCBkZXZpY2UgKmRldiwKPiAgIAkJYmxrX3F1ZXVlX2ZsYWdfc2V0KFFVRVVF
X0ZMQUdfREFYLCBxKTsKPiAgIAo+ICAgCWRpc2stPmZvcHMJCT0gJnBtZW1fZm9wczsKPiAtCWRp
c2stPnF1ZXVlCQk9IHE7Cj4gICAJZGlzay0+cHJpdmF0ZV9kYXRhCT0gcG1lbTsKPiAgIAludmRp
bW1fbmFtZXNwYWNlX2Rpc2tfbmFtZShuZG5zLCBkaXNrLT5kaXNrX25hbWUpOwo+ICAgCXNldF9j
YXBhY2l0eShkaXNrLCAocG1lbS0+c2l6ZSAtIHBtZW0tPnBmbl9wYWQgLSBwbWVtLT5kYXRhX29m
ZnNldCkKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMgYi9kcml2
ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYwo+IGluZGV4IGE1ZDAyZjIzNmNjYS4uYjVmYmRiNDE2
MDIyIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L211bHRpcGF0aC5jCj4gKysrIGIv
ZHJpdmVycy9udm1lL2hvc3QvbXVsdGlwYXRoLmMKPiBAQCAtNDI3LDcgKzQyNyw2IEBAIHN0YXRp
YyB2b2lkIG52bWVfcmVxdWV1ZV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKPiAgIAo+
ICAgaW50IG52bWVfbXBhdGhfYWxsb2NfZGlzayhzdHJ1Y3QgbnZtZV9jdHJsICpjdHJsLCBzdHJ1
Y3QgbnZtZV9uc19oZWFkICpoZWFkKQo+ICAgewo+IC0Jc3RydWN0IHJlcXVlc3RfcXVldWUgKnE7
Cj4gICAJYm9vbCB2d2MgPSBmYWxzZTsKPiAgIAo+ICAgCW11dGV4X2luaXQoJmhlYWQtPmxvY2sp
Owo+IEBAIC00NDMsMzMgKzQ0MiwyNCBAQCBpbnQgbnZtZV9tcGF0aF9hbGxvY19kaXNrKHN0cnVj
dCBudm1lX2N0cmwgKmN0cmwsIHN0cnVjdCBudm1lX25zX2hlYWQgKmhlYWQpCj4gICAJaWYgKCEo
Y3RybC0+c3Vic3lzLT5jbWljICYgTlZNRV9DVFJMX0NNSUNfTVVMVElfQ1RSTCkgfHwgIW11bHRp
cGF0aCkKPiAgIAkJcmV0dXJuIDA7Cj4gICAKPiAtCXEgPSBibGtfYWxsb2NfcXVldWUoY3RybC0+
bnVtYV9ub2RlKTsKPiAtCWlmICghcSkKPiAtCQlnb3RvIG91dDsKPiAtCWJsa19xdWV1ZV9mbGFn
X3NldChRVUVVRV9GTEFHX05PTlJPVCwgcSk7Cj4gLQkvKiBzZXQgdG8gYSBkZWZhdWx0IHZhbHVl
IGZvciA1MTIgdW50aWwgZGlzayBpcyB2YWxpZGF0ZWQgKi8KPiAtCWJsa19xdWV1ZV9sb2dpY2Fs
X2Jsb2NrX3NpemUocSwgNTEyKTsKPiAtCWJsa19zZXRfc3RhY2tpbmdfbGltaXRzKCZxLT5saW1p
dHMpOwo+IC0KPiAtCS8qIHdlIG5lZWQgdG8gcHJvcGFnYXRlIHVwIHRoZSBWTUMgc2V0dGluZ3Mg
Ki8KPiAtCWlmIChjdHJsLT52d2MgJiBOVk1FX0NUUkxfVldDX1BSRVNFTlQpCj4gLQkJdndjID0g
dHJ1ZTsKPiAtCWJsa19xdWV1ZV93cml0ZV9jYWNoZShxLCB2d2MsIHZ3Yyk7Cj4gLQo+IC0JaGVh
ZC0+ZGlzayA9IGFsbG9jX2Rpc2soMCk7Cj4gKwloZWFkLT5kaXNrID0gYmxrX2FsbG9jX2Rpc2so
Y3RybC0+bnVtYV9ub2RlKTsKPiAgIAlpZiAoIWhlYWQtPmRpc2spCj4gLQkJZ290byBvdXRfY2xl
YW51cF9xdWV1ZTsKPiArCQlyZXR1cm4gLUVOT01FTTsKPiAgIAloZWFkLT5kaXNrLT5mb3BzID0g
Jm52bWVfbnNfaGVhZF9vcHM7Cj4gICAJaGVhZC0+ZGlzay0+cHJpdmF0ZV9kYXRhID0gaGVhZDsK
PiAtCWhlYWQtPmRpc2stPnF1ZXVlID0gcTsKPiAgIAlzcHJpbnRmKGhlYWQtPmRpc2stPmRpc2tf
bmFtZSwgIm52bWUlZG4lZCIsCj4gICAJCQljdHJsLT5zdWJzeXMtPmluc3RhbmNlLCBoZWFkLT5p
bnN0YW5jZSk7Cj4gLQlyZXR1cm4gMDsKPiAgIAo+IC1vdXRfY2xlYW51cF9xdWV1ZToKPiAtCWJs
a19jbGVhbnVwX3F1ZXVlKHEpOwo+IC1vdXQ6Cj4gLQlyZXR1cm4gLUVOT01FTTsKPiArCWJsa19x
dWV1ZV9mbGFnX3NldChRVUVVRV9GTEFHX05PTlJPVCwgaGVhZC0+ZGlzay0+cXVldWUpOwo+ICsJ
Lyogc2V0IHRvIGEgZGVmYXVsdCB2YWx1ZSBvZiA1MTIgdW50aWwgdGhlIGRpc2sgaXMgdmFsaWRh
dGVkICovCj4gKwlibGtfcXVldWVfbG9naWNhbF9ibG9ja19zaXplKGhlYWQtPmRpc2stPnF1ZXVl
LCA1MTIpOwo+ICsJYmxrX3NldF9zdGFja2luZ19saW1pdHMoJmhlYWQtPmRpc2stPnF1ZXVlLT5s
aW1pdHMpOwo+ICsKPiArCS8qIHdlIG5lZWQgdG8gcHJvcGFnYXRlIHVwIHRoZSBWTUMgc2V0dGlu
Z3MgKi8KPiArCWlmIChjdHJsLT52d2MgJiBOVk1FX0NUUkxfVldDX1BSRVNFTlQpCj4gKwkJdndj
ID0gdHJ1ZTsKPiArCWJsa19xdWV1ZV93cml0ZV9jYWNoZShoZWFkLT5kaXNrLT5xdWV1ZSwgdndj
LCB2d2MpOwo+ICsJcmV0dXJuIDA7Cj4gICB9Cj4gICAKPiAgIHN0YXRpYyB2b2lkIG52bWVfbXBh
dGhfc2V0X2xpdmUoc3RydWN0IG52bWVfbnMgKm5zKQo+IEBAIC03NjgsMTYgKzc1OCw3IEBAIHZv
aWQgbnZtZV9tcGF0aF9yZW1vdmVfZGlzayhzdHJ1Y3QgbnZtZV9uc19oZWFkICpoZWFkKQo+ICAg
CS8qIG1ha2Ugc3VyZSBhbGwgcGVuZGluZyBiaW9zIGFyZSBjbGVhbmVkIHVwICovCj4gICAJa2Js
b2NrZF9zY2hlZHVsZV93b3JrKCZoZWFkLT5yZXF1ZXVlX3dvcmspOwo+ICAgCWZsdXNoX3dvcmso
JmhlYWQtPnJlcXVldWVfd29yayk7Cj4gLQlibGtfY2xlYW51cF9xdWV1ZShoZWFkLT5kaXNrLT5x
dWV1ZSk7Cj4gLQlpZiAoIXRlc3RfYml0KE5WTUVfTlNIRUFEX0RJU0tfTElWRSwgJmhlYWQtPmZs
YWdzKSkgewo+IC0JCS8qCj4gLQkJICogaWYgZGV2aWNlX2FkZF9kaXNrIHdhc24ndCBjYWxsZWQs
IHByZXZlbnQKPiAtCQkgKiBkaXNrIHJlbGVhc2UgdG8gcHV0IGEgYm9ndXMgcmVmZXJlbmNlIG9u
IHRoZQo+IC0JCSAqIHJlcXVlc3QgcXVldWUKPiAtCQkgKi8KPiAtCQloZWFkLT5kaXNrLT5xdWV1
ZSA9IE5VTEw7Cj4gLQl9Cj4gLQlwdXRfZGlzayhoZWFkLT5kaXNrKTsKPiArCWJsa19jbGVhbnVw
X2Rpc2soaGVhZC0+ZGlzayk7Cj4gICB9Cj4gICAKPiAgIHZvaWQgbnZtZV9tcGF0aF9pbml0X2N0
cmwoc3RydWN0IG52bWVfY3RybCAqY3RybCkKPiAKV2hhdCBhYm91dCB0aGUgY2hlY2sgZm9yIEdF
TkhEX0ZMX1VQIGEgYml0IGZ1cnRoZXIgdXAgaW4gbGluZSA3NjY/CkNhbiB0aGlzIHN0aWxsIGhh
cHBlbiB3aXRoIHRoZSBuZXcgYWxsb2NhdGlvbiBzY2hlbWUsIGllIGlzIHRoZXJlIHN0aWxsIAph
IGRpZmZlcmVuY2UgaW4gbGlmZXRpbWUgYmV0d2VlbiAtPmRpc2sgYW5kIC0+ZGlzay0+cXVldWU/
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAg
S2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgs
IE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyks
IEdlc2Now6RmdHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

