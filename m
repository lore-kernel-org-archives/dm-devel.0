Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F04FC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 18:18:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-9Z2XIPaaMNGpQyLJf4Ks9Q-1; Fri, 03 Dec 2021 13:18:30 -0500
X-MC-Unique: 9Z2XIPaaMNGpQyLJf4Ks9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9601010199B4;
	Fri,  3 Dec 2021 18:18:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F39633E38;
	Fri,  3 Dec 2021 18:18:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1CA8D1806D2D;
	Fri,  3 Dec 2021 18:18:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B3IHX0Q016707 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 13:17:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D4D6D401E40; Fri,  3 Dec 2021 18:17:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1275401E7A
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 18:17:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7E8380A0AF
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 18:17:33 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
	[209.85.128.48]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-224-WXEfXNriNKyaZqY2ioW0sw-1; Fri, 03 Dec 2021 13:17:32 -0500
X-MC-Unique: WXEfXNriNKyaZqY2ioW0sw-1
Received: by mail-wm1-f48.google.com with SMTP id y196so2985883wmc.3;
	Fri, 03 Dec 2021 10:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:from:subject:to:cc
	:references:content-language:in-reply-to:content-transfer-encoding;
	bh=6IhgbePcNYbTpqTptK4SeaodhTLEOpR3UNLtHIZNW8U=;
	b=XI/szRb5MpO9nlcOiLXHpxWy1dYJpg7mGWpJfF/uwsPwkeVQ5RLu40HtqltIO941FA
	aAtFUMxr9fJ9mLHHRYoGhPbGUZ63zIrNIr5A8NvPKrzYsCvKjCFzHQ+9Pz3gx4i9iYiE
	HVOfLt+dPSoh5TMv60GSVq605uwRwyEYmFN4kOqQYnS9VB8v+8VZH+fh5g+16dfMcJIu
	t/ZWpYFT5DXYv/0a3aSYQVoZ8z0kVPX4c2fNEzW7u2t9/UtdHJv7Valc9sShY86pIWwV
	m+6jPTjg17b683Lup1XVC0TIa4TdS+SzlEwiGxhx0SYu7ZpdFckz6Kx+HLqHLdUtpg7t
	x6oA==
X-Gm-Message-State: AOAM5313m6jyA3n83vcXD4IriC/aMVI+KpuXxH/Ti5i7bA78ThA8TeSp
	FGLnYPVmgdeJ1urYbcQG9g==
X-Google-Smtp-Source: ABdhPJzONRorkiitDwP8f5W2fIvex+j5d11MRwpnLirsjrPyDuV01FXOk6BFN5mns1WbkxUqAzGZrA==
X-Received: by 2002:a1c:90:: with SMTP id 138mr16817100wma.27.1638555450304;
	Fri, 03 Dec 2021 10:17:30 -0800 (PST)
Received: from localhost (50.red-83-33-156.dynamicip.rima-tde.net.
	[83.33.156.50]) by smtp.gmail.com with ESMTPSA id
	r83sm5904900wma.22.2021.12.03.10.17.29
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 03 Dec 2021 10:17:29 -0800 (PST)
Message-ID: <2fb2d579-c774-50d8-0459-3b9087acbf1f@gmail.com>
Date: Fri, 3 Dec 2021 19:17:28 +0100
MIME-Version: 1.0
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Martin Wilck <mwilck@suse.com>, Alasdair G Kergon <agk@redhat.com>
References: <20211201223518.3775-1-xose.vazquez@gmail.com>
	<20211201223518.3775-3-xose.vazquez@gmail.com>
	<b548b43ffccf9977ddb37b14046f03f897ec489c.camel@suse.com>
In-Reply-To: <b548b43ffccf9977ddb37b14046f03f897ec489c.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH resend] multipath-tools: dm-devel is a closed
	ml
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvMi8yMSAwODo0NSwgTWFydGluIFdpbGNrIHdyb3RlOgoKPiBPbiBXZWQsIDIwMjEtMTIt
MDEgYXQgMjM6MzUgKzAxMDAsIFhvc2UgVmF6cXVleiBQZXJleiB3cm90ZToKPj4gSnVzdCBmb3Ig
c3Vic2NyaWJlcnMKPj4KPj4gQ2M6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+PiBD
YzogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+PiBDYzogQ2hyaXN0
b3BoZSBWYXJvcXVpIDxjaHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy5jb20+Cj4+IENjOiBETS1E
RVZFTCBNTCA8ZG0tZGV2ZWxAcmVkaGF0LmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogWG9zZSBWYXpx
dWV6IFBlcmV6IDx4b3NlLnZhenF1ZXpAZ21haWwuY29tPgo+PiAtLS0KPj4gIMKgUkVBRE1FLm1k
IHwgMiArLQo+PiAgwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKPj4KPiAKPiBBY2NvcmRpbmcgdG8gQWxhc2RhaXIncyBzdGF0ZW1lbnQsCj4gKGh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL2FyY2hpdmVzL2RtLWRldmVsLzIwMjEtT2N0b2Jlci9tc2cwMDAz
Ny5odG1sKSwKPiB0aGUgbGlzdCBpcyAibW9kZXJhdGVkIGZvciBub24tc3Vic2NyaWJlcnMiLCBu
b3Qgc3RyaWN0bHkgc3Vic2NyaWJlcnMtCj4gb25seS4KPiAKPiBNb3Jlb3ZlciwgdGhlIHNhbWUg
UkVBRE1FIGhhcyAiKHN1YnNjcmliZXJzLW9ubHkpIiBqdXN0IGEgZmV3IGxpbmVzCj4gYWJvdmUs
IGluIHRoZSAiTWFpbGluZyBMaXN0IiBzZWN0aW9uLgoKIm1vZGVyYXRlZCBmb3Igbm9uLXN1YnNj
cmliZXJzIiBzaG91bGQgb25seSBiZSBmb3IgdmVyeSBzcG9yYWRpYyBwb3N0ZXJzLgpDb250cmli
dXRvcnMgbXVzdCBiZSBpbiB0aGUgbGlzdC4KU29tZXRpbWVzIHNvbWUgbWVzc2FnZXMgZ2V0IGxv
c3QgYmVjYXVzZSBpdCdzIGh1bWFuLW9wZXJhdGVkLiBBbmQgaXQKYWxzbyBvdmVybG9hZHMgbWwg
YWRtaW5zIHdpdGggdW5uZWNlc3NhcnkgZXh0cmEgd29yay4KCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

