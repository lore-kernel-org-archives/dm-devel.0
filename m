Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03ECDC77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682012540;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ser+uOdMs3bDs2NOhljyW5RULE3b7hgMdKGZ4Hkhv9A=;
	b=en3yLhihtyou3Fw3tNU1uRKyL3mW+JywCIm9v2UoE9gRLCOh19OjxhJrN2IncDBz807s8h
	4DCyAdEynf4OB5MZaAgmulZQP4ipUbLTz4F2jbvaWy08TmPPLMb9E8H8yuxlIP5QxMCjAs
	on+ikEFX/TVscxVIOgakSAuoNKORaD0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-g5OV0DuTMYSGTGlQNBQ6tw-1; Thu, 20 Apr 2023 13:42:17 -0400
X-MC-Unique: g5OV0DuTMYSGTGlQNBQ6tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 954AA3C0F1B2;
	Thu, 20 Apr 2023 17:42:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34238440BC;
	Thu, 20 Apr 2023 17:42:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F3F361946A40;
	Thu, 20 Apr 2023 17:42:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7486619466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 17:42:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FCE0492B06; Thu, 20 Apr 2023 17:42:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38013492B05
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 17:42:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1601629AA2C2
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 17:42:13 +0000 (UTC)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-3xtNxeGPNfq0HsMjlySWwA-1; Thu, 20 Apr 2023 13:42:10 -0400
X-MC-Unique: 3xtNxeGPNfq0HsMjlySWwA-1
Received: by mail-ej1-f43.google.com with SMTP id
 a640c23a62f3a-94a34d3812dso96963666b.3
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682012529; x=1684604529;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=jOShlAmW5KtWyt18VPabl3AojpTzB/52zpa39oAofYI=;
 b=gJ4Gw6EUrNbQdog8FQOvapjijweSJlrL6f+L29WjCXeliC/6OK/ufWgJI+ltXO3Vs/
 YsACort9e4s+AFC/P9GOzXXowKgYZknxNLc2HbjwnOoJH1Mf9rVb31LhY7xtGbpI/Bxb
 2v9S/wJVzxl27QBlOuIJRkN5phr+7RctPUUV8ol3UkO2cu+H6ixTyPCFSw1UjxLG/5c/
 ew7nyRXeTiAongyIPmwJj1nrXcE7LLpVD4EHaXIQP7n5Hu07gcbol7xhFP9P+K2oVt8T
 USRVaAzlrqvfM2jxqFphkWoj5MkLcXlne6KmcHK1tB6PcExwfDFUeCYWOl5osCQ+c4d5
 IqTw==
X-Gm-Message-State: AAQBX9fx/4bZUyG8a4vDdEiPoVt0N7KLg3MxTzz04vDlfrBAURA9Bhh8
 DseDViQBhjhEFplzx7QbLrj353vw8uz8RtkwMN9Teg==
X-Google-Smtp-Source: AKy350auT20t6FOb+4AgjUmWFcoyThBQnArWZX8Nl6LqCPFqucTjIuxXlPmzUnAM2Xrg1Nu+DICIWX/ywGGGDp/EAL0=
X-Received: by 2002:a05:6402:7d8:b0:502:2265:8428 with SMTP id
 u24-20020a05640207d800b0050222658428mr2195635edy.38.1682012529194; Thu, 20
 Apr 2023 10:42:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-1-sarthakkukreti@chromium.org>
 <20230418221207.244685-2-sarthakkukreti@chromium.org>
 <b74cc3d8-bfde-8375-3b19-24ea13eb1196@acm.org>
In-Reply-To: <b74cc3d8-bfde-8375-3b19-24ea13eb1196@acm.org>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 20 Apr 2023 10:41:57 -0700
Message-ID: <CAG9=OMOfpJHB3HbjK46_bh_P6b4vdSfBt1Q39ukuKhZzyscnow@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 1/4] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RHJvcHBlZCBpbiB2NS4KClRoYW5rcyEKU2FydGhhawoKT24gVHVlLCBBcHIgMTgsIDIwMjMgYXQg
Mzo0M+KAr1BNIEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPiB3cm90ZToKPgo+
IE9uIDQvMTgvMjMgMTU6MTIsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+ICAgICAgIC8qIEZh
aWwgaWYgd2UgZG9uJ3QgcmVjb2duaXplIHRoZSBmbGFncy4gKi8KPiA+IC0gICAgIGlmIChtb2Rl
ICYgfkJMS0RFVl9GQUxMT0NfRkxfU1VQUE9SVEVEKQo+ID4gKyAgICAgaWYgKG1vZGUgIT0gMCAm
JiBtb2RlICYgfkJMS0RFVl9GQUxMT0NfRkxfU1VQUE9SVEVEKQo+ID4gICAgICAgICAgICAgICBy
ZXR1cm4gLUVPUE5PVFNVUFA7Cj4KPiBJcyB0aGlzIGNoYW5nZSBuZWNlc3Nhcnk/IERvZXNuJ3Qg
KG1vZGUgJiB+QkxLREVWX0ZBTExPQ19GTF9TVVBQT1JURUQpCj4gIT0gMCBpbXBseSB0aGF0IG1v
ZGUgIT0gMD8KPgo+IFRoYW5rcywKPgo+IEJhcnQuCj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

