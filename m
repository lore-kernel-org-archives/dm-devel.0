Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6BFCCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119155;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Bo5ngE0aOnzhS/NPxDKfTCjVeDD0YYQW/tL5FitCyrE=;
	b=Sk6KgntjpKyDne0kKycfT1X+0wb+43dg8kv98/e0sdwGiFswe7SR6obdkJigahHhkfpjM6
	cgY5guhl2peO6ZuqgLWY1EykkFERX2Iv/8VTzkQ4RmmyEY9M8p89wX/DtKNL3R5X0jdBFl
	DKWlDg0CXbm8vTOC6btf2rudCuy4mic=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-e1bojPTiPiinK3Av5Cbkag-1; Wed, 06 Jul 2022 10:52:32 -0400
X-MC-Unique: e1bojPTiPiinK3Av5Cbkag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D3AB80D08D;
	Wed,  6 Jul 2022 14:52:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AFE018EC9;
	Wed,  6 Jul 2022 14:52:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABD93194706D;
	Wed,  6 Jul 2022 14:52:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 29DF51947042
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Jul 2022 19:37:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B3CF40D1B97; Sat,  2 Jul 2022 19:37:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0751540C124A
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:37:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E36558001EA
 for <dm-devel@redhat.com>; Sat,  2 Jul 2022 19:37:56 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr
 [80.12.242.130]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 us-mta-550-go0uPLYFPiyCbLnjhyd3Xg-1; Sat, 02 Jul 2022 15:37:54 -0400
X-MC-Unique: go0uPLYFPiyCbLnjhyd3Xg-1
Received: from [192.168.1.18] ([90.11.190.129]) by smtp.orange.fr with ESMTPA
 id 7iwCoALuLgNxB7iwCosqC6; Sat, 02 Jul 2022 21:37:53 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 02 Jul 2022 21:37:53 +0200
X-ME-IP: 90.11.190.129
Message-ID: <39e65450-eea6-8498-1dcc-a40699b49457@wanadoo.fr>
Date: Sat, 2 Jul 2022 21:37:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Newsgroups: gmane.linux.kernel.janitors, gmane.linux.kernel.device-mapper.devel,
 gmane.linux.kernel
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <56a3cb896ec446ca24e4756042d9f0829afc671a.1656785856.git.christophe.jaillet@wanadoo.fr>
 <YsCVW5Dt3YcE3TLL@smile.fi.intel.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YsCVW5Dt3YcE3TLL@smile.fi.intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 2/4] fs/ntfs3: Rename bitmap_size() as
 ntfs3_bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, yury.norov@gmail.com, gor@linux.ibm.com,
 linux@rasmusvillemoes.dk, hca@linux.ibm.com, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, vneethv@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

TGUgMDIvMDcvMjAyMiDDoCAyMDo1OCwgQW5keSBTaGV2Y2hlbmtvIGEgw6ljcml0wqA6Cj4gT24g
U2F0LCBKdWwgMDIsIDIwMjIgYXQgMDg6Mjk6MjdQTSArMDIwMCwgQ2hyaXN0b3BoZSBKQUlMTEVU
IHdyb3RlOgo+PiBJbiBvcmRlciB0byBpbnRyb2R1Y2UgYSBiaXRtYXBfc2l6ZSgpIGZ1bmN0aW9u
IGluIHRoZSBiaXRtYXAgQVBJLCB3ZSBoYXZlCj4+IHRvIHJlbmFtZSBmdW5jdGlvbnMgd2l0aCBh
IHNpbWlsYXIgbmFtZS4KPiAKPiAuLi4KPiAKPj4gICAvKiBOVEZTIHVzZXMgcXVhZCBhbGlnbmVk
IGJpdG1hcHMuICovCj4+IC1zdGF0aWMgaW5saW5lIHNpemVfdCBiaXRtYXBfc2l6ZShzaXplX3Qg
Yml0cykKPj4gK3N0YXRpYyBpbmxpbmUgc2l6ZV90IG50ZnMzX2JpdG1hcF9zaXplKHNpemVfdCBi
aXRzKQo+PiAgIHsKPj4gICAJcmV0dXJuIEFMSUdOKChiaXRzICsgNykgPj4gMywgOCk7Cj4gCj4g
SXQgd291bGQgYmUgZWFzaWVyIHRvIHVuZGVyc3RhbmQgaW4gYSB3YXkKPiAKPiAJcmV0dXJuIEJJ
VFNfVE9fQllURVMoQUxJR04oYml0cywgNjQpKTsKClRoaXMgcHVycG9zZSBvZiB0aGUgcGF0Y2gg
d2FzIG9ubHkgdG8gcmVuYW1lIGEgZnVuY3Rpb24sIG5vdCB0byBtb2RpZnkgCnRoZSBjb2RlIGl0
c2VsZiwgZXZlbiBpZiBib3RoIHZlcnNpb24gYWxzbyBsb29rcyBlcXVpdmFsZW50IHRvIG1lLgoK
U28gSSdsbCBsZWF2ZSBpdCB0byB5b3Ugb3IgYW55b25lIGVsc2UgdG8gY2hhbmdlIGl0LgoKQ0oK
Cj4gCj4+ICAgfQo+IAoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

