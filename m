Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AADEC54EBF
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645391;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DYQzCGNsJXeI4SFZRlV6kn9ta/QWmLoKtbzBoC/2Xrk=;
	b=AZmH2firutpsK9NX0dotYMiCwvrib1M5oOFErCuBtDZ92fkCvlxD+fgeuQSNllpK1y5Smo
	1YSOsXJyU/XWzRxWn74lazYljZgHYs/9mJ5PgUGNJBOCWcaOsdU/En3Ni0Ha6jY52BiGdE
	I9V2xWwcjeIA/5ffKrrMmxhH0VdTJgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-3tYHK_wtMR-YWLgfbQYYpg-1; Mon, 02 Jan 2023 02:43:07 -0500
X-MC-Unique: 3tYHK_wtMR-YWLgfbQYYpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20B1B80D0ED;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F12464015306;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CA8D194704A;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 241CD1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:14:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1568DC16026; Thu, 29 Dec 2022 08:14:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DC6FC16025
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6AC485A588
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:14:38 +0000 (UTC)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com
 [209.85.218.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-Fpn6ymnmNa2Yj0-LFWEX-Q-1; Thu, 29 Dec 2022 03:14:37 -0500
X-MC-Unique: Fpn6ymnmNa2Yj0-LFWEX-Q-1
Received: by mail-ej1-f41.google.com with SMTP id m18so43378906eji.5
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Wf4Oclx/s2DatfZfaRbzTJQI1IZBAeRXW5JK4LTSla4=;
 b=6lopwJlY7m4r1TyzYyP031t2FGlUvrrIHJzckeLUPvw4Kaq+YCVNxJlXOUNhPcbz7Y
 3nQJFH8sbHp12vJtTKn7p4OmK5Z1yyRCPI1iqEjJNKgKmmokkqHs1sZUJKKRdSYtE7FF
 UPp71F7vm3dbxB1WcPOYrF+UYEbqqVBYaiFJzxTQr1tdVJYhy953WtuZoCS6vvA1OtDU
 nH/KBP9RGWwKvBjit3QKmrvO4EXcOw4k800zK6TWvV+avuNhuFIdZPqA8JEVZc9bakxa
 uAg79YoF8wkdH9bwP6k0+o8mV9N8QNQn6/Qp6NmkpcDmMXSuczC/qUpYfIGQP2C92spe
 eNyQ==
X-Gm-Message-State: AFqh2kqBSuEnKuUB5JJtMmoW4pSNJGqNY4f2PghA4r/pMJnFDTSX/JZD
 /h8fCw7fyVtKBOxYEeXEDyXBB0YPKxjp72f+POX6+g==
X-Google-Smtp-Source: AMrXdXs300Z+BXOJPxEJlPkjyVUzSJVOjoySN3yowIHivu+kDMNajS+vq938RArP6B2ta87auqxQOwl3KblSmt1bED8=
X-Received: by 2002:a17:907:c013:b0:7c0:eb3c:1037 with SMTP id
 ss19-20020a170907c01300b007c0eb3c1037mr2068068ejc.663.1672301676050; Thu, 29
 Dec 2022 00:14:36 -0800 (PST)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-5-sarthakkukreti@google.com>
 <YylweQAZkIdb5ixo@infradead.org>
 <CAG9=OMNoG01UUStNs_Zhsv6mXZw0M0q2v54ZriJvHZ4aspvjEQ@mail.gmail.com>
 <Yy1yOGy7yF4AShDB@infradead.org>
In-Reply-To: <Yy1yOGy7yF4AShDB@infradead.org>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 29 Dec 2022 00:14:25 -0800
Message-ID: <CAG9=OMOLLjVJHTPmDSPM3t+Ko90CcN5C01UhEadZReECUE5umw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: Re: [dm-devel] [PATCH RFC 4/8] fs: Introduce FALLOC_FL_PROVISION
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org,
 Evan Green <evgreen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 23, 2022 at 1:45 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Sep 20, 2022 at 10:54:32PM -0700, Sarthak Kukreti wrote:
> > [ mmc0blkp1 | ext4(1) | sparse file | loop | dm-thinp | dm-thin | ext4(2) ]
> >
> > would be predicated on the guarantees of fallocate() per allocation
> > layer; if ext4(1) was replaced by a filesystem that did not support
> > fallocate(), then there would be no guarantee that a write to a file
> > on ext4(2) succeeds.
>
> a write or any unlimited number of writes?

(Apologies for the super late reply!) In this case, even a write won't
be guaranteed if we run out of space on the lower filesystem. Looking
at the fallocate() man page, I think the key part lies in the
following phrase (emphasis mine):

```
After a successful call, subsequent writes into the range
specified by offset and len are guaranteed not to fail _because of
lack of disk space_
```

So, it's not a blanket guarantee that all writes will always succeed,
but that any writes into that range will not fail due to lack of disk
space. As you mentioned, writes may happen out-of-place in one or more
layer. But the fallocate(FALLOC_FL_PROVISION) ensures that each layer
will preserve space for writes into that range to not fail with ENOSPC
(so eg. ext4 and dm-thinp will set aside enough extents to fulfil that
promise later on for all writes).

Best

Sarthak

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

