Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6223CC7EE31
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480089;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2um2Iay77H61XLsW/MxMvsZ0/IlbMwb4NDWRVkGLtbc=;
	b=caWMzknYMTSHCeLwpggp+eZUSBRdhnXf4Cj8btI6MykXMk+eAsQhst1kSTcgJfNo3PJAoj
	XJVmd7L37DmtyucRT/eH52ywELvVEbrvMgVordKJkW3WcftIpqy0Cj/5T1rP/zNFwPxkI9
	Dl+c7xnA2rEYlmZXCYzkT7H4YUNIAwE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-ANL7nhjeOEKwFhh_w9wWrg-1; Tue, 30 May 2023 16:54:48 -0400
X-MC-Unique: ANL7nhjeOEKwFhh_w9wWrg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E8201C0759A;
	Tue, 30 May 2023 20:54:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F01761121339;
	Tue, 30 May 2023 20:54:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAB70194E127;
	Tue, 30 May 2023 20:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AA7A21946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 11:29:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 991D440CFD46; Tue, 30 May 2023 11:29:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 918D940CFD45
 for <dm-devel@redhat.com>; Tue, 30 May 2023 11:29:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7649B85A5A8
 for <dm-devel@redhat.com>; Tue, 30 May 2023 11:29:26 +0000 (UTC)
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-x3W322mdMqScU2Bw-yvBXQ-1; Tue, 30 May 2023 07:29:25 -0400
X-MC-Unique: x3W322mdMqScU2Bw-yvBXQ-1
Received: by mail-vk1-f200.google.com with SMTP id
 71dfb90a1353d-4572aa34839so821549e0c.3
 for <dm-devel@redhat.com>; Tue, 30 May 2023 04:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685446165; x=1688038165;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=NpOBAS8Bi4kBG+sylQuaVNwQB72hawQBUTtbh7SjPqA=;
 b=JOSO4aK5zQuT1+d7Owpu3/bp+QsJ4WEfFHHSz5Q1AoDuaaZ2DHMH8h2gI1fGtOFKCR
 uBFII6Z+mT0v6SdltDdvSkrrjIberXce9658DuyG6r6hl6qDL8R7IbLPT0lf8Wc4CYJn
 Fk/cE7hG/OPaU/uraSCYY1T8QF3ZOrvnNjBHSx9M2OldNmq+noYrTx7PWsRsQDQ55Kd1
 eQkFfp5eh0upDhqXIT1c2npbd1qK15Oam92uBoXMF1+UbZtmtp2U0lZgtkrDlxZWJZRz
 P4ctxKrDeRqeGKTxIBMyvOcl4srdvbaxwgIslcu1WnsvuKxurqapcu+0SjJSiELkoJH3
 pFHQ==
X-Gm-Message-State: AC+VfDzlebIny5/u1XtYPAmFvQgIlsKGSgOHn9CJbFLNEkuXkep4nnv1
 zSKZqmp0E38ugei/Xm0nRpoCslTwLVx4PvRdiK7waEe0sEwtFddDEwwqzqDUALa7iRgaKJrVPRR
 5/hIFlmbO8b7LzS+Y1/BSFFynfSpZoy4=
X-Received: by 2002:a1f:4b45:0:b0:44f:cc32:1585 with SMTP id
 y66-20020a1f4b45000000b0044fcc321585mr396086vka.16.1685446164684; 
 Tue, 30 May 2023 04:29:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ60g8d6uIJQJ6uxHej74jlrBVrcHx9EcH35VqVEe7Tezem4ctVekj51qYF9EFj7YKA4koNTixi+3DAOC1La86o=
X-Received: by 2002:a1f:4b45:0:b0:44f:cc32:1585 with SMTP id
 y66-20020a1f4b45000000b0044fcc321585mr396070vka.16.1685446164430; Tue, 30 May
 2023 04:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
 <20230522104146.2856-1-nj.shetty@samsung.com>
 <20230522104146.2856-3-nj.shetty@samsung.com>
In-Reply-To: <20230522104146.2856-3-nj.shetty@samsung.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Tue, 30 May 2023 13:29:12 +0200
Message-ID: <CAFL455nMtKbDt1HeN6D2WPB2JjOYq2z1=RagmmuhmQ33eL2Bfw@mail.gmail.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: Re: [dm-devel] [PATCH v11 2/9] block: Add copy offload support
 infrastructure
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
Cc: linux-nvme@lists.infradead.org, James.Bottomley@hansenpartnership.com,
 linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, anuj20.g@samsung.com,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 joshi.k@samsung.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

cG8gMjIuIDUuIDIwMjMgdiAxMzoxNyBvZGVzw61sYXRlbCBOaXRlc2ggU2hldHR5IDxuai5zaGV0
dHlAc2Ftc3VuZy5jb20+IG5hcHNhbDoKPgo+ICtzdGF0aWMgaW50IF9fYmxrZGV2X2NvcHlfb2Zm
bG9hZChzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2X2luLCBsb2ZmX3QgcG9zX2luLAo+ICsgICAg
ICAgICAgICAgICBzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2X291dCwgbG9mZl90IHBvc19vdXQs
IHNpemVfdCBsZW4sCj4gKyAgICAgICAgICAgICAgIGNpb19pb2RvbmVfdCBlbmRpbywgdm9pZCAq
cHJpdmF0ZSwgZ2ZwX3QgZ2ZwX21hc2spCj4gK3sKPiArICAgICAgIHN0cnVjdCBjaW8gKmNpbzsK
PiArICAgICAgIHN0cnVjdCBjb3B5X2N0eCAqY3R4Owo+ICsgICAgICAgc3RydWN0IGJpbyAqcmVh
ZF9iaW8sICp3cml0ZV9iaW87Cj4gKyAgICAgICBzdHJ1Y3QgcGFnZSAqdG9rZW47Cj4gKyAgICAg
ICBzZWN0b3JfdCBjb3B5X2xlbjsKPiArICAgICAgIHNlY3Rvcl90IHJlbSwgbWF4X2NvcHlfbGVu
Owo+ICsKPiArICAgICAgIGNpbyA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBjaW8pLCBHRlBfS0VS
TkVMKTsKPiArICAgICAgIGlmICghY2lvKQo+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVOT01F
TTsKPiArICAgICAgIGF0b21pY19zZXQoJmNpby0+cmVmY291bnQsIDApOwo+ICsgICAgICAgY2lv
LT53YWl0ZXIgPSBjdXJyZW50Owo+ICsgICAgICAgY2lvLT5lbmRpbyA9IGVuZGlvOwo+ICsgICAg
ICAgY2lvLT5wcml2YXRlID0gcHJpdmF0ZTsKPiArCj4gKyAgICAgICBtYXhfY29weV9sZW4gPSBt
aW4oYmRldl9tYXhfY29weV9zZWN0b3JzKGJkZXZfaW4pLAo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIGJkZXZfbWF4X2NvcHlfc2VjdG9ycyhiZGV2X291dCkpIDw8IFNFQ1RPUl9TSElGVDsKPiAr
Cj4gKyAgICAgICBjaW8tPnBvc19pbiA9IHBvc19pbjsKPiArICAgICAgIGNpby0+cG9zX291dCA9
IHBvc19vdXQ7Cj4gKyAgICAgICAvKiBJZiB0aGVyZSBpcyBhIGVycm9yLCBjb21wX2xlbiB3aWxs
IGJlIHNldCB0byBsZWFzdCBzdWNjZXNzZnVsbHkKPiArICAgICAgICAqIGNvbXBsZXRlZCBjb3Bp
ZWQgbGVuZ3RoCj4gKyAgICAgICAgKi8KPiArICAgICAgIGNpby0+Y29tcF9sZW4gPSBsZW47Cj4g
KyAgICAgICBmb3IgKHJlbSA9IGxlbjsgcmVtID4gMDsgcmVtIC09IGNvcHlfbGVuKSB7Cj4gKyAg
ICAgICAgICAgICAgIGNvcHlfbGVuID0gbWluKHJlbSwgbWF4X2NvcHlfbGVuKTsKPiArCj4gKyAg
ICAgICAgICAgICAgIHRva2VuID0gYWxsb2NfcGFnZShnZnBfbWFzayk7Cj4gKyAgICAgICAgICAg
ICAgIGlmICh1bmxpa2VseSghdG9rZW4pKQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8g
ZXJyX3Rva2VuOwoKWy4uLl0KCj4gK2Vycl90b2tlbjoKPiArICAgICAgIGNpby0+Y29tcF9sZW4g
PSBtaW5fdChzZWN0b3JfdCwgY2lvLT5jb21wX2xlbiwgKGxlbiAtIHJlbSkpOwo+ICsgICAgICAg
aWYgKCFhdG9taWNfcmVhZCgmY2lvLT5yZWZjb3VudCkpCj4gKyAgICAgICAgICAgICAgIHJldHVy
biAtRU5PTUVNOwo+ICsgICAgICAgLyogV2FpdCBmb3Igc3VibWl0dGVkIElPcyB0byBjb21wbGV0
ZSAqLwo+ICsgICAgICAgcmV0dXJuIGJsa2Rldl9jb3B5X3dhaXRfY29tcGxldGlvbihjaW8pOwo+
ICt9CgpTdXBwb3NlIHRoZSBmaXJzdCBjYWxsIHRvICJ0b2tlbiA9IGFsbG9jX3BhZ2UoKSIgZmFp
bHMgKGFuZApjaW8tPnJlZmNvdW50ID09IDApLCBpc24ndCAiY2lvIiBnb2luZyB0byBiZSBsZWFr
ZWQgaGVyZT8KCk1hdXJpemlvCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==

