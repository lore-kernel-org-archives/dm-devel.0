Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6D6C04ABF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695230981;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nL2ZLonWzKQNWx52Ruz380bukhrzc33j/crArI6oeBI=;
	b=O+iEk93CI3GIcraG7ufuHU06QBDmmPTIUjkmQ6UtCfMvsQv29rdl5bNzM9ZCBNXcHimrhS
	e2mtr82fKMBS2yYeCABtplhR8FaHcPhQ+Wret162RLvbH3kyr6cwjxBMlC0JuMZuxHUuJd
	i9yum2+ePZMagh80AZGs/dK/YCYcuzY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-nXDqDk4DMnmcJg2EK2FH-w-1; Wed, 20 Sep 2023 13:29:38 -0400
X-MC-Unique: nXDqDk4DMnmcJg2EK2FH-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31CC3858F1C;
	Wed, 20 Sep 2023 17:29:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA1872026D37;
	Wed, 20 Sep 2023 17:29:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6915319465B7;
	Wed, 20 Sep 2023 17:29:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8237A194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 14:36:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 514E9711282; Wed, 20 Sep 2023 14:36:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49C2D492B16
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 14:36:02 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D543811E8F
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 14:36:02 +0000 (UTC)
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-W5h3GagYNZGZ30BTIy5vzQ-1; Wed, 20 Sep 2023 10:36:00 -0400
X-MC-Unique: W5h3GagYNZGZ30BTIy5vzQ-1
Received: from localhost (unknown [10.10.165.8])
 by mail.ispras.ru (Postfix) with ESMTPSA id 76EFF40F1DD2;
 Wed, 20 Sep 2023 14:35:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 76EFF40F1DD2
Date: Wed, 20 Sep 2023 17:35:56 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <vdtvo2av3upya6mugjyiqo2hfnn6q4dpofoku6rvrtgmycgbrp@scpcnu3ta7ch>
References: <20230920105119.21276-1-pchelkin@ispras.ru>
 <c7818967-1fea-45da-9713-20de4bcb1c44@suse.de>
MIME-Version: 1.0
In-Reply-To: <c7818967-1fea-45da-9713-20de4bcb1c44@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 20 Sep 2023 17:22:20 +0000
Subject: Re: [dm-devel] [PATCH] dm-zoned: free dmz->ddev array in
 dmz_put_zoned_device
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
Cc: lvc-project@linuxtesting.org, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Alexey Khoroshilov <khoroshilov@ispras.ru>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ispras.ru
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjMvMDkvMjAgMDQ6MDZQTSwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+IE9uIDkvMjAvMjMg
MTI6NTEsIEZlZG9yIFBjaGVsa2luIHdyb3RlOgo+ID4gQ29tbWl0IDRkYmExMjg4MWY4OCAoImRt
IHpvbmVkOiBzdXBwb3J0IGFyYml0cmFyeSBudW1iZXIgb2YgZGV2aWNlcyIpCj4gPiBtYWRlIHRo
ZSBwb2ludGVycyB0byBhZGRpdGlvbmFsIHpvbmVkIGRldmljZXMgdG8gYmUgc3RvcmVkIGluIGEK
PiA+IGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBkbXotPmRkZXYgYXJyYXkuIEhvd2V2ZXIsIHRoaXMg
YXJyYXkgaXMgbm90IGZyZWVkLgo+ID4gCj4gPiBGcmVlIGl0IHdoZW4gY2xlYW5pbmcgdXAgem9u
ZWQgZGV2aWNlIGluZm9ybWF0aW9uIGluc2lkZQo+ID4gZG16X3B1dF96b25lZF9kZXZpY2UoKS4g
QXNzaWduaW5nIE5VTEwgdG8gZG16LT5kZGV2IGVsZW1lbnRzIGRvZXNuJ3QgbWFrZQo+ID4gc2Vu
c2UgdGhlcmUgYXMgdGhleSBhcmUgbm90IHN1cHBvc2VkIHRvIGJlIHJldXNlZCBsYXRlciBhbmQg
dGhlIHdob2xlIGRtego+ID4gdGFyZ2V0IHN0cnVjdHVyZSBpcyBiZWluZyBjbGVhbmVkIGFueXdh
eS4KPiA+IAo+ID4gRm91bmQgYnkgTGludXggVmVyaWZpY2F0aW9uIENlbnRlciAobGludXh0ZXN0
aW5nLm9yZykuCj4gPiAKPiA+IEZpeGVzOiA0ZGJhMTI4ODFmODggKCJkbSB6b25lZDogc3VwcG9y
dCBhcmJpdHJhcnkgbnVtYmVyIG9mIGRldmljZXMiKQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcKPiA+IFNpZ25lZC1vZmYtYnk6IEZlZG9yIFBjaGVsa2luIDxwY2hlbGtpbkBpc3ByYXMu
cnU+Cj4gPiAtLS0KPiA+ICAgZHJpdmVycy9tZC9kbS16b25lZC10YXJnZXQuYyB8IDggKysrLS0t
LS0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkK
PiA+IAo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMgYi9kcml2
ZXJzL21kL2RtLXpvbmVkLXRhcmdldC5jCj4gPiBpbmRleCBhZDhlNjcwYTJmOWIuLmUyNWNkOWRi
NjI3NSAxMDA2NDQKPiA+IC0tLSBhL2RyaXZlcnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMKPiA+ICsr
KyBiL2RyaXZlcnMvbWQvZG0tem9uZWQtdGFyZ2V0LmMKPiA+IEBAIC03NTMsMTIgKzc1MywxMCBA
QCBzdGF0aWMgdm9pZCBkbXpfcHV0X3pvbmVkX2RldmljZShzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSkK
PiA+ICAgCXN0cnVjdCBkbXpfdGFyZ2V0ICpkbXogPSB0aS0+cHJpdmF0ZTsKPiA+ICAgCWludCBp
Owo+ID4gLQlmb3IgKGkgPSAwOyBpIDwgZG16LT5ucl9kZGV2czsgaSsrKSB7Cj4gPiAtCQlpZiAo
ZG16LT5kZGV2W2ldKSB7Cj4gPiArCWZvciAoaSA9IDA7IGkgPCBkbXotPm5yX2RkZXZzOyBpKysp
Cj4gPiArCQlpZiAoZG16LT5kZGV2W2ldKQo+ID4gICAJCQlkbV9wdXRfZGV2aWNlKHRpLCBkbXot
PmRkZXZbaV0pOwo+ID4gLQkJCWRtei0+ZGRldltpXSA9IE5VTEw7Cj4gPiAtCQl9Cj4gPiAtCX0K
PiA+ICsJa2ZyZWUoZG16LT5kZGV2KTsKPiA+ICAgfQo+ID4gICBzdGF0aWMgaW50IGRtel9maXh1
cF9kZXZpY2VzKHN0cnVjdCBkbV90YXJnZXQgKnRpKQo+IAo+IEhtbS4gSSdtIG5vdCB0aGF0IGhh
cHB5IHdpdGggaXQ7IGRtel9wdXRfem9uZWRfZGV2aWNlKCkgaXMgdXNpbmcgZG1fdGFyZ2V0Cj4g
YXMgYW4gYXJndW1lbnQsIHdoZXJlYXMgYWxsIG9mIHRoZSBmdW5jdGlvbnMgc3Vycm91bmRpbmcg
dGhlIGNhbGwgc2l0ZXMgaXMKPiB1c2luZyB0aGUgZG16X3RhcmdldCBkaXJlY3RseS4KPiAKPiBN
aW5kIHRvIG1vZGlmeSB0aGUgZnVuY3Rpb24gdG8gdXNlICdzdHJ1Y3QgZG16X3RhcmdldCcgYXMg
YW4gYXJndW1lbnQ/CgpkbV90YXJnZXQgaXMgcmVxdWlyZWQgaW5zaWRlIGRtel9wdXRfem9uZWRf
ZGV2aWNlKCkgZm9yIGRtX3B1dF9kZXZpY2UoKQpjYWxscy4gSSBjYW4ndCBzZWUgYSB3YXkgZm9y
IHJlZmVyZW5jaW5nIGl0IHZpYSBkbXpfdGFyZ2V0LiBEbyB5b3UgbWVhbgpwYXNzaW5nIGFkZGl0
aW9uYWwgc2Vjb25kIGFyZ3VtZW50IGxpa2UKICBkbXpfcHV0X3pvbmVkX2RldmljZShzdHJ1Y3Qg
ZG16X3RhcmdldCAqZG16LCBzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSkgPwoKQlRXLCBJIGFsc28gdGhp
bmsgaXQgY2FuIGJlIHJlbmFtZWQgdG8gZG16X3B1dF96b25lZF9kZXZpY2VzKCkuCgo+IAo+IENo
ZWVycywKPiAKPiBIYW5uZXMKPiAtLSAKPiBEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAg
ICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdAo+IGhhcmVAc3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4Cj4gU1VTRSBTb2Z0d2FyZSBTb2x1dGlv
bnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCj4gSFJCIDM2ODA5IChBRyBO
w7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKPiBNeWVycywg
QW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCj4gCgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

