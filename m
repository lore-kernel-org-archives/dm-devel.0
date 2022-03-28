Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52911C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Mar 2022 18:19:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-OxH9QqDeN9aXir1ZdQB0KA-1; Mon, 28 Mar 2022 14:19:29 -0400
X-MC-Unique: OxH9QqDeN9aXir1ZdQB0KA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC0F529AA388;
	Mon, 28 Mar 2022 18:19:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6506C2166B3F;
	Mon, 28 Mar 2022 18:19:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 294BB1949762;
	Mon, 28 Mar 2022 18:19:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7ACAA1947BBF
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 17:57:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A87F1402648; Mon, 28 Mar 2022 17:57:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 668F31402642
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 17:57:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D9C52999B31
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 17:57:27 +0000 (UTC)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-4NPxqkgxNu-qsLNtXIzH6Q-1; Mon, 28 Mar 2022 13:57:25 -0400
X-MC-Unique: 4NPxqkgxNu-qsLNtXIzH6Q-1
Received: by mail-wm1-f43.google.com with SMTP id h16so8877208wmd.0;
 Mon, 28 Mar 2022 10:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=2kO6T2ASQuCjJOXEVRYDHjlJQNO/rWgpbSWJAf3YKg0=;
 b=w2pBA3yW4BIo6q+YfQYPKKCKQEartPGxVRG0UeYtkQGTMSKV8DfwuLOGwAfyFEDpiK
 bMpX01eR5uM1gTYXMyN8WGoA2XtRWSM2rn+8gCsZNNb8YaMqE9dkiWgaO4k2vWAALIws
 X3BflmYRq4LGmAOVAus3+PTHyXW8roQtfu73K5Z7eR2dOKSXlTmRJA58KaatN2QGccF2
 fDHzkWynvvjTRJt8hjzkGB8Ki455JZ/NdUtOb3VHvKR+0sYsQFKlpu0NEX4sRSCUFc8G
 u5LeXeQP7RKd3MYf579P3tp/wxpsen/gt6x/i9HNfrbDq0q/N/wfmsBAHcwPbeU0ze1g
 vLhA==
X-Gm-Message-State: AOAM532EgX41j9Qi+B/5ihwV2a7hmvAW8CjJkihAFc8PJpXscRT0rPp7
 T2vUafXCqo1uDGhFMVDHUg==
X-Google-Smtp-Source: ABdhPJyuzg6d9AjY7ke/i24yES0KooEAZfG6AO6s7Jc/8Ybim756ti8u5gjEhHKpO5e4XJ+KeJL8oA==
X-Received: by 2002:a7b:c541:0:b0:38c:b0ed:31c4 with SMTP id
 j1-20020a7bc541000000b0038cb0ed31c4mr445924wmk.141.1648490243904; 
 Mon, 28 Mar 2022 10:57:23 -0700 (PDT)
Received: from localhost (136.red-176-87-3.dynamicip.rima-tde.net.
 [176.87.3.136]) by smtp.gmail.com with ESMTPSA id
 n37-20020a05600c3ba500b0038cc9d6ff5bsm172621wms.4.2022.03.28.10.57.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 28 Mar 2022 10:57:23 -0700 (PDT)
Message-ID: <9bdd8437-741b-ff0c-068c-9d8cf211fff0@gmail.com>
Date: Mon, 28 Mar 2022 19:57:21 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20220328170404.8565-1-xose.vazquez@gmail.com>
 <5187f68e1a6595d47d10a05ea01931e1ce8cad27.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <5187f68e1a6595d47d10a05ea01931e1ce8cad27.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] multipath-tools: add basic info on how to
 use multipath-tools with NVMe devices
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yOC8yMiAxOTo0OCwgTWFydGluIFdpbGNrIHdyb3RlOgo+IE9uIE1vbiwgMjAyMi0wMy0y
OCBhdCAxOTowNCArMDIwMCwgWG9zZSBWYXpxdWV6IFBlcmV6IHdyb3RlOgo+PiBDYzogTWFydGlu
IFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cj4+IENjOiBCZW5qYW1pbiBNYXJ6aW5za2kgPGJtYXJ6
aW5zQHJlZGhhdC5jb20+Cj4+IENjOiBDaHJpc3RvcGhlIFZhcm9xdWkgPGNocmlzdG9waGUudmFy
b3F1aUBvcGVuc3ZjLmNvbT4KPj4gQ2M6IERNLURFVkVMIE1MIDxkbS1kZXZlbEByZWRoYXQuY29t
Pgo+PiBTaWduZWQtb2ZmLWJ5OiBYb3NlIFZhenF1ZXogUGVyZXogPHhvc2UudmF6cXVlekBnbWFp
bC5jb20+Cj4+IC0tLQo+PiAgwqBSRUFETUUubnZtZSB8IDEyICsrKysrKysrKysrKwo+PiAgwqAx
IGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQo+PiAgwqBjcmVhdGUgbW9kZSAxMDA2NDQg
UkVBRE1FLm52bWUKPiAKPiBXaHkgYW5vdGhlciBzZXBhcmF0ZSBSRUFETUUgd2l0aCBqdXN0IDEy
IGxpbmVzPwo+IAo+IE1hcnRpbgoKUkVBRE1FLm1kIGlzIGludGVuZGVkIG11bHRpcGF0aC10b29s
cyBkZXZlbG9wZXJzLgpBbmQgUkVBRE1FLmFsdWEgYW5kIFJFQURNRS5udm1lIGFyZSBmb3Igc3lz
YWRtaW5zLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0
cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

