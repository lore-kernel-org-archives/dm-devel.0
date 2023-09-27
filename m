Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8AEE82CA7
	for <dm-devel@archiver.kernel.org>; Wed, 27 Sep 2023 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695830354;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=og7TP4xg9O5dWPNfB0Vg+J/uvHmS8onFlSS+oLaUdwQ=;
	b=FjTvVb+O5kU76ouC2TDT0Sio8sPyZ1S0rkxJmqO0nidsSwcUthgrcUIEqvPjNf3YrjqRIE
	yTqlRspIkFpPJU16JLUZtPMAYXXmr7Gl4o30AhclZZKX/oPttgdVMjso1sPY7KavnyXA/i
	8gZ0dYShb+tXgq3nCqMI5mF2r+TCeDA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-Wy-MQRFzOiav1aM0Sw30Wg-1; Wed, 27 Sep 2023 11:59:11 -0400
X-MC-Unique: Wy-MQRFzOiav1aM0Sw30Wg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3474A280FED8;
	Wed, 27 Sep 2023 15:59:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 90799492B16;
	Wed, 27 Sep 2023 15:59:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA9011946588;
	Wed, 27 Sep 2023 15:58:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 852141946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Sep 2023 15:57:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38C5240C6E76; Wed, 27 Sep 2023 15:57:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3263C40C6EA8
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 15:57:05 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 164AD280FED3
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 15:57:05 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-dVoOLnNHOKqYaB-uj70vDw-1; Wed, 27 Sep 2023 11:57:03 -0400
X-MC-Unique: dVoOLnNHOKqYaB-uj70vDw-1
Received: by mail-qt1-f182.google.com with SMTP id
 d75a77b69052e-418148607c2so36861771cf.3
 for <dm-devel@redhat.com>; Wed, 27 Sep 2023 08:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695830223; x=1696435023;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=S3Il49+//K5JCm+OJgwegi/zdJ0hzFwfrUfLnTjc6G4=;
 b=d4V6VL6S6eWbC2iAJ7JwpV5USGsRlRTSctLErSyu6QcJdytiCUxLcZGlY6yHEo+hP+
 TaxzWsGwaFH1G0LHZN4QjYPYQEeN3duA4JQ+T9rdVOJ9RpCkKTNHau7j0Y4n/HjqUfL4
 w5ZQjthbd2YJZgm6CdXjjryFQ5PKVKqk2/sH5VzQZ/CeQ0SniryTqUZ1OEeG7e9pD7fv
 3W1LuZYQztzt2M12hObMoeS7yjxOMfZAVsG/XJtfd7dzLdhvan/NQVeWtm2VnqaY/zb4
 0aElpLFMglWjoCjjSZAPSNiq9FrFGr0lj9HpQhuk26UOWAvCdgX9wlTajkPt8ptUwwFF
 nwaA==
X-Gm-Message-State: AOJu0YyToZsLr6pKv5iopvgr+7BvJmaHigvADxZ4UF5RYPYo2QVsGQ67
 IkHcGZsSVsmGUv8RrJe2oLGpyDw=
X-Google-Smtp-Source: AGHT+IGlNeEFInSsY3+T7WPLWCeeNAt+7/UBnUocZYzLtSLlwFsm/XDL1vFa4mRtygT3O8tv3RjtrA==
X-Received: by 2002:a05:622a:14cf:b0:418:1dc6:b909 with SMTP id
 u15-20020a05622a14cf00b004181dc6b909mr2634137qtx.26.1695830222747; 
 Wed, 27 Sep 2023 08:57:02 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 jj2-20020a05622a740200b004054b435f8csm5379047qtb.65.2023.09.27.08.57.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Sep 2023 08:57:02 -0700 (PDT)
Date: Wed, 27 Sep 2023 11:57:01 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <ZRRQzWHeTajRZGko@redhat.com>
References: <ZRNWRyc7xPY17fvt@casper.infradead.org>
 <ZRNg7ctL4cx75RVh@casper.infradead.org>
 <ZROyqtbB6OuMOqci@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <ZROyqtbB6OuMOqci@casper.infradead.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] Sleeping function called from invalid context
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
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 27 2023 at 12:42P -0400,
Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Sep 26, 2023 at 11:53:33PM +0100, Matthew Wilcox wrote:
> > I'm going to sleep now instead of running the last 10 steps of the
> > bisect.  If nobody's found this when I wake up, I'll finish it then.
> 
> Bisection found it.  I confirmed by hand; checking out this commit
> yields a failed test, and then reverting it leads to a success.
> 
> commit 026e4728c276cdf3ec618a71a38181864596027b
> Author: Joe Thornber <ejt@redhat.com>
> Date:   Wed Sep 13 10:39:09 2023 +0100
> 
>     dm thin: Use the extent allocator for data blocks
> 
>     The thin_pool object now contains an extent-allocator, and each thin
>     device contains an allocation-context from this.  The allocation
>     context is used to guide data block allocations.  The actual
>     allocation book-keeping is still done by the space-map.
> 
>     2 new specific unit tests were added to dm-unit:
> 
>        /thinp/fragmentation/thins
>        /thinp/fragmentation/snapshots
> 
>        https://github.com/jthornber/dm-unit/blob/main/src/tests/thinp.rs
> 
>     Signed-off-by: Joe Thornber <ejt@redhat.com>
>     Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> 
> Joe, in case you missed the earlier splat:

...

> 
> This seems fairly clear to me; there's a spin_lock() around the call to
> __alloc() in dm_ea_context_alloc(), which then calls all the way down
> that stack until you get to cache_get(), which takes a semaphore and
> the locking validation quite reasonably says "You can't do that".
> 
> I'm sure you don't need my help coming up with a fix.  Although I might
> ask that you turn on at least some basic locking checks in future while
> developing your code, even if not full lockdep.  I think this particular
> warning comes out of CONFIG_DEBUG_ATOMIC_SLEEP=y.

Thanks for the report and bisecting -- wish I caught you earlier to
save you the hassle (was immediately clear which commit caused it when
I saw the trace).

Joe is looking at how best to fix and also updating dmtest-python [1]
to scrape the kernel log to pickup such bugs (as-is the kernel will
carry on despite the splat, so far anyway).

But I've dropped the related code from linux-next until this is all
fixed properly.

Mike

[1] https://github.com/jthornber/dmtest-python.git

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

