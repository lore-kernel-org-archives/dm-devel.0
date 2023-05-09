Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C5E9C77B75
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683651111;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/6jUBAFI86OeK6EB2c0wD74TFCXI7kQBSyHQ3thsPw0=;
	b=LNJ1xtp1BoHB6j/KyKC3YiIsg7VZB/BjgQEfHyEbZZnpNvJ3R2wGjAt8gGoERN8W8MAHq+
	oYmxwaIoxsmAQsoI5hfLVfck55qB/BKQ56p2iFjwZj3nCM7GCTgbm/7kcJbwFBlvjnxT0R
	p/aPJ/j1m6PHh3V+cLMOwzS/YZfY4Ro=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-xiAi4rcBPq-9WPW2z72jjQ-1; Tue, 09 May 2023 12:51:48 -0400
X-MC-Unique: xiAi4rcBPq-9WPW2z72jjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BC888026E8;
	Tue,  9 May 2023 16:51:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A54863F5B;
	Tue,  9 May 2023 16:51:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B18D19465BD;
	Tue,  9 May 2023 16:51:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A83E19465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 16:51:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A193492B00; Tue,  9 May 2023 16:51:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 12A8D492B01
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:51:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB7AC100F64F
 for <dm-devel@redhat.com>; Tue,  9 May 2023 16:51:42 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
 [209.85.222.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-sW9cOq2-MuCLxjyfYSyVgg-1; Tue, 09 May 2023 12:51:41 -0400
X-MC-Unique: sW9cOq2-MuCLxjyfYSyVgg-1
Received: by mail-qk1-f182.google.com with SMTP id
 af79cd13be357-7577ef2fa31so782368185a.0
 for <dm-devel@redhat.com>; Tue, 09 May 2023 09:51:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683651100; x=1686243100;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=8AiXugarlhHToBN2ueOGwWaX5E4llz8s13EASoB3wVI=;
 b=UgOswdxZxN5GrLRyMP3SjR8dn6CzCptACbbACt9oJTnlKBAgqMzseDBJ5/7Utw94dG
 rZ6p/1oyqL0/7q4+S5MPGfSKyeww2r7R0V7S/dl+6deoZbPegaG2NDDgxTmjtGhDhzz/
 nlx06vqOjTnDRIXMoB0A/qZqE0wsG8uiW8jWTJBMKK2nGl2GwEvxyYpwpqrvu+b5rK+9
 +Z+NYoq/LwjPdeyoP5F/rKnoAbqZ/1LGQYqT3usNOBX/UI3DsqnOPmiKmZZlQleXBG3a
 rS//D6PXBm0wlSL4uXwViEY6zCJ04HtBxmslH1sYQn1TWZo4ymohtficwoJOFip92+xx
 Agrw==
X-Gm-Message-State: AC+VfDwaYGqsS+NW5OilaNkYD/Y2h7JTsF2/hOP2SZsBKZfRJCtKRDQq
 mTYLi68sm1Wba/eg8kb57wcdNLarv3+WQSyY215Ffvc=
X-Google-Smtp-Source: ACHHUZ4xRyujKImbkSQcW8Z759B/taKjk2/BBWT+4ePbKXa9irKnpFPNPIQc/SyDOhMLc66FmfxRwA==
X-Received: by 2002:a05:6214:29c7:b0:56e:c066:3cd2 with SMTP id
 gh7-20020a05621429c700b0056ec0663cd2mr19939922qvb.2.1683651100740; 
 Tue, 09 May 2023 09:51:40 -0700 (PDT)
Received: from localhost ([217.138.208.150]) by smtp.gmail.com with ESMTPSA id
 m4-20020a0cf184000000b0061b3338d6d9sm890247qvl.50.2023.05.09.09.51.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 May 2023 09:51:40 -0700 (PDT)
Date: Tue, 9 May 2023 12:51:38 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZFp6GphV3H0eyrH+@redhat.com>
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-2-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230506062909.74601-2-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v6 1/5] block: Don't invalidate pagecache for
 invalid falloc modes
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
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, May 06 2023 at  2:29P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> Only call truncate_bdev_range() if the fallocate mode is
> supported. This fixes a bug where data in the pagecache
> could be invalidated if the fallocate() was called on the
> block device with an invalid mode.
> 
> Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
> Cc: stable@vger.kernel.org
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

