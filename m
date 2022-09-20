Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A07C6FA8B
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 02:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663640285;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tFvkv4PGuNVmzZwN+NB50JbOoDJBneDnvgp9dWAgjcs=;
	b=COUTItsoujJU36d6V2leCXVhmCYg7ID5cSwwrkc6JuXHK4pbDeP4wIai8JG03NsrUa10+D
	PwZ1JYDqEA+9sFH8dEqVrDA3xvP/fGM4Y2M3yQxu/jbDHiQnt9LktVT9M9FoE8jo7pH+Va
	H9qRrn5tE1fqOSp6FymUjOkaKxvDmF0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-LN5IYVQZMJqrRuE8cXFWBg-1; Mon, 19 Sep 2022 22:18:01 -0400
X-MC-Unique: LN5IYVQZMJqrRuE8cXFWBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFF271C0BC61;
	Tue, 20 Sep 2022 02:17:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 92650C16922;
	Tue, 20 Sep 2022 02:17:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 685F719465A2;
	Tue, 20 Sep 2022 02:17:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AE2419465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 02:17:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1D1E023177; Tue, 20 Sep 2022 02:17:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1567123176
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 02:17:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6CBB101A52A
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 02:17:54 +0000 (UTC)
Received: from mail1.bemta37.messagelabs.com (mail1.bemta37.messagelabs.com
 [85.158.142.112]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-xxbHvXZKOU2ZVEoaz60EMg-1; Mon, 19 Sep 2022 22:17:53 -0400
X-MC-Unique: xxbHvXZKOU2ZVEoaz60EMg-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRWlGSWpSXmKPExsViZ8ORqHtWSTP
 Z4OUnG4v1p44xW+x9N5vV4uyvqywWbRu/Mlo8XLCZ3WJtf7oDm8euXY3sHptWdbJ5vN93lS2A
 OYo1My8pvyKBNePw1EfsBau5KjZ/ncrUwPiao4uRi0NIYAujxPvmI+wQznImia8HnzB3MXICO
 dsYJeb114DYvAJ2EkdvLmECsVkEVCV+HO9lh4gLSpyc+YQFxBYVSJK4uuEuK4gtLOAjsWTpN7
 B6NgFHiXmzNrKB2CICzhJ9SyczgSxjFrjBKDFnwkEWiGV2Eq87vzCC2JwC9hJHZ08Da2AWsJB
 Y/OYgO4QtL9G8dTbYcRICihJtS/6xQ9gVEo3TDzFB2GoSV89tYp7AKDQLyX2zkIyahWTUAkbm
 VYw2SUWZ6RkluYmZObqGBga6hoamQNpQ19hAL7FKN1EvtVQ3L7+oJEPXUC+xvFgvtbhYr7gyN
 zknRS8vtWQTIzB+UopT5XYwHtj3S+8QoyQHk5IoL1edRrIQX1J+SmVGYnFGfFFpTmrxIUYZDg
 4lCV57Qc1kIcGi1PTUirTMHGAsw6QlOHiURHjZpIDSvMUFibnFmekQqVOMxhznd+7fy8yxtuH
 AXmYhlrz8vFQpcd4UBaBSAZDSjNI8uEGwFHOJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAejkjBv
 uBzQFJ7MvBK4fa+ATmECOuWGijrIKSWJCCmpBqa96Wmn1PYLl/Z8ln47TUG6zfbmvR1csw+KH
 Knousb/TC6lf7aVbNtv5zdMzlvWCtuVG6nsSnv5juXopntpbH/XM5jkPDlwvkNV89TJmUsNAv
 8evlQrr72/Ifb0Pqtv6rem/Mjdmhc7a/EdbdN/gatqOw6ETJOp096l1VObM79IecffaLmfxze
 squoICj/FZZm3+lVPUqJqxYbP3x8XCDMt19o5m/Pvv4N6OQU/2J4WH30r3+0XIp15bvU2bYbX
 0p99mCzftz+8e+F78LG5fJ4nvePi5DNNr54IuXe8fEPBIZazD77zXs6tY1iZbDk7U249myZz7
 o+FJWsfv/p7svD+dZuz2V0rNhkmXb9ltWWDEktxRqKhFnNRcSIA/di6r6wDAAA=
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-2.tower-745.messagelabs.com!1663640269!137330!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 32726 invoked from network); 20 Sep 2022 02:17:49 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
 by server-2.tower-745.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384
 encrypted SMTP; 20 Sep 2022 02:17:49 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
 by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 62EA4100199;
 Tue, 20 Sep 2022 03:17:49 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121
 [10.183.43.173])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 5609B100197;
 Tue, 20 Sep 2022 03:17:49 +0100 (BST)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Tue, 20 Sep 2022 03:17:45 +0100
Message-ID: <ddc9d252-8c19-bed3-13bf-8999a061bcd4@fujitsu.com>
Date: Tue, 20 Sep 2022 10:17:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From: =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
To: <zwisler@kernel.org>, <toshi.kani@hpe.com>, <jmoyer@redhat.com>
References: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
In-Reply-To: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
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
Cc: snitzer@redhat.com, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
 "y-goto@fujitsu.com" <y-goto@fujitsu.com>, dm-devel@redhat.com,
 =?UTF-8?B?R3UsIEppbnhpYW5nL+mhviDph5Hpppk=?= <gujx@fujitsu.com>,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgQWxsLAoKUGluZy4gSXMgdGhlcmUgYW55IGZlZWRiYWNrIGFib3V0IHRoZSBxdWVzdGlvbj8K
CkJlc3QgUmVnYXJkcywKWGlhbyBZYW5nCgpPbiAyMDIyLzkvMTYgMTQ6NTYsIFlhbmcsIFhpYW8v
5p2oIOaZkyB3cm90ZToKPiBIaSBSb3NzLCBUb3NoaSwgSmVmZiBhbmQgb3RoZXJzCj4gCj4gQWZ0
ZXIgcmVhZGluZyB0aGUga2VybmVsIHBhdGNoZXNbMV1bMl1bM10gYWJvdXQgZG0sIEkgdGhpbmsg
b25seSB0aHJlZSAKPiB0eXBlcyhsaW5lYXIsIHN0cmlwZSBhbmQgbG9nLXdyaXRlcykgb2YgZG0g
Y2FuIHN1cHBvcnQgREFYIG5vdywgcmlnaHQ/Cj4gCj4gWzFdIAo+IGh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQv
P2lkPTk4ZDgyZjQ4ZjE5ODNjZWVmNWM4ZDJmNmM4N2JmZWUyOTE4NzkwZWUgCj4gCj4gWzJdIAo+
IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRz
L2xpbnV4LmdpdC9jb21taXQvP2lkPWJlZWMyNWI0NTczYmMzMTBmNWExMmNmMzMyMDdiMjBlY2Mz
MDk0NWMgCj4gCj4gWzNdIAo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvP2lkPTg0YjIyZjgzNzhjZjQ5MzUy
NDA0M2EwYThkZDU2N2M1OGM2NDU0NmYgCj4gCj4gCj4gSW4gYWRkaXRpb24sIEkgYWxzbyBzYXcg
dGhhdCBKZWZmIGhhcyBhZGRlZCBhIGNoZWNrWzRdIGZvciB0aGUgREFYIAo+IHN1cHBvcnQgb2Yg
ZG0gaW4geGZzdGVzdHMuCj4gCj4gWzRdIAo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9mcy94ZnMveGZzdGVzdHMtZGV2LmdpdC9jb21taXQvP2lkPWZjN2IzOTAzODk0YTYyMTNjNzY1
ZDY0ZGY5MTg0N2Y0NDYwMzM2YTIgCj4gCj4gCj4gSSB3b25kZXIgd2h5IG9ubHkgdGhyZWUgdHlw
ZXMgb2YgZG0gbmVlZCB0byBzdXBwb3J0IERBWD8gSXMgdGhlcmUgYW55IAo+IHJlYXNvbi9oaXN0
b3J5IGFuZCB1c2UgY2FzZT8KPiAKPiBJcyBpdCBuZWNlc3NhcnkgdG8gbWFrZSBvdGhlciB0eXBl
cyAoZm9yIGV4YW1wbGUsIHRoaW4tcG9vbCkgc3VwcG9ydCAKPiBEQVg/IElmIG5lY2Vzc2FyeSwg
aXMgdGhlcmUgYW55IHVzZSBjYXNlIGZvciBvdGhlciB0eXBlcz8KPiAKPiBCZXN0IFJlZ2FyZHMs
Cj4gWGlhbyBZYW5nCj4gCj4gLS0gCj4gZG0tZGV2ZWwgbWFpbGluZyBsaXN0Cj4gZG0tZGV2ZWxA
cmVkaGF0LmNvbQo+IGh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwKPiAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

