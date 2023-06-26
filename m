Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 690EDC3DA40
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 00:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687910860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ct+FgJvRJkA5LSHZ/XPvKv08NyWkOMAdpOTqk57vaWA=;
	b=WTj0kaP1xm6uhiZgGiO0aSSMq51yf5tRKyUhFxNt12JI8w22nSuo8vvbvpklAlfd8MQPnT
	qNTqVdM30WXNYHym6Ei+3LyJSbhPAn0dfAJT5DlFDDk9MrKhD1qYu9lJBSV0Sjj84uLrX6
	bfqSw+SxDw3jT2XQB7EUeYRV0pvLFAc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-b8uEIoJ1Ot-Y5vbVTPuwDQ-1; Tue, 27 Jun 2023 20:07:37 -0400
X-MC-Unique: b8uEIoJ1Ot-Y5vbVTPuwDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB2A3380670A;
	Wed, 28 Jun 2023 00:07:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 107562166B25;
	Wed, 28 Jun 2023 00:07:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB7921946587;
	Wed, 28 Jun 2023 00:07:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 42A4E1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 12:59:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC35340C6CCD; Mon, 26 Jun 2023 12:59:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D556240C6F5A
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 12:59:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BABA51C03D9D
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 12:59:33 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-itba1tmBOZSAIikdUgs79w-1; Mon, 26 Jun 2023 08:59:31 -0400
X-MC-Unique: itba1tmBOZSAIikdUgs79w-1
Received: by mail-wm1-f51.google.com with SMTP id
 5b1f17b1804b1-3fa99f6a4a1so7065965e9.3
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 05:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687784370; x=1690376370;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=apk70vZy4KhYcnG84Q1wffo81Dl8DaLTVZRWL3wj6Xs=;
 b=jtWNzylj6s0A9U94AogwjkLKKFMUML5r1495bYBMisFOCd7ghE1LQInv+wbm/Lzm1U
 8v4tKOkjr4NEqOa/DSQWNbL/qmf4VbM8m8c8vXGIh3JyBdRexD/+I9bWNUlRbvBVbOY9
 HdbKSOBwe6YxNgedVHrSRaAdJeK8MF0DjamYe0mD2yjk3XVZIyeAFWObaPtx8xRgZJar
 TwRqfWnYAC/Zjekucvuw9ijIqiLOQMrCgQVX9Dfx12FxjL/iaBoexlF4Jz3N1i6/0ha9
 EaO4TXOxlxQqLYtmrZkJJrv7b6P2eUM7tifNVDo60VFppBk1Lt76N72KM3s741gjXacn
 mITg==
X-Gm-Message-State: AC+VfDy6Os69+UvSDqdezx46j7Sl/bMHJJdugCj3Oc4plzp55OvDgXYz
 LyPxL/Kqs/DYVt42pprbWcOP4g==
X-Google-Smtp-Source: ACHHUZ6cBlNtxq75cN4Re6BcQmPh/298izmROOMzkk3aoy5z+JpobqagrTiu+DwsCmdHdbox+wHzaQ==
X-Received: by 2002:a05:600c:2942:b0:3f8:efc5:3382 with SMTP id
 n2-20020a05600c294200b003f8efc53382mr24739064wmd.31.1687784370379; 
 Mon, 26 Jun 2023 05:59:30 -0700 (PDT)
Received: from localhost ([102.36.222.112]) by smtp.gmail.com with ESMTPSA id
 k5-20020a5d6e85000000b003063a92bbf5sm7386241wrz.70.2023.06.26.05.59.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Jun 2023 05:59:28 -0700 (PDT)
Date: Mon, 26 Jun 2023 15:59:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de>
 <ZJh73z2CsgHEJ4iv@itl-email>
MIME-Version: 1.0
In-Reply-To: <ZJh73z2CsgHEJ4iv@itl-email>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Wed, 28 Jun 2023 00:07:30 +0000
Subject: Re: [dm-devel] [PATCH v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
Cc: Mike Snitzer <snitzer@kernel.org>, kernel-janitors@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
 Markus Elfring <Markus.Elfring@web.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBKdW4gMjUsIDIwMjMgYXQgMDE6Mzk6NDBQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIFN1biwgSnVuIDI1LCAyMDIzIGF0IDAxOjIzOjQwUE0gKzAyMDAsIE1h
cmt1cyBFbGZyaW5nIHdyb3RlOgo+ID4gPiBUaGlzIGNhbiBiZSB1c2VkIHRvIGF2b2lkIHJhY2Ug
Y29uZGl0aW9ucyBpbiB3aGljaCBhIGRldmljZSBpcyBkZXN0cm95ZWQKPiA+ID4gYW5kIHJlY3Jl
YXRlZCB3aXRoIHRoZSBzYW1lIG1ham9yL21pbm9yLCBuYW1lLCBvciBVVUlELiDigKYKPiA+IAo+
ID4gUGxlYXNlIGFkZCBhbiBpbXBlcmF0aXZlIGNoYW5nZSBzdWdnZXN0aW9uLgo+IAo+IFdpbGwg
Zml4IGluIHYzLgoKWW91IGRvbid0IGhhdmUgdG8gbGlzdGVuIHRvIE1hcmt1cy4gIE1vc3Qgb2Yg
dXMgY2FuJ3Qgc2VlIE1hcmt1cydzCmVtYWlscyBiZWNhdXNlIGhlJ3MgYmFubmVkIGZyb20gdGhl
IHZnZXIgbWFpbGluZyBsaXN0cy4KCk1hcmt1cywgc3RvcCBib3RoZXJpbmcgcGVvcGxlIGFib3V0
IHRyaXZpYWwgbm9uc2Vuc2UuICBJJ3ZlIHNhaWQgdGhpcwp0byB5b3UgYmVmb3JlLCB0aGF0IGlm
IHlvdSBzcG90IGEgYnVnIGluIGEgcGF0Y2ggdGhhdCdzIHdlbGNvbWUgZmVlZGJhY2sKYnV0IGlm
IHlvdSBqdXN0IGhhdmUgY29tbWVudHMgYWJvdXQgZ3JhbW1hciB0aGVuIG5vIG9uZSB3YW50cyB0
aGF0LgoKcmVnYXJkcywKZGFuIGNhcnBlbnRlcgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRt
LWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0
aW5mby9kbS1kZXZlbAo=

