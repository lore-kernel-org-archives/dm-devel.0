Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57025C433E6
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:51:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C40564F60
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 09:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C40564F60
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-y3-JvVDSPleB2i2MFnWGyQ-1; Wed, 03 Feb 2021 04:51:21 -0500
X-MC-Unique: y3-JvVDSPleB2i2MFnWGyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEE5C835E22;
	Wed,  3 Feb 2021 09:51:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DC5218E4B;
	Wed,  3 Feb 2021 09:51:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 720784EA48;
	Wed,  3 Feb 2021 09:51:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1130XV4V006218 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 19:33:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4F26711422DA; Wed,  3 Feb 2021 00:33:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B25E11422D8
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 00:33:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D82D8115B0
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 00:33:29 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
	[209.85.218.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-525-PoCkIKssNuSs0RaElpzGHw-1; Tue, 02 Feb 2021 19:33:27 -0500
X-MC-Unique: PoCkIKssNuSs0RaElpzGHw-1
Received: by mail-ej1-f54.google.com with SMTP id w1so32818698ejf.11;
	Tue, 02 Feb 2021 16:33:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=Z+13UOGCC7I+iljuuHXBZA6fphrD3cnMtJ966bWAe3g=;
	b=F1ZxcSrmUAWm1gdBW8fh8hBt9IDtsiyV1StVe2gZGp6AIdcQ8X8lYBo9Q16YzfipzW
	IZkxf256+EDWXrUMlH8Z0H4CeiCuFosiO2A7qxFVcLJRWlGtPy/zgKXNq8AgmiMXQ/5V
	JbomgqXUjvcTGx/TPcT0wI69gF5hjPuOTg+i+I8bxAxKoUhaNd2ozl5lc8fhFnlH8bKl
	NufTRBGjOQXpCUQmf8QrB1QODaLMD18LT8Tq3C/mamXcSa+ePj7yXTGUyXOYVDNp4lhA
	JDrWe4SbILyUGKQgcHfOO0nSTB+j5M66cUI7wPNwn/ynegLhUOsDzPoDQEaswsyDsg+y
	EJIA==
X-Gm-Message-State: AOAM532LOpZC6JgGnYifXFPTd09FxeF//Tz+eiKIEE5yMfn3QgW4r/wZ
	IlADqPN6QycYh98/nx/w5xoT8OUXhx1jwACySCE=
X-Google-Smtp-Source: ABdhPJzbDVdYiWc6xmBFTMIEEpr2atHpxPzwcj5CyseOV1v3Bm60OiC0TKbqos0bNluJExG0dUR+CAKHxhTcJEdwLWY=
X-Received: by 2002:a17:906:3ad0:: with SMTP id
	z16mr587105ejd.72.1612312405694; 
	Tue, 02 Feb 2021 16:33:25 -0800 (PST)
MIME-Version: 1.0
References: <20210122084321.24012-1-a.fatoum@pengutronix.de>
In-Reply-To: <20210122084321.24012-1-a.fatoum@pengutronix.de>
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Date: Wed, 3 Feb 2021 03:33:14 +0300
Message-ID: <CALT56yMudd0jKx8TiWvSrsE-Y3efhnFwNYcgkDiExcZONNBt3A@mail.gmail.com>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1130XV4V006218
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 03 Feb 2021 04:50:36 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	kernel list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	kernel@pengutronix.de, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] dm crypt: replaced #if defined with
	IS_ENABLED
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

0L/RgiwgMjIg0Y/QvdCyLiAyMDIxINCzLiDQsiAxMTo0MywgQWhtYWQgRmF0b3VtIDxhLmZhdG91
bUBwZW5ndXRyb25peC5kZT46Cj4KPiBJU19FTkFCTEVEKENPTkZJR19FTkNSWVBURURfS0VZUykg
aXMgdHJ1ZSB3aGV0aGVyIHRoZSBvcHRpb24gaXMgYnVpbHQtaW4KPiBvciBhIG1vZHVsZSwgc28g
dXNlIGl0IGluc3RlYWQgb2YgI2lmIGRlZmluZWQgY2hlY2tpbmcgZm9yIGVhY2gKPiBzZXBhcmF0
ZWx5Lgo+Cj4gVGhlIG90aGVyICNpZiB3YXMgdG8gYXZvaWQgYSBzdGF0aWMgZnVuY3Rpb24gZGVm
aW5lZCwgYnV0IHVudXNlZAo+IHdhcm5pbmcuIEFzIHdlIG5vdyBhbHdheXMgYnVpbGQgdGhlIGNh
bGxzaXRlIHdoZW4gdGhlIGZ1bmN0aW9uCj4gaXMgZGVmaW5lZCwgd2UgY2FuIHJlbW92ZSB0aGF0
IGZpcnN0ICNpZiBndWFyZC4KPgo+IFN1Z2dlc3RlZC1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBh
cm5kYi5kZT4KPiBTaWduZWQtb2ZmLWJ5OiBBaG1hZCBGYXRvdW0gPGEuZmF0b3VtQHBlbmd1dHJv
bml4LmRlPgoKQWNrZWQtYnk6IERtaXRyeSBCYXJ5c2hrb3YgPGRtaXRyeS5iYXJ5c2hrb3ZAbGlu
YXJvLm9yZz4KCgotLSAKV2l0aCBiZXN0IHdpc2hlcwpEbWl0cnkKCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

