Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1558FC77B7E
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 23:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685401979;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OUCwqP00fzR6j0aENJezuNA/yBnrNOkj928aAeGn5v4=;
	b=PvBl6dnN+rncieM7+/csYr9Y8Jt+2m8FIcg//Mk38VODsvNZ2jUHp+gGpVGkMBbllSS4L3
	hx6iFm58XfC7qFHEsCERfZbS9YhOpGwicYHQ3MM+qi0dxpJWBARepVWaAuQ7ze1eTTtumI
	PsQv/Rr5c6DlQ0ftq6ixJRYULvB2dvE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-AfstQVxxN9ySbIogv_rQIw-1; Mon, 29 May 2023 19:12:56 -0400
X-MC-Unique: AfstQVxxN9ySbIogv_rQIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8806185A78B;
	Mon, 29 May 2023 23:12:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68EEA140EBB8;
	Mon, 29 May 2023 23:12:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B4871946595;
	Mon, 29 May 2023 23:12:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BBA75194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 23:12:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D73E112132D; Mon, 29 May 2023 23:12:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 861F4112132C
 for <dm-devel@redhat.com>; Mon, 29 May 2023 23:12:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 682F0811E7C
 for <dm-devel@redhat.com>; Mon, 29 May 2023 23:12:51 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-5H0145S6OMK6MLxWg8mxnw-1; Mon, 29 May 2023 19:12:49 -0400
X-MC-Unique: 5H0145S6OMK6MLxWg8mxnw-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-64d30ab1f89so2527995b3a.3
 for <dm-devel@redhat.com>; Mon, 29 May 2023 16:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685401968; x=1687993968;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=CEb/q2oR2f3xfXECLF27YKQHP0Ck5BcAeCfMowWxLOI=;
 b=kthYQT2VufRxJjMyJzVfxNRjjkBWduYB7HoDtyrIEt6m9OAlRMGMU6Pz3/7QRzqdnz
 /knYX+LhqzBDOTYqqdBk/D6881qE9UZetvuxjK/nCBsGnBSIN3ob4+xCi+lV0mPXxf99
 RwnCcbm61PDn37XdNJe1Tiw6zUpt1NzmLG8MbvsgTZXjXSL5fL/1Gt8lzGaEeS5P2rVe
 81s6EsvFnpzJR0xf/Gyu0K153AOdvWwq9vYPqLtjBIsamJ0EfimRAB2pNF2SoEiCKuxy
 85C5CoxOJXTtMPYogbNcC1n9LRZT931tToEDU/T4lWyrREqHr9WUHokBBJyxPwCNUoVi
 BFGA==
X-Gm-Message-State: AC+VfDx/kwt+nCLI7MrKh8Kvmr/NBCxKXW0HIfvqBzJ9Ef9geutz/Q7J
 z7Aj2lHQQpgN+asiHXyMmTlVYA==
X-Google-Smtp-Source: ACHHUZ7Q5mP843nhoE0+BC2QT5pCXDuq4Cdhm+ZbTapkVUOV3QG9I8B9Dc17Xb/SzUwDSi8xRONYzg==
X-Received: by 2002:a05:6a20:a5a8:b0:10e:f1e3:8217 with SMTP id
 bc40-20020a056a20a5a800b0010ef1e38217mr451730pzb.17.1685401968467; 
 Mon, 29 May 2023 16:12:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au.
 [49.179.0.188]) by smtp.gmail.com with ESMTPSA id
 j31-20020a63fc1f000000b00502e7115cbdsm7469726pgi.51.2023.05.29.16.12.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 29 May 2023 16:12:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1q3m2e-005UaD-1Z;
 Tue, 30 May 2023 09:12:44 +1000
Date: Tue, 30 May 2023 09:12:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <ZHUxbLh1P9yiq2c9@dread.disaster.area>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHUVy7jut1Ex1IGJ@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZHUVy7jut1Ex1IGJ@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] fuzzing bcachefs with dm-flakey
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
Cc: linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 dm-devel@redhat.com, Kent Overstreet <kent.overstreet@linux.dev>,
 Mikulas Patocka <mpatocka@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 29, 2023 at 10:14:51PM +0100, Matthew Wilcox wrote:
> On Mon, May 29, 2023 at 04:59:40PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I improved the dm-flakey device mapper target, so that it can do random 
> > corruption of read and write bios - I uploaded it here: 
> > https://people.redhat.com/~mpatocka/testcases/bcachefs/dm-flakey.c
> > 
> > I set up dm-flakey, so that it corrupts 10% of read bios and 10% of write 
> > bios with this command:
> > dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"
> 
> I'm not suggesting that any of the bugs you've found are invalid, but 10%
> seems really high.  Is it reasonable to expect any filesystem to cope
> with that level of broken hardware?  Can any of our existing ones cope
> with that level of flakiness?  I mean, I've got some pretty shoddy USB
> cables, but ...

It's realistic in that when you have lots of individual storage
devices, load balanced over all of them, and then one fails
completely we'll see an IO error rate like this. These are the sorts
of setups I'd expect to be using erasure coding with bcachefs, so
the IO failure rate should be able to head towards 20-30% before
actual loss and/or corruption should start occurring.

In this situation, if the failures were isolated to an individual
device, then I'd want the filesystem to kick that device out of the
backing pool. Hence all the failures go away and then rebuild of the
redundancy the erasure coding provides can take place. i.e. an IO
failure rate this high should be a very short lived incident for a
filesystem that directly manages individual devices.

But within a single, small device, it's not a particularly realistic
scenario. If it's really corrupting this much active metadata, then
the filesystem should be shutting down at the first
uncorrectable/unrecoverable metadata error and every other IO error
is then superfluous.

Of course, bcachefs might be doing just that - cleanly shutting down
an active filesystem is a very hard problem. XFS still has intricate
and subtle issues with shutdown of active filesystems that can cause
hangs and/or crashes, so I wouldn't expect bcachefs to be able to
handle these scenarios completely cleanly at this stage of it's
development....

Perhaps it is worthwhile running the same tests on btrfs so we can
something to compare the bcachefs behaviour to. I suspect that btrfs
will fair little better on the single device, no checksums
corruption test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

