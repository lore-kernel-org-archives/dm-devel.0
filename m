Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A3CC433B4
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 09:08:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BAC786102A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 09:08:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAC786102A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-Ipg-QYuuOhW10cDFxtcB-A-1; Mon, 26 Apr 2021 05:08:08 -0400
X-MC-Unique: Ipg-QYuuOhW10cDFxtcB-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CFF081744F;
	Mon, 26 Apr 2021 09:08:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDDC319D80;
	Mon, 26 Apr 2021 09:08:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C11F944A58;
	Mon, 26 Apr 2021 09:07:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13Q95iH1022162 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 05:05:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3D9702179392; Mon, 26 Apr 2021 09:05:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3794A217938E
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 09:05:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4A86858F0D
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 09:05:41 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-575-BEC2TEQnPVaXN4wghjYVqg-1;
	Mon, 26 Apr 2021 05:05:39 -0400
X-MC-Unique: BEC2TEQnPVaXN4wghjYVqg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 6DF1BB029;
	Mon, 26 Apr 2021 09:05:37 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-11-ming.lei@redhat.com>
	<b6a1f1fa-bad2-e072-6292-363510fc7017@suse.de> <YIZzGAxaNnNE0Ipa@T590>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <f1a13439-9ea7-9cdd-7489-2da4abd7256f@suse.de>
Date: Mon, 26 Apr 2021 11:05:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIZzGAxaNnNE0Ipa@T590>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13Q95iH1022162
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 10/12] block: limit hw queues to be polled
 in each blk_poll()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yNi8yMSAxMDowMCBBTSwgTWluZyBMZWkgd3JvdGU6Cj4gT24gTW9uLCBBcHIgMjYsIDIw
MjEgYXQgMDk6MTk6MjBBTSArMDIwMCwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+PiBPbiA0LzIy
LzIxIDI6MjAgUE0sIE1pbmcgTGVpIHdyb3RlOgo+Pj4gTGltaXQgYXQgbW9zdCA4IHF1ZXVlcyBh
cmUgcG9sbGVkIGluIGVhY2ggYmxrX3B1bGwoKSwgYXZvaWQgdG8KPj4+IGFkZCBleHRyYSBsYXRl
bmN5IHdoZW4gcXVldWUgZGVwdGggaXMgaGlnaC4KPj4+Cj4+PiBSZXZpZXdlZC1ieTogSmVmZmxl
IFh1IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPj4+IFNpZ25lZC1vZmYtYnk6IE1pbmcg
TGVpIDxtaW5nLmxlaUByZWRoYXQuY29tPgo+Pj4gLS0tCj4+PiAgYmxvY2svYmxrLXBvbGwuYyB8
IDc4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQo+Pj4g
IDEgZmlsZSBjaGFuZ2VkLCA1NSBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkKPj4+Cj4+
PiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXBvbGwuYyBiL2Jsb2NrL2Jsay1wb2xsLmMKPj4+IGlu
ZGV4IDI0OWQ3M2ZmNmY4MS4uMjBlN2M0N2NjOTg0IDEwMDY0NAo+Pj4gLS0tIGEvYmxvY2svYmxr
LXBvbGwuYwo+Pj4gKysrIGIvYmxvY2svYmxrLXBvbGwuYwo+Pj4gQEAgLTI4OCwzNiArMjg4LDMy
IEBAIHN0YXRpYyB2b2lkIGJpb19ncnBfbGlzdF9tb3ZlKHN0cnVjdCBiaW9fZ3JwX2xpc3QgKmRz
dCwKPj4+ICAJc3JjLT5ucl9ncnBzIC09IGNudDsKPj4+ICB9Cj4+PiAgCj4+PiAtc3RhdGljIGlu
dCBibGtfbXFfcG9sbF9pbyhzdHJ1Y3QgYmlvICpiaW8pCj4+PiArI2RlZmluZSBQT0xMX0hDVFhf
TUFYX0NOVCA4Cj4+PiArCj4+PiArc3RhdGljIGJvb2wgYmxrX2FkZF91bmlxdWVfaGN0eChzdHJ1
Y3QgYmxrX21xX2h3X2N0eCAqKmRhdGEsIGludCAqY250LAo+Pj4gKwkJc3RydWN0IGJsa19tcV9o
d19jdHggKmhjdHgpCj4+PiAgewo+Pj4gLQlzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSA9IGJpby0+
YmlfYmRldi0+YmRfZGlzay0+cXVldWU7Cj4+PiAtCWJsa19xY190IGNvb2tpZSA9IGJpb19nZXRf
cG9sbF9kYXRhKGJpbyk7Cj4+PiAtCWludCByZXQgPSAwOwo+Pj4gKwlpbnQgaTsKPj4+ICAKPj4+
IC0JLyogd2FpdCB1bnRpbCB0aGUgYmlvIGlzIHN1Ym1pdHRlZCByZWFsbHkgKi8KPj4+IC0JaWYg
KCFibGtfcWNfdF9yZWFkeShjb29raWUpKQo+Pj4gLQkJcmV0dXJuIDA7Cj4+PiAgCj4+PiAtCWlm
ICghYmlvX2ZsYWdnZWQoYmlvLCBCSU9fRE9ORSkgJiYgYmxrX3FjX3RfdmFsaWQoY29va2llKSkg
ewo+Pj4gLQkJc3RydWN0IGJsa19tcV9od19jdHggKmhjdHggPQo+Pj4gLQkJCXEtPnF1ZXVlX2h3
X2N0eFtibGtfcWNfdF90b19xdWV1ZV9udW0oY29va2llKV07Cj4+PiArCWZvciAoaSA9IDA7IGkg
PCAqY250OyBpKyspIHsKPj4+ICsJCWlmIChkYXRhW2ldID09IGhjdHgpCj4+PiArCQkJZ290byBl
eGl0Owo+Pj4gKwl9Cj4+PiAgCj4+PiAtCQlyZXQgKz0gYmxrX21xX3BvbGxfaGN0eChxLCBoY3R4
KTsKPj4+ICsJaWYgKGkgPCBQT0xMX0hDVFhfTUFYX0NOVCkgewo+Pj4gKwkJZGF0YVtpXSA9IGhj
dHg7Cj4+PiArCQkoKmNudCkrKzsKPj4+ICAJfQo+Pj4gLQlyZXR1cm4gcmV0Owo+Pj4gKyBleGl0
Ogo+Pj4gKwlyZXR1cm4gKmNudCA9PSBQT0xMX0hDVFhfTUFYX0NOVDsKPj4+ICB9Cj4+PiAgCj4+
PiAtc3RhdGljIGludCBibGtfYmlvX3BvbGxfYW5kX2VuZF9pbyhzdHJ1Y3QgYmlvX2dycF9saXN0
ICpncnBzKQo+Pj4gK3N0YXRpYyB2b2lkIGJsa19idWlsZF9wb2xsX3F1ZXVlcyhzdHJ1Y3QgYmlv
X2dycF9saXN0ICpncnBzLAo+Pj4gKwkJc3RydWN0IGJsa19tcV9od19jdHggKipkYXRhLCBpbnQg
KmNudCkKPj4+ICB7Cj4+PiAtCWludCByZXQgPSAwOwo+Pj4gIAlpbnQgaTsKPj4+ICAKPj4+IC0J
LyoKPj4+IC0JICogUG9sbCBodyBxdWV1ZSBmaXJzdC4KPj4+IC0JICoKPj4+IC0JICogVE9ETzog
bGltaXQgbWF4IHBvbGwgdGltZXMgYW5kIG1ha2Ugc3VyZSB0byBub3QgcG9sbCBzYW1lCj4+PiAt
CSAqIGh3IHF1ZXVlIG9uZSBtb3JlIHRpbWUuCj4+PiAtCSAqLwo+Pj4gIAlmb3IgKGkgPSAwOyBp
IDwgZ3Jwcy0+bnJfZ3JwczsgaSsrKSB7Cj4+PiAgCQlzdHJ1Y3QgYmlvX2dycF9saXN0X2RhdGEg
KmdycCA9ICZncnBzLT5oZWFkW2ldOwo+Pj4gIAkJc3RydWN0IGJpbyAqYmlvOwo+Pj4gQEAgLTMy
NSwxMSArMzIxLDMxIEBAIHN0YXRpYyBpbnQgYmxrX2Jpb19wb2xsX2FuZF9lbmRfaW8oc3RydWN0
IGJpb19ncnBfbGlzdCAqZ3JwcykKPj4+ICAJCWlmIChiaW9fZ3JwX2xpc3RfZ3JwX2VtcHR5KGdy
cCkpCj4+PiAgCQkJY29udGludWU7Cj4+PiAgCj4+PiAtCQlmb3IgKGJpbyA9IGdycC0+bGlzdC5o
ZWFkOyBiaW87IGJpbyA9IGJpby0+YmlfcG9sbCkKPj4+IC0JCQlyZXQgKz0gYmxrX21xX3BvbGxf
aW8oYmlvKTsKPj4+ICsJCWZvciAoYmlvID0gZ3JwLT5saXN0LmhlYWQ7IGJpbzsgYmlvID0gYmlv
LT5iaV9wb2xsKSB7Cj4+PiArCQkJYmxrX3FjX3QgIGNvb2tpZTsKPj4+ICsJCQlzdHJ1Y3QgYmxr
X21xX2h3X2N0eCAqaGN0eDsKPj4+ICsJCQlzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcTsKPj4+ICsK
Pj4+ICsJCQlpZiAoYmlvX2ZsYWdnZWQoYmlvLCBCSU9fRE9ORSkpCj4+PiArCQkJCWNvbnRpbnVl
Owo+Pj4gKwo+Pj4gKwkJCS8qIHdhaXQgdW50aWwgdGhlIGJpbyBpcyBzdWJtaXR0ZWQgcmVhbGx5
ICovCj4+PiArCQkJY29va2llID0gYmlvX2dldF9wb2xsX2RhdGEoYmlvKTsKPj4+ICsJCQlpZiAo
IWJsa19xY190X3JlYWR5KGNvb2tpZSkgfHwgIWJsa19xY190X3ZhbGlkKGNvb2tpZSkpCj4+PiAr
CQkJCWNvbnRpbnVlOwo+Pj4gKwo+Pj4gKwkJCXEgPSBiaW8tPmJpX2JkZXYtPmJkX2Rpc2stPnF1
ZXVlOwo+Pj4gKwkJCWhjdHggPSBxLT5xdWV1ZV9od19jdHhbYmxrX3FjX3RfdG9fcXVldWVfbnVt
KGNvb2tpZSldOwo+Pj4gKwkJCWlmIChibGtfYWRkX3VuaXF1ZV9oY3R4KGRhdGEsIGNudCwgaGN0
eCkpCj4+PiArCQkJCXJldHVybjsKPj4+ICsJCX0KPj4+ICAJfQo+Pj4gK30KPj4+ICsKPj4+ICtz
dGF0aWMgdm9pZCBibGtfYmlvX3BvbGxfcmVhcF9pb3Moc3RydWN0IGJpb19ncnBfbGlzdCAqZ3Jw
cykKPj4+ICt7Cj4+PiArCWludCBpOwo+Pj4gIAo+Pj4gLQkvKiByZWFwIGJpb3MgKi8KPj4+ICAJ
Zm9yIChpID0gMDsgaSA8IGdycHMtPm5yX2dycHM7IGkrKykgewo+Pj4gIAkJc3RydWN0IGJpb19n
cnBfbGlzdF9kYXRhICpncnAgPSAmZ3Jwcy0+aGVhZFtpXTsKPj4+ICAJCXN0cnVjdCBiaW8gKmJp
bzsKPj4+IEBAIC0zNTQsNiArMzcwLDIyIEBAIHN0YXRpYyBpbnQgYmxrX2Jpb19wb2xsX2FuZF9l
bmRfaW8oc3RydWN0IGJpb19ncnBfbGlzdCAqZ3JwcykKPj4+ICAJCX0KPj4+ICAJCV9fYmlvX2dy
cF9saXN0X21lcmdlKCZncnAtPmxpc3QsICZibCk7Cj4+PiAgCX0KPj4+ICt9Cj4+PiArCj4+PiAr
c3RhdGljIGludCBibGtfYmlvX3BvbGxfYW5kX2VuZF9pbyhzdHJ1Y3QgYmlvX2dycF9saXN0ICpn
cnBzKQo+Pj4gK3sKPj4+ICsJaW50IHJldCA9IDA7Cj4+PiArCWludCBpOwo+Pj4gKwlzdHJ1Y3Qg
YmxrX21xX2h3X2N0eCAqaGN0eFtQT0xMX0hDVFhfTUFYX0NOVF07Cj4+PiArCWludCBjbnQgPSAw
Owo+Pj4gKwo+Pj4gKwlibGtfYnVpbGRfcG9sbF9xdWV1ZXMoZ3JwcywgaGN0eCwgJmNudCk7Cj4+
PiArCj4+PiArCWZvciAoaSA9IDA7IGkgPCBjbnQ7IGkrKykKPj4+ICsJCXJldCArPSBibGtfbXFf
cG9sbF9oY3R4KGhjdHhbaV0tPnF1ZXVlLCBoY3R4W2ldKTsKPj4+ICsKPj4+ICsJYmxrX2Jpb19w
b2xsX3JlYXBfaW9zKGdycHMpOwo+Pj4gKwo+Pj4gIAlyZXR1cm4gcmV0Owo+Pj4gIH0KPj4+ICAK
Pj4+Cj4+IENhbid0IHdlIG1ha2UgaXQgYSBzeXNmcyBhdHRyaWJ1dGUgaW5zdGVhZCBvZiBoYXJk
LWNvZGluZyBpdD8KPj4gJzgnIHNlZW1zIGEgYml0IGFyYml0cmFyeSB0byBtZSwgSSdkIHJhdGhl
ciBoYXZlIHRoZSBhYmlsaXR5IHRvIG1vZGlmeSBpdC4uLgo+IAo+IEknZCByYXRoZXIgbm90IGFk
ZCBzdWNoIGNvZGUgaW4gdGhlIGZlYXR1cmUgJ2VuYWJsZW1lbnQnIHN0YWdlIHNpbmNlIEkgZG9l
c24ndAo+IG9ic2VydmUgdGhlIG51bWJlciBwbGF5cyBhIGJpZyByb2xlIHlldC4gSXQgaXMgYWRk
ZWQgZm9yIGhvbGRpbmcgaHcgcXVldWVzIHRvCj4gYmUgcG9sbGVkIG9uIHN0YWNrIHZhcmlhYmxl
cywgYWxzbyBhdm9pZCB0byBhZGQgdG9vIG11Y2ggbGF0ZW5jeSBpZiB0aGVyZSBpcwo+IHRvbyBt
YW55IGJpb3MgZnJvbSB0b28gbWFueSBodyBxdWV1ZXMgdG8gYmUgcmVhcGVkLgo+IAo+IEFsc28g
dGhlIGFjdHVhbCBwb2xsZWQgaHcgcXVldWVzIGNhbiBiZSBvYnNlcnZlZCBlYXNpbHkgdmlhIGJw
ZnRyYWNlLCBzbyBkZWJ1Zwo+IHB1cnBvc2UgZnJvbSBzeXNmcyBpc24ndCBuZWNlc3NhcnkgdG9v
Lgo+IApPa2F5LiBZb3UgY2FuIGFkZCBteQoKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8
aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlCQkg
ICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUJCQkgICAgICAgICAg
ICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdt
YkgsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBIUkIgMzY4MDkgKEFHIE7D
vHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

