Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD2CC77B71
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 06:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681455129;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0GXfBcniercn5jK80504QMKZnkPrJS99Mhj9rw3yAss=;
	b=iZuJD1fEZiytsxZg7UMDk6NwJbQMupg4UxRgQz3AMdN1bw60KTJQzOK8WG76OAcDmg1qPt
	RAPhi4LvWCsbeQy52uv1JPYCX2B5wJ6NOnenTu0HDjNPEzHYwbYLUhjjiCQT0p545FHFz/
	QSkBym6lpxPcePEprWJS0pI0iprJ8EQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-kw44z3fyMomlKevq4Tlvgg-1; Fri, 14 Apr 2023 02:52:08 -0400
X-MC-Unique: kw44z3fyMomlKevq4Tlvgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FDFE185A7AC;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A5E01121333;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DFC91946A7A;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC5E419465B6
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Apr 2023 00:02:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D0F32027044; Fri, 14 Apr 2023 00:02:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 951B12027043
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 00:02:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75F4685D537
 for <dm-devel@redhat.com>; Fri, 14 Apr 2023 00:02:42 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-y7lVV8gGOmyyTKVDVVEHiA-1; Thu, 13 Apr 2023 20:02:40 -0400
X-MC-Unique: y7lVV8gGOmyyTKVDVVEHiA-1
Received: by mail-pj1-f43.google.com with SMTP id
 z11-20020a17090abd8b00b0024721c47ceaso3042000pjr.3
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 17:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681430559; x=1684022559;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=o7P9g3Nl+EfrrL2NO6MRAt6Dye4XvqSU4otNxeRaGZY=;
 b=ZsK6pFxBQUOgw+paRkhattZVp1I3bKJXMaGifp18APzSMANS/Ci89fsyQflNuiRW6i
 qsISLlb0887TeONlidrW5jh6aRJpmlNrD98hcGp6tBVs8NFy/YBXNNRoMh4tcypigodw
 mG49f2c0tdcWi+48B6GvlIvs/M/U2tTxh8wKLkxq731FlLF09Ima2Yi+BR/4C+XZFym7
 32tTfH1XxnugvQpvSK4Rdy3u2S4fFAKM/qMSQUIJUIfIbaEHtcLOWxDg6x4I4e+tFUCs
 1I2Bwehp014tpE2ULVZr52qzKO5Y3vG+nW6pg6OTJJ311KzJj7nOgUrbpsHTcRHybzlH
 4imw==
X-Gm-Message-State: AAQBX9dkbu/WcnTnEfxom0dTnfpTl3TSn/zm/g1l/8FUsl8b8wi3ZRnZ
 w999olPpSbyqcKG14ZCLkLyLQA==
X-Google-Smtp-Source: AKy350a2nB2erFq7GiOYjZ2KhzsJGWrzG9WdIfbNnMAWthKviGqkJTS5lu3A5CkCn3PsSc1wuojVvw==
X-Received: by 2002:a17:90b:2692:b0:246:f5a3:e942 with SMTP id
 pl18-20020a17090b269200b00246f5a3e942mr9234592pjb.18.1681430559599; 
 Thu, 13 Apr 2023 17:02:39 -0700 (PDT)
Received: from sarthakkukreti-glaptop.corp.google.com
 ([2620:15c:9d:200:72cc:7fa5:adcb:7c02])
 by smtp.gmail.com with ESMTPSA id
 u18-20020a17090a891200b002470f179b92sm2212939pjn.43.2023.04.13.17.02.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 Apr 2023 17:02:39 -0700 (PDT)
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
To: sarthakkukreti@google.com, dm-devel@redhat.com,
 linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 13 Apr 2023 17:02:16 -0700
Message-ID: <20230414000219.92640-1-sarthakkukreti@chromium.org>
In-Reply-To: <20221229071647.437095-1-sarthakkukreti@chromium.org>
References: <20221229071647.437095-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Fri, 14 Apr 2023 06:52:02 +0000
Subject: [dm-devel] [PATCH v3 0/3] Introduce provisioning primitives for
 thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGksCgpUaGlzIHBhdGNoIHNlcmllcyBhZGRzIGEgbWVjaGFuaXNtIHRvIHBhc3MgdGhyb3VnaCBw
cm92aXNpb24gcmVxdWVzdHMgb24Kc3RhY2tlZCB0aGlubHkgcHJvdmlzaW9uZWQgYmxvY2sgZGV2
aWNlcy4KClRoZSBsaW51eCBrZXJuZWwgcHJvdmlkZXMgc2V2ZXJhbCBtZWNoYW5pc21zIHRvIHNl
dCB1cCB0aGlubHkgcHJvdmlzaW9uZWQKYmxvY2sgc3RvcmFnZSBhYnN0cmFjdGlvbnMgKGVnLiBk
bS10aGluLCBsb29wIGRldmljZXMgb3ZlciBzcGFyc2UgZmlsZXMpLAplaXRoZXIgZGlyZWN0bHkg
YXMgYmxvY2sgZGV2aWNlcyBvciBiYWNraW5nIHN0b3JhZ2UgZm9yIGZpbGVzeXN0ZW1zLiBDdXJy
ZW50bHksCnNob3J0IG9mIHdyaXRpbmcgZGF0YSB0byBlaXRoZXIgdGhlIGRldmljZSBvciBmaWxl
c3lzdG1lLCB0aGVyZSBpcyBubyB3YXkgZm9yCnVzZXJzIHRvIHByZS1hbGxvY2F0ZSBzcGFjZSBm
b3IgdXNlIGluIHN1Y2ggc3RvcmFnZSBzZXR1cHMuIENvbnNpZGVyIHRoZQpmb2xsb3dpbmcgdXNl
LWNhc2VzOgoKMSkgU3VzcGVuZC10by1kaXNrIGFuZCByZXN1bWUgZnJvbSBhIGRtLXRoaW4gZGV2
aWNlOiBJbiBvcmRlciB0byBlbnN1cmUgdGhhdAogICB0aGUgdW5kZXJseWluZyB0aGlucG9vbCBt
ZXRhZGF0YSBpcyBub3QgbW9kaWZpZWQgZHVyaW5nIHRoZSBzdXNwZW5kCiAgIG1lY2hhbmlzbSwg
dGhlIGRtLXRoaW4gZGV2aWNlIG5lZWRzIHRvIGJlIGZ1bGx5IHByb3Zpc2lvbmVkLgoyKSBJZiBh
IGZpbGVzeXN0ZW0gdXNlcyBhIGxvb3AgZGV2aWNlIG92ZXIgYSBzcGFyc2UgZmlsZSwgZmFsbG9j
YXRlKCkgb24gdGhlCiAgIGZpbGVzeXN0ZW0gd2lsbCBhbGxvY2F0ZSBibG9ja3MgZm9yIGZpbGVz
IGJ1dCB0aGUgdW5kZXJseWluZyBzcGFyc2UgZmlsZQogICB3aWxsIHJlbWFpbiBpbnRhY3QuCjMp
IEFub3RoZXIgZXhhbXBsZSBpcyB2aXJ0dWFsIG1hY2hpbmUgdXNpbmcgYSBzcGFyc2UgZmlsZS9k
bS10aGluIGFzIGEgc3RvcmFnZQogICBkZXZpY2U7IGJ5IGRlZmF1bHQsIGFsbG9jYXRpb25zIHdp
dGhpbiB0aGUgVk0gYm91bmRhcmllcyB3aWxsIG5vdCBhZmZlY3QKICAgdGhlIGhvc3QuCjQpIFNl
dmVyYWwgc3RvcmFnZSBzdGFuZGFyZHMgc3VwcG9ydCBtZWNoYW5pc21zIGZvciB0aGluIHByb3Zp
c2lvbmluZyBvbgogICByZWFsIGhhcmR3YXJlIGRldmljZXMuIEZvciBleGFtcGxlOgogICBhLiBU
aGUgTlZNZSBzcGVjIDEuMGIgc2VjdGlvbiAyLjEuMSBsb29zZWx5IHRhbGtzIGFib3V0IHRoaW4g
cHJvdmlzaW9uaW5nOgogICAgICAiV2hlbiB0aGUgVEhJTlAgYml0IGluIHRoZSBOU0ZFQVQgZmll
bGQgb2YgdGhlIElkZW50aWZ5IE5hbWVzcGFjZSBkYXRhCiAgICAgICBzdHJ1Y3R1cmUgaXMgc2V0
IHRvIOKAmDHigJksIHRoZSBjb250cm9sbGVyIC4uLiBzaGFsbCB0cmFjayB0aGUgbnVtYmVyIG9m
CiAgICAgICBhbGxvY2F0ZWQgYmxvY2tzIGluIHRoZSBOYW1lc3BhY2UgVXRpbGl6YXRpb24gZmll
bGQiCiAgIGIuIFRoZSBTQ1NpIEJsb2NrIENvbW1hbmRzIHJlZmVyZW5jZSAtIDQgc2VjdGlvbiBy
ZWZlcmVuY2VzICJUaGluCiAgICAgIHByb3Zpc2lvbmVkIGxvZ2ljYWwgdW5pdHMiLAogICBjLiBV
RlMgMy4wIHNwZWMgc2VjdGlvbiAxMy4zLjMgcmVmZXJlbmNlcyAiVGhpbiBwcm92aXNpb25pbmci
LgoKSW4gYWxsIHRoZSBhYm92ZSBzaXR1YXRpb25zLCBjdXJyZW50bHksIHRoZSBvbmx5IHdheSBm
b3IgcHJlLWFsbG9jYXRpbmcgc3BhY2UKaXMgdG8gaXNzdWUgd3JpdGVzIChvciB1c2UgV1JJVEVf
WkVST0VTL1dSSVRFX1NBTUUpLiBIb3dldmVyLCB0aGF0IGRvZXMgbm90CnNjYWxlIHdlbGwgd2l0
aCBsYXJnZXIgcHJlLWFsbG9jYXRpb24gc2l6ZXMuCgpUaGlzIHBhdGNoc2V0IGludHJvZHVjZXMg
cHJpbWl0aXZlcyB0byBzdXBwb3J0IGJsb2NrLWxldmVsIHByb3Zpc2lvbmluZyAobm90ZToKdGhl
IHRlcm0gJ3Byb3Zpc2lvbmluZycgaXMgdXNlZCB0byBwcmV2ZW50IG92ZXJsb2FkaW5nIHRoZSB0
ZXJtCidhbGxvY2F0aW9ucy9wcmUtYWxsb2NhdGlvbnMnKSByZXF1ZXN0cyBhY3Jvc3MgZmlsZXN5
c3RlbXMgYW5kIGJsb2NrIGRldmljZXMuClRoaXMgYWxsb3dzIGZhbGxvY2F0ZSgpIGFuZCBmaWxl
IGNyZWF0aW9uIHJlcXVlc3RzIHRvIHJlc2VydmUgc3BhY2UgYWNyb3NzCnN0YWNrZWQgbGF5ZXJz
IG9mIGJsb2NrIGRldmljZXMgYW5kIGZpbGVzeXN0ZW1zLiBDdXJyZW50bHksIHRoZSBwYXRjaHNl
dCBjb3ZlcnMKYSBwcm90b3R5cGUgb24gdGhlIGRldmljZS1tYXBwZXIgdGFyZ2V0cywgbG9vcCBk
ZXZpY2UgYW5kIGV4dDQsIGJ1dCB0aGUgc2FtZQptZWNoYW5pc20gY2FuIGJlIGV4dGVuZGVkIHRv
IG90aGVyIGZpbGVzeXN0ZW1zL2Jsb2NrIGRldmljZXMgYXMgd2VsbCBhcyBleHRlbmRlZApmb3Ig
dXNlIHdpdGggZGV2aWNlcyBpbiA0IGEtYy4KClBhdGNoIDEgaW50cm9kdWNlcyBSRVFfT1BfUFJP
VklTSU9OIGFzIGEgbmV3IHJlcXVlc3QgdHlwZS4KVGhlIHByb3Zpc2lvbiByZXF1ZXN0IGFjdHMg
bGlrZSB0aGUgaW52ZXJzZSBvZiBhIGRpc2NhcmQgcmVxdWVzdDsgaW5zdGVhZApvZiBub3RpZnlp
bmcgbG93ZXIgbGF5ZXJzIHRoYXQgdGhlIGJsb2NrIHJhbmdlIHdpbGwgbm8gbG9uZ2VyIGJlIHVz
ZWQsIHByb3Zpc2lvbgphY3RzIGFzIGEgcmVxdWVzdCB0byBsb3dlciBsYXllcnMgdG8gcHJvdmlz
aW9uIGRpc2sgc3BhY2UgZm9yIHRoZSBnaXZlbiBibG9jawpyYW5nZS4gUmVhbCBoYXJkd2FyZSBz
dG9yYWdlIGRldmljZXMgd2lsbCBjdXJyZW50bHkgZGlzYWJsZSB0aGUgcHJvdmlzaW9pbmcKY2Fw
YWJpbGl0eSBidXQgZm9yIHRoZSBzdGFuZGFyZHMgbGlzdGVkIGluIDRhLi1jLiwgUkVRX09QX1BS
T1ZJU0lPTiBjYW4gYmUKb3ZlcmxvYWRlZCBmb3IgdXNlIGFzIHRoZSBwcm92aXNpb2luZyBwcmlt
aXRpdmUgZm9yIGZ1dHVyZSBkZXZpY2VzLgoKUGF0Y2ggMiBpbXBsZW1lbnRzIFJFUV9PUF9QUk9W
SVNJT04gaGFuZGxpbmcgZm9yIHNvbWUgb2YgdGhlIGRldmljZS1tYXBwZXIKdGFyZ2V0cy4gRGV2
aWNlLW1hcHBlciB0YXJnZXRzIHdpbGwgdXN1YWxseSBtaXJyb3IgdGhlIHN1cHBvcnQgb2YgdW5k
ZXJseWluZwpkZXZpY2VzLiBUaGlzIHBhdGNoIGFsc28gZW5hYmxlcyB0aGUgdXNlIG9mIGZhbGxv
Y2F0ZSBpbiBtb2RlID09IDAgZm9yIGJsb2NrCmRldmljZXMuCgpQYXRjaCAzIHdpcmVzIHVwIHRo
ZSBsb29wIGRldmljZSBoYW5kbGluZyBvZiBSRVFfT1BfUFJPVklTSU9OIGFuZCBjYWxscwpmYWxs
b2NhdGUoKSB3aXRoIG1vZGUgMCBvbiB0aGUgdW5kZXJseWluZyBmaWxlL2Jsb2NrIGRldmljZS4K
ClRlc3Rpbmc6Ci0tLS0tLS0tCi0gVGVzdGVkIG9uIGEgVk0gcnVubmluZyBhIDYuMiBrZXJuZWwu
CgotIFByZWFsbG9jYXRpb24gb2YgZG0tdGhpbiBkZXZpY2VzOgpBcyBleHBlY3RlZCwgYXZvaWRp
bmcgdGhlIG5lZWQgdG8gemVybyBvdXQgdGhpbmx5LXByb3Zpc2lvbmVkIGJsb2NrIGRldmljZXMg
dG8KcHJlYWxsb2NhdGUgc3BhY2Ugc3BlZWRzIHVwIHRoZSBwcm92aXNpb25pbmcgb3BlcmF0aW9u
IHNpZ25pZmljYW50bHk6CgpUaGUgZm9sbG93aW5nIHdhcyB0ZXN0ZWQgb24gYSBkbS10aGluIGRl
dmljZSBzZXQgdXAgb24gdG9wIG9mIGEgZG0tdGhpbnAgd2l0aApza2lwX2Jsb2NrX3plcm9pbmc9
dHJ1ZS4KQSkgWmVyb291dCB3YXMgbWVhc3VyZWQgdXNpbmcgYGZhbGxvY2F0ZSAteiAuLi5gCkIp
IFByb3Zpc2lvbiB3YXMgbWVhc3VyZWQgdXNpbmcgYGZhbGxvY2F0ZSAtcCAuLi5gLgoKU2l6ZQlU
aW1lCUEJQgo1MTJNCXJlYWwJMS4wOTMJMC4wMzQKCXVzZXIJMAkwCglzeXMJMC4wMjIJMC4wMQox
RwlyZWFsCTIuMTgyCTAuMDQ4Cgl1c2VyCTAJMC4wMQoJc3lzCTAuMDIyCTAKMkcJcmVhbAk0LjM0
NAkwLjA4MgoJdXNlcgkwCTAuMDEKCXN5cwkwLjAzNgkwCjRHCXJlYWwJOC42NzkJMC4xNTMKCXVz
ZXIJMAkwLjAxCglzeXMJMC4wNzMJMAo4RwlyZWFsCTE3Ljc3NwkwLjMxOAoJdXNlcgkwCTAuMDEK
CXN5cwkwLjE0NAkwCgpDaGFuZ2Vsb2c6CgpWMzoKLSBEcm9wIEZBTExPQ19GTF9QUk9WSVNJT04g
YW5kIHVzZSBtb2RlID09IDAgZm9yIHByb3Zpc2lvbiByZXF1ZXN0cy4KLSBEcm9wIGZzLXNwZWNp
ZmljIHBhdGNoZXM7IHdpbGwgYmUgc2VudCBvdXQgaW4gYSBmb2xsb3cgdXAgc2VyaWVzLgotIEZp
eCBtaXNzaW5nIHNoYXJlZCBibG9jayBoYW5kbGluZyBmb3IgdGhpbiBzbmFwc2hvdHMuCgpWMjoK
LSBGaXggc3RhY2tlZCBsaW1pdCBoYW5kbGluZy4KLSBFbmFibGUgcHJvdmlzaW9uIHJlcXVlc3Qg
aGFuZGxpbmcgaW4gZG0tc25hcHNob3QKLSBEb24ndCBjYWxsIHRydW5jYXRlX2JkZXZfcmFuZ2Ug
aWYgYmxrZGV2X2ZhbGxvY2F0ZSgpIGlzIGNhbGxlZCB3aXRoCiAgRkFMTE9DX0ZMX1BST1ZJU0lP
Ti4KLSBDbGFyaWZ5IHNlbWFudGljcyBvZiBGQUxMT0NfRkxfUFJPVklTSU9OIGFuZCB3aHkgaXQg
bmVlZHMgdG8gYmUgYSBzZXBhcmF0ZSBmbGFnCiAgKGFzIG9wcG9zZWQgdG8gb3ZlcmxvYWRpbmcg
bW9kZSA9PSAwKS4KClNhcnRoYWsgS3VrcmV0aSAoMyk6CiAgYmxvY2s6IEludHJvZHVjZSBwcm92
aXNpb25pbmcgcHJpbWl0aXZlcwogIGRtOiBBZGQgc3VwcG9ydCBmb3IgYmxvY2sgcHJvdmlzaW9u
aW5nCiAgbG9vcDogQWRkIHN1cHBvcnQgZm9yIHByb3Zpc2lvbiByZXF1ZXN0cwoKIGJsb2NrL2Js
ay1jb3JlLmMgICAgICAgICAgICAgIHwgICA1ICsrCiBibG9jay9ibGstbGliLmMgICAgICAgICAg
ICAgICB8ICA1MyArKysrKysrKysrKysrKysrCiBibG9jay9ibGstbWVyZ2UuYyAgICAgICAgICAg
ICB8ICAxOCArKysrKysKIGJsb2NrL2Jsay1zZXR0aW5ncy5jICAgICAgICAgIHwgIDE5ICsrKysr
KwogYmxvY2svYmxrLXN5c2ZzLmMgICAgICAgICAgICAgfCAgIDggKysrCiBibG9jay9ib3VuY2Uu
YyAgICAgICAgICAgICAgICB8ICAgMSArCiBibG9jay9mb3BzLmMgICAgICAgICAgICAgICAgICB8
ICAxNCArKystLQogZHJpdmVycy9ibG9jay9sb29wLmMgICAgICAgICAgfCAgNDIgKysrKysrKysr
KysrKwogZHJpdmVycy9tZC9kbS1jcnlwdC5jICAgICAgICAgfCAgIDQgKy0KIGRyaXZlcnMvbWQv
ZG0tbGluZWFyLmMgICAgICAgIHwgICAxICsKIGRyaXZlcnMvbWQvZG0tc25hcC5jICAgICAgICAg
IHwgICA3ICsrKwogZHJpdmVycy9tZC9kbS10YWJsZS5jICAgICAgICAgfCAgMjUgKysrKysrKysK
IGRyaXZlcnMvbWQvZG0tdGhpbi5jICAgICAgICAgIHwgMTEwICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0KIGRyaXZlcnMvbWQvZG0uYyAgICAgICAgICAgICAgIHwgICA0ICsrCiBp
bmNsdWRlL2xpbnV4L2Jpby5oICAgICAgICAgICB8ICAgNiArLQogaW5jbHVkZS9saW51eC9ibGtf
dHlwZXMuaCAgICAgfCAgIDUgKy0KIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgICAgIHwgIDE2
ICsrKysrCiBpbmNsdWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaCB8ICAxMSArKysrCiAxOCBmaWxl
cyBjaGFuZ2VkLCAzMzMgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pCgotLSAKMi40MC4w
LjYzNC5nNGNhM2VmMzIxMS1nb29nCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVsCg==

