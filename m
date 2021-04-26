Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F7AC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:17:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 04E7B61151
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 07:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04E7B61151
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-DImV_A8PP1WjFeaEUsTJaw-1; Mon, 26 Apr 2021 03:17:33 -0400
X-MC-Unique: DImV_A8PP1WjFeaEUsTJaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B08F38189C6;
	Mon, 26 Apr 2021 07:17:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94D5462464;
	Mon, 26 Apr 2021 07:17:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B1E544A58;
	Mon, 26 Apr 2021 07:17:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13Q7HODQ012976 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 03:17:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AD28F44018; Mon, 26 Apr 2021 07:17:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8B184402B
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 07:17:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E122F104D99D
	for <dm-devel@redhat.com>; Mon, 26 Apr 2021 07:17:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-291-HaLSlwgPOmmby9jyl5E_AQ-1;
	Mon, 26 Apr 2021 03:17:17 -0400
X-MC-Unique: HaLSlwgPOmmby9jyl5E_AQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CB651AF31;
	Mon, 26 Apr 2021 07:17:15 +0000 (UTC)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-10-ming.lei@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <527cf81d-5d6c-03ca-a6ae-cc18b9a67787@suse.de>
Date: Mon, 26 Apr 2021 09:17:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422122038.2192933-10-ming.lei@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13Q7HODQ012976
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 09/12] block: use per-task poll context to
 implement bio based io polling
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8yMi8yMSAyOjIwIFBNLCBNaW5nIExlaSB3cm90ZToKPiBDdXJyZW50bHkgYmlvIGJhc2Vk
IElPIHBvbGxpbmcgbmVlZHMgdG8gcG9sbCBhbGwgaHcgcXVldWUgYmxpbmRseSwgdGhpcwo+IHdh
eSBpcyB2ZXJ5IGluZWZmaWNpZW50LCBhbmQgb25lIGJpZyByZWFzb24gaXMgdGhhdCB3ZSBjYW4n
dCBwYXNzIGFueQo+IGJpbyBzdWJtaXNzaW9uIHJlc3VsdCB0byBibGtfcG9sbCgpLgo+IAo+IElu
IElPIHN1Ym1pc3Npb24gY29udGV4dCwgdHJhY2sgYXNzb2NpYXRlZCB1bmRlcmx5aW5nIGJpb3Mg
YnkgcGVyLXRhc2sKPiBzdWJtaXNzaW9uIHF1ZXVlIGFuZCBzdG9yZSByZXR1cm5lZCAnY29va2ll
JyBpbiBiaW8tPmJpX3BvbGxfZGF0YSB3aGljaAo+IGlzIGFkZGVkIGJ5IGZpbGxpbmcgYSBob2xl
IG9mIC5iaV9pdGVyLCBhbmQgcmV0dXJuIGN1cnJlbnQtPnBpZCB0bwo+IGNhbGxlciBvZiBzdWJt
aXRfYmlvKCkgZm9yIGFueSBiaW8gYmFzZWQgZHJpdmVyJ3MgSU8sIHdoaWNoIGlzCj4gc3VibWl0
dGVkIGZyb20gRlMuCj4gCj4gSW4gSU8gcG9sbCBjb250ZXh0LCB0aGUgcGFzc2VkIGNvb2tpZSB0
ZWxscyB1cyB0aGUgUElEIG9mIHN1Ym1pc3Npb24KPiBjb250ZXh0LCB0aGVuIHdlIGNhbiBmaW5k
IGJpb3MgZnJvbSB0aGUgcGVyLXRhc2sgaW8gcHVsbCBjb250ZXh0IG9mCj4gc3VibWlzc2lvbiBj
b250ZXh0LiBNb3ZpbmcgYmlvcyBmcm9tIHN1Ym1pc3Npb24gcXVldWUgdG8gcG9sbCBxdWV1ZSBv
Zgo+IHRoZSBwb2xsIGNvbnRleHQsIGFuZCBrZWVwIHBvbGxpbmcgdW50aWwgdGhlc2UgYmlvcyBh
cmUgZW5kZWQuIFJlbW92ZQo+IGJpbyBmcm9tIHBvbGwgcXVldWUgaWYgdGhlIGJpbyBpcyBlbmRl
ZC4gQWRkIGJpbyBmbGFncyBvZiBCSU9fRE9ORSBhbmQKPiBCSU9fRU5EX0JZX1BPTEwgZm9yIHN1
Y2ggcHVycG9zZS4KPiAKPiBJbiB3YXMgZm91bmQgaW4gSmVmZmxlIFh1J3MgdGVzdCB0aGF0IGtm
aWZvIGRvZXNuJ3Qgc2NhbGUgd2VsbCBmb3IgYQo+IHN1Ym1pc3Npb24gcXVldWUgYXMgcXVldWUg
ZGVwdGggaXMgaW5jcmVhc2VkLCBzbyBhIG5ldyBtZWNoYW5pc20gZm9yCj4gdHJhY2tpbmcgYmlv
cyBpcyBuZWVkZWQuIFNvIGZhciBiaW8ncyBzaXplIGlzIGNsb3NlIHRvIDIgY2FjaGVsaW5lIHNp
emUsCj4gYW5kIGl0IG1heSBub3QgYmUgYWNjZXB0ZWQgdG8gYWRkIG5ldyBmaWVsZCBpbnRvIGJp
byBmb3Igc29sdmluZyB0aGUKPiBzY2FsYWJpbGl0eSBpc3N1ZSBieSB0cmFja2luZyBiaW9zIHZp
YSBsaW5rZWQgbGlzdCwgc3dpdGNoIHRvIGJpbyBncm91cAo+IGxpc3QgZm9yIHRyYWNraW5nIGJp
bywgdGhlIGlkZWEgaXMgdG8gcmV1c2UgLmJpX2VuZF9pbyBmb3IgbGlua2luZyBiaW9zCj4gaW50
byBhIGxpbmtlZCBsaXN0IGZvciBhbGwgc2hhcmluZyBzYW1lIC5iaV9lbmRfaW8oY2FsbCBpdCBi
aW8gZ3JvdXApLAo+IHdoaWNoIGlzIHJlY292ZXJlZCBiZWZvcmUgZW5kaW5nIGJpbyByZWFsbHks
IHNpbmNlIEJJT19FTkRfQllfUE9MTCBpcwo+IGFkZGVkIGZvciBlbmhhbmNpbmcgdGhpcyBwb2lu
dC4gVXN1YWxseSAuYmlfZW5kX2JpbyBpcyBzYW1lIGZvciBhbGwKPiBiaW9zIGluIHNhbWUgbGF5
ZXIsIHNvIGl0IGlzIGVub3VnaCB0byBwcm92aWRlIHZlcnkgbGltaXRlZCBncm91cHMsIHN1Y2gK
PiBhcyAxNiBvciBsZXNzIGZvciBmaXhpbmcgdGhlIHNjYWxhYmlsaXR5IGlzc3VlLgo+IAo+IFVz
dWFsbHkgc3VibWlzc2lvbiBzaGFyZXMgY29udGV4dCB3aXRoIGlvIHBvbGwuIFRoZSBwZXItdGFz
ayBwb2xsIGNvbnRleHQKPiBpcyBqdXN0IGxpa2Ugc3RhY2sgdmFyaWFibGUsIGFuZCBpdCBpcyBj
aGVhcCB0byBtb3ZlIGRhdGEgYmV0d2VlbiB0aGUgdHdvCj4gcGVyLXRhc2sgcXVldWVzLgo+IAo+
IEFsc28gd2hlbiB0aGUgc3VibWlzc2lvbiB0YXNrIGlzIGV4aXRpbmcsIGRyYWluIHBlbmRpbmcg
SU9zIGluIHRoZSBjb250ZXh0Cj4gdW50aWwgYWxsIGFyZSBkb25lLgo+IAo+IFRlc3RlZC1ieTog
SmVmZmxlIFh1IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPiBSZXZpZXdlZC1ieTogSmVm
ZmxlIFh1IDxqZWZmbGV4dUBsaW51eC5hbGliYWJhLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBNaW5n
IExlaSA8bWluZy5sZWlAcmVkaGF0LmNvbT4KPiAtLS0KPiAgYmxvY2svYmlvLmMgICAgICAgICAg
ICAgICB8ICAgNSArCj4gIGJsb2NrL2Jsay1jb3JlLmMgICAgICAgICAgfCAgMzkgKysrKy0KPiAg
YmxvY2svYmxrLWlvYy5jICAgICAgICAgICB8ICAgMyArCj4gIGJsb2NrL2Jsay1wb2xsLmMgICAg
ICAgICAgfCAzNDUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KPiAgYmxv
Y2svYmxrLmggICAgICAgICAgICAgICB8ICAzMyArKysrCj4gIGluY2x1ZGUvbGludXgvYmxrX3R5
cGVzLmggfCAgMjcgKystCj4gIDYgZmlsZXMgY2hhbmdlZCwgNDQ4IGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5k
ZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAgICAgICBLZXJu
ZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlCQkJICAgICAgICAgICAgICAgKzQ5IDkx
MSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJILCA5MDQwOSBO
w7xybmJlcmcKR0Y6IEYuIEltZW5kw7ZyZmZlciwgSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpCgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

