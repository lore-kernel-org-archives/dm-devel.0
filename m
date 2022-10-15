Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480C7C4332F
	for <dm-devel@archiver.kernel.org>; Sat, 15 Oct 2022 08:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665822519;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gEI6oDrhMn8bKhw31dbj3NdpEIbX871mvKz3ox7fY1U=;
	b=aWGEUq/dInMl6LWDw+XyEaZyNezchhwJoEVyX13SDSun8idmHf0v6Xt4yfdlFXWMyGA5vk
	/7hgpcqUnRKNw/noiKAmTbOr5vJYEUI4huBUBQamRrckCObUXeC3SdEJ0H4EvtbCGA8ckG
	bGIli1eVCpdBHlenc68A87bdqt5Z7Co=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-kXKVdBwkPLiOmOXNe1WUOw-1; Sat, 15 Oct 2022 04:28:38 -0400
X-MC-Unique: kXKVdBwkPLiOmOXNe1WUOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FBF338145B0;
	Sat, 15 Oct 2022 08:28:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D774536BB8;
	Sat, 15 Oct 2022 08:28:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCBCB1946589;
	Sat, 15 Oct 2022 08:28:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63BA51946586
 for <dm-devel@listman.corp.redhat.com>; Sat, 15 Oct 2022 08:28:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 585D5200C0D5; Sat, 15 Oct 2022 08:28:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D583200C0CD
 for <dm-devel@redhat.com>; Sat, 15 Oct 2022 08:28:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E89E23C11ECA
 for <dm-devel@redhat.com>; Sat, 15 Oct 2022 08:28:21 +0000 (UTC)
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com
 [195.245.231.3]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-dIQBAKj3MpelVq2WOGoIXw-1; Sat, 15 Oct 2022 04:28:14 -0400
X-MC-Unique: dIQBAKj3MpelVq2WOGoIXw-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleJIrShJLcpLzFFi42Kxs+FI0pXO90o
 2uLdb3mL9qWPMFnvfzWa1OPvrKotF28avjBYPF2xmt1jbn+7A5rFrVyO7x6ZVnWwe7/ddZQtg
 jmLNzEvKr0hgzdg4+RNjQSN3xeF785gaGH9zdDFycQgJbGSUeL6hmQnCWcIksXVrGyuEs41RY
 v3P6YxdjJwcvAJ2Eue3fWEDsVkEVCWmXlrIAhEXlDg58wmYLSqQJHF1w12gZg4OYQFHic2fVU
 HCIgJKEm8mTWUGmcksMIlJYsLsbjaIBbcYJXYenQrWzAbUMG/WRrAFnAL2EsfaPoDZzAIWEov
 fHGSHsOUlmrfOZgaxJQQUJdqW/GOHsCskZs1qY4Kw1SSuntvEPIFRaBaS+2YhGTULyagFjMyr
 GM2KU4vKUot0DU30kooy0zNKchMzc/QSq3QT9VJLdctTi0t0jfQSy4v1UouL9Yorc5NzUvTyU
 ks2MQKjJqVYpX0H46dlf/QOMUpyMCmJ8mZs8UwW4kvKT6nMSCzOiC8qzUktPsQow8GhJMF7Md
 srWUiwKDU9tSItMwcYwTBpCQ4eJRFezjSgNG9xQWJucWY6ROoUoy7H+Z379zILseTl56VKifN
 W5wAVCYAUZZTmwY2AJZNLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYR5Z2UBTeHJzCuB2/QK
 6AgmoCOWnnIDOaIkESEl1cAk6zPLz7b7QM62I2WL/qvYxaaZnOys35N6c4u14oWqXz+Tf5hPk
 xC8uaD9rBP3HUkTrSWXotZ82efi91/w3LlnCXrJhxo/HqhJiBHMybmxPvTd8W1zLMxqbwZnZy
 1MXJN26fvVb4v3LLqUYCf/ZUfvFA6P34p/4q/qVZ3d8KBt6ln3E18tJnlMePTKvfPx00mzRH8
 GRhuxustEhZyPFgqqyHI4oXZFPMg5Z4L2spMO3budBR1MH23befHidnX2o7v0n0iws4jqHXbu
 mBdxgqtzr072wvqZS8TCgvZF3LOe9fx2VdrpZ66HPD+33jH7K2eyRPe/yKGzO5QWpJ/Zura7x
 zTfwWiFXodwxvctbnwhSizFGYmGWsxFxYkAFdD3/6EDAAA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-17.tower-571.messagelabs.com!1665822491!92368!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 16510 invoked from network); 15 Oct 2022 08:28:11 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
 by server-17.tower-571.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384
 encrypted SMTP; 15 Oct 2022 08:28:11 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
 by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id 37B951AC;
 Sat, 15 Oct 2022 09:28:11 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126
 [10.183.43.178])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 2A7621B0;
 Sat, 15 Oct 2022 09:28:11 +0100 (BST)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Sat, 15 Oct 2022 09:28:07 +0100
Message-ID: <37bb1a88-550d-e8b8-0f57-37df8d8fa8d8@fujitsu.com>
Date: Sat, 15 Oct 2022 16:27:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Jeff Moyer <jmoyer@redhat.com>
References: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
 <x49y1u5lxpt.fsf@segfault.boston.devel.redhat.com>
 <a04a8253-44af-11d6-f2ab-6421fe5110a8@fujitsu.com>
 <x49tu4sc26t.fsf@segfault.boston.devel.redhat.com>
From: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
In-Reply-To: <x49tu4sc26t.fsf@segfault.boston.devel.redhat.com>
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] Question about which types of dm need to support DAX
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
Cc: toshi.kani@hpe.com, snitzer@redhat.com,
 Shiyang Ruan <ruansy.fnst@fujitsu.com>,
 "y-goto@fujitsu.com" <y-goto@fujitsu.com>, dm-devel@redhat.com,
 =?UTF-8?B?R3UsIEppbnhpYW5nL+mhviA=?= =?UTF-8?B?6YeR6aaZ?= <gujx@fujitsu.com>,
 zwisler@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjAyMi85LzI3IDIyOjM4LCBKZWZmIE1veWVyIHdyb3RlOgo+ICJZYW5nLCBYaWFvL+adqCDm
mZMiIDx5YW5neC5qeUBmdWppdHN1LmNvbT4gd3JpdGVzOgo+IAo+PiBIaSBKZWZmLAo+Pgo+PiBU
aGFua3MgYSBsb3QgZm9yIHlvdXIgcmVwbHkuCj4+Cj4+IE9uIDIwMjIvOS8yNyAzOjUyLCBKZWZm
IE1veWVyIHdyb3RlOgo+Pj4gIllhbmcsIFhpYW8v5p2oIOaZkyIgPHlhbmd4Lmp5QGZ1aml0c3Uu
Y29tPiB3cml0ZXM6Cj4+Pgo+Pj4+IEhpIFJvc3MsIFRvc2hpLCBKZWZmIGFuZCBvdGhlcnMKPj4+
Pgo+Pj4+IEFmdGVyIHJlYWRpbmcgdGhlIGtlcm5lbCBwYXRjaGVzWzFdWzJdWzNdIGFib3V0IGRt
LCBJIHRoaW5rIG9ubHkgdGhyZWUKPj4+PiB0eXBlcyhsaW5lYXIsIHN0cmlwZSBhbmQgbG9nLXdy
aXRlcykgb2YgZG0gY2FuIHN1cHBvcnQgREFYIG5vdywgcmlnaHQ/Cj4+Pgo+Pj4gUmlnaHQuCj4+
Pgo+Pj4+IEkgd29uZGVyIHdoeSBvbmx5IHRocmVlIHR5cGVzIG9mIGRtIG5lZWQgdG8gc3VwcG9y
dCBEQVg/IElzIHRoZXJlIGFueQo+Pj4+IHJlYXNvbi9oaXN0b3J5IGFuZCB1c2UgY2FzZT8KPj4+
Cj4+PiBJdCB3YXMgZWFzeSB0byBhZGQgREFYIHN1cHBvcnQgdG8gdGhvc2UgdGFyZ2V0cy4gIE5v
dGUgdGhhdCBpZiBhIHRhcmdldAo+Pj4gbmVlZHMgdG8gaW50ZXJjZXB0IEkvTywgdGhlbiBpdCBp
cyBmdW5kYW1lbnRhbGx5IGluY29tcGF0aWJsZSB3aXRoIERBWC4KPj4KPj4gSG93IGNhbiBJIGtu
b3cgd2hpY2ggdGFyZ2V0IG5lZWRzIHRvIGludGVyY2VwdCBJL08/Cj4gCj4gVGhlcmUncyBubyBi
ZXR0ZXIgd2F5IHRoYW4gcmVhZGluZyBhbmQgdW5kZXJzdGFuZGluZyB3aGF0IGVhY2ggdGFyZ2V0
Cj4gZG9lcy4KCkhpIEplZmYsCgpBZnRlciByZWFkaW5nIHRoZSBjb2RlIGFib3V0IHRoaW4gcHJv
dmlzaW9uaW5nIHRhcmdldCwgdGhpbiBwcm92aXNpb25pbmcgCnRhcmdldCBkZXBlbmRzIG9uIERN
X0JVRklPIGtjb25maWcgd2hpY2ggaXMgZGVzaWduZWQgdG8gY2FjaGUgSS9PLiBJcyBpdCAKd2hh
dCB5b3Ugc2FpZCBhYm91dCAiaW50ZXJjZXB0IEkvTyI/IFBlcmhhcHMsIHdlIGhhdmUgdG8gZHJv
cCBETV9CVUZJTyAKZm9yIHRoaW4gcHJvdmlzaW9uaW5nIHRhcmdldCBpZiB3ZSB3YW50IHRvIG1h
a2UgaXQgc3VwcG9ydCBEQVguCgpCZXN0IFJlZ2FyZHMsClhpYW8gWWFuZwoKPiAKPj4gQ291bGQg
eW91IHRlbGwgbWUgd2h5IGl0IGlzIGZ1bmRhbWVudGFsbHkgaW5jb21wYXRpYmxlIHdpdGggREFY
Pwo+IAo+IERBWCBzdGFuZHMgZm9yIGRpcmVjdCBhY2Nlc3MsIGFuZCBpdCBpcyBhIG1lY2hhbmlz
bSBieSB3aGljaCBhCj4gdXNlci1zcGFjZSBwcm9jZXNzIGNhbiBwZXJmb3JtIEkvTyB3aXRob3V0
IGdvaW5nIHRocm91Z2ggdGhlIGtlcm5lbC4KPiAKPiAtSmVmZgo+IAoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

