Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539F7C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 06:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669963507;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y0vVCrEHdgbb0kmNwRPZwJwxBHo3u1+c0Z7ths03j5A=;
	b=hcATu1VSgM2KIl67AeQ7sJmqkoSBs/Of3EjCsdA6nbz4DBN10ETAgSa3/ciPbkfAWMW2Jy
	QCae1y1gaRgQNnbyjaQnrWDKu3ToMUOiwhxQmad0qU1UIpymw3/QEaMIVbqPdBDsleBmr8
	oXCU0/s+FjiSX1zVJEIgqIJcb521z0Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-nlRuNgtgOuytSjvYMKAqpQ-1; Fri, 02 Dec 2022 01:45:06 -0500
X-MC-Unique: nlRuNgtgOuytSjvYMKAqpQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 766A91C06ED6;
	Fri,  2 Dec 2022 06:45:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 626D52166BBA;
	Fri,  2 Dec 2022 06:45:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0357119465A8;
	Fri,  2 Dec 2022 06:44:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A4EDD19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 06:44:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F23A2028E96; Fri,  2 Dec 2022 06:44:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6774A2028CE4
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 06:44:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4852F811E75
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 06:44:57 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-boz_DPJTNK2Z9_QBd01zqg-1; Fri, 02 Dec 2022 01:44:56 -0500
X-MC-Unique: boz_DPJTNK2Z9_QBd01zqg-1
Received: by mail-qt1-f200.google.com with SMTP id
 b20-20020ac844d4000000b003a542f9de3dso13993585qto.7
 for <dm-devel@redhat.com>; Thu, 01 Dec 2022 22:44:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=dU7NyRBpi39eRYNgeIn4w1l6oAb9tUwRMLNEvMpwXCs=;
 b=UM6tHP5x5+KcsjYw9ElfDYshElV7rLtYSDhHOk0k/ltG4Ou//IQK3MVjTL09DDZUB8
 qjY4Jb2fJwvVZ2sIzthNQtTtkD5KQqsZB/k2K88pfctIH2uMbAn3jKXwTD7SSwjKd8Nt
 fk8n4rIUriR23kBakOKXQUAeRWmI4gmgfaJzUHoYv968hPuHXw9D/K+/jwouHSXsQli2
 z5Wsljb15LFIZny7axYC8ojh/DvrowyMoW3YEtOehMO/wCXpS6toZo8sHgOMtEJ2KCfu
 DM3fRtaY3fmdNf2p2Vul0P73lc6DmmFllm1kCGVHSanA0vXaw/Nq+vN+qSDq7nqevHfU
 LAoA==
X-Gm-Message-State: ANoB5pnXkXDtricg/1MMezJrsEG8iw/p2Bc6arJlYOy9XPds9KaFEA6v
 U6F0dKYdqi36tOWVuzM7InI9/F21ooiXOiccfQ5HKTE6ppCed7KNUAjrwxtKBX2aXNZCCslT0Zl
 CiLpluzmnziJeaA==
X-Received: by 2002:a0c:e64f:0:b0:4c6:eced:ba49 with SMTP id
 c15-20020a0ce64f000000b004c6ecedba49mr28440396qvn.102.1669963495369; 
 Thu, 01 Dec 2022 22:44:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4uJial6JmJ2hYF9RJGOOCiZrBVWcVoE1vKQfz7lf4IKLozOq6hkRkgRXnTBYQvWwt+YUnHtw==
X-Received: by 2002:a0c:e64f:0:b0:4c6:eced:ba49 with SMTP id
 c15-20020a0ce64f000000b004c6ecedba49mr28440386qvn.102.1669963495144; 
 Thu, 01 Dec 2022 22:44:55 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 k14-20020a05620a414e00b006cebda00630sm1949323qko.60.2022.12.01.22.44.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 22:44:54 -0800 (PST)
Date: Fri, 2 Dec 2022 01:44:53 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Peter Korsgaard <peter@korsgaard.com>
Message-ID: <Y4me5YOfuXPC/ln5@redhat.com>
References: <20221116061656.2345538-1-peter@korsgaard.com>
 <877czkhc7u.fsf@dell.be.48ers.dk> <Y4fiQvg9OOATD5Cv@redhat.com>
 <87bkond1mi.fsf@dell.be.48ers.dk> <Y4jSkNJzTtRZSbrg@redhat.com>
 <871qpjcc50.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
In-Reply-To: <871qpjcc50.fsf@dell.be.48ers.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2] dm init: add dm-mod.waitfor to wait for
 asynchronously probed block devices
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
Cc: Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@kernel.org>,
 Helen Koike <helen.koike@collabora.com>, fabio.aiuto@amarulasolutions.com,
 dm-devel@redhat.com, michael@amarulasolutions.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 01 2022 at 11:38P -0500,
Peter Korsgaard <peter@korsgaard.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Hi,
> 
>  >> As mentioned,
>  >> https://lore.kernel.org/all/20220406154631.277107-1-fabio.aiuto@amarulasolutions.com/
>  >> is an alternatively (less nice) approach to solve the same issue, so yes
>  >> - It is useful and needed.
> 
>  > OK, so it should be easy for others to say so, right?
> 
> Yes. Fabio, you pointed me to the earlier patch, so you presumably need
> something like this as well, right?
> 
> 
>  > My hesitation is that it feels like something that could be papering
>  > over device specific issues with their async initialization?  Even if
>  > that is the case, it'd be nice to know _why_ this change is needed.
>  > IMHO, the patch header stops short of offering compelling and informed
>  > justification.
> 
> Well, it is exactly like the rootwait option we have for normal (non-dm)
> root= handling, so it is for the same use cases / issues.
> 
> A lot of embedded / non-initramfs setups use rootwait today because of
> the async initialization logic. If those setups want to use root-on-dm
> (E.G. for dm-verity) then they need to use this dm_mod.waitfor= instead
> of rootwait.
> 
> rootwait was added by:
> 
> commit cc1ed7542c8c26af0f501da8006b9fce03e9aaca
> Author: Pierre Ossman <drzeus-list@drzeus.cx>
> Date:   Sun Jul 15 23:40:35 2007 -0700
> 
>     init: wait for asynchronously scanned block devices
> 
>     Some buses (e.g.  USB and MMC) do their scanning of devices in the
>     background, causing a race between them and prepare_namespace().  In order
>     to be able to use these buses without an initrd, we now wait for the device
>     specified in root= to actually show up.
> 
>     If the device never shows up than we will hang in an infinite loop.  In
>     order to not mess with setups that reboot on panic, the feature must be
>     turned on via the command line option "rootwait".
> 
>     [bunk@stusta.de: root_wait can become static]
>     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
>     Cc: Al Viro <viro@zeniv.linux.org.uk>
>     Cc: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Adrian Bunk <bunk@stusta.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

OK, I'll accept your patch, but will tweak the DMINFO slightly to look
more like rootwait's pr_info (e.g. "Waiting for device %s..." and such).

I'll also change the msleep(20) to msleep(5) like was introduced with
commit 39a0e975c37de ("init: reduce rootwait polling interval time to
5ms") -- checkpatch be damned. ;)

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

