Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9DEC77B7E
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998756;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IP6sChTE3b3lW3R1UAChGNU1PxNnvg/14X2/Cgetkb4=;
	b=ECBxWL3mzxhYc6ghv4PlOABXOc5aFgQyG8QkX9QOwOcmnzzjcpGkRK2Oix7scSUt3pD5vI
	fhSti7SU4Ocyh93702UDvXoyEWrdODpBIJaEIyjCxQRB84kXbdMrJClLXYRNhnbx5MYQsN
	5quo6fAjSuF9tWXrTwCflNVms4iNzPw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-L_egG93COia1DEbSIEA51g-1; Thu, 25 May 2023 03:12:32 -0400
X-MC-Unique: L_egG93COia1DEbSIEA51g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 924593C01C3E;
	Thu, 25 May 2023 07:12:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E77E40CFD47;
	Thu, 25 May 2023 07:12:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40E2519465A4;
	Thu, 25 May 2023 07:12:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5FA9A19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 07:14:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6284D202696C; Wed, 24 May 2023 07:14:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AEDD200B673
 for <dm-devel@redhat.com>; Wed, 24 May 2023 07:14:02 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 409511C08787
 for <dm-devel@redhat.com>; Wed, 24 May 2023 07:14:02 +0000 (UTC)
Received: from out30-112.freemail.mail.aliyun.com
 (out30-112.freemail.mail.aliyun.com [115.124.30.112]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-562-mUAijAD_O0u_EZMJRhs3iw-1; Wed, 24 May 2023 03:13:56 -0400
X-MC-Unique: mUAijAD_O0u_EZMJRhs3iw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045170;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjN6v8P_1684912430
Received: from 30.97.48.247(mailfrom:hsiangkao@linux.alibaba.com
 fp:SMTPD_---0VjN6v8P_1684912430) by smtp.aliyun-inc.com;
 Wed, 24 May 2023 15:13:51 +0800
Message-ID: <fd4d0429-4da3-8217-6c13-14fd8a198920@linux.alibaba.com>
Date: Wed, 24 May 2023 15:13:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
To: Alexander Larsson <alexl@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Du Rui <durui@linux.alibaba.com>
References: <9505927dabc3b6695d62dfe1be371b12f5bdebf7.1684491648.git.durui@linux.alibaba.com>
 <ZGz32yw7ecKhW+lj@redhat.com>
 <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 25 May 2023 07:12:27 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAyMDIzLzUvMjQgMjM6NDMsIEFsZXhhbmRlciBMYXJzc29uIHdyb3RlOgo+IE9uIFR1ZSwg
TWF5IDIzLCAyMDIzIGF0IDc6MjnigK9QTSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAa2VybmVsLm9y
Zz4gd3JvdGU6Cj4+Cj4+IE9uIEZyaSwgTWF5IDE5IDIwMjMgYXQgIDY6MjdQIC0wNDAwLAo+PiBE
dSBSdWkgPGR1cnVpQGxpbnV4LmFsaWJhYmEuY29tPiB3cm90ZToKPj4KPj4+IE92ZXJsYXlCRCBp
cyBhIG5vdmVsIGxheWVyaW5nIGJsb2NrLWxldmVsIGltYWdlIGZvcm1hdCwgd2hpY2ggaXMgZGVz
aWduCj4+PiBmb3IgY29udGFpbmVyLCBzZWN1cmUgY29udGFpbmVyIGFuZCBhcHBsaWNhYmxlIHRv
IHZpcnR1YWwgbWFjaGluZSwKPj4+IHB1Ymxpc2hlZCBpbiBVU0VOSVggQVRDICcyMAo+Pj4gaHR0
cHM6Ly93d3cudXNlbml4Lm9yZy9zeXN0ZW0vZmlsZXMvYXRjMjAtbGktaHVpYmEucGRmCj4+Pgo+
Pj4gT3ZlcmxheUJEIGFscmVhZHkgaGFzIGEgQ29udGFpbmVyRCBub24tY29yZSBzdWItcHJvamVj
dCBpbXBsZW1lbnRhdGlvbgo+Pj4gaW4gdXNlcnNwYWNlLCBhcyBhbiBhY2NlbGVyYXRlZCBjb250
YWluZXIgaW1hZ2Ugc2VydmljZQo+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2NvbnRhaW5lcmQvYWNj
ZWxlcmF0ZWQtY29udGFpbmVyLWltYWdlCj4+Pgo+Pj4gSXQgY291bGQgYmUgbXVjaCBtb3JlIGVm
ZmljaWVudCB3aGVuIGRvIGRlY29tcHJlc3NpbmcgYW5kIG1hcHBpbmcgd29ya3MKPj4+IGluIHRo
ZSBrZXJuZWwgd2l0aCB0aGUgZnJhbWV3b3JrIG9mIGRldmljZS1tYXBwZXIsIGluIG1hbnkgY2ly
Y3Vtc3RhbmNlcywKPj4+IHN1Y2ggYXMgc2VjdXJlIGNvbnRhaW5lciBydW50aW1lLCBtb2JpbGUt
ZGV2aWNlcywgZXRjLgo+Pj4KPj4+IFRoaXMgcGF0Y2ggY29udGFpbnMgYSBtb2R1bGUsIGRtLW92
ZXJsYXliZCwgcHJvdmlkZXMgdHdvIGtpbmRzIG9mIHRhcmdldHMKPj4+IGRtLXpmaWxlIGFuZCBk
bS1sc210LCB0byBleHBvc2UgYSBncm91cCBvZiBibG9jay1kZXZpY2VzIGNvbnRhaW5zCj4+PiBP
dmVybGF5QkQgaW1hZ2UgYXMgYSBvdmVybGFpZCByZWFkLW9ubHkgYmxvY2stZGV2aWNlLgo+Pj4K
Pj4+IFNpZ25lZC1vZmYtYnk6IER1IFJ1aSA8ZHVydWlAbGludXguYWxpYmFiYS5jb20+Cj4+Cj4+
IDxzbmlwLCBvcmlnaW5hbCBwYXRjaCBoZXJlOiBbMV0gPgo+IAo+IEEgbG9uZyBsb25nIHRpbWUg
YWdvIEkgd3JvdGUgYSBkb2NrZXIgY29udGFpbmVyIGltYWdlIGJhc2VkIG9uCj4gZG0tc25hcHNo
b3QgdGhhdCBpcyB2YWd1ZWx5IHNpbWlsYXIgdG8gdGhpcyBvbmUuIEl0IGlzIHN0aWxsCj4gYXZh
aWxhYmxlLCBidXQgbm9ib2R5IHJlYWxseSB1c2VzIGl0LiBJdCBoYXMgc2V2ZXJhbCB3ZWFrbmVz
c2VzLiBGaXJzdAo+IG9mIGFsbCB0aGUgY29udGFpbmVyIGltYWdlIGlzIGFuIGFjdHVhbCBmaWxl
c3lzdGVtLCBzbyB5b3UgbmVlZCB0bwo+IHByZS1hbGxvY2F0ZSBhIGZpeGVkIG1heCBzaXplIGZv
ciBpbWFnZXMgYXQgY29uc3RydWN0aW9uIHRpbWUuCj4gU2Vjb25kbHksIGFsbCB0aGUgbHZtIHZv
bHVtZSBjaGFuZ2VzIGFuZCBtb3VudHMgZHVyaW5nIHJ1bnRpbWUgY2F1c2VkCj4gd2VpcmQgYmVo
YXZpb3VyIChlc3BlY2lhbGx5IGF0IHNjYWxlKSB0aGF0IHdhcyBwYWluZnVsIHRvIG1hbmFnZSAo
anVzdAo+IHNlYXJjaCB0aGUgZG9ja2VyIGlzc3VlIHRyYWNrZXIgZm9yIGRldm1hcHBlciBiYWNr
ZW5kKS4gSW4gdGhlIGVuZAo+IGV2ZXJ5b25lIG1vdmVkIHRvIGEgZmlsZXN5c3RlbSBiYXNlZCBp
bXBsZW1lbnRhdGlvbiAob3ZlcmxheWZzIGJhc2VkKS4KClllYWgsIGFuZCBJIHRoaW5rIHJlcHJv
ZHVjaWJpbGl0eSBpc3N1ZSBpcyBhbm90aGVyIHByb2JsZW0sIHdoaWNoIG1lYW5zCml0J3MgcXVp
dGUgaGFyZCB0byBzZWxlY3QgYSByYW5kb20gZnMgd2l0aG91dCBzb21lIGNoYW5nZSB0byBnZXQg
dGhlCmJlc3QgcmVzdWx0LiAgSSBkbyBmaW5kIHRoZXNlIGd1eXMgd29yayBvbiBlMmZzcHJvZ3Mg
YWdhaW4gYW5kIGFnYWluLgoKSSd2ZSBhbHJlYWR5IHRvbGQgdGhlbSBpbnRlcm5hbGx5IGFnYWlu
IGFuZCBhZ2FpbiwgYnV0Li4gVGhleSBvbmx5IGZvY3VzCm9uIHNvbWUgbWlub3IgcG9pbnRzIHN1
Y2ggYXMgaG93IHRvIGRvIEkvTyBhbmQgQ1BVIHByZWZldGNoIHRvIGdldAooc29tZXdoYXQpIGJl
dHRlciBwZXJmb3JtYW5jZSBhbmQgYmVhdCBFUk9GUy4gIEkgZG9uJ3Qga25vdywgSSBoYXZlIG5v
CmVub3VnaCB0aW1lIHRvIGV2ZW4gbG9vayBpbnRvIHRoYXQgd2hldGhlciB0aGlzIG5ldyBrZXJu
ZWwgc3R1ZmZzIGlzCmZpbmU6IGJlY2F1c2Ugb2YgYSB2ZXJ5IHNpbXBsaXN0IGlkZWE6CgogIHN0
YWNrZWQgc3RvcmFnZSBvdmVyaGVhZCBnZW5lcmFsbHkgdGFrZXMgZG91YmxlIHJ1bnRpbWUvbWVt
b3J5CmZvb3RwcmludHM6CiAgICBmaWxlc3lzdGVtICsgYmxvY2sgZHJpdmVycwoKPiAKPj4gSSBh
cHByZWNpYXRlIHRoYXQgdGhpcyB3b3JrIGlzIGJlaW5nIGRvbmUgd2l0aCBhbiBleWUgdG93YXJk
Cj4+IGNvbnRhaW5lcmQgImNvbW11bml0eSIgYW5kIHN0YW5kYXJkaXphdGlvbiBidXQgYmFzZWQg
b24gbXkgbGltaXRlZAo+PiByZXNlYXJjaCBpdCBhcHBlYXJzIHRoYXQgdGhpcyBmb3JtYXQgb2Yg
T0NJIGltYWdlIHN0b3JhZ2UvdXNlIGlzIG9ubHkKPj4gdXNlZCBieSBBbGliYWJhPyAoYnV0IEkg
Y291bGQgYmUgd3JvbmcuLi4pCj4+Cj4+IEJ1dCB5b3UnZCBkbyB3ZWxsIHRvIGV4cGxhaW4gd2h5
IHRoZSB1c2Vyc3BhY2Ugc29sdXRpb24gaXNuJ3QKPj4gYWNjZXB0YWJsZS4gQXJlIHRoZXJlIHNl
Y3VyaXR5IGlzc3VlcyB0aGF0IG1vdmluZyB0aGUgaW1wbGVtZW50YXRpb24KPj4gdG8ga2VybmVs
IGFkZHJlc3Nlcz8KPj4KPj4gSSBhbHNvIGhhdmUgZG91YnRzIHRoYXQgdGhpcyBzb2x1dGlvbiBp
cyBfYWN0dWFsbHlfIG1vcmUgcGVyZm9ybWFudAo+PiB0aGFuIGEgcHJvcGVyIGZpbGVzeXN0ZW0g
YmFzZWQgc29sdXRpb24gdGhhdCBhbGxvd3MgcGFnZSBjYWNoZSBzaGFyaW5nCj4+IG9mIGNvbnRh
aW5lciBpbWFnZSBkYXRhIGFjcm9zcyBtdWx0aXBsZSBjb250YWluZXJzLgo+IAo+IFRoaXMgc29s
dXRpb24gZG9lc24ndCBldmVuIGFsbG93IHBhZ2UgY2FjaGUgc2hhcmluZyBiZXR3ZWVuIHNoYXJl
ZAo+IGxheWVycyAobGlrZSBjdXJyZW50IGNvbnRhaW5lcnMgZG8pLCBtdWNoIGxlc3MgYmV0d2Vl
biBpbmRlcGVuZGVudAo+IGxheWVycy4KPiAKPj4gVGhlcmUgaXMgYW4gYWN0aXZlIGRpc2N1c3Np
b24gYWJvdXQsIGFuZCBhY3RpdmUgZGV2ZWxvcG1lbnQgZWZmb3J0Cj4+IGZvciwgdXNpbmcgb3Zl
cmxheWZzICsgZXJvZnMgZm9yIGNvbnRhaW5lciBpbWFnZXMuICBJJ20gcmVsdWN0YW50IHRvCj4+
IG1lcmdlIHRoaXMgRE0gYmFzZWQgY29udGFpbmVyIGltYWdlIGFwcHJvYWNoIHdpdGhvdXQgd2lk
ZXIgY29uc2Vuc3VzCj4+IGZyb20gb3RoZXIgY29udGFpbmVyIHN0YWtlaG9sZGVycy4KPj4KPj4g
QnV0IHNob3J0IG9mIHJlYWNoaW5nIHdpZGVyIGNvbnNlbnN1cyBvbiB0aGUgbmVlZCBmb3IgdGhl
c2UgRE0KPj4gdGFyZ2V0czogdGhlcmUgaXMgbm90aGluZyBwcmV2ZW50aW5nIHlvdSBmcm9tIGNh
cnJ5aW5nIHRoZXNlIGNoYW5nZXMKPj4gaW4geW91ciBhbGliYWJhIGtlcm5lbC4KPiAKPiBFcm9m
cyBhbHJlYWR5IGhhcyBzb21lIGJsb2NrLWxldmVsIHN1cHBvcnQgZm9yIGNvbnRhaW5lciBpbWFn
ZXMgKHdpdGgKPiBueWR1cyksIGFuZCBjb21wb3NlZnMgd29ya3Mgd2l0aCBjdXJyZW50IGluLWtl
cm5lbCBFUk9GUytvdmVybGF5ZnMuCj4gQW5kIHRoaXMgbmV3IGFwcHJvYWNoIGRvZXNuJ3QgaGVs
cCBmb3IgdGhlIElNSE8gY3VycmVudCB3ZWFrIHNwb3Qgd2UKPiBoYXZlLCB3aGljaCBpcyB1bnBy
aXZpbGVnZWQgY29udGFpbmVyIGltYWdlcy4KPiAKPiBBbHNvLCB3aGlsZSBPQ0kgYXJ0aWZhY3Rz
IGNhbiBiZSB1c2VkIHRvIHN0b3JlIGFueSBraW5kIG9mIGltYWdlCj4gZm9ybWF0cyAob3IgYW55
IG90aGVyIGtpbmQgb2YgZmlsZSkgSSB0aGluayBmb3IgYW4gYWN0dWFsIHN0YW5kYXJkaXplZAo+
IG5ldyBpbWFnZSBmb3JtYXQgaXQgd291bGQgYmUgYmV0dGVyIHRvIHdvcmsgd2l0aCB0aGUgT0NJ
IG9yZyB0byBjb21lCj4gdXAgd2l0aCBhIE9DSSB2MiBzdGFuZGFyZCBpbWFnZSBmb3JtYXQuCgpB
Z3JlZWQsIEkgaG9wZSB5b3UgZ3V5cyBjb3VsZCBhY3R1YWxseSBzaXQgZG93biBhbmQgZXZhbHVh
dGUgYSBwcm9wZXIKc29sdXRpb24gb24gdGhlIG5leHQgT0NJIHYyLCBjdXJyZW50bHkgSSBrbm93
IHRoZXJlIGFyZToKCiAgLSBDb21wb3NlZnMKICAtIChlKXN0YXJneiAgIGh0dHBzOi8vZ2l0aHVi
LmNvbS9jb250YWluZXJkL3N0YXJnei1zbmFwc2hvdHRlcgogIC0gTnlkdXMgICAgICAgaHR0cHM6
Ly9naXRodWIuY29tL2NvbnRhaW5lcmQvbnlkdXMtc25hcHNob3R0ZXIKICAtIE92ZXJsYXlCRCAg
IGh0dHBzOi8vZ2l0aHViLmNvbS9jb250YWluZXJkL2FjY2VsZXJhdGVkLWNvbnRhaW5lci1pbWFn
ZQogIC0gU09DSSAgICAgICAgaHR0cHM6Ly9naXRodWIuY29tL2F3c2xhYnMvc29jaS1zbmFwc2hv
dHRlcgogIC0gVGFyZnMKICAtIChtYXliZSBldmVuIG1vcmUuLikKCkhvbmVzdGx5LCBJIGRvIHRo
aW5rIE9TVHJlZS9Db21wb3NlZnMgaXMgdGhlIGJlc3QgYXBwcm9hY2ggZm9yIG5vdyBmb3IKZGVk
dXBsaWNhdGlvbiBhbmQgcGFnZSBjYWNoZSBzaGFyaW5nIChkdWUgdG8ga2VybmVsIGxpbWl0YXRp
b24gb2YgcGFnZQpjYWNoZSBzaGFyaW5nIGFuZCBvdmVybGF5ZnMgY29weXVwIGxpbWl0YXRpb24p
LiAgSSdtIHRvbyB0aXJlZCBvZgpjb250YWluZXIgaW1hZ2Ugc3R1ZmZzIGhvbmVzdGx5LiAgVG9v
IG11Y2ggdW5uZWNlc3NhcnkgbWFucG93ZXIgd2FzdGUuCgpUaGFua3MsCkdhbyBYaWFuZwoKPiAK
PiBCdXQsIEkgZG9uJ3QgcmVhbGx5IHNwZWFrIGZvciB0aGUgYmxvY2sgbGF5ZXIgZGV2ZWxvcGVy
cywgc28gdGFrZSBteQo+IG9waW5pb25zIHdpdGggYSBwaW5jaCBvZiBzYWx0Lgo+IAoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

