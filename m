Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA8DC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 15 May 2022 13:16:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-5qKM8qMDPeG4AUqevlN_Fg-1; Sun, 15 May 2022 09:16:40 -0400
X-MC-Unique: 5qKM8qMDPeG4AUqevlN_Fg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8060B1C05AE5;
	Sun, 15 May 2022 13:16:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 32409463DFD;
	Sun, 15 May 2022 13:16:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D998719451F0;
	Sun, 15 May 2022 13:16:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2AB9194705B
 for <dm-devel@listman.corp.redhat.com>; Sun, 15 May 2022 13:16:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4E2C1544F37; Sun, 15 May 2022 13:16:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0C3C1544F36
 for <dm-devel@redhat.com>; Sun, 15 May 2022 13:16:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C91923C021A4
 for <dm-devel@redhat.com>; Sun, 15 May 2022 13:16:36 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-LbR_UVhoMoWhizcuuczPHQ-1; Sun, 15 May 2022 09:16:35 -0400
X-MC-Unique: LbR_UVhoMoWhizcuuczPHQ-1
Received: by mail-wr1-f45.google.com with SMTP id f2so10243814wrc.0;
 Sun, 15 May 2022 06:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=a2QT4yj58XGQFBLftNQSpTn2wUgKZTfUn1XsrTzwetM=;
 b=EVyIMIaNr+FobTJh0Tfotdh4hhkod89gaqpHMJiGNhw/c0R1uO6qI/ZgCd5ibwtqFE
 Kc9x0y6caEO0asIYeONONi7j/xyUYewdughy/mSJLiFhI1dMas3ses5VFziyaL8KZ1XF
 L1KFdlcrrjTwgqSseHr+xzGZJCS7ZRbEpJu2iwoS33eCc58Uz9coFUH2R7YyV6miEtuF
 2DfZLIH0oGaHsKkVWVADCYXRC+oHZlsTKBbh8kkFbr2TY3V3N2IkHW//N3qbWXTo3Fu7
 hKmOwkIWa0oOEFA/CcqXPqyCnUR8ptTzcKK+bgg5BrzumWDBCXT/LOyija6OigxT4//J
 FJCw==
X-Gm-Message-State: AOAM533froM4OsX5xiYLsDKtNPxsisjk+bSPfR4aRKmQ31UtIqKtplFQ
 +GE3kjy/1w4ekA4zxSGA6bWwzmM31JZA
X-Google-Smtp-Source: ABdhPJwa3CGZGcbLnpY2FMw+KOyDlMQOxnaFH5EEvMELzTXYnWkX6BIkhzyXTq0B6YsQYSlgLVMW6Q==
X-Received: by 2002:a5d:5249:0:b0:20c:fdae:75d5 with SMTP id
 k9-20020a5d5249000000b0020cfdae75d5mr5389383wrc.305.1652620593569; 
 Sun, 15 May 2022 06:16:33 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 x13-20020a7bc20d000000b0039429bfebebsm12029345wmi.3.2022.05.15.06.16.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 15 May 2022 06:16:33 -0700 (PDT)
Message-ID: <d26e9d04-1f28-b784-16da-0fc0cd6e57e7@gmail.com>
Date: Sun, 15 May 2022 15:16:32 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20220330194941.28470-1-xose.vazquez@gmail.com>
 <636faa5a57cca0b51d12d5e50968124d5b187280.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <636faa5a57cca0b51d12d5e50968124d5b187280.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH RFC] multipath-tools: update "Generic NVMe"
 options in hwtable
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8zMS8yMiAxMzowMiwgTWFydGluIFdpbGNrIHdyb3RlOgo+IE9uIFdlZCwgMjAyMi0wMy0z
MCBhdCAyMTo0OSArMDIwMCwgWG9zZSBWYXpxdWV6IFBlcmV6IHdyb3RlOgo+PiBSZW1vdmVkIHZh
bHVlcyB3ZXJlIGRlZmF1bHQuCj4gCj4gVGhpcyBpcyB3cm9uZyBmb3IgdWlkX2F0dHJpYnV0ZS4g
WW91IGNhbiBzZWUgaXQgd2hlbiB5b3UgcnVuICJtYWtlCj4gdGVzdCIsIHdoaWNoIGZhaWxzIHdp
dGggeW91ciBwYXRjaC4gSXQncyBhbHNvIHdyb25nIGZvcgo+IHJldGFpbl9od2hhbmRsZXIsIGJ1
dCB0aGF0IGVudHJ5IHNob3VsZCBpbmRlZWQgYmUgcmVtb3ZlZCwgYmVjYXVzZQo+IGtlZXBpbmcg
aXQgdGhlcmUgaXMgbWlzbGVhZGluZyBhdCBiZXN0LiBod2hhbmRsZXJzIGhhdmUgbm8gbWVhbmlu
ZyBmb3IKPiBOVk1lLCBhbmQgcmV0YWluX2h3aGFuZGxlciBpcyBlbmZvcmNlZCB0byBiZSB0cnVl
IGFuIGFsbCBrZXJuZWxzIHNpbmNlCj4gNC4zLgo+IAo+IFJlZ2FyZHMsCj4gTWFydGluCj4gCj4+
IENoZWNrIEFOQSwgZWxzZSBmYWxsIGJhY2sgdG8gQ09OU1QobXVsdGlidXMpLgo+Pgo+PiBDYzog
TWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cj4+IENjOiBCZW5qYW1pbiBNYXJ6aW5za2kg
PGJtYXJ6aW5zQHJlZGhhdC5jb20+Cj4+IENjOiBDaHJpc3RvcGhlIFZhcm9xdWkgPGNocmlzdG9w
aGUudmFyb3F1aUBvcGVuc3ZjLmNvbT4KPj4gQ2M6IERNLURFVkVMIE1MIDxkbS1kZXZlbEByZWRo
YXQuY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBYb3NlIFZhenF1ZXogUGVyZXogPHhvc2UudmF6cXVl
ekBnbWFpbC5jb20+Cj4+IC0tLQo+PiAgwqBsaWJtdWx0aXBhdGgvaHd0YWJsZS5jIHwgNiArKyst
LS0KPj4gIMKgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkK
Pj4KPj4gZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9od3RhYmxlLmMgYi9saWJtdWx0aXBhdGgv
aHd0YWJsZS5jCj4+IGluZGV4IDBlMWMwYTQxLi44MWRjYTBkNSAxMDA2NDQKPj4gLS0tIGEvbGli
bXVsdGlwYXRoL2h3dGFibGUuYwo+PiArKysgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jCj4+IEBA
IC04OCw5ICs4OCw5IEBAIHN0YXRpYyBzdHJ1Y3QgaHdlbnRyeSBkZWZhdWx0X2h3W10gPSB7Cj4+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIEdlbmVyaWMgTlZNZSAqLwo+PiAg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAi
TlZNRSIsCj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5wcm9kdWN0wqDCoMKg
wqDCoMKgID0gIi4qIiwKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC51aWRfYXR0
cmlidXRlID0gREVGQVVMVF9OVk1FX1VJRF9BVFRSSUJVVEUsCj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAuY2hlY2tlcl9uYW1lwqAgPSBOT05FLAo+PiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgLnJldGFpbl9od2hhbmRsZXIgPSBSRVRBSU5fSFdIQU5ETEVSX09GRiwK
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5wZ3BvbGljecKgwqDCoMKgwqAgPSBH
Uk9VUF9CWV9QUklPLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLnBnZmFpbGJh
Y2vCoMKgwqAgPSAtRkFJTEJBQ0tfSU1NRURJQVRFLAo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLm5vX3BhdGhfcmV0cnkgPSBOT19QQVRIX1JFVFJZX1FVRVVFLAo+PiAgwqDCoMKg
wqDCoMKgwqDCoH0sCj4+ICDCoMKgwqDCoMKgwqDCoMKgLyoKPj4gIMKgwqDCoMKgwqDCoMKgwqAg
KiBBcHBsZQo+IAoKYXMgb2YgdGhpcyBwYXRjaCwgd2hhdCBlbHNlIGRvIHlvdSB3YW50IHRvIGFk
ZC9yZW1vdmUgPwoKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9od3RhYmxlLmMgYi9saWJtdWx0
aXBhdGgvaHd0YWJsZS5jCmluZGV4IDQ3ZWE1ZDNkLi4yZjc1MGFkYiAxMDA2NDQKLS0tIGEvbGli
bXVsdGlwYXRoL2h3dGFibGUuYworKysgYi9saWJtdWx0aXBhdGgvaHd0YWJsZS5jCkBAIC04Niwx
MSArODYsMTAgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHsKICAJICov
CiAgCXsKICAJCS8qIEdlbmVyaWMgTlZNZSAqLwotCQkudmVuZG9yICAgICAgICA9ICJOVk1FIiwK
KwkJLnZlbmRvciAgICAgICAgPSAiTlZNW2VFXSIsCiAgCQkucHJvZHVjdCAgICAgICA9ICIuKiIs
CiAgCQkudWlkX2F0dHJpYnV0ZSA9IERFRkFVTFRfTlZNRV9VSURfQVRUUklCVVRFLAogIAkJLmNo
ZWNrZXJfbmFtZSAgPSBOT05FLAotCQkucmV0YWluX2h3aGFuZGxlciA9IFJFVEFJTl9IV0hBTkRM
RVJfT0ZGLAogIAl9LAogIAkvKgogIAkgKiBBcHBsZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

