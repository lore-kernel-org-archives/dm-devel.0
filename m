Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F9BC77B7A
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685459707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=V+m0ANp2vzISCyUpgYPs52jwhVp1auLbq0L+LtDQfBQ=;
	b=IifEmiPUvL9VD8dxgKNwuQMSNbBszCh8xNXBG2LQ8fX+1bGfM/4xl2jouhVSPmhVZ4n7vu
	VgknHg6ExGTZAOKrTrs2FCpx44hDP/GJBDPTnCPvZIqwL+0fyAIo0998jQhf4CgcSpxpzf
	yZmi7Wx61OYw18iylb4rq9/qe0YC+5E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-2vhl7HCwPeyU6kKTn2Jd9g-1; Tue, 30 May 2023 11:15:03 -0400
X-MC-Unique: 2vhl7HCwPeyU6kKTn2Jd9g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E082C8028B1;
	Tue, 30 May 2023 15:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF628492B0A;
	Tue, 30 May 2023 15:14:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC06F19465A0;
	Tue, 30 May 2023 15:14:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF98F1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 15:14:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE95440CFD4A; Tue, 30 May 2023 15:14:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6C2640CFD48
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:14:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 767423C13518
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:14:56 +0000 (UTC)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-2HI012HiPoq5yJcOUAGLbQ-1; Tue, 30 May 2023 11:14:50 -0400
X-MC-Unique: 2HI012HiPoq5yJcOUAGLbQ-1
Received: by mail-io1-f46.google.com with SMTP id
 ca18e2360f4ac-760dff4b701so23852439f.0
 for <dm-devel@redhat.com>; Tue, 30 May 2023 08:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685459689; x=1688051689;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tp/ySIwwm4tl/YIed7+PvRfuzdgg1UhCSe2CIK+Ly+s=;
 b=MkCDHH6gUqwFi8ZIioY2nFIV5OMdsUdXlEn4hCPxBbjdJv3p7jJ1SuZIIplxxRmwIK
 dGsXHJ2ffQv+oXz2AL/xyZE12QeWqDgMZulJfHC7bgJ0sFMInJL1FLWV8m02WeRiKUR4
 /2xTgJhA2250hYZSJ/bFFOlYc/O8L/v+kj3IGQPFFk4OplZW3bN53a2w77hjAa+Rg2Cm
 C4vEbkoZwWA5rySdR72y7wAFZouuSPon3k35s2vmCorlLLqOQT5cjEq2ZLNDitxwGT6K
 j1AR2Q0RTfMBJpaNvjKQPtbGGxa9RYBtVmQ36DMA+TfEU8YV84QyX44IBDyv4aukmmM/
 MTQw==
X-Gm-Message-State: AC+VfDz+D/lAlqrlfhUU+OYl0g1qao+I4iFhrUhyMytE/QLu9QvTRmYN
 oN6qSVfsGZhXLh4MFskw4bjuFA==
X-Google-Smtp-Source: ACHHUZ5N9fZwp0C4udilf2wbvP/vXNdHUtnkR6kuIJ7hXoCHV8PblKq9G6f5VgAxs1O6gmhEp8JA/Q==
X-Received: by 2002:a05:6e02:ef3:b0:33b:85f4:2edf with SMTP id
 j19-20020a056e020ef300b0033b85f42edfmr1197714ilk.1.1685459689656; 
 Tue, 30 May 2023 08:14:49 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 i9-20020a056e02054900b00325df6679a7sm2575003ils.26.2023.05.30.08.14.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 30 May 2023 08:14:47 -0700 (PDT)
Message-ID: <bc5833bc-1c78-8d9b-69f8-1401b673b861@kernel.dk>
Date: Tue, 30 May 2023 09:14:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
 <3235f123-0638-b39f-f902-426059b87f81@kernel.dk>
 <efedff15-af48-31e5-2834-d8a879f1e6d2@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <efedff15-af48-31e5-2834-d8a879f1e6d2@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v5 00/20] bio: check return values of
 bio_add_page
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Damien Le Moal <Damien.LeMoal@wdc.com>, "kch@nvidia.com" <kch@nvidia.com>,
 "agruenba@redhat.com" <agruenba@redhat.com>,
 "shaggy@kernel.org" <shaggy@kernel.org>, "song@kernel.org" <song@kernel.org>,
 "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>,
 "willy@infradead.org" <willy@infradead.org>,
 "ming.lei@redhat.com" <ming.lei@redhat.com>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>, "rpeterso@redhat.com" <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNS8yNi8yMyAxMjozN+KAr0FNLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6Cj4gT24gMjQu
MDUuMjMgMTc6MDIsIEplbnMgQXhib2Ugd3JvdGU6Cj4+IE9uIDUvMi8yMyA0OjE5P0FNLCBKb2hh
bm5lcyBUaHVtc2hpcm4gd3JvdGU6Cj4+PiBXZSBoYXZlIHR3byBmdW5jdGlvbnMgZm9yIGFkZGlu
ZyBhIHBhZ2UgdG8gYSBiaW8sIF9fYmlvX2FkZF9wYWdlKCkgd2hpY2ggaXMKPj4+IHVzZWQgdG8g
YWRkIGEgc2luZ2xlIHBhZ2UgdG8gYSBmcmVzaGx5IGNyZWF0ZWQgYmlvIGFuZCBiaW9fYWRkX3Bh
Z2UoKSB3aGljaCBpcwo+Pj4gdXNlZCB0byBhZGQgYSBwYWdlIHRvIGFuIGV4aXN0aW5nIGJpby4K
Pj4+Cj4+PiBXaGlsZSBfX2Jpb19hZGRfcGFnZSgpIGlzIGV4cGVjdGVkIHRvIHN1Y2NlZWQsIGJp
b19hZGRfcGFnZSgpIGNhbiBmYWlsLgo+Pj4KPj4+IFRoaXMgc2VyaWVzIGNvbnZlcnRzIHRoZSBj
YWxsZXJzIG9mIGJpb19hZGRfcGFnZSgpIHdoaWNoIGNhbiBlYXNpbHkgdXNlCj4+PiBfX2Jpb19h
ZGRfcGFnZSgpIHRvIHVzaW5nIGl0IGFuZCBjaGVja3MgdGhlIHJldHVybiBvZiBiaW9fYWRkX3Bh
Z2UoKSBmb3IKPj4+IGNhbGxlcnMgdGhhdCBkb24ndCB3b3JrIG9uIGEgZnJlc2hseSBjcmVhdGVk
IGJpby4KPj4+Cj4+PiBMYXN0bHkgaXQgbWFya3MgYmlvX2FkZF9wYWdlKCkgYXMgX19tdXN0X2No
ZWNrIHNvIHdlIGRvbid0IGhhdmUgdG8gZ28gYWdhaW4KPj4+IGFuZCBhdWRpdCBhbGwgY2FsbGVy
cy4KPj4KPj4gTG9va3MgZmluZSB0byBtZSwgdGhvdWdoIGl0IHdvdWxkIGJlIG5pY2UgaWYgdGhl
IGZzIGFuZCBkbSBwZW9wbGUgY291bGQKPj4gZ2l2ZSB0aGlzIGEgcXVpY2sgbG9vay4gU2hvdWxk
IG5vdCB0YWtlIGxvbmcsIGFueSBlbXB0eSBiaW8gYWRkaXRpb24KPj4gc2hvdWxkLCBieSBkZWZp
bml0aW9uLCBiZSBhYmxlIHRvIHVzZSBhIG5vbi1jaGVja2VkIHBhZ2UgYWRkaXRpb24gZm9yCj4+
IHRoZSBmaXJzdCBwYWdlLgo+Pgo+IAo+IEkgdGhpbmsgdGhlIEZTIHNpZGUgaXMgYWxsIGNvdmVy
ZWQuIEBNaWtlIGNvdWxkIHlvdSBoYXZlIGEgbG9vayBhdCB0aGUgZG0KPiBwYXRjaGVzPwoKTm90
IHRoZSBpb21hcCBvbmUsIHRoYXQgd2FzIG15IG1haW4gY29uY2Vybi4gTm90IHRoYXQgdGhpcyBp
cyB0cmlja3kgc3R1ZmYsCmJ1dCBzdGlsbC4uLgoKLS0gCkplbnMgQXhib2UKCgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

