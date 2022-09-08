Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15843C38145
	for <dm-devel@archiver.kernel.org>; Thu,  8 Sep 2022 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662654725;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n7kbluE9Mx0JzRBfPwy1jVa+jZxubnS1T5n+16eCVNc=;
	b=ef0OYl5UISjBxz0C+xdyQoGY9ROYnx4ojSCoJwOXKMv9e3A9nQyzV8YO6izqJ6hU1wR8Cx
	pUd6aibnGBnUS1Cjg/i1Peio3S1d67o+UMylYoQtZAGUAwpFTmi8T+hRNjGECktn+rVujF
	3sNFW9DY2WSDpC+SmztMbGm3CaoPiQk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-5fgHIGVcP76LJPC3m9A9jQ-1; Thu, 08 Sep 2022 12:32:03 -0400
X-MC-Unique: 5fgHIGVcP76LJPC3m9A9jQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DEF9294EDE9;
	Thu,  8 Sep 2022 16:32:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E1C1909FF;
	Thu,  8 Sep 2022 16:31:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4BA9F1946A44;
	Thu,  8 Sep 2022 16:31:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B9F11946A41
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Sep 2022 16:31:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB817112131B; Thu,  8 Sep 2022 16:31:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7ADA1121315
 for <dm-devel@redhat.com>; Thu,  8 Sep 2022 16:31:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC2D0382C96F
 for <dm-devel@redhat.com>; Thu,  8 Sep 2022 16:31:57 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-ptvgTzTtO06RksXqlas0DA-1; Thu, 08 Sep 2022 12:31:56 -0400
X-MC-Unique: ptvgTzTtO06RksXqlas0DA-1
Received: by mail-qt1-f169.google.com with SMTP id e28so13327651qts.1
 for <dm-devel@redhat.com>; Thu, 08 Sep 2022 09:31:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=PX5B4DOO9VKB3vdPnCDviaalsOiW5Pvp7jCaKLShA6c=;
 b=J7SIKTp/Nq+/5X8A4AZyk/dWhGldAa4GWs63LQn5IVnJM+4BfpYfGykpLqGRvo8ZZo
 xnCfB23MpYbejHchY8ASP1C7maHuyIhQR5Gt69n3qrdsSaNb2es+jIZ+iIWlFJEVkfeK
 RIotmxxJ50QjqKaTw6TSTR8vQ5pMRhy4NSoNB8H9M0JPIBjHrTHcirfxI6iFhV4lO8OI
 gfpvIn75HI/xqkSHVUHBPsN4WGbBSTMbInOtd6PU1R2T5Xp2NQA2Fa4IKfzuNA+fXkP0
 g40cTYK/DphKJd8HZc3whZMI8VYya+a/xm3/NHeps/SLiNudErlExV8/JSIDtIJJR+8a
 dX3Q==
X-Gm-Message-State: ACgBeo0FzEwhSqg+4TxrkrnZIg9fVN45f1RJ2T4fBLh9me+Z7xljMneW
 xrQygBZMDA+cnM9lH8LKxYtGdoI=
X-Google-Smtp-Source: AA6agR7c+N33V5guNwxmRNMXuWyaQo5G9ZX7Cz4TZ5I9iGmtqsztgxOGSE4f05D5DrKrMDgf0tX/ng==
X-Received: by 2002:a05:622a:178e:b0:344:56a8:25da with SMTP id
 s14-20020a05622a178e00b0034456a825damr8513942qtk.375.1662654715883; 
 Thu, 08 Sep 2022 09:31:55 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 l5-20020ac81485000000b0031f41ea94easm14551916qtj.28.2022.09.08.09.31.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Sep 2022 09:31:55 -0700 (PDT)
Date: Thu, 8 Sep 2022 12:31:54 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YxoY+hDrmNwvmbiM@redhat.com>
References: <20220907133055.1.Ic8a1dafe960dc0f8302e189642bc88ebb785d274@changeid>
 <166259004596.4128104.7200162640366282166.b4-ty@chromium.org>
 <YxoJcG5MN4OdaulL@redhat.com> <202209080912.00880AD6@keescook>
MIME-Version: 1.0
In-Reply-To: <202209080912.00880AD6@keescook>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] dm: verity-loadpin: Only trust verity targets with
 enforcement
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
Cc: dianders@chromium.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, mka@chromium.org,
 sarthakkukreti@chromium.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 08 2022 at 12:13P -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Thu, Sep 08, 2022 at 11:25:36AM -0400, Mike Snitzer wrote:
> > On Wed, Sep 07 2022 at  6:34P -0400,
> > Kees Cook <keescook@chromium.org> wrote:
> > 
> > > On Wed, 7 Sep 2022 13:30:58 -0700, Matthias Kaehlcke wrote:
> > > > Verity targets can be configured to ignore corrupted data blocks.
> > > > LoadPin must only trust verity targets that are configured to
> > > > perform some kind of enforcement when data corruption is detected,
> > > > like returning an error, restarting the system or triggering a
> > > > panic.
> > > > 
> > > > 
> > > > [...]
> > > 
> > > Applied to for-next/hardening, thanks!
> > > 
> > > [1/1] dm: verity-loadpin: Only trust verity targets with enforcement
> > >       https://git.kernel.org/kees/c/2e1875c05267
> > 
> > Does this mean you're intending to send this upstream?  I prefer to
> > take all DM changes unless there is an external dependency.
> 
> Oh! Yeah, I added it to my tree since you'd asked me to take the
> original verity-loadpin series and this was a fix. I'm happy either
> way. Shall I drop this change from my tree?

Let's leave it in your tree if you'll be sending this as a fix for
6.0-rc?

But moving forward, I'll take new development that is localized to DM.
Sound good?

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

