Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0452C6FA82
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 12:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664282588;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hL7+ZQDWQYo02g/F4/2VpWTJ5jY9dNrnxOQ9syQ6PDk=;
	b=el1s4tyrPhJRceWZiCCC/jKKc3Sz3GP1INHY75x3zUEq4RJuCLcO7f012EN5/xfwr+BWv4
	WogcuJTTj+1IS/YEjNofva97bdje4B1z96iOR/fNUs3/1uaHSipPCq246awKONrh6LlCuC
	qv3FWxyQaK/PZVQ3kFOgK/C3la1y+oA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-DlzwPN5UPTOT791ZfMkoGQ-1; Tue, 27 Sep 2022 08:43:05 -0400
X-MC-Unique: DlzwPN5UPTOT791ZfMkoGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3669D299E760;
	Tue, 27 Sep 2022 12:43:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E65FF40C2065;
	Tue, 27 Sep 2022 12:43:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C295C19465B1;
	Tue, 27 Sep 2022 12:43:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E68461946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 12:42:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A35944C816; Tue, 27 Sep 2022 12:42:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B84542222
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 12:42:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7852986EB30
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 12:42:59 +0000 (UTC)
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com
 [85.158.142.2]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-98ce7s_YMcmkaLokwtNWKw-1; Tue, 27 Sep 2022 08:42:55 -0400
X-MC-Unique: 98ce7s_YMcmkaLokwtNWKw-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRWlGSWpSXmKPExsViZ8MxSffUe6N
 kg+v/rSzWnzrGbLH33WxWi7O/rrJYtG38ymjxcMFmdou1/ekObB67djWye2xa1cnm8X7fVbYA
 5ijWzLyk/IoE1oxb6wwKvrFWPJ37hL2B8QFLFyMXh5DAFkaJxoe32SCc5UwSLSvvskM42xglr
 kw/wdTFyMnBK2An8b7zOBuIzSKgKrGxbS0jRFxQ4uTMJywgtqhAksTVDXdZuxg5OIQFHCU2f1
 YFCYsIKEm8mTSVGWQms8AkJokJs7vB5ggJFElMXP8DrJcNqH7erI1gcU4Be4mnm76AzWcWsJB
 Y/OYgO4QtL9G8dTYziC0hoCjRtuQfO4RdIdE4/RAThK0mcfXcJuYJjEKzkJw3C8moWUhGLWBk
 XsVok1SUmZ5RkpuYmaNraGCga2hoqmtprmtobKmXWKWbqJdaqpuXX1SSoWuol1herJdaXKxXX
 JmbnJOil5dasokRGD0pxYndOxhX7/uld4hRkoNJSZQ39KhRshBfUn5KZUZicUZ8UWlOavEhRh
 kODiUJXre3QDnBotT01Iq0zBxgJMOkJTh4lER4774CSvMWFyTmFmemQ6ROMepynN+5fy+zEEt
 efl6qlDgvzzugIgGQoozSPLgRsKRyiVFWSpiXkYGBQYinILUoN7MEVf4VozgHo5Iw7+I3QFN4
 MvNK4Da9AjqCCegIOz59kCNKEhFSUg1Mu/6xZd2KNZt75nH9BdFjH5/r75rI4rju7fITW+vdN
 vFtvNMbf3r1ihLejXLKD/qYj+7VLOoUjL9kosOVrDftcetfCev9Z0qPSAqs3T59e5V29acDNl
 /WLbewnvvgwGLp7Ek7XPZWMh+a8rnx1aWHrerBQjHzfFVOXlFl23Al+qCX72WWjfPOrZv90Nf
 zVMF281hhUbHZ66936Vfee3XspPDkm46lb6wFxWc2dpcHtL383vPzcugX7xsrA6uWBmWstnd8
 9mdynb7p9fKVvC63Y97Narx49yH7ofA4dgH2h1km7jPbRM49veLntjTmzqHdG10mcbHeWRpqo
 Rp0hvns697c53alDL+fzn74oTzoiZwSS3FGoqEWc1FxIgC4EHX7pQMAAA==
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-13.tower-745.messagelabs.com!1664282570!17768!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 12314 invoked from network); 27 Sep 2022 12:42:50 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
 by server-13.tower-745.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384
 encrypted SMTP; 27 Sep 2022 12:42:50 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
 by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id 549171000E7;
 Tue, 27 Sep 2022 13:42:50 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121
 [10.183.43.173])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 339441000CC;
 Tue, 27 Sep 2022 13:42:50 +0100 (BST)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 27 Sep 2022 13:42:45 +0100
Message-ID: <a04a8253-44af-11d6-f2ab-6421fe5110a8@fujitsu.com>
Date: Tue, 27 Sep 2022 20:42:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Jeff Moyer <jmoyer@redhat.com>
References: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
 <x49y1u5lxpt.fsf@segfault.boston.devel.redhat.com>
From: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
In-Reply-To: <x49y1u5lxpt.fsf@segfault.boston.devel.redhat.com>
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgSmVmZiwKClRoYW5rcyBhIGxvdCBmb3IgeW91ciByZXBseS4KCk9uIDIwMjIvOS8yNyAzOjUy
LCBKZWZmIE1veWVyIHdyb3RlOgo+ICJZYW5nLCBYaWFvL+adqCDmmZMiIDx5YW5neC5qeUBmdWpp
dHN1LmNvbT4gd3JpdGVzOgo+IAo+PiBIaSBSb3NzLCBUb3NoaSwgSmVmZiBhbmQgb3RoZXJzCj4+
Cj4+IEFmdGVyIHJlYWRpbmcgdGhlIGtlcm5lbCBwYXRjaGVzWzFdWzJdWzNdIGFib3V0IGRtLCBJ
IHRoaW5rIG9ubHkgdGhyZWUKPj4gdHlwZXMobGluZWFyLCBzdHJpcGUgYW5kIGxvZy13cml0ZXMp
IG9mIGRtIGNhbiBzdXBwb3J0IERBWCBub3csIHJpZ2h0Pwo+IAo+IFJpZ2h0Lgo+IAo+PiBJIHdv
bmRlciB3aHkgb25seSB0aHJlZSB0eXBlcyBvZiBkbSBuZWVkIHRvIHN1cHBvcnQgREFYPyBJcyB0
aGVyZSBhbnkKPj4gcmVhc29uL2hpc3RvcnkgYW5kIHVzZSBjYXNlPwo+IAo+IEl0IHdhcyBlYXN5
IHRvIGFkZCBEQVggc3VwcG9ydCB0byB0aG9zZSB0YXJnZXRzLiAgTm90ZSB0aGF0IGlmIGEgdGFy
Z2V0Cj4gbmVlZHMgdG8gaW50ZXJjZXB0IEkvTywgdGhlbiBpdCBpcyBmdW5kYW1lbnRhbGx5IGlu
Y29tcGF0aWJsZSB3aXRoIERBWC4KCkhvdyBjYW4gSSBrbm93IHdoaWNoIHRhcmdldCBuZWVkcyB0
byBpbnRlcmNlcHQgSS9PPyBDb3VsZCB5b3UgdGVsbCBtZSAKd2h5IGl0IGlzIGZ1bmRhbWVudGFs
bHkgaW5jb21wYXRpYmxlIHdpdGggREFYPwoKQmVzdCBSZWdhcmRzLApYaWFvIFlhbmcKPiAKPiBD
aGVlcnMsCj4gSmVmZgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

