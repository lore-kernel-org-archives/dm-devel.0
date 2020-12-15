Return-Path: <SRS0=VSmt=FT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EB6C2BBCA
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 364032228A
	for <dm-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 364032228A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-BRc1AbWwNNaxOLlEDrv8nQ-1; Tue, 15 Dec 2020 04:59:59 -0500
X-MC-Unique: BRc1AbWwNNaxOLlEDrv8nQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B845BEC1B6;
	Tue, 15 Dec 2020 09:59:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95CAC5D9F6;
	Tue, 15 Dec 2020 09:59:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 044A4180954D;
	Tue, 15 Dec 2020 09:59:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BF314MG031552 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 22:01:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BAFC6110F0AC; Tue, 15 Dec 2020 03:01:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6451110F0AB
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 03:01:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BBEF858284
	for <dm-devel@redhat.com>; Tue, 15 Dec 2020 03:01:02 +0000 (UTC)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
	[209.85.210.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-585-RTJSt8UuPY6b61v-ZIgJjg-1; Mon, 14 Dec 2020 22:00:59 -0500
X-MC-Unique: RTJSt8UuPY6b61v-ZIgJjg-1
Received: by mail-pf1-f193.google.com with SMTP id t8so13586425pfg.8
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 19:00:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
	:mime-version:content-transfer-encoding;
	bh=b9Yyd2SJUpD5M0JEcQPm/jMQVqbJpky9fEX60fZ5oLU=;
	b=WmP4cKQx8In9irwxEPZxFpE7dcj7lQ1H9lG/QNUbwtm453Y1aSYJMfUvZE/osXDzeb
	nAtKTlV1yF3ID8jVtvd5BOsWH8QwJ7EbNVLIPjpivGg/pftBeH+L76fbwEauEd+QpPMX
	OE5lxD8g4HYcm+e/7Xj8pioO8xG691ahwwyo4Gia6KkN6j0J2Ib7q3LXvXvR0P0p4U7h
	vYGZFiIhyPNC3UG9/QBHNcj9D7nltdJjG23bf8PvamWAWd8wKXRQCl0En2OKzESRjx2C
	u1SuoVt4GH+MVHq4hiX8LDXXxBteYtVLZ0dS/rkKobgOtGbDsRHgav50CSCSWU8YWIsG
	ZRJA==
X-Gm-Message-State: AOAM530onchRfd/jDlJXr/aZS6eXT1vh6cYlxO7zE8EjPQamt/oJEXhj
	C4gbeNtaDBXAWv0IQUGCKxiDwA==
X-Google-Smtp-Source: ABdhPJyKCn7Z6PEeIJzplurcW2m8m7LJC9wdzi2X3lcSQ1bxIAbeSMiqO89ZdyZdyMq5hexNtN0JQw==
X-Received: by 2002:a05:6a00:80b:b029:198:124a:d58a with SMTP id
	m11-20020a056a00080bb0290198124ad58amr25719514pfk.56.1608001258225;
	Mon, 14 Dec 2020 19:00:58 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net.
	[76.210.143.223]) by smtp.gmail.com with ESMTPSA id
	c199sm23127946pfb.108.2020.12.14.19.00.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 14 Dec 2020 19:00:57 -0800 (PST)
Date: Mon, 14 Dec 2020 19:00:57 -0800 (PST)
X-Google-Original-Date: Mon, 14 Dec 2020 19:00:53 PST (-0800)
In-Reply-To: <30d39293-80a4-9ef5-92bb-6b6dec464be3@toxicpanda.com>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: josef@toxicpanda.com
Message-ID: <mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Dec 2020 04:59:49 -0500
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org, snitzer@redhat.com,
	linux-doc@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	dm-devel@redhat.com, michael.christie@oracle.com,
	linux-kselftest@vger.kernel.org, kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
	BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gVGh1LCAxMCBEZWMgMjAyMCAwOTowMzoyMSBQU1QgKC0wODAwKSwgam9zZWZAdG94aWNwYW5k
YS5jb20gd3JvdGU6Cj4gT24gMTIvOS8yMCAxMDozOCBQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3Rl
Ogo+PiBPbiAxMi83LzIwIDEwOjU1IEFNLCBQYWxtZXIgRGFiYmVsdCB3cm90ZToKPj4+IEFsbCBp
biBhbGwsIEkndmUgZm91bmQgaXQgYSBiaXQgaGFyZCB0byBmaWd1cmUgb3V0IHdoYXQgc29ydCBv
ZiBpbnRlcmVzdAo+Pj4gcGVvcGxlCj4+PiBoYXZlIGluIGRtLXVzZXI6IHdoZW4gSSBicmluZyB0
aGlzIHVwIEkgc2VlbSB0byBydW4gaW50byBwZW9wbGUgd2hvJ3ZlIGRvbmUKPj4+IHNpbWlsYXIg
dGhpbmdzIGJlZm9yZSBhbmQgYXJlIHZhZ3VlbHkgaW50ZXJlc3RlZCwgYnV0IGNlcnRhaW5seSBu
b2JvZHkgaXMKPj4+IGNob21waW5nIGF0IHRoZSBiaXQuwqAgSSdtIHNlbmRpbmcgaXQgb3V0IGlu
IHRoaXMgZWFybHkgc3RhdGUgdG8gdHJ5IGFuZAo+Pj4gZmlndXJlCj4+PiBvdXQgaWYgaXQncyBp
bnRlcmVzdGluZyBlbm91Z2ggdG8ga2VlcCBnb2luZy4KPj4KPj4gQ2MtaW5nIEpvc2VmIGFuZCBN
aWtlIHNpbmNlIHRoZWlyIG5iZCBjb250cmlidXRpb25zIG1ha2UgbWUgd29uZGVyCj4+IHdoZXRo
ZXIgdGhpcyBuZXcgZHJpdmVyIGNvdWxkIGJlIHVzZWZ1bCB0byB0aGVpciB1c2UgY2FzZXM/Cj4+
Cj4KPiBTb3JyeSBnbWFpbCtpbWFwIHN1Y2tzIGFuZCBJIGNhbid0IGdldCBteSBlbWFpbCBjbGll
bnQgdG8gZ2V0IGF0IHRoZSBvcmlnaW5hbAo+IHRocmVhZC4gIEhvd2V2ZXIgaGVyZSBpcyBteSB0
YWtlLgoKYW5kIEkgZ3Vlc3MgSSB0aGVuIGhhdmUgdG8gYXBvbGlnaXplIGZvciBtaXNzaW5nIHlv
dXIgZW1haWwgOykuICBIb3BlZnVsbHkgdGhhdAp3YXMgdGhlIHByb2JsZW0sIGJ1dCB3aG8ga25v
d3MuCgo+IDEpIFRoZSBhZHZhbnRhZ2VzIG9mIHVzaW5nIGRtLXVzZXIgb2YgTkJEIHRoYXQgeW91
IGxpc3RlZCBhcmVuJ3QgYWN0dWFsbHkKPiBwcm9ibGVtcyBmb3IgTkJELiAgV2UgaGF2ZSBOQkQg
d29ya2luZyBpbiBwcm9kdWN0aW9uIHdoZXJlIHlvdSBjYW4gaGFuZCBvZmYgdGhlCj4gc29ja2V0
cyBmb3IgdGhlIHNlcnZlciB3aXRob3V0IGVuZGluZyBpbiB0aW1lb3V0cywgaXQgd2FzIGFjdHVh
bGx5IHRoZSBtYWluCj4gcmVhc29uIHdlIHdyb3RlIG91ciBvd24gc2VydmVyIHNvIHdlIGNvdWxk
IHVzZSB0aGUgRkQgdHJhbnNmZXIgc3R1ZmYgdG8gcmVzdGFydAo+IHRoZSBzZXJ2ZXIgd2l0aG91
dCBpbXBhY3RpbmcgYW55IGNsaWVudHMgdGhhdCBoYWQgdGhlIGRldmljZSBpbiB1c2UuCgpPSy4g
IFNvIHlvdSBqdXN0IHNlbmQgdGhlIEZEIGFyb3VuZCB1c2luZyBvbmUgb2YgdGhlIHN0YW5kYXJk
IG1lY2hhbmlzbXMgdG8Kb3JjaGVzdHJhdGUgdGhlIGhhbmRvZmY/ICBJIGd1ZXNzIHRoYXQgbWln
aHQgd29yayBmb3Igb3VyIHVzZSBjYXNlLCBhc3N1bWluZwp3aGF0ZXZlciB0aGUgc2VjdXJpdHkg
c2lkZSBvZiB0aGluZ3Mgd2FzIGRvaW5nIHdhcyBPSyB3aXRoIHRoZSBvbGQgRkQuICBUQkggSSdt
Cm5vdCBzdXJlIGhvdyBhbGwgdGhhdCB3b3JrcyBhbmQgd2hpbGUgd2UgdGhvdWdodCBhYm91dCBk
b2luZyB0aGF0IHNvcnQgb2YKdHJhbnNmZXIgc2NoZW1lIHdlIGRlY2lkZWQgdG8ganVzdCBvcGVu
IGl0IGFnYWluIC0tIG5vdCBzdXJlIGhvdyBmYXIgd2Ugd2VyZQpkb3duIHRoZSBkbS11c2VyIHJh
YmJpdCBob2xlIGF0IHRoYXQgcG9pbnQsIHRob3VnaCwgYXMgdGhpcyBzb3J0IG9mIGFyb3NlIG91
dApvZiBzb21lIG90aGVyIGlkZWFzLgoKPiAyKSBUaGUgZXh0cmEgY29weSBpcyBhIGJpZyBkZWFs
LCBpbiBmYWN0IHdlIGFscmVhZHkgaGF2ZSB0b28gbWFueSBjb3BpZXMgaW4gb3VyCj4gZXhpc3Rp
bmcgTkJEIHNldHVwIGFuZCBhcmUgYWN0aXZlbHkgbG9va2luZyBmb3Igd2F5cyB0byBhdm9pZCB0
aG9zZS4KPgo+IERvbid0IHRha2UgdGhpcyBhcyBJIGRvbid0IHRoaW5rIGRtLXVzZXIgaXMgYSBn
b29kIGlkZWEsIGJ1dCBJIHRoaW5rIGF0IHRoZSB2ZXJ5Cj4gbGVhc3QgaXQgc2hvdWxkIHN0YXJ0
IHdpdGggdGhlIHZlcnkgYmVzdCB3ZSBoYXZlIHRvIG9mZmVyLCBzdGFydGluZyB3aXRoIGFzIGZl
dwo+IGNvcGllcyBhcyBwb3NzaWJsZS4KCkkgd2FzIHJlYWxseSBleHBlcnRpbmcgc29tZW9uZSB0
byBzYXkgdGhhdC4gIEl0IGRvZXMgc2VlbSBraW5kIG9mIHNpbGx5IHRvIGJ1aWxkCm91dCB0aGUg
bmV3IGludGVyZmFjZSwgYnV0IG5vdCBnbyBhbGwgdGhlIHdheSB0byBhIHJpbmcgYnVmZmVyLiAg
V2UganVzdCBkaWRuJ3QKcmVhbGx5IGhhdmUgYW55IHdheSB0byBqdXN0aWZ5IHRoZSBleHRyYSBj
b21wbGV4aXR5IGFzIG91ciB1c2UgY2FzZXMgYXJlbid0CnRoYXQgaGlnaCBwZXJmb3JtYW5jZS4g
ICBJIGtpbmQgb2YgbGlrZSB0byBoYXZlIGJlbmNobWFya3MgZm9yIHRoaXMgc29ydCBvZgp0aGlu
ZywgdGhvdWdoLCBhbmQgSSBkaWRuJ3QgaGF2ZSBhbnlvbmUgd2hvIGhhZCBib3RoZXJlZCBhdm9p
ZGluZyB0aGUgbGFzdCBjb3B5CnRvIGNvbXBhcmUgYWdhaW5zdC4KCj4gSWYgeW91IGFyZSB1c2lu
ZyBpdCBjdXJyZW50bHkgaW4gcHJvZHVjdGlvbiB0aGVuIGNvb2wsIHRoZXJlJ3MgY2xlYXJseSBh
IHVzZWNhc2UKPiBmb3IgaXQuICBQZXJzb25hbGx5IGFzIEkgZ2V0IG9sZGVyIGFuZCBncm91Y2hp
ZXIgSSB3YW50IGxlc3MgdGhpbmdzIGluIHRoZQo+IGtlcm5lbCwgc28gaWYgdGhpcyBlbmFibGVz
IHVzIHRvIGV2ZW50dWFsbHkgZG8gZXZlcnl0aGluZyBOQkQgcmVsYXRlZCBpbgo+IHVzZXJzcGFj
ZSB3aXRoIG5vIHBlcmZvcm1hbmNlIGRyb3AgdGhlbiBJJ2QgYmUgZG93bi4gIEkgZG9uJ3QgdGhp
bmsgeW91IG5lZWQgdG8KPiBtYWtlIHRoYXQgeW91ciBwcmltYXJ5IGdvYWwsIGJ1dCBhdCBsZWFz
dCBwb2xpc2hpbmcgdGhpcyB1cCBzbyBpdCBjb3VsZAo+IHBvdGVudGlhbGx5IGJlIGFidXNlZCBp
biB0aGUgZnV0dXJlIHdvdWxkIG1ha2UgaXQgbW9yZSBjb21wZWxsaW5nIGZvciBtZXJnaW5nLgo+
IFRoYW5rcywKCllhLCBpdCdzIGluIEFuZHJvaWQgYWxyZWFkeSBhbmQgd2UnbGwgYmUgc2hpcHBp
bmcgaXQgYXMgcGFydCBvZiB0aGUgbmV3IE9UQQpmbG93IGZvciB0aGUgbmV4dCByZWxlYXNlLiAg
VGhlIHJ1bGVzIG9uIGRlcHJlY2F0aW9uIGFyZSBhIGJpdCBkaWZmZXJlbnQgb3Zlcgp0aGVyZSwg
dGhvdWdoLCBzbyBpdCdzIG5vdCBsaWtlIHdlJ3JlIHdlZCB0byBpdC4gIFRoZSB3aG9sZSBwb2lu
dCBvZiBicmluZ2luZwp0aGlzIHVwIGhlcmUgd2FzIHRvIHRyeSBhbmQgZ2V0IHNvbWV0aGluZyB1
c2FibGUgYnkgZXZlcnlvbmUsIGFuZCB3aGlsZSBJJ2QKZXZlbnR1YWxseSBsaWtlIHRvIGdldCB3
aGF0ZXZlcidzIGluIEFuZHJvaWQgaW50byB0aGUga2VybmVsIHByb3BlciB3ZSdkIHJlYWxseQpw
bGFubmVkIG9uIHN1cHBvcnRpbmcgYW4gZXh0cmEgQW5kcm9pZC1vbmx5IEFCSSBmb3IgYSBjeWNs
ZSBhdCBsZWFzdC4gIAoKSSdtIGtpbmQgb2YgaW5jbGluZWQgdG8gdGFrZSBhIGNyYWNrIGF0IHRo
ZSBleHRyYSBjb3B5LCB0byBhdCBsZWFzdCBzZWUgaWYKYnVpbGRpbmcgc29tZXRoaW5nIHRoYXQg
ZWxpbWluYXRlcyBpdCBpcyB2aWFibGUuICBJJ20gbm90IHJlYWxseSBzdXJlIGlmIGl0IGlzCihv
ciBhdCBsZWFzdCwgaWYgaXQnbGwgbmV0IHVzIGEgbWVhbmluZ2Z1bCBhbW91bnQgb2YgcGVyZm9y
bWFuY2UpLCBidXQgaXQnZCBhdApsZWFzdCBiZSBpbnRlcmVzdGluZyB0byB0cnkuCgpJdCdkIGJl
IG5pY2UgdG8gaGF2ZSBzb21lIGJlbmNobWFyayB0YXJnZXQsIHRob3VnaCwgYXMgb3RoZXJ3aXNl
IHRoaXMgc3R1ZmYKaGFuZ3Mgb24gZm9yZXZlci4gIE15IHdvcmtsb2FkcyBhcmUgaW4gc2VsZnRl
c3RzIGxhdGVyIG9uIGluIHRoZSBwYXRjaCBzZXQsIGJ1dApJJ20gZXNzZW50aWFsbHkgdXNpbmcg
dG1wZnMgYXMgYSBiYXNlbGluZSB0byBjb21wYXJlIGFnYWluc3QgZXh0NCtkbS11c2VyIHdpdGgK
c29tZSBGSU8gZXhhbXBsZXMgYXMgd29ya2xvYWRzLiAgT3VyIGVhcmx5IGJlbmNobWFyayBudW1i
ZXJzIGluZGljYXRlZCB0aGlzIHdhcwp3YXkgZmFzdGVyIHRoYW4gd2UgbmVlZGVkLCBzbyBJIGRp
ZG4ndCBldmVuIGJvdGhlciBwdXR0aW5nIHRvZ2V0aGVyIGEgcHJvcGVyCnN5c3RlbSB0byBydW4g
b24gc28gSSBkb24ndCByZWFsbHkgaGF2ZSBhbnkgbWVhbmluZ2Z1bCBudW1iZXJzIHRoZXJlLiAg
SXMgdGhlcmUKYW4gTkJEIHNlcnZlciB0aGF0J3MgZmFzdCB0aGF0IEkgc2hvdWxkIGJlIGNvbXBh
cmluZyBhZ2FpbnN0PwoKSSBoYXZlbid0IGdvdHRlbiBhIHdob2xlIGxvdCBvZiBmZWVkYmFjaywg
c28gSSdtIGluY2xpbmVkIHRvIGF0IGxlYXN0IGhhdmUgc29tZQpyZWFzb25hYmxlIHBlcmZvcm1h
bmNlIG51bWJlcnMgYmVmb3JlIGJvdGhlcmluZyB3aXRoIGEgdjIuCgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

