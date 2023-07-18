Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAC1EB64DA
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jul 2023 07:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689750200;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DL88Gzhj8PIBhY554uTO0X4ejF1xZxr/o2u7IlJV6zc=;
	b=A33LILK+kizfdRGw5OAEjni1aY6bHxRE4vSv+NEWoOSzwEVhZSzTTWF57x6RhRtPu9yHj8
	/8ShzrXXPW44XWNsPoP4EyKYLvVpYsREQgXr/NitfMZh6XxXChavOBf0aPH3zrR25YsRIz
	39Yo1//G4B75VHphmrBqJg7MZ96aOt4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-wGpTGlFbNSqLGTx2e0Cpng-1; Wed, 19 Jul 2023 03:03:16 -0400
X-MC-Unique: wGpTGlFbNSqLGTx2e0Cpng-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0B63101A528;
	Wed, 19 Jul 2023 07:03:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9C794CD0FE;
	Wed, 19 Jul 2023 07:03:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFE6B1946597;
	Wed, 19 Jul 2023 07:03:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A57A194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Jul 2023 13:05:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DE7B1454143; Tue, 18 Jul 2023 13:04:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 246211454142
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 13:04:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08D218D1697
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 13:04:59 +0000 (UTC)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com
 [209.85.128.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-clbjATSdO-GcbaYjNSE-JQ-1; Tue, 18 Jul 2023 09:04:56 -0400
X-MC-Unique: clbjATSdO-GcbaYjNSE-JQ-1
Received: by mail-yw1-f179.google.com with SMTP id
 00721157ae682-570877f7838so61358837b3.0
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 06:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689685496; x=1692277496;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :references:in-reply-to:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=RUFE4zZGrAvUM/BoEy+41CZw289243/LNIISiR4wdq4=;
 b=HsNdlLLafTnmOKdjLhMh/E/S2Bf9JIixHuE7vQZ/BzzOFIqTGukfuhCf6AufW1Q4g7
 HL+jMss2JccF5TlftgTyQCBor/Col1umR0L+CYukh4uqe4NokmsKPdnuf7Xnhj9DPHrA
 3Chg0t30dl3IIWAkVOGslL35s7gzI9nkx/TwBaEGZBtwZ/O9Z+/89rfJWxRvbM38tgwL
 /dwPKEQYdBMBUqMhuAOSJK6woOGMJ84GucUTpNYWUXB5IsZvdgSEyZlKAlttuSva+Px9
 Aw60WzF5ZbyVq1rYy87IPDVHNIhR2XLsSZSCMwrojtFQLJunH6H/0Uriwj1+rMSpQ/yH
 Az5A==
X-Gm-Message-State: ABy/qLbNcQ2/cDq7cc1eEiygYagd0Ko0f2PlgWiXL2PCVbeua2+mMMMt
 AcjEjB9/zhHSYgLp/4ENVaPhhc6GtB2EYyjCQuHSfk5ybzQ=
X-Google-Smtp-Source: APBJJlGo6r2SOc2GWzwcOvHjYk8wrh3BVeiVaUH0xXbdA4eoxfhuOLsOeaiAyVyyQi2q8eduXr015bWDuZB5Lt4rRQ0=
X-Received: by 2002:a81:638b:0:b0:57a:75b8:b790 with SMTP id
 x133-20020a81638b000000b0057a75b8b790mr18662345ywb.29.1689685496085; Tue, 18
 Jul 2023 06:04:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:7886:b0:31a:16:342c with HTTP; Tue, 18 Jul 2023
 06:04:55 -0700 (PDT)
In-Reply-To: <CAEYzJUGC8Yj1dQGsLADT+pB-mkac0TAC-typAORtX7SQ1kVt+g@mail.gmail.com>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTU=WsTaSowjkKT-snuvZwqWqnH3cdgGoCkToH02qEkgg@mail.gmail.com>
 <20230718053017.GB6042@tomerius.de>
 <CAEYzJUGC8Yj1dQGsLADT+pB-mkac0TAC-typAORtX7SQ1kVt+g@mail.gmail.com>
From: "Alan C. Assis" <acassis@gmail.com>
Date: Tue, 18 Jul 2023 10:04:55 -0300
Message-ID: <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
To: =?UTF-8?Q?Bj=C3=B8rn_Forsman?= <bjorn.forsman@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 19 Jul 2023 07:03:10 +0000
Subject: Re: [dm-devel] File system robustness
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
Cc: dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 linux-embedded@vger.kernel.org, Kai Tomerius <kai@tomerius.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQmrDuHJuLAoKT24gNy8xOC8yMywgQmrDuHJuIEZvcnNtYW4gPGJqb3JuLmZvcnNtYW5AZ21h
aWwuY29tPiB3cm90ZToKPiBPbiBUdWUsIDE4IEp1bCAyMDIzIGF0IDA4OjAzLCBLYWkgVG9tZXJp
dXMgPGthaUB0b21lcml1cy5kZT4gd3JvdGU6Cj4+IEkgc2hvdWxkIGhhdmUgbWVudGlvbmVkIHRo
YXQgSSdsbCBoYXZlIGEgbGFyZ2UgTkFORCBmbGFzaCwgc28gZXh0NAo+PiBtaWdodCBzdGlsbCBi
ZSB0aGUgZmlsZSBzeXN0ZW0gb2YgY2hvaWNlLiBUaGUgb3RoZXIgb25lcyB5b3UgbWVudGlvbmVk
Cj4+IGFyZSBpbnRlcmVzdGluZyB0byBjb25zaWRlciwgYnV0IHNlZW0gdG8gYmUgbW9yZSBmaXR0
aW5nIGZvciBhIHNtYWxsZXIKPj4gTk9SIGZsYXNoLgo+Cj4gSWYgeW91IG1lYW4gcmF3IE5BTkQg
Zmxhc2ggSSB3b3VsZCB0aGluayBVQklGUyBpcyBzdGlsbCB0aGUgd2F5IHRvIGdvPwo+IChJdCdz
IGJlZW4gc2V2ZXJhbCB5ZWFycyBzaW5jZSBJIHdhcyBpbnRvIGVtYmVkZGVkIExpbnV4IHN5c3Rl
bXMuKQo+Cj4gaHR0cHM6Ly9lbGludXgub3JnL2ltYWdlcy8wLzAyL0ZpbGVzeXN0ZW1fQ29uc2lk
ZXJhdGlvbnNfZm9yX0VtYmVkZGVkX0RldmljZXMucGRmCj4gaXMgZm9jdXNlZCBvbiBlTU1DL1NE
IENhcmRzLCB3aGljaCBoYXZlIGJ1aWx0LWluIGNvbnRyb2xsZXJzIHRoYXQKPiBlbmFibGUgdGhl
bSB0byBwcmVzZW50IGEgYmxvY2sgZGV2aWNlIGludGVyZmFjZSwgd2hpY2ggaXMgdmVyeSB1bmxp
a2UKPiB3aGF0IHJhdyBOQU5EIGRldmljZXMgaGF2ZS4KPgo+IFBsZWFzZSBzZWUgaHR0cHM6Ly93
d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvZmlsZXN5c3RlbXMvdWJpZnMuaHRtbAo+IGZv
ciBtb3JlIGluZm8uCj4KCllvdSBhcmUgcmlnaHQsIGZvciBOQU5EIHRoZXJlIGlzIGFuIG9sZCAo
YnV0IGdvbGQpIHByZXNlbnRhdGlvbiBoZXJlOgoKaHR0cHM6Ly9lbGludXgub3JnL2ltYWdlcy83
LzdlL0VMQzIwMDktRmxhc2hGUy1Ub3NoaWJhLnBkZgoKVUJJRlMgYW5kIFlBRkZTMiBhcmUgdGhl
IHdheSB0byBnby4KCkJ1dCBwbGVhc2Ugbm90ZSB0aGF0IFlBRkZTMiBuZWVkcyBsaWNlbnNlIHBh
eW1lbnQgZm9yIGNvbW1lcmNpYWwKYXBwbGljYXRpb24gKHNvbWV0aGluZyB0aGF0IEkgb25seSBk
aXNjb3ZlcmVkIHJlY2VudGx5IHdoZW4gWGlhb21pCmludGVncmF0ZWQgaXQgaW50byBOdXR0WCBt
YWlubGluZSwgYmFkIHN1cnByaXNlKS4KCkJSLAoKQWxhbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

