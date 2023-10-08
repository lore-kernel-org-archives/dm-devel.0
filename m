Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1315DE95A67
	for <dm-devel@archiver.kernel.org>; Sun,  8 Oct 2023 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696809047;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CGnwxeAAQ/TDsBsNpNoJRDnehu8BVFEFG57YoziFrk4=;
	b=KyCSXp9k+td+2YZtWV960d7hy0omqTZYWW62WtKU2jw28RwyOpO9yLIIQTl6iToXW5aq7U
	BJyZma7LBhnyaa+47cxffKzIMJAbBNIij7OoFHaoLlluw7hv5NNHKgYzuPzReWD7JFwrsj
	I1AEZPOr72y4ZD+GfLrJDq8g40iS1sU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-IozXoMfrPwC1eFxzfw9I-A-1; Sun, 08 Oct 2023 19:50:43 -0400
X-MC-Unique: IozXoMfrPwC1eFxzfw9I-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CE3A1875048;
	Sun,  8 Oct 2023 23:50:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A23DB1005E28;
	Sun,  8 Oct 2023 23:50:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C7901946595;
	Sun,  8 Oct 2023 23:50:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E183D194658C
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 Oct 2023 23:50:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A83E21005E29; Sun,  8 Oct 2023 23:50:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A08ED1005E28
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:50:40 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 821BF1C04B55
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:50:40 +0000 (UTC)
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com
 [209.85.161.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-mpwz1xtPORq-k8QlROzBbA-1; Sun, 08 Oct 2023 19:50:18 -0400
X-MC-Unique: mpwz1xtPORq-k8QlROzBbA-1
Received: by mail-oo1-f42.google.com with SMTP id
 006d021491bc7-57ba2cd3507so2393589eaf.2
 for <dm-devel@redhat.com>; Sun, 08 Oct 2023 16:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696809018; x=1697413818;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=I2nXJZN5gQs0HWJ4/hq5HXlGZoe48+E1mQuJOq50Cgo=;
 b=HNGkaT+b5xhogcj3LgRIG2feFslIPBlX5vRDdP+t0dVba6voNIYCClXgRGSKQURqag
 tKw7UsrMeSeGsJuJb5l3oqvgDeKYhhQx/+jJ4oH9T/3VbH9d417Cgqvpr5DBvVcPhZrd
 lN9WhkFqaf34nnso0xQQykoLctTk0/TLDeov1eZ3JKfcDsOGGHcQKoAGiy1pbOGdD7wB
 kBmaXiytCXnkQJQaFIFrT4UJSaF6mPd0WRBOegQHA05bgTw6QrLLTjcYZlY4LLeb/tdl
 DNEFtqr0jEwE0fL0OU42XR91LBSIeqjn3vCOSwatD4ShRuxJHWG+f1BKuylB5S6U/Hqv
 W4Qg==
X-Gm-Message-State: AOJu0YwXr5pEQ774bIxeGGzi6vwQGiEm7kMnfKwKBKDnrtGKWSy5qfuX
 CBDNd9rqdQZmhFFB6bqOB5gcuKvI9dIEV9JKJsg=
X-Google-Smtp-Source: AGHT+IFfwMQn/LIz0fT9Fj7uLEIoUwAbkj1YKSVtQkmCaXkvkIj17Ot1p/KFHLEdYyOotJzHAl0xtw==
X-Received: by 2002:a05:6358:278c:b0:143:8084:e625 with SMTP id
 l12-20020a056358278c00b001438084e625mr14782727rwb.11.1696809017793; 
 Sun, 08 Oct 2023 16:50:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 21-20020a17090a035500b002796494b98csm9815038pjf.37.2023.10.08.16.50.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 08 Oct 2023 16:50:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qpdXK-00BIFK-0u;
 Mon, 09 Oct 2023 10:50:14 +1100
Date: Mon, 9 Oct 2023 10:50:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSNANlreccIVXuo+@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 0/5] Introduce provisioning primitives
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
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 06, 2023 at 06:28:12PM -0700, Sarthak Kukreti wrote:
> Hi,
> 
> This patch series is version 8 of the patch series to introduce
> block-level provisioning mechanism (original [1]), which is useful for provisioning
> space across thinly provisioned storage architectures (loop devices
> backed by sparse files, dm-thin devices, virtio-blk). This series has
> minimal changes over v7[2].
> 
> This patch series is rebased from the linux-dm/dm-6.5-provision-support [1] on to
> (cac405a3bfa2 Merge tag 'for-6.6-rc3-tag'). In addition, there's an
> additional patch to allow passing through an unshare intent via REQ_OP_PROVISION
> (suggested by Darrick in [4]).

The XFS patches I just posted were smoke tested a while back against
loop devices and then forward ported to this patchset. Good for
testing that userspace driven file preallocation gets propagated by
the filesystem down to the backing device correctly and that
subsequent IO to the file then does the right thing (e.g. fio
testing using fallocate() to set up the files being written to)....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

