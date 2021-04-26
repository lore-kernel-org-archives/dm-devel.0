Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64216C433ED
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:19:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D0E9461151
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:19:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0E9461151
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-T3ABQu-zPFuQt4CF42IhGw-1; Mon, 26 Apr 2021 03:19:44 -0400
X-MC-Unique: T3ABQu-zPFuQt4CF42IhGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C27408189C8;
	Mon, 26 Apr 2021 07:19:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76ADC60BE5;
	Mon, 26 Apr 2021 07:19:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 396B01806D1B;
	Mon, 26 Apr 2021 07:19:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13Q7Jc07013159 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 03:19:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D21C12087A28; Mon, 26 Apr 2021 07:19:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC7712087A21
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 07:19:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBE4F80080F
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 07:19:35 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-536-qkdkOJ6ANdK2dVR6tBhyAA-1;
	Mon, 26 Apr 2021 03:19:31 -0400
X-MC-Unique: qkdkOJ6ANdK2dVR6tBhyAA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BFD5CB009;
	Mon, 26 Apr 2021 07:19:29 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-11-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <b6a1f1fa-bad2-e072-6292-363510fc7017@suse.de>
Date: Mon, 26 Apr 2021 09:19:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422122038.2192933-11-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13Q7Jc07013159
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yMi8yMSAyOjIwIFBNLCBNaW5nIExlaSB3cm90ZToKPiBMaW1pdCBhdCBtb3N0IDggcXVl
dWVzIGFyZSBwb2xsZWQgaW4gZWFjaCBibGtfcHVsbCgpLCBhdm9pZCB0bwo+IGFkZCBleHRyYSBs
YXRlbmN5IHdoZW4gcXVldWUgZGVwdGggaXMgaGlnaC4KPiAKPiBSZXZpZXdlZC1ieTogSmVmZmxl
IFh1IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBNaW5nIExl
aSA8bWluZy5sZWlAcmVkaGF0LmNvbT4KPiAtLS0KPiAgYmxvY2svYmxrLXBvbGwuYyB8IDc4ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNTUgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdp
dCBhL2Jsb2NrL2Jsay1wb2xsLmMgYi9ibG9jay9ibGstcG9sbC5jCj4gaW5kZXggMjQ5ZDczZmY2
ZjgxLi4yMGU3YzQ3Y2M5ODQgMTAwNjQ0Cj4gLS0tIGEvYmxvY2svYmxrLXBvbGwuYwo+ICsrKyBi
L2Jsb2NrL2Jsay1wb2xsLmMKPiBAQCAtMjg4LDM2ICsyODgsMzIgQEAgc3RhdGljIHZvaWQgYmlv
X2dycF9saXN0X21vdmUoc3RydWN0IGJpb19ncnBfbGlzdCAqZHN0LAo+ICAJc3JjLT5ucl9ncnBz
IC09IGNudDsKPiAgfQo+ICAKPiAtc3RhdGljIGludCBibGtfbXFfcG9sbF9pbyhzdHJ1Y3QgYmlv
ICpiaW8pCj4gKyNkZWZpbmUgUE9MTF9IQ1RYX01BWF9DTlQgOAo+ICsKPiArc3RhdGljIGJvb2wg
YmxrX2FkZF91bmlxdWVfaGN0eChzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqKmRhdGEsIGludCAqY250
LAo+ICsJCXN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4KQo+ICB7Cj4gLQlzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSA9IGJpby0+YmlfYmRldi0+YmRfZGlzay0+cXVldWU7Cj4gLQlibGtfcWNfdCBj
b29raWUgPSBiaW9fZ2V0X3BvbGxfZGF0YShiaW8pOwo+IC0JaW50IHJldCA9IDA7Cj4gKwlpbnQg
aTsKPiAgCj4gLQkvKiB3YWl0IHVudGlsIHRoZSBiaW8gaXMgc3VibWl0dGVkIHJlYWxseSAqLwo+
IC0JaWYgKCFibGtfcWNfdF9yZWFkeShjb29raWUpKQo+IC0JCXJldHVybiAwOwo+ICAKPiAtCWlm
ICghYmlvX2ZsYWdnZWQoYmlvLCBCSU9fRE9ORSkgJiYgYmxrX3FjX3RfdmFsaWQoY29va2llKSkg
ewo+IC0JCXN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4ID0KPiAtCQkJcS0+cXVldWVfaHdfY3R4
W2Jsa19xY190X3RvX3F1ZXVlX251bShjb29raWUpXTsKPiArCWZvciAoaSA9IDA7IGkgPCAqY250
OyBpKyspIHsKPiArCQlpZiAoZGF0YVtpXSA9PSBoY3R4KQo+ICsJCQlnb3RvIGV4aXQ7Cj4gKwl9
Cj4gIAo+IC0JCXJldCArPSBibGtfbXFfcG9sbF9oY3R4KHEsIGhjdHgpOwo+ICsJaWYgKGkgPCBQ
T0xMX0hDVFhfTUFYX0NOVCkgewo+ICsJCWRhdGFbaV0gPSBoY3R4Owo+ICsJCSgqY250KSsrOwo+
ICAJfQo+IC0JcmV0dXJuIHJldDsKPiArIGV4aXQ6Cj4gKwlyZXR1cm4gKmNudCA9PSBQT0xMX0hD
VFhfTUFYX0NOVDsKPiAgfQo+ICAKPiAtc3RhdGljIGludCBibGtfYmlvX3BvbGxfYW5kX2VuZF9p
byhzdHJ1Y3QgYmlvX2dycF9saXN0ICpncnBzKQo+ICtzdGF0aWMgdm9pZCBibGtfYnVpbGRfcG9s
bF9xdWV1ZXMoc3RydWN0IGJpb19ncnBfbGlzdCAqZ3JwcywKPiArCQlzdHJ1Y3QgYmxrX21xX2h3
X2N0eCAqKmRhdGEsIGludCAqY250KQo+ICB7Cj4gLQlpbnQgcmV0ID0gMDsKPiAgCWludCBpOwo+
ICAKPiAtCS8qCj4gLQkgKiBQb2xsIGh3IHF1ZXVlIGZpcnN0Lgo+IC0JICoKPiAtCSAqIFRPRE86
IGxpbWl0IG1heCBwb2xsIHRpbWVzIGFuZCBtYWtlIHN1cmUgdG8gbm90IHBvbGwgc2FtZQo+IC0J
ICogaHcgcXVldWUgb25lIG1vcmUgdGltZS4KPiAtCSAqLwo+ICAJZm9yIChpID0gMDsgaSA8IGdy
cHMtPm5yX2dycHM7IGkrKykgewo+ICAJCXN0cnVjdCBiaW9fZ3JwX2xpc3RfZGF0YSAqZ3JwID0g
JmdycHMtPmhlYWRbaV07Cj4gIAkJc3RydWN0IGJpbyAqYmlvOwo+IEBAIC0zMjUsMTEgKzMyMSwz
MSBAQCBzdGF0aWMgaW50IGJsa19iaW9fcG9sbF9hbmRfZW5kX2lvKHN0cnVjdCBiaW9fZ3JwX2xp
c3QgKmdycHMpCj4gIAkJaWYgKGJpb19ncnBfbGlzdF9ncnBfZW1wdHkoZ3JwKSkKPiAgCQkJY29u
dGludWU7Cj4gIAo+IC0JCWZvciAoYmlvID0gZ3JwLT5saXN0LmhlYWQ7IGJpbzsgYmlvID0gYmlv
LT5iaV9wb2xsKQo+IC0JCQlyZXQgKz0gYmxrX21xX3BvbGxfaW8oYmlvKTsKPiArCQlmb3IgKGJp
byA9IGdycC0+bGlzdC5oZWFkOyBiaW87IGJpbyA9IGJpby0+YmlfcG9sbCkgewo+ICsJCQlibGtf
cWNfdCAgY29va2llOwo+ICsJCQlzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eDsKPiArCQkJc3Ry
dWN0IHJlcXVlc3RfcXVldWUgKnE7Cj4gKwo+ICsJCQlpZiAoYmlvX2ZsYWdnZWQoYmlvLCBCSU9f
RE9ORSkpCj4gKwkJCQljb250aW51ZTsKPiArCj4gKwkJCS8qIHdhaXQgdW50aWwgdGhlIGJpbyBp
cyBzdWJtaXR0ZWQgcmVhbGx5ICovCj4gKwkJCWNvb2tpZSA9IGJpb19nZXRfcG9sbF9kYXRhKGJp
byk7Cj4gKwkJCWlmICghYmxrX3FjX3RfcmVhZHkoY29va2llKSB8fCAhYmxrX3FjX3RfdmFsaWQo
Y29va2llKSkKPiArCQkJCWNvbnRpbnVlOwo+ICsKPiArCQkJcSA9IGJpby0+YmlfYmRldi0+YmRf
ZGlzay0+cXVldWU7Cj4gKwkJCWhjdHggPSBxLT5xdWV1ZV9od19jdHhbYmxrX3FjX3RfdG9fcXVl
dWVfbnVtKGNvb2tpZSldOwo+ICsJCQlpZiAoYmxrX2FkZF91bmlxdWVfaGN0eChkYXRhLCBjbnQs
IGhjdHgpKQo+ICsJCQkJcmV0dXJuOwo+ICsJCX0KPiAgCX0KPiArfQo+ICsKPiArc3RhdGljIHZv
aWQgYmxrX2Jpb19wb2xsX3JlYXBfaW9zKHN0cnVjdCBiaW9fZ3JwX2xpc3QgKmdycHMpCj4gK3sK
PiArCWludCBpOwo+ICAKPiAtCS8qIHJlYXAgYmlvcyAqLwo+ICAJZm9yIChpID0gMDsgaSA8IGdy
cHMtPm5yX2dycHM7IGkrKykgewo+ICAJCXN0cnVjdCBiaW9fZ3JwX2xpc3RfZGF0YSAqZ3JwID0g
JmdycHMtPmhlYWRbaV07Cj4gIAkJc3RydWN0IGJpbyAqYmlvOwo+IEBAIC0zNTQsNiArMzcwLDIy
IEBAIHN0YXRpYyBpbnQgYmxrX2Jpb19wb2xsX2FuZF9lbmRfaW8oc3RydWN0IGJpb19ncnBfbGlz
dCAqZ3JwcykKPiAgCQl9Cj4gIAkJX19iaW9fZ3JwX2xpc3RfbWVyZ2UoJmdycC0+bGlzdCwgJmJs
KTsKPiAgCX0KPiArfQo+ICsKPiArc3RhdGljIGludCBibGtfYmlvX3BvbGxfYW5kX2VuZF9pbyhz
dHJ1Y3QgYmlvX2dycF9saXN0ICpncnBzKQo+ICt7Cj4gKwlpbnQgcmV0ID0gMDsKPiArCWludCBp
Owo+ICsJc3RydWN0IGJsa19tcV9od19jdHggKmhjdHhbUE9MTF9IQ1RYX01BWF9DTlRdOwo+ICsJ
aW50IGNudCA9IDA7Cj4gKwo+ICsJYmxrX2J1aWxkX3BvbGxfcXVldWVzKGdycHMsIGhjdHgsICZj
bnQpOwo+ICsKPiArCWZvciAoaSA9IDA7IGkgPCBjbnQ7IGkrKykKPiArCQlyZXQgKz0gYmxrX21x
X3BvbGxfaGN0eChoY3R4W2ldLT5xdWV1ZSwgaGN0eFtpXSk7Cj4gKwo+ICsJYmxrX2Jpb19wb2xs
X3JlYXBfaW9zKGdycHMpOwo+ICsKPiAgCXJldHVybiByZXQ7Cj4gIH0KPiAgCj4gCkNhbid0IHdl
IG1ha2UgaXQgYSBzeXNmcyBhdHRyaWJ1dGUgaW5zdGVhZCBvZiBoYXJkLWNvZGluZyBpdD8KJzgn
IHNlZW1zIGEgYml0IGFyYml0cmFyeSB0byBtZSwgSSdkIHJhdGhlciBoYXZlIHRoZSBhYmlsaXR5
IHRvIG1vZGlmeSBpdC4uLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tl
CQkgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUJCQkgICAgICAg
ICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55
IEdtYkgsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBIUkIgMzY4MDkgKEFH
IE7DvHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

