Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD433C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657913934;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Wd+37axpVNFGVl9TnmOkvMCyAoN+7vmzfaClOVLpoOI=;
	b=YwQZejX4oRdTYpucN1zoAmA87162yI7pzf4SDO1U5meCzo85Ro8lkkKoeflGhc2RrQ5BXt
	EYrixNd39JqT0R/bDH2dTIYts4tGKtOkLOosGVzjA885eCRTBxiGToPoaiC+6i+hJM0XfS
	jeI1h1U2/3JsshRB63jT7DjiKTexzgo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-j4qqB88FPVivwIzbPrKvvw-1; Fri, 15 Jul 2022 15:38:51 -0400
X-MC-Unique: j4qqB88FPVivwIzbPrKvvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 750F83C025B5;
	Fri, 15 Jul 2022 19:38:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 113891121314;
	Fri, 15 Jul 2022 19:38:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BEE621947041;
	Fri, 15 Jul 2022 19:38:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F5C819466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 19:38:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D29C2026D07; Fri, 15 Jul 2022 19:38:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D912026D64
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 19:38:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AEFF811E81
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 19:38:45 +0000 (UTC)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
 [209.85.208.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-FuvPyXO6OjuSx3XDbTVl6w-1; Fri, 15 Jul 2022 15:38:41 -0400
X-MC-Unique: FuvPyXO6OjuSx3XDbTVl6w-1
Received: by mail-ed1-f52.google.com with SMTP id m16so7537607edb.11;
 Fri, 15 Jul 2022 12:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=EcHI0RFme1P+FHdB6sWN7r2D7IfzNHh0dba57jzLiec=;
 b=6sxULa45nlRXA6ReuTkdIraEfr5yCoim1bSfeL1t6oxgmZKsdhjnPIt1UsEQ6g/3Us
 A5ZCgGf9rMxEEX3v0GdVJWGmyJ2JUz6SZCqDmYxbImC83R8mm6MgnQOfK9uGN9DjW5Kt
 CUQB6ZRhnQeSdyBtKHIzIfNYUQ3MaszbhPx18J5tATcqIv4jSRJgMlZxMluev6zPzWyZ
 APt+6vDcFY9d9d8YjqU/bXdbpZgAsQzVlYogS1h+XfTReLS8fIWKj8T0+018y1XHU/M7
 /vQEQK4Zy8hVkTfv76dA4X7wfXHnYsrbIECuQyMc6vSzYkGU2v5hjp7G6JsGT47LmptO
 XAiw==
X-Gm-Message-State: AJIora8Odan6Yq/HwDsgRlBxUsIolTAYkpbM5EjvZqmWY8nCsBx/nVkU
 01BrsaW+BfdHpcVnxKywjcKe5YHD1fkIKLPc
X-Google-Smtp-Source: AGRyM1t7ZLWeZqKRDMnbSZm440nvKe3q7hq5HnywN8/NkfbVf3xIOHWfjSVlGbYdoxccZXlAOXhWPg==
X-Received: by 2002:aa7:dcd5:0:b0:43a:70f7:8e4d with SMTP id
 w21-20020aa7dcd5000000b0043a70f78e4dmr20604931edu.85.1657913919826; 
 Fri, 15 Jul 2022 12:38:39 -0700 (PDT)
Received: from [192.168.1.4] (78-3-70-107.adsl.net.t-com.hr. [78.3.70.107])
 by smtp.gmail.com with ESMTPSA id
 cw11-20020a056402228b00b0043a8f40a038sm3370511edb.93.2022.07.15.12.38.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Jul 2022 12:38:39 -0700 (PDT)
Message-ID: <cca5b463-a860-de8d-b7e4-a8d30aef2ff2@gmail.com>
Date: Fri, 15 Jul 2022 21:38:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
To: Mikulas Patocka <mpatocka@redhat.com>, Daniil Lunev <dlunev@chromium.org>
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
 <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
 <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <alpine.LRH.2.02.2207150528170.5197@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Brian Geffon <bgeffon@google.com>, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDE1LiAwNy4gMjIgdiAxMTozNiBNaWt1bGFzIFBhdG9ja2EgbmFwc2FsKGEpOgo+Cj4gT24g
RnJpLCAxNSBKdWwgMjAyMiwgRGFuaWlsIEx1bmV2IHdyb3RlOgo+Cj4+IEhpIE1pa2UsCj4+IFRo
YW5rIHlvdSBmb3IgeW91ciByZXNwb25zZS4gSSBzaG91bGQgaGF2ZSBwcm9iYWJseSBhZGRlZCBt
b3JlIGNvbnRleHQKPj4gdG8gdGhlIGNvbW1pdCBtZXNzYWdlIHRoYXQgSSBzcGVjaWZpZWQgaW4g
dGhlIGNvdmVyIGxldHRlci4gVGhlIGlkZWEgaXMgdG8KPj4gcHJvaGliaXQgYWNjZXNzIG9mIGFs
bCB1c2Vyc3BhY2UsIGluY2x1ZGluZyB0aGUgcm9vdC4gVGhlIG1haW4gY29uY2VybiBoZXJlCj4+
IGlzIHBvdGVudGlhbCBzeXN0ZW0gYXBwbGljYXRpb25zJyB2dWxuZXJhYmlsaXRpZXMgdGhhdCBj
YW4gdHJpY2sgdGhlIHN5c3RlbSB0bwo+PiBvcGVyYXRlIG9uIG5vbi1pbnRlbmRlZCBmaWxlcyB3
aXRoIGVsZXZhdGVkIHBlcm1pc3Npb25zLiBXaGlsZSB0aG9zZSBjb3VsZAo+PiBhbHNvIGJlIGV4
cGxvaXRlZCB0byBnZXQgbW9yZSBhY2Nlc3MgdG8gdGhlIHJlZ3VsYXIgZmlsZSBzeXN0ZW1zLCB0
aG9zZSBmaXJzdGx5Cj4+IGhhcyB0byBiZSB1c2VhYmxlIGJ5IHVzZXJzcGFjZSBmb3Igbm9ybWFs
IHN5c3RlbSBvcGVyYXRpb24gKGUuZy4gdG8gc3RvcmUKPj4gdXNlciBkYXRhKSwgc2Vjb25kbHks
IG5ldmVyIGNvbnRhaW4gcGxhaW4gdGV4dCBzZWNyZXRzLiBTd2FwIGNvbnRlbnQgaXMgYQo+PiBk
aWZmZXJlbnQgc3RvcnkgLSBhY2Nlc3MgdG8gaXQgY2FuIGxlYWsgdmVyeSBzZW5zaXRpdmUgaW5m
b3JtYXRpb24sIHdoaWNoCj4+IG90aGVyd2lzZSBpcyBuZXZlciBhdmFpbGFibGUgYXMgcGxhaW50
ZXh0IG9uIGFueSBwZXJzaXN0ZW50IG1lZGlhIC0gZS5nLiByYXcKPj4gdXNlciBzZWNyZXRzLCBy
YXcgZGlzayBlbmNyeXB0aW9uIGtleXMgZXRjLCBvdGhlciBzZWN1cml0eSByZWxhdGVkIHRva2Vu
cy4KPj4gVGh1cyB3ZSBwcm9wb3NlIGEgbWVjaGFuaXNtIHRvIGVuYWJsZSBzdWNoIGEgbG9ja2Rv
d24gYWZ0ZXIgbmVjZXNzYXJ5Cj4+IGNvbmZpZ3VyYXRpb24gaGFzIGJlZW4gZG9uZSB0byB0aGUg
ZGV2aWNlIGF0IGJvb3QgdGltZS4KPj4gLS1EYW5paWwKPiBJZiBzb21lb25lIGdhaW5zIHJvb3Qs
IGhlIGNhbiBkbyBhbnl0aGluZyBvbiB0aGUgc3lzdGVtLgo+Cj4gSSdtIHF1aXRlIHNrZXB0aWNh
bCBhYm91dCB0aGVzZSBhdHRlbXB0czsgcHJvdGVjdGluZyB0aGUgc3lzdGVtIGZyb20gdGhlCj4g
cm9vdCB1c2VyIGlzIG5ldmVyLWVuZGluZyB3aGFjay1hLW1vbGUgZ2FtZS4KCgpJdCdzIGluIGZh
Y3QgYSAnZGVzaWduIGZlYXR1cmUnIG9mIHdob2xlIERNwqAgdGhhdCByb290IGNhbiBhbHdheXMg
b3BlbiBhbnkgCmRldmljZSBpbiBkZXZpY2Ugc3RhY2sgKGFsdGhvdWdoIGNhdXNlIHNvbWUgdHJv
dWJsZXMgdG8gaS5lLiBzb21lIGx2bTIgbG9naWMpIApzdWNoIGZlYXR1cmUgaXMgdXNlZnVsIGku
ZS4gZm9yIGRlYnVnZ2luZyBkZXZpY2UgcHJvYmxlbXMuIFRoZXJlIHdhcyBuZXZlciBhbiAKaW50
ZW50aW9uIHRvIHByb2hpYml0IHJvb3QgdXNlciBmcm9tICdzZWVpbmcnIGFsbCBzdGFja2VkIGRl
dmljZXMuCgpSZWdhcmRzCgpaZGVuZWsKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

