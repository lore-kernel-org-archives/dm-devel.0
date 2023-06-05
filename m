Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31018C7EE2A
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 05:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685941595;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N9uKOzBMVeI6T8bVu/RaAnlRTjF+BRl/8U5GEtQ1ODE=;
	b=XKytG0bsc4mWxIyAqGQeSf/xlFtsaCEI/FORJhONKKZa26UzZ4PIxPwETD3iFNd/OrZcpQ
	emnLK8qKEupyfSPYFUHVtzKMjcWziDvjRAuyx9RuBXIy8YG1aHRTHd7GRDAzudSAl9jKzq
	ej0ld9X0sXvmfPwPM/cUak25lO0riNs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-Mf8RJ2mHOeizqSR6f_37JA-1; Mon, 05 Jun 2023 01:06:33 -0400
X-MC-Unique: Mf8RJ2mHOeizqSR6f_37JA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AAA21C06906;
	Mon,  5 Jun 2023 05:06:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 27D8D2026D6A;
	Mon,  5 Jun 2023 05:06:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6B4819465A0;
	Mon,  5 Jun 2023 05:06:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F22821946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 05:06:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DFAA240CFD47; Mon,  5 Jun 2023 05:06:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D834C40CFD46
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:06:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A584C800BFF
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 05:06:30 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-jdGMRtX6N7yDJi_fmujHlg-1; Mon, 05 Jun 2023 01:06:27 -0400
X-MC-Unique: jdGMRtX6N7yDJi_fmujHlg-1
Received: by mail-qv1-f42.google.com with SMTP id
 6a1803df08f44-62606e67c0dso39746016d6.2; 
 Sun, 04 Jun 2023 22:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685941586; x=1688533586;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=+0m9/08QZWQ/wUkhRL9qb7LK9JpSK87yrVqMhqYcFTg=;
 b=jWu3QngCe1z1cQYagtCU32LX9mFbnaxwkZnL7k4mmiRxT6jZEVd4jnRFIT25H2g3Wn
 rOKMNAy8JN87o+kHbP4W+xFENPmtES3Iu2RKIfAt68b3rgQ8Q0mIam16d4hi+azJAAbJ
 S2wzqD3gsoNEOI5sMi8DofqCfMsIJIZexHdutkp2DeGZz+YbT1siTJi5BInkQ/61kUtR
 9w3xAs4i38Tj31QrpIvZcI4GKILnnhI3/Ayhf7Xh54I+sI+UYZY4FSRxyGqQHZug7wgN
 T2kRXvXpMFG1o6U46iJ/bpc91kk4jO0bBNmOCatrymOqaEpDShioGSUDf5hPz9Wt7zxw
 Sz0w==
X-Gm-Message-State: AC+VfDziW+lg4I+1AOJZmOFqCN1Zwi8EIjhLOA1hlqYIU7XJxWV9tR0W
 At79BRpXBpJ1O+wWKCRAOcjk93lX6BZImj0EbM9dDlw0F4o=
X-Google-Smtp-Source: ACHHUZ5f+kUrUqUxyh0/XUqZrXk9aTJgcO2RlWDc+1IGWvGMJkOOSmnZ+SlDuxv7TojAyru181PMwZGP8Jl7APEbUE0=
X-Received: by 2002:a05:6214:d4a:b0:62a:8f5f:2f9a with SMTP id
 10-20020a0562140d4a00b0062a8f5f2f9amr7728472qvr.41.1685941586040; Sun, 04 Jun
 2023 22:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-5-eatnumber1@gmail.com>
 <ZH1T1hK1CzHhhNuo@debian.me>
In-Reply-To: <ZH1T1hK1CzHhhNuo@debian.me>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sun, 4 Jun 2023 22:05:59 -0700
Message-ID: <CA+zrezT7+EziQRnUaSiEfrv87k0Gp7SOgiKnfe2PN6T5DJ8Pbg@mail.gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v3 4/4] Document an example of how the
 tunables relate in dm-integrity.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

U2FtZSBhcyB3aXRoIHRoZSBwYXRjaCBhZGRpbmcgZGVmYXVsdCB2YWx1ZXMuIENhbiB5b3UgcmVj
b21tZW5kCnNvbWV0aGluZyB0byBzYXkgaW4gdGhlIGNvbW1pdCBiZXlvbmQgdGhlIHN1bW1hcnkg
bGluZT8KCk9uIFN1biwgSnVuIDQsIDIwMjMgYXQgODoxN+KAr1BNIEJhZ2FzIFNhbmpheWEgPGJh
Z2FzZG90bWVAZ21haWwuY29tPiB3cm90ZToKPgo+IE9uIFN1biwgSnVuIDA0LCAyMDIzIGF0IDEy
OjA2OjA0UE0gLTA3MDAsIFJ1c3NlbGwgSGFybW9uIHdyb3RlOgo+ID4gRm9yIGV4YW1wbGUsIG9u
IGEgZGV2aWNlIHVzaW5nIHRoZSBkZWZhdWx0IGludGVybGVhdmVfc2VjdG9ycyBvZiAzMjc2OCwg
YQo+ID4gYmxvY2tfc2l6ZSBvZiA1MTIsIGFuZCBhbiBpbnRlcm5hbF9oYXNoIG9mIGNyYzMyYyB3
aXRoIGEgdGFnIHNpemUgb2YgNAo+ID4gYnl0ZXMsIGl0IHdpbGwgdGFrZSAxMjggS2lCIG9mIHRh
Z3MgdG8gdHJhY2sgYSBmdWxsIGRhdGEgYXJlYSwgcmVxdWlyaW5nCj4gPiAyNTYgc2VjdG9ycyBv
ZiBtZXRhZGF0YSBwZXIgZGF0YSBhcmVhLiBXaXRoIHRoZSBkZWZhdWx0IGJ1ZmZlcl9zZWN0b3Jz
IG9mCj4gPiAxMjgsIHRoYXQgbWVhbnMgdGhlcmUgd2lsbCBiZSAyIGJ1ZmZlcnMgcGVyIG1ldGFk
YXRhIGFyZWEsIG9yIDIgYnVmZmVycwo+ID4gcGVyIDE2IE1pQiBvZiBkYXRhLgo+Cj4gQWdhaW4s
IHRoZSBwYXRjaCBkZXNjcmlwdGlvbiBkdXBsaWNhdGVzIGRpZmYgY29udGVudC4KPgo+IC0tCj4g
QW4gb2xkIG1hbiBkb2xsLi4uIGp1c3Qgd2hhdCBJIGFsd2F5cyB3YW50ZWQhIC0gQ2xhcmEKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

