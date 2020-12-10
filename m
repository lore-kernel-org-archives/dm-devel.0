Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A82BC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 17:03:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB35B230FC
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 17:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB35B230FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-4IkzAw9iM4WxYcdm9abrUQ-1; Thu, 10 Dec 2020 12:03:39 -0500
X-MC-Unique: 4IkzAw9iM4WxYcdm9abrUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 621AF803635;
	Thu, 10 Dec 2020 17:03:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75A9C6A252;
	Thu, 10 Dec 2020 17:03:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50CA0180954D;
	Thu, 10 Dec 2020 17:03:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BAH3Um9000700 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 12:03:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EDE4BDAF09; Thu, 10 Dec 2020 17:03:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7766DAF10
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 17:03:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2FC785828C
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 17:03:27 +0000 (UTC)
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com
	[209.85.222.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-64-HQhdRLPaPPy0a1SH3uJ8XQ-1; Thu, 10 Dec 2020 12:03:25 -0500
X-MC-Unique: HQhdRLPaPPy0a1SH3uJ8XQ-1
Received: by mail-qk1-f194.google.com with SMTP id 19so5434320qkm.8
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 09:03:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=sUTklf9jBEwzs6UhWeShzolt35srKpXJ+Aec/2jQSUU=;
	b=kdQv8I07MsZm2mtsx8sY0vbpWUOiTr24FuQWHr1q62ux/S6zwzveG0fwW5MWpXWQz9
	FQ4w0YL9vClasfRUvmkUm4Q1lc4HM3Z1i+6gMuVF6Q7jXCl/lEd+PcZLEIwQfmbiOn9b
	Ii9ZErk8/7SwQaByCM1bKXzMiJpCsTH34EfpW234xyAzq179qds0LXMBfoi6WH+IBVmn
	A45jXQ1gkgqoD+f/uDMCoKcFVOYFAyjpYh++lEbeesoaScrzrsTHPxr+q5rjZlq1zmmf
	3h2+ZGmWcEfyIO/wBeo8lOAJDs61kE+oCuL7UFOHZ9C+54EV+dPYvt2EEE8LmBRvc94/
	f9ug==
X-Gm-Message-State: AOAM533LnWWJkhDVlRcozIJv4zBrjBh03k1CyJAq3IO7HGpLikRJf45S
	JDQHaUfhJkegoBMLnvK0GEC3LPVShM6G51Zl
X-Google-Smtp-Source: ABdhPJymXAQH/aw0VSr4+J5MsG5kd52DH5BGq1ZaXwLD+lvifpGCtkGDCg1EXTpttoD9CP3doaPF0g==
X-Received: by 2002:a37:bac7:: with SMTP id
	k190mr10524292qkf.464.1607619804657; 
	Thu, 10 Dec 2020 09:03:24 -0800 (PST)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com.
	[174.109.172.136]) by smtp.gmail.com with ESMTPSA id
	y22sm3789944qkj.129.2020.12.10.09.03.23
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 10 Dec 2020 09:03:23 -0800 (PST)
To: Bart Van Assche <bvanassche@acm.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Christoph Hellwig <hch@infradead.org>
References: <mhng-97fc5874-29d0-4d9e-8c92-d3704a482f28@palmerdabbelt-glaptop1>
	<6fb5be2d-c6ca-c21b-dddf-9b314973dcfe@acm.org>
From: Josef Bacik <josef@toxicpanda.com>
Message-ID: <30d39293-80a4-9ef5-92bb-6b6dec464be3@toxicpanda.com>
Date: Thu, 10 Dec 2020 12:03:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <6fb5be2d-c6ca-c21b-dddf-9b314973dcfe@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, linux-doc@vger.kernel.org, shuah@kernel.org,
	corbet@lwn.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
	Mike Christie <michael.christie@oracle.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvOS8yMCAxMDozOCBQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgo+IE9uIDEyLzcvMjAg
MTA6NTUgQU0sIFBhbG1lciBEYWJiZWx0IHdyb3RlOgo+PiBBbGwgaW4gYWxsLCBJJ3ZlIGZvdW5k
IGl0IGEgYml0IGhhcmQgdG8gZmlndXJlIG91dCB3aGF0IHNvcnQgb2YgaW50ZXJlc3QKPj4gcGVv
cGxlCj4+IGhhdmUgaW4gZG0tdXNlcjogd2hlbiBJIGJyaW5nIHRoaXMgdXAgSSBzZWVtIHRvIHJ1
biBpbnRvIHBlb3BsZSB3aG8ndmUgZG9uZQo+PiBzaW1pbGFyIHRoaW5ncyBiZWZvcmUgYW5kIGFy
ZSB2YWd1ZWx5IGludGVyZXN0ZWQsIGJ1dCBjZXJ0YWlubHkgbm9ib2R5IGlzCj4+IGNob21waW5n
IGF0IHRoZSBiaXQuwqAgSSdtIHNlbmRpbmcgaXQgb3V0IGluIHRoaXMgZWFybHkgc3RhdGUgdG8g
dHJ5IGFuZAo+PiBmaWd1cmUKPj4gb3V0IGlmIGl0J3MgaW50ZXJlc3RpbmcgZW5vdWdoIHRvIGtl
ZXAgZ29pbmcuCj4gCj4gQ2MtaW5nIEpvc2VmIGFuZCBNaWtlIHNpbmNlIHRoZWlyIG5iZCBjb250
cmlidXRpb25zIG1ha2UgbWUgd29uZGVyCj4gd2hldGhlciB0aGlzIG5ldyBkcml2ZXIgY291bGQg
YmUgdXNlZnVsIHRvIHRoZWlyIHVzZSBjYXNlcz8KPiAKClNvcnJ5IGdtYWlsK2ltYXAgc3Vja3Mg
YW5kIEkgY2FuJ3QgZ2V0IG15IGVtYWlsIGNsaWVudCB0byBnZXQgYXQgdGhlIG9yaWdpbmFsIAp0
aHJlYWQuICBIb3dldmVyIGhlcmUgaXMgbXkgdGFrZS4KCjEpIFRoZSBhZHZhbnRhZ2VzIG9mIHVz
aW5nIGRtLXVzZXIgb2YgTkJEIHRoYXQgeW91IGxpc3RlZCBhcmVuJ3QgYWN0dWFsbHkgCnByb2Js
ZW1zIGZvciBOQkQuICBXZSBoYXZlIE5CRCB3b3JraW5nIGluIHByb2R1Y3Rpb24gd2hlcmUgeW91
IGNhbiBoYW5kIG9mZiB0aGUgCnNvY2tldHMgZm9yIHRoZSBzZXJ2ZXIgd2l0aG91dCBlbmRpbmcg
aW4gdGltZW91dHMsIGl0IHdhcyBhY3R1YWxseSB0aGUgbWFpbiAKcmVhc29uIHdlIHdyb3RlIG91
ciBvd24gc2VydmVyIHNvIHdlIGNvdWxkIHVzZSB0aGUgRkQgdHJhbnNmZXIgc3R1ZmYgdG8gcmVz
dGFydCAKdGhlIHNlcnZlciB3aXRob3V0IGltcGFjdGluZyBhbnkgY2xpZW50cyB0aGF0IGhhZCB0
aGUgZGV2aWNlIGluIHVzZS4KCjIpIFRoZSBleHRyYSBjb3B5IGlzIGEgYmlnIGRlYWwsIGluIGZh
Y3Qgd2UgYWxyZWFkeSBoYXZlIHRvbyBtYW55IGNvcGllcyBpbiBvdXIgCmV4aXN0aW5nIE5CRCBz
ZXR1cCBhbmQgYXJlIGFjdGl2ZWx5IGxvb2tpbmcgZm9yIHdheXMgdG8gYXZvaWQgdGhvc2UuCgpE
b24ndCB0YWtlIHRoaXMgYXMgSSBkb24ndCB0aGluayBkbS11c2VyIGlzIGEgZ29vZCBpZGVhLCBi
dXQgSSB0aGluayBhdCB0aGUgdmVyeSAKbGVhc3QgaXQgc2hvdWxkIHN0YXJ0IHdpdGggdGhlIHZl
cnkgYmVzdCB3ZSBoYXZlIHRvIG9mZmVyLCBzdGFydGluZyB3aXRoIGFzIGZldyAKY29waWVzIGFz
IHBvc3NpYmxlLgoKSWYgeW91IGFyZSB1c2luZyBpdCBjdXJyZW50bHkgaW4gcHJvZHVjdGlvbiB0
aGVuIGNvb2wsIHRoZXJlJ3MgY2xlYXJseSBhIHVzZWNhc2UgCmZvciBpdC4gIFBlcnNvbmFsbHkg
YXMgSSBnZXQgb2xkZXIgYW5kIGdyb3VjaGllciBJIHdhbnQgbGVzcyB0aGluZ3MgaW4gdGhlIApr
ZXJuZWwsIHNvIGlmIHRoaXMgZW5hYmxlcyB1cyB0byBldmVudHVhbGx5IGRvIGV2ZXJ5dGhpbmcg
TkJEIHJlbGF0ZWQgaW4gCnVzZXJzcGFjZSB3aXRoIG5vIHBlcmZvcm1hbmNlIGRyb3AgdGhlbiBJ
J2QgYmUgZG93bi4gIEkgZG9uJ3QgdGhpbmsgeW91IG5lZWQgdG8gCm1ha2UgdGhhdCB5b3VyIHBy
aW1hcnkgZ29hbCwgYnV0IGF0IGxlYXN0IHBvbGlzaGluZyB0aGlzIHVwIHNvIGl0IGNvdWxkIApw
b3RlbnRpYWxseSBiZSBhYnVzZWQgaW4gdGhlIGZ1dHVyZSB3b3VsZCBtYWtlIGl0IG1vcmUgY29t
cGVsbGluZyBmb3IgbWVyZ2luZy4gClRoYW5rcywKCkpvc2VmCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

