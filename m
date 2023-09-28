Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C010BCE7B08
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695926867;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A5OmMUcX5VpK/sDxlsajE1FeAGzJ00ZjjilXCXpsxKw=;
	b=KcecXXedkZAfTQem2h6GjlREh4Hcow/IgkPk64k9cQyXk7G5BVXoN4PHgi9tKqimb9yi9V
	jnz/p9b4PHHiamH/jBwwZHsKm8VioQ90XwuZnzzrYoe6ppiXoXCAjqkMaRGDvz/ay22HhW
	fax8XExCQoHDtaIpGOqL/Ilp/2UE+B8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-nFycKf3uNbS_yXEWLFtzFA-1; Thu, 28 Sep 2023 14:47:45 -0400
X-MC-Unique: nFycKf3uNbS_yXEWLFtzFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B293101A58B;
	Thu, 28 Sep 2023 18:47:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 136E6C158BA;
	Thu, 28 Sep 2023 18:47:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDD361946588;
	Thu, 28 Sep 2023 18:47:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5FA461946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 18:46:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C1AB28FE; Thu, 28 Sep 2023 18:46:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43C6E170EC
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 18:46:06 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20E01185A797
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 18:46:06 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-O6YSEQtcN3e7X-DeQAYlmQ-1; Thu, 28 Sep 2023 14:46:04 -0400
X-MC-Unique: O6YSEQtcN3e7X-DeQAYlmQ-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by dfw.source.kernel.org (Postfix) with ESMTP id 28597618CA;
 Thu, 28 Sep 2023 18:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5058C433CA;
 Thu, 28 Sep 2023 18:46:02 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id
 2adb3069b0e04-5041bb9ce51so21108035e87.1; 
 Thu, 28 Sep 2023 11:46:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YxYr3yTVLuZ16wfO9JYdgnzO2f5zvdzGD/tuSxht9NMsW0l85DD
 WwQYO6WayyPh9EZ6Y/iQ9EuEVDvDdDTYcPkpcog=
X-Google-Smtp-Source: AGHT+IEP/A671di6lQEvr4rOqxf6W0ucETdxmobG5KsUclVSSm+4J94KeLxwDjY2OceTV/iDTvypyEilu52yJW74hMo=
X-Received: by 2002:a19:6557:0:b0:501:b8dc:6c45 with SMTP id
 c23-20020a196557000000b00501b8dc6c45mr1943815lfj.18.1695926760898; Thu, 28
 Sep 2023 11:46:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <20230928061543.1845742-4-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-4-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 28 Sep 2023 11:45:48 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4tQ9A+ddpxGhfza3WSdkL+FXmS-4NLUUN7MNk0TOY0WA@mail.gmail.com>
Message-ID: <CAPhsuW4tQ9A+ddpxGhfza3WSdkL+FXmS-4NLUUN7MNk0TOY0WA@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH -next v3 03/25] md: add new helpers to
 suspend/resume array
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBTZXAgMjcsIDIwMjMgYXQgMTE6MjLigK9QTSBZdSBLdWFpIDx5dWt1YWkxQGh1YXdl
aWNsb3VkLmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+
Cj4KPiBBZHZhbnRhZ2VzIGZvciBuZXcgYXBpczoKPiAgLSByZWNvbmZpZ19tdXRleCBpcyBub3Qg
cmVxdWlyZWQ7Cj4gIC0gdGhlIHdlaXJkIGxvZ2ljYWwgdGhhdCBzdXNwZW5kIGFycmF5IGhvbGQg
J3JlY29uZmlnX211dGV4JyBmb3IKPiAgICBtZGRldl9jaGVja19yZWNvdmVyeSgpIHRvIHVwZGF0
ZSBzdXBlcmJsb2NrIGlzIG5vdCBuZWVkZWQ7Cj4gIC0gdGhlIHNwZWNhaWwgaGFuZGxpbmcsICdw
ZXJzLT5wcmVwYXJlX3N1c3BlbmQnLCBmb3IgcmFpZDQ1NiBpcyBub3QKPiAgICBuZWVkZWQ7Cj4g
IC0gSXQncyBzYWZlIHRvIGJlIGNhbGxlZCBhdCBhbnkgdGltZSBvbmNlIG1kZGV2IGlzIGFsbG9j
YXRlZCwgYW5kIGl0J3MKPiAgICBkZXNpZ25lZCB0byBiZSB1c2VkIGZyb20gc2xvdyBwYXRoIHdo
ZXJlIGFycmF5IGNvbmZpZ3VyYXRpb24gaXMgY2hhbmdlZDsKPiAgLSB0aGUgbmV3IGhlbHBlcnMg
aXMgZGVzaWduZWQgdG8gYmUgY2FsbGVkIGJlZm9yZSBtZGRldl9sb2NrKCksIGhlbmNlCj4gICAg
aXQgc3VwcG9ydCB0byBiZSBpbnRlcnJ1cHRlZCBieSB1c2VyIGFzIHdlbGwuCj4KPiBTaWduZWQt
b2ZmLWJ5OiBZdSBLdWFpIDx5dWt1YWkzQGh1YXdlaS5jb20+Cj4gLS0tCj4gIGRyaXZlcnMvbWQv
bWQuYyB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0KPiAgZHJpdmVycy9tZC9tZC5oIHwgICAzICsrCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTAzIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9t
ZC5jIGIvZHJpdmVycy9tZC9tZC5jCj4gaW5kZXggZTQ2MGIzODAxNDNkLi5hMDc1ZDAzZDAzZDMg
MTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9tZC9tZC5jCj4gKysrIGIvZHJpdmVycy9tZC9tZC5jCj4g
QEAgLTQ0MywxMiArNDQzLDIyIEBAIHZvaWQgbWRkZXZfc3VzcGVuZChzdHJ1Y3QgbWRkZXYgKm1k
ZGV2KQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2tkZXBfaXNfaGVsZCgmbWRkZXYtPnJl
Y29uZmlnX211dGV4KSk7Cj4KPiAgICAgICAgIFdBUk5fT05fT05DRSh0aHJlYWQgJiYgY3VycmVu
dCA9PSB0aHJlYWQtPnRzayk7Cj4gLSAgICAgICBpZiAobWRkZXYtPnN1c3BlbmRlZCsrKQo+ICsK
PiArICAgICAgIC8qIGNhbid0IGNvbmN1cnJlbnQgd2l0aCBfX21kZGV2X3N1c3BlbmQoKSBhbmQg
X19tZGRldl9yZXN1bWUoKSAqLwo+ICsgICAgICAgbXV0ZXhfbG9jaygmbWRkZXYtPnN1c3BlbmRf
bXV0ZXgpOwo+ICsgICAgICAgaWYgKG1kZGV2LT5zdXNwZW5kZWQrKykgewo+ICsgICAgICAgICAg
ICAgICBtdXRleF91bmxvY2soJm1kZGV2LT5zdXNwZW5kX211dGV4KTsKPiAgICAgICAgICAgICAg
ICAgcmV0dXJuOwoKQ2FuIHdlIG1ha2UgbWRkZXYtPnN1c3BlbmRlZCBhdG9taWNfdCwgYW5kIHVz
ZSBhdG9taWNfaW5jX3JldHVybigpCmhlcmU/CgpUaGFua3MsClNvbmcKClsuLi5dCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

