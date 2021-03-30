Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472DCC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:28:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5881E61955
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5881E61955
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-j-k1JAMDNPGyTSYXuRC7fQ-1; Tue, 30 Mar 2021 02:28:51 -0400
X-MC-Unique: j-k1JAMDNPGyTSYXuRC7fQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C5EB81746A;
	Tue, 30 Mar 2021 06:28:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D7B11001B2C;
	Tue, 30 Mar 2021 06:28:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D49CD4BB7C;
	Tue, 30 Mar 2021 06:28:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6QxKx006986 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:26:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 88490113F79E; Tue, 30 Mar 2021 06:26:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84419113F79F
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:26:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95D5B802317
	for <dm-devel@redhat.com>; Tue, 30 Mar 2021 06:26:56 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-126-efoObB6rNM-HBNmyoQ_7zg-1;
	Tue, 30 Mar 2021 02:26:49 -0400
X-MC-Unique: efoObB6rNM-HBNmyoQ_7zg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1F99FAE86;
	Tue, 30 Mar 2021 06:26:48 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210329152622.173035-1-ming.lei@redhat.com>
	<20210329152622.173035-12-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <162f000f-7f86-8988-4a15-2c3bf70de1b7@suse.de>
Date: Tue, 30 Mar 2021 08:26:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210329152622.173035-12-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12U6QxKx006986
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V4 11/12] block: add poll_capable method to
 support bio-based IO polling
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

T24gMy8yOS8yMSA1OjI2IFBNLCBNaW5nIExlaSB3cm90ZToKPiBGcm9tOiBKZWZmbGUgWHUgPGpl
ZmZsZXh1QGxpbnV4LmFsaWJhYmEuY29tPgo+IAo+IFRoaXMgbWV0aG9kIGNhbiBiZSB1c2VkIHRv
IGNoZWNrIGlmIGJpby1iYXNlZCBkZXZpY2Ugc3VwcG9ydHMgSU8gcG9sbGluZwo+IG9yIG5vdC4g
Rm9yIG1xIGRldmljZXMsIGNoZWNraW5nIGZvciBodyBxdWV1ZSBpbiBwb2xsaW5nIG1vZGUgaXMK
PiBhZGVxdWF0ZSwgd2hpbGUgdGhlIHNhbml0eSBjaGVjayBzaGFsbCBiZSBpbXBsZW1lbnRhdGlv
biBzcGVjaWZpYyBmb3IKPiBiaW8tYmFzZWQgZGV2aWNlcy4gRm9yIGV4YW1wbGUsIGRtIGRldmlj
ZSBuZWVkcyB0byBjaGVjayBpZiBhbGwKPiB1bmRlcmx5aW5nIGRldmljZXMgYXJlIGNhcGFibGUg
b2YgSU8gcG9sbGluZy4KPiAKPiBUaG91Z2ggYmlvLWJhc2VkIGRldmljZSBtYXkgaGF2ZSBkb25l
IHRoZSBzYW5pdHkgY2hlY2sgZHVyaW5nIHRoZQo+IGRldmljZSBpbml0aWFsaXphdGlvbiBwaGFz
ZSwgY2FjaGVpbmcgdGhlIHJlc3VsdCBvZiB0aGlzIHNhbml0eSBjaGVjawo+IChzdWNoIGFzIGJ5
IGNhY2hlaW5nIGluIHRoZSBxdWV1ZV9mbGFncykgbWF5IG5vdCB3b3JrLiBCZWNhdXNlIGZvciBk
bQo+IGRldmljZXMsIHVzZXJzIGNvdWxkIGNoYW5nZSB0aGUgc3RhdGUgb2YgdGhlIHVuZGVybHlp
bmcgZGV2aWNlcyB0aHJvdWdoCj4gJy9zeXMvYmxvY2svPGRldj4vaW9fcG9sbCcsIGJ5cGFzc2lu
ZyB0aGUgZG0gZGV2aWNlIGFib3ZlLiBJbiB0aGlzIGNhc2UsCj4gdGhlIGNhY2hlZCByZXN1bHQg
b2YgdGhlIHZlcnkgYmVnaW5uaW5nIHNhbml0eSBjaGVjayBjb3VsZCBiZQo+IG91dC1vZi1kYXRl
LiBUaHVzIHRoZSBzYW5pdHkgY2hlY2sgbmVlZHMgdG8gYmUgZG9uZSBldmVyeSB0aW1lICdpb19w
b2xsJwo+IGlzIHRvIGJlIG1vZGlmaWVkLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEplZmZsZSBYdSA8
amVmZmxleHVAbGludXguYWxpYmFiYS5jb20+Cj4gLS0tCj4gICBibG9jay9ibGstc3lzZnMuYyAg
ICAgIHwgMTQgKysrKysrKysrKystLS0KPiAgIGluY2x1ZGUvbGludXgvYmxrZGV2LmggfCAgMSAr
Cj4gICAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4g
Cj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1zeXNmcy5jIGIvYmxvY2svYmxrLXN5c2ZzLmMKPiBp
bmRleCBkYjMyNjhkNDEyNzQuLmM4ZTdlNGFmNjZjYiAxMDA2NDQKPiAtLS0gYS9ibG9jay9ibGst
c3lzZnMuYwo+ICsrKyBiL2Jsb2NrL2Jsay1zeXNmcy5jCj4gQEAgLTQyNiw5ICs0MjYsMTcgQEAg
c3RhdGljIHNzaXplX3QgcXVldWVfcG9sbF9zdG9yZShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwg
Y29uc3QgY2hhciAqcGFnZSwKPiAgIAl1bnNpZ25lZCBsb25nIHBvbGxfb247Cj4gICAJc3NpemVf
dCByZXQ7Cj4gICAKPiAtCWlmICghcS0+dGFnX3NldCB8fCBxLT50YWdfc2V0LT5ucl9tYXBzIDw9
IEhDVFhfVFlQRV9QT0xMIHx8Cj4gLQkgICAgIXEtPnRhZ19zZXQtPm1hcFtIQ1RYX1RZUEVfUE9M
TF0ubnJfcXVldWVzKQo+IC0JCXJldHVybiAtRUlOVkFMOwo+ICsJaWYgKHF1ZXVlX2lzX21xKHEp
KSB7Cj4gKwkJaWYgKCFxLT50YWdfc2V0IHx8IHEtPnRhZ19zZXQtPm5yX21hcHMgPD0gSENUWF9U
WVBFX1BPTEwgfHwKPiArCQkgICAgIXEtPnRhZ19zZXQtPm1hcFtIQ1RYX1RZUEVfUE9MTF0ubnJf
cXVldWVzKQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsKPiArCX0gZWxzZSB7Cj4gKwkJc3RydWN0IGdl
bmRpc2sgKmRpc2sgPSBxdWV1ZV90b19kaXNrKHEpOwo+ICsKPiArCQlpZiAoIWRpc2stPmZvcHMt
PnBvbGxfY2FwYWJsZSB8fAo+ICsJCSAgICAhZGlzay0+Zm9wcy0+cG9sbF9jYXBhYmxlKGRpc2sp
KQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsKPiArCX0KPiAgIAo+ICAgCXJldCA9IHF1ZXVlX3Zhcl9z
dG9yZSgmcG9sbF9vbiwgcGFnZSwgY291bnQpOwo+ICAgCWlmIChyZXQgPCAwKQo+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oIGIvaW5jbHVkZS9saW51eC9ibGtkZXYuaAo+IGlu
ZGV4IGJmYWI3NGI0NWYxNS4uYTQ2Zjk3NWYyYTJmIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGlu
dXgvYmxrZGV2LmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oCj4gQEAgLTE4ODEsNiAr
MTg4MSw3IEBAIHN0cnVjdCBibG9ja19kZXZpY2Vfb3BlcmF0aW9ucyB7Cj4gICAJaW50ICgqcmVw
b3J0X3pvbmVzKShzdHJ1Y3QgZ2VuZGlzayAqLCBzZWN0b3JfdCBzZWN0b3IsCj4gICAJCQl1bnNp
Z25lZCBpbnQgbnJfem9uZXMsIHJlcG9ydF96b25lc19jYiBjYiwgdm9pZCAqZGF0YSk7Cj4gICAJ
Y2hhciAqKCpkZXZub2RlKShzdHJ1Y3QgZ2VuZGlzayAqZGlzaywgdW1vZGVfdCAqbW9kZSk7Cj4g
Kwlib29sICgqcG9sbF9jYXBhYmxlKShzdHJ1Y3QgZ2VuZGlzayAqZGlzayk7Cj4gICAJc3RydWN0
IG1vZHVsZSAqb3duZXI7Cj4gICAJY29uc3Qgc3RydWN0IHByX29wcyAqcHJfb3BzOwo+ICAgfTsK
PiAKSSByZWFsbHkgd29uZGVyIGhvdyB0aGlzIHdvdWxkIHdvcmsgZm9yIG52bWUgbXVsdGlwYXRo
OyBidXQgSSBndWVzcyBpdCAKZG9lc24ndCBjaGFuZ2UgdGhlIGN1cnJlbnQgc2l0dWF0aW9uLgoK
U286CgpSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMs
CgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0
b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6Rm
dHNmw7xocmVyOiBGZWxpeCBJbWVuZMO2cmZmZXIKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVs

