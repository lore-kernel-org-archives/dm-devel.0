Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FA8C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 03:17:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-hkqSZ-HVNYCZ0wgyb_fk_w-1; Sun, 17 Apr 2022 23:17:00 -0400
X-MC-Unique: hkqSZ-HVNYCZ0wgyb_fk_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C5A03804067;
	Mon, 18 Apr 2022 03:16:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA1B940FF407;
	Mon, 18 Apr 2022 03:16:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3DA419451F1;
	Mon, 18 Apr 2022 03:16:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27BA519466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 03:16:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BF2F574771; Mon, 18 Apr 2022 03:16:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07BC9574768
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 03:16:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E461C185A7B2
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 03:16:56 +0000 (UTC)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com
 [209.85.160.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-p4s6Tc-QPJqtztOQ14AxtQ-1; Sun, 17 Apr 2022 23:16:55 -0400
X-MC-Unique: p4s6Tc-QPJqtztOQ14AxtQ-1
Received: by mail-qt1-f173.google.com with SMTP id o18so9335787qtk.7
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 20:16:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Xg66rN/k7YXbXVlhfm9XM2FMk2dwtaKqTQCkUOQCLY4=;
 b=drQ8SLCfZLUp5ZPFdfRHMZ4yfo3zQhjALiiK0ShSvV/LuRUV6OBC0GlSNOsS/JSbCr
 yUEw/QZBfVkqNU7alnoduafaPMlsHr9/IRhtSuim4A7ctlkLeL5bZu+uveJqZ4qEo28B
 6SzWnqjmmkBBLJ7l52d3j66vCWMXqzEZqD6O/QgYg7tmhICb59qQ53IZedG/BxSvWQ4U
 Ow6y97QmuhYkyGJ5IRE1Md7EPm2VbSauiGDkqJS2nAwmX0mD+Bpi9OmLgBBnN7j/EJBt
 CVDen5nLf1uxyrs7PxvjdasiPwLqSlnVDhI3GartRUG0yyYsKHgw6RTlmSyaY6niYpSh
 x9mw==
X-Gm-Message-State: AOAM532u19qi2ziO54iJxfB/38aHNRhiuns/bGQhKxqhWMHnLsZSjC6p
 /AH295nGe716T0F9BlVhYdYuVjo=
X-Google-Smtp-Source: ABdhPJyE78mIy/MYgQOeRWnwSUwxKxbVBsUvqSAKZ5f39HtCksxvs/vJseVWf9/PuP7b13DQGwyVHQ==
X-Received: by 2002:a05:622a:208:b0:2e1:b3ec:b7ce with SMTP id
 b8-20020a05622a020800b002e1b3ecb7cemr5906810qtx.345.1650251814817; 
 Sun, 17 Apr 2022 20:16:54 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w6-20020a05622a190600b002f1f91ad3e7sm2728970qtc.22.2022.04.17.20.16.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 20:16:54 -0700 (PDT)
Date: Sun, 17 Apr 2022 23:16:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <YlzYJS7gWBbEIaw6@redhat.com>
References: <20220418022733.56168-1-snitzer@kernel.org>
 <378611be-45ea-6085-7848-83380642c81a@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <378611be-45ea-6085-7848-83380642c81a@opensource.wdc.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [dm-5.19 PATCH 00/21] dm: changes staged for 5.19
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
Cc: axboe@kernel.dk, dm-devel@redhat.com, hch@lst.de, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Apr 17 2022 at 11:00P -0400,
Damien Le Moal <damien.lemoal@opensource.wdc.com> wrote:

> On 4/18/22 11:27, Mike Snitzer wrote:
> > Hi,
> > 
> > This patchset reflects what I've staged in linux-dm.git's "dm-5.19"
> > branch (also staged in "for-next" for linux-next):
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19
> > 
> > It build's on jens/for-5.19/block branch (which is based on v5.18-rc3)
> 
> Mike, thanks for posting. We will run this on zoned stuff to check.

OK, I appreciate it..

> Note that patches 13 to 20 are empty...

Not sure what's going on there... basically any patch that wasn't from
me (so 1, 13-19) isn't showing up in patchwork or the dm-devel
archive.

This is my first submission of patches using my snitzer@kernel.org
alias with redhat's smtp server that is really anal about not sending
email that isn't from me.  Yet it sent the email but seized on the
following to have the body be empty:
"From: Ming Lei <ming.lei@redhat.com>"

Best part is my email account shows all the emails sent like all was
perfect.  Sorting this out will have to wait until Tuesday.

Sorry, but please just pull the dm-5.19 branch via git ;)

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

