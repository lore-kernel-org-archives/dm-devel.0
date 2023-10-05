Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C791E92FF2
	for <dm-devel@archiver.kernel.org>; Fri,  6 Oct 2023 06:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696575572;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mRMRPGBFYmkG7o4+p27jmCBtdIs73ZM0SWr9Fd1GP28=;
	b=X+c6zbSv9HAmu4+fputNTF1xpnaJ15sIUkLx8pPmkkHnqu/TFZ5cVIhiDp84KX7/5vO54b
	8z4sb+AWSRt8kEndj+OeGa9l8VjOQo5M6/IXIrfVKnlIccrjCCivCLwBnstKFTticY2B4e
	+/MxZyPKFowK8zjws7IshT4l0V8kh+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-E5RKb62yMPevb--tUo_Q1Q-1; Fri, 06 Oct 2023 02:59:29 -0400
X-MC-Unique: E5RKb62yMPevb--tUo_Q1Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66271185AD45;
	Fri,  6 Oct 2023 06:59:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5295043532A;
	Fri,  6 Oct 2023 06:59:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6C44194658F;
	Fri,  6 Oct 2023 06:59:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D414F194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 17:15:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A98C940D1CA; Thu,  5 Oct 2023 17:15:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A1C3B492B16
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 17:15:47 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85AEB185A79C
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 17:15:47 +0000 (UTC)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-rg_4YjxvOeiTEn9LyhZE8w-1; Thu, 05 Oct 2023 13:15:45 -0400
X-MC-Unique: rg_4YjxvOeiTEn9LyhZE8w-1
Received: by mail-lf1-f52.google.com with SMTP id
 2adb3069b0e04-5041d6d8b10so1617761e87.2
 for <dm-devel@redhat.com>; Thu, 05 Oct 2023 10:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696526144; x=1697130944;
 h=content-transfer-encoding:content-language:cc:to:subject:from
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=CnzOVAYxsodjctC05aqml+twu9UDVsuakS0jGmFKSgg=;
 b=v2IZVcOQniM91/pAkSL3xPTeNYSbY9YGSNhdZ7+9eJP6NQ509e10sly4PjnZBH3pnQ
 G12dL8GEmr7PByXvC4vMIKRH6UEsaR4knwk1bTtK1ehlTAwAowECQwFYFwLl6DdBSqB+
 ii91Slp1Tez23cqiu321QZUg6/u2Svqi/eb70DsAqqAH+JhzwBGhLe+pJIKZ/kbb6Si7
 WiZNbLQaER2y9yxwihj4ablO5xi1xznMn5NTOFxTStAcnElrq+FgScXeisSmrgUWFxTr
 tpNHi3vGSIRw4hDgEkti/AOgr9np4uk+Mmte/Hbp1zoXDWvfte52N1TVYPOFfZne7SZu
 IAIw==
X-Gm-Message-State: AOJu0YwM/djGos6+m5ZcdN6pbUs6q+7PENxFDMEQHMhRa31QgVvJyCRR
 k03bZORx38s4wuOjSrt8HSg=
X-Google-Smtp-Source: AGHT+IGWIZN6tRvq2iK5UJGyhn5SyW7cCbcnJve+ssV6Vm3nSGmoNM3mEIzInHl7x7+t6TvnVVh3nA==
X-Received: by 2002:a05:6512:114d:b0:500:79f7:1738 with SMTP id
 m13-20020a056512114d00b0050079f71738mr5822724lfg.17.1696526144024; 
 Thu, 05 Oct 2023 10:15:44 -0700 (PDT)
Received: from [192.168.0.9] (88-114-1-11.elisa-laajakaista.fi. [88.114.1.11])
 by smtp.gmail.com with ESMTPSA id
 n15-20020ac2490f000000b004fe2de20d88sm365031lfi.232.2023.10.05.10.15.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 05 Oct 2023 10:15:43 -0700 (PDT)
Message-ID: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
Date: Thu, 5 Oct 2023 20:15:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: =?UTF-8?Q?Tatu_Heikkil=c3=a4?= <tatu.heikkila@gmail.com>
To: herbert@gondor.apana.org.au
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 06 Oct 2023 06:59:25 +0000
Subject: [dm-devel] (Bisected) Accessing opened Bitlocker partition leads to
 memory fault and kernel panic on Imac8, 1
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGVsbG8sCkkgdGhpbmsgeW91IGFuZCB0aGUgbGlzdHMgYXJlIHJpZ2h0IHJlY2lwaWVudHMsIGZv
cmdpdmUgbWUgaWYgbm90LCBJJ3ZlIApuZXZlciByZXBvcnRlZCBrZXJuZWwgYnVncyBiZWZvcmUu
IE5haXZlbHkgdGhpcyBzZWVtcyBhIGNyeXB0byBpc3N1ZSBhbmQgCkhlcmJlcnQgWHUgZnJvbSBj
cnlwdG8gbWFpbnRhaW5lcnMgbWFkZSB0aGUgYnVnZ3kgY29tbWl0LCBidXQgaXQgZWRpdHMgCmRy
aXZlcnMvbWQvZG1fY3J5cHQuYyBtYWludGFpbmVkIGJ5IGRtLWRldmVsIHBlb3BsZSBwZXIgTUFJ
TlRBSU5FUlMsIHNvIApJJ20gZ29pbmcgYnkgdGhhdC4KCkF0IHRoZSBjZW50ZXIgb2YgdGhlIGlz
c3VlIGlzIG15IEltYWM4LDEgYW5kIGFuIGV4dGVybmFsIDJUQiBTU0Qgd2l0aCA1IApwYXJ0aXRp
b25zOiBhbiBFRkkrTUJSIHBvcnRhYmxlIEFyY2ggTGludXggaW5zdGFsbCB3aXRoIExVS1MgZW5j
cnlwdGVkIApleHQ0IC9ob21lLCBhbmQgYSAxLjdUQiBleEZBVCBlbmNyeXB0ZWQgd2l0aCBCaXRs
b2NrZXIuCgpNb3VudGluZyB0aGUgTFVLUyBwYXJ0aXRpb24gd29ya3MgZmluZSBvbiBhbGwgbXkg
NCBjb21wdXRlcnMgKEltYWM4LDEsIApJbWFjMTIsMiwgdHdvIGdlbmVyaWMgSW50ZWxzOyBGZWRv
cmEncyBHTk9NRSBndmZzIHZvbHVtZSBtb25pdG9yIG9mdGVuIApjcmFzaGVzIG9uIG1vdW50IHVz
aW5nIHRoaXMgZHJpdmUpLCBhbmQgbW91bnRpbmcgdGhlIEJpdGxvY2tlciBwYXJ0aXRpb24gCndv
cmtzIG9uIGFsbCBvdGhlciBjb21wdXRlcnMsIGJ1dCBteSBJbWFjOCwxLiBPbiBteSBvdGhlciBj
b21wdXRlcnMsIEkgCmNhbiBib290IGludG8gdGhlIHBvcnRhYmxlIGluc3RhbGwgd2hpY2ggYXV0
b21vdW50cyB0aGUgQml0bG9ja2VyIApwYXJ0aXRpb24gZmluZS4gSG93ZXZlciwgb24gbXkgSW1h
YzgsMSwgcmVnYXJkbGVzcyBpZiBJIGJvb3QgaW50byB0aGUgCmV4dGVybmFsIGRyaXZlJ3MgcG9y
dGFibGUgQXJjaCBMaW51eCBpbnN0YWxsLCBvciB1c2UgdGhlIEltYWMncyBvd24gCmludGVybmFs
IERlYmlhbiB0ZXN0aW5nIGluc3RhbGwsIGFueSBwb3N0LTYuNCBrZXJuZWwgcmVsaWFibHkgcGFu
aWNzIAooNTArIHRpbWVzIHNvIGZhciwgMTAwJSBvZiB0aGUgdGltZSkgd2hlbiBhY2Nlc3Npbmcg
dGhlIHVubG9ja2VkIApCaXRsb2NrZXIgdm9sdW1lOgoKIyBjcnlwdHNldHVwIG9wZW4gL2Rldi9z
ZGI1IC0tdHlwZSBiaXRsayBjcnVjaWFsCkVudGVyIHBhc3NwaHJhc2UgZm9yIC9kZXYvc2RiNToK
IyBtb3VudCAvZGV2L21hcHBlci9jcnVjaWFsIHRlbXAgW2tlcm5lbCBpbW1lZGlhdGVseSBwYW5p
Y3MgaWYgSSB0cnkgdG8gCnRhYi1jb21wbGV0ZSB0aGUgbW91bnQgcG9pbnQsIG1ha2luZyB0aGUg
c2hlbGwgYWxzbyBhY2Nlc3MgdGhlIGRlY3J5cHRlZCAKZGV2aWNlIEkgYXNzdW1lLCBvciB0cnkg
dG8gcnVuIHRoZSBjb21tYW5kXQoKSSBvcmlnaW5hbGx5IHJhbiBpbnRvIHRoaXMgd2hlbiBtb3Vu
dGluZyB1c2luZyBYRkNFJ3MgVGh1bmFyIAppbXBsZW1lbnRhdGlvbi4gVXNpbmcgaXQsIHRoZSBt
b3VudCBmYWlscyB3aXRoICJPcGVyYXRpb24gd2FzIGNhbmNlbGxlZCIgCmFuZCB0aGUgc3lzdGVt
IGNyYXNoZXMgd2l0aGluIGEgbWludXRlLgoKR2l0IGJpc2VjdCBsZWFkIG1lIHRvOgojIGZpcnN0
IGJhZCBjb21taXQ6IFtlMzAyMzA5NGRmZmI0MTU0MDMzMGZiMGM3NGNkM2EwMTljZDUyNWMyXSBk
bSBjcnlwdDogCkF2b2lkIHVzaW5nIE1BWF9DSVBIRVJfQkxPQ0tTSVpFCgpJZiBJIGdpdCByZXZl
cnQgZTMwMjMwOTRkZmZiNDE1NDAzMzBmYjBjNzRjZDNhMDE5Y2Q1MjVjMiBvbiBjdXJyZW50IApM
aW51cycgZ2l0IG1hc3RlciwgdGhlIGlzc3VlIGdvZXMgYXdheS4gU28gSSdtIHBlcnNvbmFsbHkg
bm90IGFsbCB0aGF0IAphZmZlY3RlZCBhbnltb3JlIChpZiBJJ20gcmVhZHkgdG8gY29tcGlsZSBt
eSBrZXJuZWxzIGZyb20gbm93IG9uKSwgYW5kIEkgCnVuZGVyc3RhbmQgdGhhdCB5b3UgaGF2ZSBu
byBjbGVhciB3YXkgdG8gcmVwcm9kdWNlIHRoaXMgYXMgaXQgc2VlbXMgCnN0cm9uZ2x5IGJvdW5k
IHRvIGhhcmR3YXJlLCBidXQgc2VlbXMgbGlrZSB0aGlzIGNvdWxkIHBvaW50IHRvIGEgCnBvdGVu
dGlhbGx5IHNlcmlvdXMgc2VjdXJpdHkgaXNzdWUgc2luY2UgaXQgaW52b2x2ZXMgYm90aCBjcnlw
dG8gYW5kIAp1bmRlZmluZWQgYmVoYXZpb3VyLgoKS2R1bXAgZG1lc2cgbG9ncyAodGhlIGVycm9y
IG91dHB1dCBpcyBub3QgY29tcGxldGVseSBjb25zaXN0ZW50IGJldHdlZW4gCnBhbmljcykgJiAu
Y29uZmlnIGNhbiBiZSBmb3VuZCBpbiBhIGR1bW15IEJ1Z3ppbGxhIHJlcG9ydCAKaHR0cHM6Ly9i
dWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTc5ODIKClBsZWFzZSBsZXQgbWUg
a25vdyBpZiBJIGNhbiBoZWxwIHlvdSBpbiBhbnkgd2F5LiBJIGRvbid0IG1pbmQgdXNpbmcgdGhp
cyAKYXMgYSBnYXRld2F5IHRvIGxlYXJuIG1vcmUgYWJvdXQga2VybmVsIGRlYnVnZ2luZyBldGMu
CgpCZXN0IHJlZ2FyZHMsClRhdHUgSGVpa2tpbMOkCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

