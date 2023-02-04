Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E1C5C05027
	for <dm-devel@archiver.kernel.org>; Sat,  4 Feb 2023 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675470019;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rqeyr/D/YGGGK9GjleJAp9kBsMDaNint8yJJNFvSsGU=;
	b=fpDTEgLRbyieHlazo5EQ/f4P3EH0fxY+WFHsz4njjZuX5yn9zgtAEqlmwODNjTz8tmrMAX
	Hy2N6xIJKQ84UP7vWzL/rmcAtuCHWawPEmlz8MY7vHY3mJpArZSG7QKwfKhZpDDZh48n+A
	obVh1Eh1cAH9HpxzQ3RMeuAtDKqhHhU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-h5rxgtcWMBCpvxjn6MXOyA-1; Fri, 03 Feb 2023 19:20:15 -0500
X-MC-Unique: h5rxgtcWMBCpvxjn6MXOyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FCC91C05AAC;
	Sat,  4 Feb 2023 00:20:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DAA9B112132C;
	Sat,  4 Feb 2023 00:20:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 839A8194658C;
	Sat,  4 Feb 2023 00:20:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E5DC1946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  4 Feb 2023 00:20:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DC77410B1B8; Sat,  4 Feb 2023 00:20:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 569C8410B1AD
 for <dm-devel@redhat.com>; Sat,  4 Feb 2023 00:20:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B30818483B3
 for <dm-devel@redhat.com>; Sat,  4 Feb 2023 00:20:12 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-2P_W1DOjP52QSQgJ4zF2lQ-1; Fri, 03 Feb 2023 19:20:10 -0500
X-MC-Unique: 2P_W1DOjP52QSQgJ4zF2lQ-1
Received: by mail-qt1-f174.google.com with SMTP id h24so7440555qta.12
 for <dm-devel@redhat.com>; Fri, 03 Feb 2023 16:20:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=KkoMTSq4l3G1c49HimqfC19O87IH6JspHAce298n11w=;
 b=f4QeMFRQiD/qbqmw3ghQeKhMeom9+J8Hlr5jRhmoT4rA7ce5HzuY5j3y2ozsm9XvQy
 xPWQRQwnBkBre9thXJcOV1J0Lmcuw/SxQW654hi03e5KPRxPgm5L85v/CmzW6lel6IFD
 iXEzk/qMCa+viMRuCrTxeZNBIK61H71eGkF58uY88P4/+508jE1b/GNmoFpGUK1PicNS
 UIjFVvp+LcHfWMk7jo5OLhtVV9ZcqMEqs/DcJBnNtvlWsfw4cF7BKZy4jQmVcJTVcBbO
 gaFzOrS3VhqHHs1OA7E6lPtDwaHiQB7VUfoxwiXqemOSNXVfOI72D1VLnf8VXBXevPtU
 4ugg==
X-Gm-Message-State: AO0yUKWJC11SlO1dm3b1D2UJ2xE3TKq44g/lN96ZIrXKkRZ+u4xfv6fx
 gmoFzagZAi0C7vJtcVuQ9jYHiFI=
X-Google-Smtp-Source: AK7set8kb03l51pPPK2sD000T3nG6rEGMEgSpN3Th8LXVdJ9cJkEm26hx9e4hZWuukXmwkgbfjBXSQ==
X-Received: by 2002:ac8:7f50:0:b0:3a5:1ea1:bae2 with SMTP id
 g16-20020ac87f50000000b003a51ea1bae2mr19566958qtk.34.1675470010067; 
 Fri, 03 Feb 2023 16:20:10 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 g17-20020ae9e111000000b006ce580c2663sm2801394qkm.35.2023.02.03.16.20.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Feb 2023 16:20:09 -0800 (PST)
Date: Fri, 3 Feb 2023 19:20:08 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Message-ID: <Y92kuOeVIaVimXbf@redhat.com>
References: <20230202181423.2910619-1-hch@lst.de> <Y9xqvF6nTptzHwpv@redhat.com>
 <Y9x8pagVnO7Xtnbn@redhat.com> <20230203150053.GA28516@lst.de>
 <Y904yA+mS9go9XKP@redhat.com>
 <20230203235028.GC17327@octiron.msp.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20230203235028.GC17327@octiron.msp.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] block: remove submit_bio_noacct
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 03 2023 at  6:50P -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> On Fri, Feb 03, 2023 at 11:39:36AM -0500, Mike Snitzer wrote:
> > On Fri, Feb 03 2023 at 10:00P -0500,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Thu, Feb 02, 2023 at 10:16:53PM -0500, Mike Snitzer wrote:
> > > > > > The current usage of submit_bio vs submit_bio_noacct which skips the
> > > > > > VM events and task account is a bit unclear.  It seems to be mostly
> > > > > > intended for sending on bios received by stacking drivers, but also
> > > > > > seems to be used for stacking drivers newly generated metadata
> > > > > > sometimes.
> > > > > 
> > > > > Your lack of confidence conveyed in the above shook me a little bit
> > > > > considering so much of this code is attributed to you -- I mostly got
> > > > > past that, but I am a bit concerned about one aspect of the
> > > > > submit_bio() change (2nd to last comment inlined below).
> > > 
> > > The confidence is about how it is used.  And that's up to the driver
> > > authors, not helped by them not having any guidelines.  And while
> > > I've touched this code a lot, the split between the two levels of API
> > > long predates me.
> > > 
> > > > > > Remove the separate API and just skip the accounting if submit_bio
> > > > > > is called recursively.  This gets us an accounting behavior that
> > > > > > is very similar (but not quite identical) to the current one, while
> > > > > > simplifying the API and code base.
> > > > > 
> > > > > Can you elaborate on the "but not quite identical"? This patch is
> > > > > pretty mechanical, just folding code and renaming.. but you obviously
> > > > > saw subtle differences.  Likely worth callign those out precisely.
> > > 
> > > The explanation was supposed to be in the Lines above.  Now accounting
> > > is skipped if in a ->submit_bio recursion.  Before that it dependent
> > > on drivers calling either submit_bio or submit_bio_noacct, for which
> > > there was no clear guideline and drivers have been a bit sloppy about.
> > 
> > OK, but afaict the code is identical after your refactoring.
> > Side-effect is drivers that were double accounting will now be fixed.
> 
> Doesn't this open dm up to double accounting? Take dm-delay for
> instance. If the delay is 0, then submit_bio() for the underlying device
> will be called recursively and will skip the accounting.  If the delay
> isn't 0, then submit_bio() for the underlying device will be called
> later from a workqueue and the accounting will happen again, even though
> the same amount of IO happens in either case. Or am I missing something
> here?
> 
> -Ben 

Nope, you aren't missing anything, good catch!

Callers of dm_submit_bio_remap() are the poster-child for submitting
bios from a different task.

So yeah...

Nacked-by: Mike Snitzer <snitzer@kernel.org>

(Could be that many submit_bio_noacct callers can be converted but we
really do need to keep the submit_bio_noacct interface)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

