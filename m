Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF45CE7A81
	for <dm-devel@archiver.kernel.org>; Fri, 22 Sep 2023 23:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695424728;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uZLgqc5k5mBI1N7Z1xlCHC6u+0vFXGWiP7khVS79AHk=;
	b=gesThvPRabF4yHszKnhvm4XGKzzRux53//d2vDFVQ9VSNtNBJwDBkSfHMLJ3CLECCNil2r
	L2hwjm9Rfqw2M/ZtmdfScUW3x5FJQAgqGzJ7nltAJ86vaL9VdqMHUOGpyLIMV1kTSP5hVq
	yUcsAV8wcJRMbpquoj9ACyDRqrApZi4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-2qDquR56MbusZY7Le4hJdQ-1; Fri, 22 Sep 2023 19:18:44 -0400
X-MC-Unique: 2qDquR56MbusZY7Le4hJdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A4421C068D9;
	Fri, 22 Sep 2023 23:18:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE6E8140E950;
	Fri, 22 Sep 2023 23:18:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7D8819465B8;
	Fri, 22 Sep 2023 23:18:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98A581946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Sep 2023 23:18:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84B4328FD; Fri, 22 Sep 2023 23:18:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D32451E3
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 23:18:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52E643C0DDA8
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 23:18:39 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-597-uFq-6jClMX6ZvmSs6vcz7Q-1; Fri,
 22 Sep 2023 19:18:37 -0400
X-MC-Unique: uFq-6jClMX6ZvmSs6vcz7Q-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id 88701CE2487;
 Fri, 22 Sep 2023 23:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BDEC433CC;
 Fri, 22 Sep 2023 23:09:05 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id
 2adb3069b0e04-503065c4b25so4620962e87.1; 
 Fri, 22 Sep 2023 16:09:05 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxxwu+NZl3RbS8Wlt9ZfTqn3dF1P2GsiuypsW6urEanxw+lYeQ4
 sxL4gGkLt6GH75beQAi9vwyNEbA3j1KfZUoV38w=
X-Google-Smtp-Source: AGHT+IEAb+xDxRN3HgexXJCyA3Nj9nD7JJYeVV5OIEdt78KHSlk6j9bbQtcn8PWQQkwDhlhYDV8R+2xAkkzxyA2TeGY=
X-Received: by 2002:a05:6512:3446:b0:4fb:9f93:365f with SMTP id
 j6-20020a056512344600b004fb9f93365fmr676218lfr.38.1695424143960; Fri, 22 Sep
 2023 16:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <b8f8cc10-8081-afe4-738b-376a1248ec05@ultracoder.org>
In-Reply-To: <b8f8cc10-8081-afe4-738b-376a1248ec05@ultracoder.org>
From: Song Liu <song@kernel.org>
Date: Fri, 22 Sep 2023 16:08:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Dvk4cgfqju=Oz1wdHeXtYdW--fbSq8r8xqQSsCpf81A@mail.gmail.com>
Message-ID: <CAPhsuW5Dvk4cgfqju=Oz1wdHeXtYdW--fbSq8r8xqQSsCpf81A@mail.gmail.com>
To: Kirill Kirilenko <kirill@ultracoder.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] fstrim on raid1 LV with writemostly PV leads to
 system freeze
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
Cc: heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org,
 dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgZm9sa3MsCgpUaGFua3MgZm9yIHRoZSByZXBvcnQuIEkgd2lsbCB0cnkgdG8gcmVwcm9kdWNl
IHRoaXMgaXNzdWUgbmV4dCB3ZWVrLgoKU29uZwoKT24gRnJpLCBTZXAgMjIsIDIwMjMgYXQgOToy
NeKAr0FNIEtpcmlsbCBLaXJpbGVua28gPGtpcmlsbEB1bHRyYWNvZGVyLm9yZz4gd3JvdGU6Cj4K
PiBPbiAyMi4wOS4yMDIzIDAwOjQ1ICswMzAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gPiBHaXZl
biB5b3VyIHVzZSBvZiAnd3JpdGVtb3N0bHknIEknbSBpbmZlcnJpbmcgeW91J3JlIHVzaW5nIGx2
bTIncwo+ID4gcmFpZDEgdGhhdCB1c2VzIE1EIHJhaWQxIGNvZGUgaW4gdGVybXMgb2YgdGhlIGRt
LXJhaWQgdGFyZ2V0Lgo+Cj4gWWVzLCBleGFjdGx5Lgo+Cj4gT24gMjIuMDkuMjAyMyAwMDo0NSAr
MDMwMCwgTWlrZSBTbml0emVyIHdyb3RlOgo+ID4gQWxsIHNhaWQ6IGhvcGVmdWxseSBzb21lb25l
IG1vcmUgTUQgb3JpZW50ZWQgY2FuIHJldmlldyB5b3VyIHJlcG9ydAo+ID4gYW5kIGhlbHAgeW91
IGZ1cnRoZXIuCj4gVGhhbmsgeW91LiBJIGRvbid0IG5lZWQgdG8gc2VuZCBhIG5ldyByZXBvcnQg
dG8gTUQgbWFpbnRhaW5lcnMsIGRvIEk/Cj4KPiBPbiAyMi4wOS4yMDIzIDAxOjAzICswMzAwLCBS
b21hbiBNYW1lZG92IHdyb3RlOgo+ID4gTWF5YmUgeW91ciBzeXN0ZW0gaGFzbid0IGZyb3plbiB0
b28sIGp1c3QgdGFraW5nIGl0cyB0aW1lIGluIHByb2Nlc3NpbmcgYWxsCj4gPiB0aGUgdGlueSBz
cGxpdCByZXF1ZXN0cy4KPiBJIGRvbid0IHRoaW5rIHNvLCBiZWNhdXNlIHRoZSBkaXNrIGFjdGl2
aXR5IGxpZ2h0IGlzIG9mZi4gTGV0IG1lIGNsYXJpZnk6Cj4gaWYgbXVzaWMgd2FzIHBsYXlpbmcg
d2hlbiB0aGUgc3lzdGVtIGZyb3plLCB0aGUgbGFzdCBzb3VuZCBidWZmZXIgYmVnaW5zCj4gdG8g
cGxheSBjeWNsaWNhbGx5LgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

