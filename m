Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAD2E95A67
	for <dm-devel@archiver.kernel.org>; Sun,  8 Oct 2023 23:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696808289;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OEm4nk2o+0fhRX5yhJ7KW6pPb5mTRI9PvLWFj4iZpDk=;
	b=UhhQFoFhqAfTRPjfGcqQu4OiRHAPcEjB/mazWVn6pTOMkBHVM3Jyuf5Fl6iAV5YiA8FjEp
	M0qfgMO+TJlpr/ei6dVyAkanz7B/RaMkTcfepWwNB/V04Ht/kN6kP+kOKndPvIZ9gUKr7u
	Q8q6cvL0Nfr2v++zsGjtyfS1F5MVqG0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-bXTW_PQCP4uUAdcGMV0v7g-1; Sun, 08 Oct 2023 19:38:06 -0400
X-MC-Unique: bXTW_PQCP4uUAdcGMV0v7g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A259138035AC;
	Sun,  8 Oct 2023 23:38:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2516C400F36;
	Sun,  8 Oct 2023 23:38:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D52B21946595;
	Sun,  8 Oct 2023 23:38:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 197DF194658C
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 Oct 2023 23:38:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C93FE400F36; Sun,  8 Oct 2023 23:38:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1A91401038
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:38:02 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FBD3101A550
 for <dm-devel@redhat.com>; Sun,  8 Oct 2023 23:38:02 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-gKLwZgJKPgCxxsiVSs7d3w-1; Sun, 08 Oct 2023 19:37:56 -0400
X-MC-Unique: gKLwZgJKPgCxxsiVSs7d3w-1
Received: by mail-pf1-f170.google.com with SMTP id
 d2e1a72fcca58-690f7d73a3aso3593047b3a.0
 for <dm-devel@redhat.com>; Sun, 08 Oct 2023 16:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696808275; x=1697413075;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ugb0tKKwENhwxws0wCM1fp+8N3X07t18Hh39dqaZxsY=;
 b=GGVgmNJaWjtzMcu2cgE77/KgZQUZ+yVAb8dZ3Kn+P948rI4lDvadAnB3DRLvID4+Q2
 4/wREY9Fy4KH54I9nKqWlAYdB8hlYeBAJ4QwHPfxnh4E3q8eixc7fzp2TWMByjujNwzm
 HAD0qs3STjzL3TSbPKa8xQDM4w0Cv2Ohnv1LDTfLRghUijBHeoc73ChiX85E7RUywRtH
 7AUhyBbqq3cgKucSYyteuNuH7A7N5J0BKYyg4A+W+/Nagp6EVRlJkmcC1GiE++ry2fYl
 BGCGPBJRehK2y2FyXRRyHA2nZ4UXkVMYE1CQTeVGR+k0WHnTC8ZoyNexhVF9xzi87l2b
 PDkg==
X-Gm-Message-State: AOJu0Yz4RAdi1OS7SOljVZ9DCkWagG/T2OkfnMOWdENrkXphcDBd/MFK
 eQBMw23cEtd3dwKUtL+C2YiOrA==
X-Google-Smtp-Source: AGHT+IGtSDlJuSlhM5b245J5Cmp3FU0as25Fi5QlSTltQv1K/y0QGdGqfOnc1SLtt6Qt6+3EetsZOQ==
X-Received: by 2002:a05:6a00:1912:b0:690:d2b0:1b37 with SMTP id
 y18-20020a056a00191200b00690d2b01b37mr18093157pfi.10.1696808275521; 
 Sun, 08 Oct 2023 16:37:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 c26-20020a62e81a000000b00693498a847fsm5047054pfi.137.2023.10.08.16.37.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 08 Oct 2023 16:37:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qpdLM-00BI5X-0f;
 Mon, 09 Oct 2023 10:37:52 +1100
Date: Mon, 9 Oct 2023 10:37:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSM9UDMFNs0050pr@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <20231007012817.3052558-4-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20231007012817.3052558-4-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v8 3/5] loop: Add support for provision
 requests
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 06, 2023 at 06:28:15PM -0700, Sarthak Kukreti wrote:
> Add support for provision requests to loopback devices.
> Loop devices will configure provision support based on
> whether the underlying block device/file can support
> the provision request and upon receiving a provision bio,
> will map it to the backing device/storage. For loop devices
> over files, a REQ_OP_PROVISION request will translate to
> an fallocate mode 0 call on the backing file.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>


Hmmmm.

This doesn't actually implement the required semantics of
REQ_PROVISION. Yes, it passes the command to the filesystem
fallocate() implementation, but fallocate() at the filesystem level
does not have the same semantics as REQ_PROVISION.

i.e. at the filesystem level, fallocate() only guarantees the next
write to the provisioned range will succeed without ENOSPC, it does
not guarantee *every* write to the range will succeed without
ENOSPC. If someone clones the loop file while it is in use (i.e.
snapshots it via cp --reflink) then all guarantees that the next
write to a provisioned LBA range will succeed without ENOSPC are
voided.

So while this will work for basic testing that the filesystem is
issuing REQ_PROVISION based IO correctly, it can't actually be used
for hosting production filesystems that need full REQ_PROVISION
guarantees when the loop device backing file is independently
shapshotted via FICLONE....

At minimuim, this set of implementation constraints needs tobe
documented somewhere...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

