Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C62EB64D9
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jun 2023 00:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687910860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B1Nbz//QDS3rmfZiG9A5+fvFbGIh7ei6MUl53TEOznY=;
	b=PgsJ5/ALS7LcZLAHDuiBOz4QjHIpmbtSxvVYB0N3vtcDq+/nmNTw5JatbmfJx8jNF9o84o
	Zdil62sSHT4SAqKeyV2F4p084bx1s+qJIqUUkpebIl+uYHDclx6cDTyH28yE03L06r93Pd
	Ki9ZRn1ZacZrINSAA6IUGsVhUkEtP/E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-3Plfx8O-ONm3oKKlut4CiQ-1; Tue, 27 Jun 2023 20:07:36 -0400
X-MC-Unique: 3Plfx8O-ONm3oKKlut4CiQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42A418ED615;
	Wed, 28 Jun 2023 00:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2DE61425362;
	Wed, 28 Jun 2023 00:07:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4A35419466DF;
	Wed, 28 Jun 2023 00:07:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B34B71946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Jun 2023 06:15:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BB6D400F08; Tue, 27 Jun 2023 06:15:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93CE648FB02
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 06:15:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 662C8104458D
 for <dm-devel@redhat.com>; Tue, 27 Jun 2023 06:15:01 +0000 (UTC)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-743tf-ekO0274KcWwu33Vg-1; Tue, 27 Jun 2023 02:14:58 -0400
X-MC-Unique: 743tf-ekO0274KcWwu33Vg-1
Received: by mail-wm1-f43.google.com with SMTP id
 5b1f17b1804b1-3f9bece8e19so63721525e9.1
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 23:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687846497; x=1690438497;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=VHlKtlmPgyjqS986fc2zdJSD+esonOp/AIyWxyN5l1o=;
 b=g6NQczE9o1PEqGWvI/bkI2KftGMzCxIo3Bpf/N/2gf37LAagC7jxUhIu1sOBc8vPmY
 KdJcsJp7T/hsAtLlG4/8/PSksf10ma3q/hWp7uzEgCgh+FxyHbFyShGsYEbqHdvkTOEE
 dCYNJs2TxoKlMhKyxYFiqAt8SXs31HEI7OakmIuVuO7krxtbxKd4WS66Rli9OYew4LTc
 uXknr4EAjQ6GUDl9kEncoVnKaTlhfLNOg73ytYLUViOiqHr/vbr2RvXfxHMazj6wswAW
 5b1P0Ug9p+SfGyMghR9Vcg1vjv0Mp3Is1vstfy/vGapvxPdycve/gRslkFGQJjM4ZhnS
 dHVQ==
X-Gm-Message-State: AC+VfDzIZX2PV3c3lD3xfURjrLrpSn62183GHdoP2LKqIiv3WCtXo1za
 NApWc7qad0LCORrusj+1/3R/wQ==
X-Google-Smtp-Source: ACHHUZ4Hau+zrVHaLTx/1I0GQLyePIEGyq3qbz6eW2P9G1juJuspLRx2PdBqMY5bk1GdQksQMKdIyQ==
X-Received: by 2002:a05:600c:28e:b0:3fa:8aed:d57f with SMTP id
 14-20020a05600c028e00b003fa8aedd57fmr7467202wmk.24.1687846497533; 
 Mon, 26 Jun 2023 23:14:57 -0700 (PDT)
Received: from localhost ([102.36.222.112]) by smtp.gmail.com with ESMTPSA id
 l21-20020a1c7915000000b003f605566610sm12500939wme.13.2023.06.26.23.14.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Jun 2023 23:14:55 -0700 (PDT)
Date: Tue, 27 Jun 2023 09:14:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Markus Elfring <Markus.Elfring@web.de>
Message-ID: <ab9f1618-5dde-4c70-a88e-c65f33abdb73@kadam.mountain>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
 <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de>
 <ZJh73z2CsgHEJ4iv@itl-email>
 <e42e8115-6f75-447e-9955-ca4ad43ed406@kadam.mountain>
 <1c1cd489-6d59-00ed-a1f5-497ca532c08d@web.de>
MIME-Version: 1.0
In-Reply-To: <1c1cd489-6d59-00ed-a1f5-497ca532c08d@web.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
 Demi Marie Obenour <demi@invisiblethingslab.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMjYsIDIwMjMgYXQgMDY6MjA6MTRQTSArMDIwMCwgTWFya3VzIEVsZnJpbmcg
d3JvdGU6Cj4gPiDigKYsIHN0b3AgYm90aGVyaW5nIHBlb3BsZSBhYm91dCB0cml2aWFsIG5vbnNl
bnNlLiDigKYKPiAKPiBTZWUgYWxzbyBhbm90aGVyIGJpdCBvZiBiYWNrZ3JvdW5kIGluZm9ybWF0
aW9uIG9uY2UgbW9yZToKPiBbUEFUQ0ggdjJdIGNlcnRzL2V4dHJhY3QtY2VydDogRml4IGNoZWNr
cGF0Y2ggaXNzdWVzCj4gMjAyMy0wNi0wOQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2tlcm5l
bC1qYW5pdG9ycy9jNDY0YzRlZS0wMzhjLTQ3YmYtODU3YS1iMTFhODk2ODBlODJAa2FkYW0ubW91
bnRhaW4vCj4gaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjMvNi85Lzg3OQoKTWFya3VzLCBpdCdz
IG5vdCBhYm91dCBpbXBlcmF0aXZlIHRlbnNlLiAgSXQncyBhYm91dCB5b3Ugd2FzdGluZwpwZW9w
bGUncyB0aW1lLgoKUmVhZCB0aGUgc3ViamVjdCBhZ2Fpbi4gICJBbGxvdyB1c2Vyc3BhY2UgdG8g
cHJvdmlkZSBleHBlY3RlZCBkaXNrc2VxIi4KVGhhdCBpcyBpbXBlcmF0aXZlIHRlbnNlLiAgSSBo
YXZlIG5vdCBwb2ludGVkIGl0IG91dCB0byB5b3UgYmVjYXVzZSBpdApqdXN0IGRvZXNuJ3QgbWF0
dGVyIGF0IGFsbC4gIElmIGl0J3MgaW4gaW1wZXJhdGl2ZSB0ZW5zZSBvciBpZiBpdCdzIG5vdApp
biBpbXBlcmF0aXZlIHRlbnNlLCBpdCBkb2Vzbid0IG1hdHRlci4KCllvdSdyZSBzZW5kaW5nIG91
dCBhIGxvdCBvZiBtZXNzYWdlcyBhbmQgcXVpdGUgYSBmZXcgdGltZXMgaXQgbG9va3MgbGlrZQp5
b3VyIHRhcmdldGluZyBuZXdiaWVzLiAgT25lIG5ldyBkZXZlbG9wZXIgc2VudCBtZSBhbiBlbWFp
bCBwcml2YXRlbHkKd2hvIHdhcyBvdmVyIHRoZSB0b3AgZ3JhdGVmdWwgd2hlbiBJIHRvbGQgaGlt
IGhlIGNvdWxkIGlnbm9yZSB5b3UuICBUaGUKZ3V5IHdhcyBsaWtlLCAiSSB3YXMgc28gcHV6emxl
ZCwgYmVjYXVzZSBpdCdzIG15IGZpcnN0IHBhdGNoIGFuZCBJCmRpZG4ndCBrbm93IGhvdyB0byBy
ZXNwb25kLiIgIFRoaXMgd2FzIGFuIGV4cGVyaWVuY2VkIHByb2dyYW1tZXIgd2hvIHdlCndhbnQs
IGJ1dCBoZSB3YXMgbmV3IHRvIHRoZSBrZXJuZWwgY29tbXVuaXR5IHNvIGhlIGRpZG4ndCBrbm93
IGlmIHdlIGhhZApiaXphcnJlIHJ1bGVzIG9yIHdoYXRldmVyLgoKSSd2ZSBsb29rZWQgdGhyb3Vn
aCB5b3VyIHBhdGNoZXMgdGhhdCBoYXZlIHJlY2VudGx5IGJlZW4gbWVyZ2VkLiAgU29tZQpvZiB0
aG9zZSBtYWludGFpbmVycyBrbm93IHRoYXQgeW91IGFyZSBiYW5uZWQgYW5kIHRoYXQgeW91ciBw
YXRjaGVzIGFyZQpub3QgZ2V0dGluZyBhbnkgcmV2aWV3IGZyb20gdGhlIG1haWxpbmcgbGlzdC4g
IFdlIGFyZSByZWFsbHkgdHJ5aW5nIHRvCmJlIG5pY2UgYW5kIHRvIHdvcmsgYXJvdW5kIHlvdXIg
c2l0dWF0aW9uLiAgQnV0IGRvbid0IHN0YXJ0IGJvdGhlcmluZwpuZXdiaWVzIHdobyBkb24ndCBr
bm93IHdoYXQgdGhlIHNpdHVhdGlvbiBpcy4KCnJlZ2FyZHMsCmRhbiBjYXJwZW50ZXIKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

