Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AED4EB64DD
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 20:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690317858;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AfNpJlIEtiUVJl9nnp4UFexZU+jUIyTFQweXN80x6Rg=;
	b=DbzU//gLtmGUfDzjqPER1HmXUXVr+Ebgy8CDkBUV37yfx6biQwDC6sEtHAS+hYSyR9FyYQ
	mXC6FsOjCRSP3lZDwdCTBfMxemLl/Go253lgxU9j3PCClD32rREwf96ya3crFViHCfqIv1
	cfUaWcMDhskwaP56bWBSrtrfo9NaoIQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-5ZvvZWDqPbShvDJj5oyfbA-1; Tue, 25 Jul 2023 16:44:14 -0400
X-MC-Unique: 5ZvvZWDqPbShvDJj5oyfbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D08081C03D80;
	Tue, 25 Jul 2023 20:44:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22B51F783A;
	Tue, 25 Jul 2023 20:44:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C323619465B9;
	Tue, 25 Jul 2023 20:44:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C8F21946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Jul 2023 20:44:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2CFB1F7830; Tue, 25 Jul 2023 20:44:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2591EF7833
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 20:44:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01AFC28088AA
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 20:44:03 +0000 (UTC)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com
 [209.85.128.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-pqhEi2ZiMoGU7CxunfmSBg-1; Tue, 25 Jul 2023 16:44:00 -0400
X-MC-Unique: pqhEi2ZiMoGU7CxunfmSBg-1
Received: by mail-yw1-f180.google.com with SMTP id
 00721157ae682-583a8596e2aso48057157b3.1
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 13:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690317840; x=1690922640;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=nWFtInZ1K1dOfuS7k8qAbtMBBIEMrxLy4VGVUtC5gnI=;
 b=g9cYnxASQHEM286GwKmKy+M5Iq+IS+J+wwyx5BxBgMnes5SHrreR2O7+5gJnfPpAk/
 54u8NKfM3RBlZaNf6k8nCulXsY9bJmQ+QXIE0EfZAh8GGo+f1aonPlhS5Xmpcrx3ybm3
 NOa6mlnwiUBWeVZOuNZ514m0g0ZkzcBkEuz7z3pb2oKBobif90eUBFfdSTPD4DgNuht1
 f9Dlm7UvxzuID31WNaAI9IC4P/8LO+bfS1dXIG4rVt7m4MDoCDS8crMUtFMYmEMkhzAf
 aZ0CHOkFpw5i/oezVFNX0tt1bIyxhSIDsSlyhk/onQ3lhJLP1CWHtoX1jaRI9JbFzgjQ
 osjg==
X-Gm-Message-State: ABy/qLa2nw1ByxIjhjFg55uR6NNQzq+n46fQziiVZ1SJIbU1Cb0auU8t
 Rjvgnab9RzjvdVCZ+0qtqDyymX2YHIUyCK57gtDr
X-Google-Smtp-Source: APBJJlFkTo4MqIRboyJijfvAESH41Sn7XZLb7Wq1Qb4xbUmcbmJhG5qWNqiv1iYXWOFUlllWKuTA5JqszvfgcdQJA1g=
X-Received: by 2002:a25:2f16:0:b0:c83:27d4:c0d6 with SMTP id
 v22-20020a252f16000000b00c8327d4c0d6mr98124ybv.37.1690317839194; Tue, 25 Jul
 2023 13:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
 <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 25 Jul 2023 16:43:48 -0400
Message-ID: <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC PATCH v10 11/17] dm-verity: consume root hash
 digest and signature data via LSM hook
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdWwgMTEsIDIwMjMgYXQgMTE6NDPigK9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1p
Y3Jvc29mdC5jb20+IHdyb3RlOgo+IE9uIEZyaSwgSnVsIDA3LCAyMDIzIGF0IDEwOjUzOjQ1QU0g
LTA0MDAsIE1pa2UgU25pdHplciB3cm90ZToKCi4uLgoKPiA+IEJvdGggb2YgeW91ciBjYWxscyB0
byBzZWN1cml0eV9iZGV2X3NldHNlY3VyaXR5KCkgdG8gc2V0IHlvdXIgYmxvYnMgaW4KPiA+IHRo
ZSBiZGV2IGFyZSBzdXNwZWN0IGJlY2F1c2UgeW91J3JlIGRvaW5nIHNvIGZyb20gdGhlIHZlcml0
eV9jdHIoKS4KPiA+IFRoZSBtYXBwZWRfZGV2aWNlIGhhcyAyIGRtX3RhYmxlIHNsb3RzIChhY3Rp
dmUgYW5kIGluYWN0aXZlKS4gIFRoZQo+ID4gdmVyaXR5X2N0cigpIGJlY29tZXMgcGFydCBvZiB0
aGUgaW5hY3RpdmUgc2xvdCwgdGhlcmUgaXMgYW4gZXh0cmEgc3RlcAo+ID4gdG8gYmluZCB0aGUg
aW5hY3RpdmUgdGFibGUgdG8gdGhlIGFjdGl2ZSB0YWJsZS4KPiA+Cj4gPiBUaGlzIGxlYWRzIHRv
IHlvdSBjaGFuZ2luZyB0aGUgYmxvYnMgaW4gdGhlIGdsb2JhbCBiZGV2IF9iZWZvcmVfIHRoZQo+
ID4gdGFibGUgaXMgYWN0dWFsbHkgYWN0aXZlLiAgSXQgaXMgcG9zc2libGUgdGhhdCB0aGUgaW5h
Y3RpdmUgdGFibGUgd2lsbAo+ID4gc2ltcGx5IGJlIHJlbW92ZWQgYW5kIHRoZSBETSB2ZXJpdHkg
ZGV2aWNlIHB1dCBiYWNrIGluIHNlcnZpY2U7Cj4gPiBsZWF2aW5nIHlvdXIgYmxvYihzKSBpbiB0
aGUgYmRldiBpbmNvbnNpc3RlbnQuCj4gPgo+ID4gVGhpcyBpc3N1ZSBoYXMgcGFyYWxsZWxzIHRv
IGhvdyB3ZSBuZWVkIHRvIGRlZmVyIGNoYW5naW5nIHRoZSBnbG9iYWwKPiA+IHF1ZXVlX2xpbWl0
cyBhc3NvY2lhdGVkIHdpdGggYSByZXF1ZXN0X3F1ZXVlIHVudGlsIF9hZnRlcl8gYWxsIHRhYmxl
Cj4gPiBsb2FkaW5nIGlzIHNldHRsZWQgYW5kIHRoZW4gdGhlIHVwZGF0ZSBpcyBkb25lIGp1c3Qg
YmVmb3JlIHJlc3VtaW5nCj4gPiB0aGUgRE0gZGV2aWNlIChtYXBwZWRfZGV2aWNlKSAtLSBzZWUg
ZG1fdGFibGVfc2V0X3Jlc3RyaWN0aW9ucygpLgo+ID4KPiA+IFVuZm9ydHVuYXRlbHksIHRoaXMg
ZmVlbHMgbGlrZSBpdCBtYXkgcmVxdWlyZSBhIG5ldyBob29rIGluIHRoZQo+ID4gdGFyZ2V0X3R5
cGUgc3RydWN0IChlLmcuIC0+ZmluYWxpemUoKSkKPgo+IFRoYW5rcyBmb3IgcG9pbnRpbmcgb3V0
IHRoaXMgaXNzdWUuIFdlIHdlcmUgY2FsbGluZyBzZWN1cml0eV9iZGV2X3NldHNlY3VyaXR5KCkK
PiBiZWNhdXNlIHRoZSByb290aGFzaCBzaWduYXR1cmUgZGF0YSBpcyBvbmx5IGF2YWlsYWJsZSBp
biB2ZXJpdHlfY3RyKCkKPiBhbmQgaXQgaXMgZGlzY2FyZGVkIGFmdGVyIHZlcml0eV9jdHIoKSBm
aW5pc2hlcy4KPiBBZnRlciBkaWdnaW5nIGRlZXBlciBpbnRvIHRoZSB0YWJsZV9sb2FkLCBJIHJl
YWxpemVkIHRoYXQgd2Ugd2VyZSBpbmRlZWQKPiB3cm9uZyBoZXJlLgo+Cj4gQmFzZWQgb24gbXkg
dW5kZXJzdGFuZGluZyBvZiB5b3VyIHN1Z2dlc3Rpb24sIGl0IHNlZW1zIHRoYXQgdGhlIGNvcnJl
Y3QKPiBhcHByb2FjaCB3b3VsZCBiZSB0byBzYXZlIHRoZSByb290aGFzaCBzaWduYXR1cmUgaW50
byB0aGUgc3RydWN0IGRtX3RhcmdldAoKV291bGQgeW91IGJlIGRvaW5nIHRoaXMgd2l0aCBhIExT
TSBob29rLCBvciB3b3VsZCB0aGlzIGxpdmUgaW4gdGhlCmRldmljZSBtYXBwZXIgbGF5ZXI/Cgo+
IGFuZCB0aGVuIGludm9rZSBzZWN1cml0eV9iZGV2X3NldHNlY3VyaXR5KCkgYmVmb3JlIGFjdGl2
YXRpbmcKPiB0aGUgaW5hY3RpdmUgdGFibGUgaW4gdGhlIF9fYmluZCBmdW5jdGlvbiAod2hlcmUg
ZG1fdGFibGVfc2V0X3Jlc3RyaWN0aW9ucyBpcyBjYWxsZWQpLgo+Cj4gVG8gZmFjaWxpdGF0ZSB0
aGlzIHByb2Nlc3MsIGl0IHNlZW1zIGFwcHJvcHJpYXRlIHRvIGludHJvZHVjZSBhIG5ldyBob29r
Cj4gY2FsbGVkIGZpbmFsaXplKCkgd2l0aGluIHRoZSBzdHJ1Y3QgdGFyZ2V0X3R5cGUuIFRoaXMg
aG9vayB3b3VsZCBlbmFibGUKPiB0YXJnZXRzIHRvIGRlZmluZSB0YXNrcyB0aGF0IG5lZWQgdG8g
YmUgY29tcGxldGVkIGJlZm9yZSBhY3RpdmF0aW5nCj4gYSBuZXcgdGFibGUuCj4KPiBJbiBvdXIg
c3BlY2lmaWMgY2FzZSwgd2Ugd291bGQgYWRkIGEgZmluYWxpemUgaG9vayB0byB0aGUgZG0tdmVy
aXR5IG1vZHVsZSwKPiBhbGxvd2luZyB1cyB0byBjYWxsIHNlY3VyaXR5X2JkZXZfc2V0c2VjdXJp
dHkoKSBhbmQgYXNzb2NpYXRlIHRoZSByb290aGFzaAo+IGluZm9ybWF0aW9uIGluIHRoZSBzdHJ1
Y3QgZG1fdGFyZ2V0IHdpdGggdGhlIHN0cnVjdCBibG9ja19kZXZpY2Ugb2YKPiB0aGUgc3RydWN0
IG1hcHBlZF9kZXZpY2UuIElzIHRoaXMgY29ycmVjdD8KCldoZXJlIHdvdWxkIHRoZSBmaW5hbGl6
ZSgpIGhvb2sgYmUgY2FsbGVkPwoKLS0gCnBhdWwtbW9vcmUuY29tCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9t
YWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

