Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E99C636CC
	for <dm-devel@archiver.kernel.org>; Fri,  3 Feb 2023 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675394251;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TB6f09yVrJ79okN2HKlGJlZb8dn7xTi2UyBKSksMGV4=;
	b=BQbEg/CnkVVw3Wk6ehSNv4L7WtIhcI72lWwBhQ/h3nvG7uw0JBmhvLMLPmez2Jk2AzQsbN
	RxfHRscFthKgmOkNsO7MtwCkf/wiSnIa+gOwOYPWiZGL3SZG2vCCzoFYsbuFVPnQd8gWRZ
	ICw6Hw4Y/6A0UZcsi8bCcfTeAF0pO5w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-SPpFsHrPNE-b2v1XwSvZkg-1; Thu, 02 Feb 2023 22:17:29 -0500
X-MC-Unique: SPpFsHrPNE-b2v1XwSvZkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 222541C05EB1;
	Fri,  3 Feb 2023 03:17:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC502166B33;
	Fri,  3 Feb 2023 03:17:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07230194658C;
	Fri,  3 Feb 2023 03:17:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D62F91946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Feb 2023 03:16:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 22ECA51FF; Fri,  3 Feb 2023 03:16:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B77A51E5
 for <dm-devel@redhat.com>; Fri,  3 Feb 2023 03:16:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EED9618A6460
 for <dm-devel@redhat.com>; Fri,  3 Feb 2023 03:16:56 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
 [209.85.219.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-YRkUeoHIP6WuA-uewdk4ig-1; Thu, 02 Feb 2023 22:16:55 -0500
X-MC-Unique: YRkUeoHIP6WuA-uewdk4ig-1
Received: by mail-qv1-f51.google.com with SMTP id w15so2206320qvs.11
 for <dm-devel@redhat.com>; Thu, 02 Feb 2023 19:16:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=chy9YyvhK7mXtGQ0tGQeB7OCTzTRKLRhbvbjGLVTm2I=;
 b=zqngQek4jgWvT1F8FHy56f8uw/uvh00hKU2k46ZjX1Eu5AlLR9Gs6ELpmpgfop4T73
 uvq7Y/SOlX5e6UsOzfkyDp7ZwnuOrbsCtTYw5+HrN9NpUMi19Q0mQb7WlDlBbEtd2Ld4
 2lbkofLUegdxLa8AcuWnFAIaaa8S3YhUG4sahs6mREHTXfMzjO869vO7G+P7eTjY8HMB
 qmwAH10cOvOnYhGAeu+jQvPnCr9gkDZi8TfSaRPUmFIPo3Mml/+Tbygy4oGw+YjjiZIn
 dNsz9t974RT+yGV9vuDMik3S4vG3xF2W3SOc1TthnxznbVKPdrnunBb6eT9D9hmpWQuy
 tDgg==
X-Gm-Message-State: AO0yUKU0m5/7lIDJwMEhdpwYpYIN3VukK1ITIPJNPn4AopDgsBo/EvdF
 AbrpEUJFCt5dFejuipDnojXG8x0=
X-Google-Smtp-Source: AK7set/2v3K4VImtWp4wHlaBIXTCJSzpiCix8tANg3EljgK7D+Bw6KwYPu2AFz6rnlkQQv5scx+9Zg==
X-Received: by 2002:a0c:e9c9:0:b0:537:6f8c:2c2c with SMTP id
 q9-20020a0ce9c9000000b005376f8c2c2cmr12293368qvo.41.1675394214581; 
 Thu, 02 Feb 2023 19:16:54 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 ea7-20020a05620a488700b007290be5557bsm1000464qkb.38.2023.02.02.19.16.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Feb 2023 19:16:54 -0800 (PST)
Date: Thu, 2 Feb 2023 22:16:53 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y9x8pagVnO7Xtnbn@redhat.com>
References: <20230202181423.2910619-1-hch@lst.de> <Y9xqvF6nTptzHwpv@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y9xqvF6nTptzHwpv@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
 linux-raid@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 02 2023 at  9:00P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Thu, Feb 02 2023 at  1:14P -0500,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > The current usage of submit_bio vs submit_bio_noacct which skips the
> > VM events and task account is a bit unclear.  It seems to be mostly
> > intended for sending on bios received by stacking drivers, but also
> > seems to be used for stacking drivers newly generated metadata
> > sometimes.
> 
> Your lack of confidence conveyed in the above shook me a little bit
> considering so much of this code is attributed to you -- I mostly got
> past that, but I am a bit concerned about one aspect of the
> submit_bio() change (2nd to last comment inlined below).
> 
> > Remove the separate API and just skip the accounting if submit_bio
> > is called recursively.  This gets us an accounting behavior that
> > is very similar (but not quite identical) to the current one, while
> > simplifying the API and code base.
> 
> Can you elaborate on the "but not quite identical"? This patch is
> pretty mechanical, just folding code and renaming.. but you obviously
> saw subtle differences.  Likely worth callign those out precisely.
> 
> How have you tested this patch?  Seems like I should throw all the lvm
> and DM tests at it.
> 

...

> > @@ -716,6 +712,27 @@ void submit_bio_noacct(struct bio *bio)
> >  
> >  	might_sleep();
> >  
> > +	/*
> > +	 * We only want one ->submit_bio to be active at a time, else stack
> > +	 * usage with stacked devices could be a problem.  Use current->bio_list
> > +	 * to collect a list of requests submited by a ->submit_bio method while
> > +	 * it is active, and then process them after it returned.
> > +	 */
> > +	if (current->bio_list) {
> > +		bio_list_add(&current->bio_list[0], bio);
> > +		return;
> > +	}
> 
> It seems pretty aggressive to queue the bio to current->bio_list so
> early. Before this patch, that didn't happen until the very end
> (meaning all the negative checks of submit_bio_noacct were done before
> doing the bio_list_add() due to recursion). This is my primary concern
> with this patch. Is that the biggest aspect of your "not quite
> identical" comment in the patch header?
> 
> In practice this will manifest as delaying the negative checks, until
> returning from active submit_bio, but they will still happen.

Actually, I don't think those checks are done at all now.

Unless I'm missing something, this seems like it needs proper
justification and a lot of review and testing.

So why do this change?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

