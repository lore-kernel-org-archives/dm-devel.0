Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B18C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 10:57:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB9F764E32
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 10:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB9F764E32
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-E9Y3YuYaMrOov7hf5ASddA-1; Tue, 23 Feb 2021 05:57:29 -0500
X-MC-Unique: E9Y3YuYaMrOov7hf5ASddA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C77910082F5;
	Tue, 23 Feb 2021 10:57:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAC8C19172;
	Tue, 23 Feb 2021 10:57:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8835C4E58E;
	Tue, 23 Feb 2021 10:57:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NAvHVO030842 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 05:57:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 543B720F4720; Tue, 23 Feb 2021 10:57:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E16A2166B2F
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 10:57:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41D4B8919BE
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 10:57:14 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
	[209.85.128.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-394-hXUAVpdVMGqoIBQ3l-3qRw-1; Tue, 23 Feb 2021 05:57:10 -0500
X-MC-Unique: hXUAVpdVMGqoIBQ3l-3qRw-1
Received: by mail-wm1-f52.google.com with SMTP id v21so1984436wml.4;
	Tue, 23 Feb 2021 02:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=7dfT24Rjl2LDEShwVl6cMR4l2r2detK+N21hnykk0TM=;
	b=Y4V+Ovgi0dhJgDLXM/qD27NijFuvNkYEvpvEDluRaacOpH8rAZjn0FPh6GctoRiofo
	BCfZMI80NQcULW4x3Yc8f7DnVCWmk7xgCjy8asiBqkOp6POIAuKO4Iv/t+A0UOt3Ol/a
	oYdkUSfsgTqx3QszOD+HO3oZfd9rN85b6prAlBtICrFaLpvnhK91LPI2e1IrgvA4fjNf
	jLjwytPlEFp5xjcOWb03Rsh1NMk939PAcMY/uxGNHHYZDrtNnSGjnPs9/8GwvtBJsUdm
	4sD/cHERLtb9TzF/NJSMyETGTV3Q8EH6N9L8XvX5wSGCAMfST+aA24xb6QDc9/JSJjJH
	HnQQ==
X-Gm-Message-State: AOAM531XPlTiyPgGKMtbdic2sorsSRLLbayjSRV7WTgnnT/66S5WZgAI
	wzqAOWV5t4+Jb+ssHYyqVsMp+U2YWLQ=
X-Google-Smtp-Source: ABdhPJwG+0AAWnVRoknhGxHG8aE9T9BCXowl5pY2qhCWIWEOY9wemuAtNBY4xdgMm5E6pEmz5IdaTg==
X-Received: by 2002:a05:600c:358d:: with SMTP id
	p13mr10641443wmq.152.1614077828752; 
	Tue, 23 Feb 2021 02:57:08 -0800 (PST)
Received: from [192.168.2.27] (39.35.broadband4.iol.cz. [85.71.35.39])
	by smtp.gmail.com with ESMTPSA id
	e1sm32271682wrd.44.2021.02.23.02.57.07
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 23 Feb 2021 02:57:08 -0800 (PST)
To: =?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>
References: <20210222220110.22ee6d0e@pouet.cJ>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <6576ebcf-f250-fbf5-063c-91bd7cb1e5e6@gmail.com>
Date: Tue, 23 Feb 2021 11:57:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222220110.22ee6d0e@pouet.cJ>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, mpatocka@redhat.com, samitolvanen@google.com
Subject: Re: [dm-devel] [PATCH] dm-verity: Fix FEC for RS roots non-aligned
 to block size
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjMvMDIvMjAyMSAwNDowMCwgSsOpcsO0bWUgQ2FycmV0ZXJvIHdyb3RlOgo+IFRlc3RlZC1i
eTogSsOpcsO0bWUgQ2FycmV0ZXJvIDxjSi1rb0B6b3VnbG91Yi5ldT4KPiAKPiAKPiBJIHNtb2tl
LXRlc3RlZCBieSBmdXp6aW5nIGNvbnRpZ3VvdXMgcmFuZ2VzIG9mIHVzZXIgZGF0YSAobm90IGhh
c2gKPiB0cmVlKSBhbmQgY29ycmVjdGlvbiB3b3JrcyB1cCB0byB0aGUgYW1vdW50IG9mIGFkZGVk
IGNvcnJlY3Rpb24gKHNpbmNlCj4gZXJhc3VyZXMgYXJlIGlkZW50aWZpZWQgYnkgaGFzaGVzKS4K
ClRoYW5rcyBmb3IgdGVzdGluZyEKCj4gU2luY2UgdGhlIGZpeCBsb29rcyBvYnZpb3VzLCB0aGlz
IHNob3VsZCBwcm9iYWJseSBDQyB0byBzdGFibGU/CgpZZXMsIEkgZm9yZ290IHRvIGFkZCB0aGUg
dGFnLCBJIHRoaW5rIHRoaXMgc2hvdWxkIGdvIHRvIGFsbCBzdGFibGUga2VybmVscy4KCihJdCBv
bmx5IG5lZWRzIGRtX2J1ZmlvX3NldF9zZWN0b3Jfb2Zmc2V0KCkgdGhhdCB3YXMgYWRkZWQgbGF0
ZXIgdGhhbiBGRUMsIElJUkMuKQoKTWlsYW4KCnAucy4KVGhlcmUgYXJlIGFsc28gYnVncyBpbiB1
c2Vyc3BhY2UgdmVyaXR5c2V0dXAgaWYgRkVDIGhhcyBoYXNoIGFyZWEgaXMgc3RvcmVkCm9uIHRo
ZSBzYW1lIGRldmljZSwgdGhlbiBjb2RlIG1pc2NhbGN1bGF0ZXMgcGFyaXR5IGJ5dGVzIHRoZW4u
ClRoaXMgd2lsbCBiZSBmaXhlZCBzb29uIGluIG5leHQgc3RhYmxlIGNyeXB0c2V0dXAgcmVsZWFz
ZS4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

