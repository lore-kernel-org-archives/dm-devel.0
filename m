Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A18C7EB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687474508;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V6aBF0lIrNbYBK3hH/aQ4+zsQSY8xPsP7S7z3KI7+Fc=;
	b=HWmVBf0a/C2aQvZYlSMjqx5aFGSMNPOp29vHTzKKAgVj8cTZBF9ZYN3JApjowzW/jB8EJY
	7FfrgRT8wahrpj0HPHVk5y9eWO6IK7fnrE/dnC/UrUy07Z6ZCC2cuN+YouIlUdrTBJcf4E
	mm9HgjNH+TVH1ajo74GuxNnHxqbJ+as=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-Ib3vmQ2BMemsIFomznaBwQ-1; Thu, 22 Jun 2023 18:55:06 -0400
X-MC-Unique: Ib3vmQ2BMemsIFomznaBwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FA0680027F;
	Thu, 22 Jun 2023 22:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FD7114682F7;
	Thu, 22 Jun 2023 22:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E0161946588;
	Thu, 22 Jun 2023 22:55:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 685671946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 22:55:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B27D425358; Thu, 22 Jun 2023 22:55:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3449040D1A4
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 22:55:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72C9D18E525C
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 22:55:01 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-UkpWGg1wMWyNWviwrsMqlQ-1; Thu, 22 Jun 2023 18:54:58 -0400
X-MC-Unique: UkpWGg1wMWyNWviwrsMqlQ-1
Received: by mail-qt1-f175.google.com with SMTP id
 d75a77b69052e-3f9e9e9d06fso6075231cf.0
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 15:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687474497; x=1690066497;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Hxwe4U/gR1Uh57JJuryfGWiZL12pc/O1PR213FsnSzs=;
 b=Z236Hjol21AIjvWHO6AqnY5xMjYKFA9jsKbj9Vuo+p8GB4HhhN2/tgzYiK8woce+Op
 u5A4ZJzi+UTDkE8lEfthjdLg6VJAT5NmhdZTKVoBjlOq+JgReET9tRXR71Q5EBoGnA5e
 l9n0/SkYXzvI50B2+r8SsMFsKvvXUn979ldqsB8y7B73I0vCgmnDKNjozfURiAuDgA+o
 Wcl12AU9FeQx3QKkbwRNwVqR3j01XxbW5cS6j3o+jla9sbTWet9lLwoyXst1AtSkRGW/
 63lq/GXi8X0+VjGEZTmCwIxZ/g/kQ2rrMWJTCJPWYwRMSCIWxTBDwh2MAC6trXYjGS8X
 wVNg==
X-Gm-Message-State: AC+VfDzV+7GS6tS9qXTxq3kYgkbbXnbs8v0K3/yS2fw2469FBhfgIsO3
 PdSXN66joHyMFS5BWVekeiJQsFg=
X-Google-Smtp-Source: ACHHUZ79bSHFD7FD+XGavRP6t/FT+fV0G63ZVlm9T0OEFJddU4uSU8havX2f8kv9D7oKLAm5A2IhIA==
X-Received: by 2002:ad4:5caf:0:b0:621:54d:23e1 with SMTP id
 q15-20020ad45caf000000b00621054d23e1mr29689752qvh.14.1687474497526; 
 Thu, 22 Jun 2023 15:54:57 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 p18-20020a0ccb92000000b00621268e14efsm4352272qvk.55.2023.06.22.15.54.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 15:54:57 -0700 (PDT)
Date: Thu, 22 Jun 2023 18:54:56 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZJTRQP1XqlQAC2Xb@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-2-demi@invisiblethingslab.com>
 <ZJR2rGZw0Ddf3TFK@redhat.com> <ZJSmYgvwoSY6Gb4f@itl-email>
MIME-Version: 1.0
In-Reply-To: <ZJSmYgvwoSY6Gb4f@itl-email>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 1/6] device-mapper: Check that target
 specs are sufficiently aligned
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdW4gMjIgMjAyMyBhdCAgMzo1MVAgLTA0MDAsCkRlbWkgTWFyaWUgT2Jlbm91ciA8
ZGVtaUBpbnZpc2libGV0aGluZ3NsYWIuY29tPiB3cm90ZToKCj4gT24gVGh1LCBKdW4gMjIsIDIw
MjMgYXQgMTI6Mjg6MjhQTSAtMDQwMCwgTWlrZSBTbml0emVyIHdyb3RlOgo+ID4gT24gU2F0LCBK
dW4gMDMgMjAyMyBhdCAxMDo1MlAgLTA0MDAsCj4gPiBEZW1pIE1hcmllIE9iZW5vdXIgPGRlbWlA
aW52aXNpYmxldGhpbmdzbGFiLmNvbT4gd3JvdGU6Cj4gPiAKPiA+ID4gT3RoZXJ3aXNlIHN1YnNl
cXVlbnQgY29kZSB3aWxsIGRlcmVmZXJlbmNlIGEgbWlzYWxpZ25lZAo+ID4gPiBgc3RydWN0IGRt
X3RhcmdldF9zcGVjICpgLCB3aGljaCBpcyB1bmRlZmluZWQgYmVoYXZpb3IuCj4gPiA+IAo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBEZW1pIE1hcmllIE9iZW5vdXIgPGRlbWlAaW52aXNpYmxldGhpbmdz
bGFiLmNvbT4KPiA+ID4gRml4ZXM6IDFkYTE3N2U0YzNmNCAoIkxpbnV4LTIuNi4xMi1yYzIiKQo+
ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwo+ID4gPiAtLS0KPiA+ID4gIGRyaXZlcnMv
bWQvZG0taW9jdGwuYyB8IDcgKysrKysrKwo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKQo+ID4gPiAKPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0taW9jdGwuYyBi
L2RyaXZlcnMvbWQvZG0taW9jdGwuYwo+ID4gPiBpbmRleCBjYzc3Y2YzZDQxMDkyMTQzMmViMGM2
MmNkZWRlN2Q1NWI5YWE2NzRhLi4zNGZhNzRjNmE3MGRiOGFhNjdhYWJhM2Y2YTJmYzRmMzhlZjcz
NmJjIDEwMDY0NAo+ID4gPiAtLS0gYS9kcml2ZXJzL21kL2RtLWlvY3RsLmMKPiA+ID4gKysrIGIv
ZHJpdmVycy9tZC9kbS1pb2N0bC5jCj4gPiA+IEBAIC0xMzk0LDYgKzEzOTQsMTMgQEAgc3RhdGlj
IGlubGluZSBmbW9kZV90IGdldF9tb2RlKHN0cnVjdCBkbV9pb2N0bCAqcGFyYW0pCj4gPiA+ICBz
dGF0aWMgaW50IG5leHRfdGFyZ2V0KHN0cnVjdCBkbV90YXJnZXRfc3BlYyAqbGFzdCwgdWludDMy
X3QgbmV4dCwgdm9pZCAqZW5kLAo+ID4gPiAgCQkgICAgICAgc3RydWN0IGRtX3RhcmdldF9zcGVj
ICoqc3BlYywgY2hhciAqKnRhcmdldF9wYXJhbXMpCj4gPiA+ICB7Cj4gPiA+ICsJc3RhdGljX2Fz
c2VydChfQWxpZ25vZihzdHJ1Y3QgZG1fdGFyZ2V0X3NwZWMpIDw9IDgsCj4gPiA+ICsJCSAgICAg
ICJzdHJ1Y3QgZG1fdGFyZ2V0X3NwZWMgaGFzIGV4Y2Vzc2l2ZSBhbGlnbm1lbnQgcmVxdWlyZW1l
bnRzIik7Cj4gPiAKPiA+IFJlYWxseSBub3Qgc3VyZSB3aGF0IHlvdSBtZWFuIGJ5ICJoYXMgZXhj
ZXNzaXZlIGFsaWdubWVudCByZXF1aXJlbWVudHMiLi4uCj4gCj4gVGhpcyBwYXRjaCBjaGVja3Mg
dGhhdCBzdHJ1Y3QgZG1fdGFyZ2V0X3NwZWMgaXMgOC1ieXRlIGFsaWduZWQuICBUaGF0IGlzCj4g
b2theSBpZiBpdHMgYWxpZ25tZW50IGlzIDggb3IgbGVzcywgYnV0IG5vdCBpZiBpcyAxNiBvciBt
b3JlLCBzbyBJIGFkZGVkCj4gYSBzdGF0aWMgYXNzZXJ0IHRvIGNoZWNrIHRoYXQgc3RydWN0IGRt
X3RhcmdldF9zcGVjIGluZGVlZCByZXF1aXJlcyBhdAo+IG1vc3QgOC1ieXRlIGFsaWdubWVudC4g
IFRoYXQgc2FpZCwg4oCcZXhjZXNzaXZlIGFsaWdubWVudCByZXF1aXJlbWVudHPigJ0gaXMKPiAo
YXMgc2hvd24gYnkgeW91IGhhdmluZyB0byBhc2sgdGhpcyBxdWVzdGlvbikgYSBiYWQgZXJyb3Ig
bWVzc2FnZS4KPiBXb3VsZCDigJxtdXN0IG5vdCByZXF1aXJlIG1vcmUgdGhhbiA4LWJ5dGUgYWxp
Z25tZW504oCdIGJlIGJldHRlcj8KClllcywgdGhhdCdzIGJldHRlciwgSSd2ZSB1cGRhdGVkIGl0
IHRvIHVzZSB0aGF0LgogCj4gPiA+ICsJaWYgKG5leHQgJSA4KSB7Cj4gPiA+ICsJCURNRVJSKCJO
ZXh0IHRhcmdldCBzcGVjIChvZmZzZXQgJXUpIGlzIG5vdCA4LWJ5dGUgYWxpZ25lZCIsIG5leHQp
Owo+ID4gPiArCQlyZXR1cm4gLUVJTlZBTDsKPiA+ID4gKwl9Cj4gPiA+ICsKPiA+ID4gIAkqc3Bl
YyA9IChzdHJ1Y3QgZG1fdGFyZ2V0X3NwZWMgKikgKCh1bnNpZ25lZCBjaGFyICopIGxhc3QgKyBu
ZXh0KTsKPiA+ID4gIAkqdGFyZ2V0X3BhcmFtcyA9IChjaGFyICopICgqc3BlYyArIDEpOwo+ID4g
PiAgCj4gPiAKPiA+IEJ1dCB0aGlzIHBhdGNoIGFuZCBwYXRjaGVzIDIgYW5kIDMgbmVlZCBtb3Jl
IHJldmlldy4gSSdkIGxpa2UgTWlrdWxhcyB0byByZXZpZXcuCj4gPiAKPiA+IEkgZGlkIHBpY2sg
dXAgcGF0Y2hlcyA0LTYgZm9yIHRoZSB1cGNvbWluZyA2LjUgbWVyZ2Ugd2luZG93Lgo+IAo+IFRo
YW5rcyEKPiAKPiA+IE5vdGUsIHBsZWFzZSBwcmVmaXggd2l0aCAiZG0gaW9jdGwiIGluc3RlYWQg
b2YgImRldmljZS1tYXBwZXIiLgo+IAo+IEdvb2QgdG8ga25vdywgdGhhbmtzISAgSSBoYXZlIHNl
dmVyYWwgYWRkaXRpb25hbCBwYXRjaGVzIHdyaXR0ZW4gdGhhdAo+IHJlcXVpcmUgcGF0Y2ggNC4g
IFNob3VsZCBJIHNlbmQgcGF0Y2hlcyAxIHRocm91Z2ggMyBpbiB0aGUgc2FtZSBzZXJpZXMKPiBh
cyB3ZWxsPwoKSSBkaWQgZW5kIHVwIHBpY2tpbmcgdXAgcGF0Y2hlcyAxLTMgYW5kIHJlYmFzZWQg
c28gdGhleSBhcmUgaW4gZnJvbnQKb2YgeW91ciBwYXRjaGVzIDQtNiBsaWtlIHlvdSBpbnRlbmRl
ZC4KCkJ1dCBJIGFncmVlIHdpdGggTWlrdWxhcywgSSdtIG5vdCBzZWVpbmcgdGhlIHBvaW50IGlu
IHRhZ2dpbmcgYW55IG9mCnRoZXNlIGZvciBzdGFibGVALgoKQWxsIGNvbW1pdHMgYXJlIGN1cnJl
bnRseSBhdCB0aGUgdGlwIG9mIGRtLTYuNSwgc2VlOgpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9kZXZpY2UtbWFwcGVyL2xpbnV4LWRtLmdpdC9sb2cvP2g9
ZG0tNi41CgpNaWtlCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

