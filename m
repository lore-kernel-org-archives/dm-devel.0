Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17FB5C05027
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676399679;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tNEk8eOOWsln9CtS5jiQeCi3OtYK3JHRYzoffjytCOY=;
	b=aDbikcRuA4UO9IQszn+fWSbD3Jc8O2r5XbrC9q+LAAjAbDgioa28D3XAGgc2QBzKPLY5ck
	YtI2wFb+YnOUq+9z+PFsldVgfexFv/ITj40sQgi2XeS9VRuBqMqsOoqg2U8No+/c5QjQyn
	a7Pn/QQNERxBpZslFsw1/OxYgZCpL+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-7afm-JojMZCUBX0sjkqAQg-1; Tue, 14 Feb 2023 13:34:38 -0500
X-MC-Unique: 7afm-JojMZCUBX0sjkqAQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBDCC811E6E;
	Tue, 14 Feb 2023 18:34:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AA381121314;
	Tue, 14 Feb 2023 18:34:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E587C1946588;
	Tue, 14 Feb 2023 18:34:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1B721946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 18:34:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D58882166B2B; Tue, 14 Feb 2023 18:34:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE97B2166B26
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:34:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFB9E2A2AD4A
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 18:34:30 +0000 (UTC)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-330--jrAcCs9MrWYkeZdT80tlg-1; Tue, 14 Feb 2023 13:34:29 -0500
X-MC-Unique: -jrAcCs9MrWYkeZdT80tlg-1
Received: by mail-qt1-f179.google.com with SMTP id cr22so18577680qtb.10
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 10:34:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=vmWhx2vOrM7/z6AvBw92mQx14PHle33tN0tFdIANHcE=;
 b=hUio1nOgpy0NPdlN4+WPxn1I6omeyIZWPTSNEh0nSOB+jywJ/bUpHFeWEgq2QzkKcW
 K5qOrjqZ8sQCtTXmLwEJBJ0fZYp8XFxwkIzCMqiQC2EQ9SX1f5Cshho67QoVhP8TwPia
 +laMYXWJQ98Ab6M4s26Mow7RhQ6p0lm0KdLeSK+pfdpEZrtn4eK8YNyauLGp5pNo+Ndh
 B85sZqlfmxUEnAEKb+BMfsykKpesbwGqgOhITiSsPmsT7cWGdCao9OSZSbgNsX0TGDLw
 PPSAJQtdLEUH4/QnYnDZJhfG5Jwz+DewMuQFG0ggHAZrw8iT4uvziPp3IIgeicGI6Kxt
 RWyg==
X-Gm-Message-State: AO0yUKWGW2PSEb1W1kmWb3kG72KJAJq15jt6L4xiKHYF7H6BFe+DgE8D
 A1Lx/0gk8iI+Pqk08srT0ER0DAcjQIoSfkRAYg==
X-Google-Smtp-Source: AK7set+0ZHro/XpJ/65/kSycbS/eiDfXwwDyPyu+RMWkhTYO4g4L0HWqcH7EfKvbj4C9xigJTYpQ6A==
X-Received: by 2002:a05:622a:4d2:b0:3b8:629e:afd1 with SMTP id
 q18-20020a05622a04d200b003b8629eafd1mr4838401qtx.53.1676399668630; 
 Tue, 14 Feb 2023 10:34:28 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 q2-20020ac84102000000b003b62bc6cd1csm11769921qtl.82.2023.02.14.10.34.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Feb 2023 10:34:28 -0800 (PST)
Date: Tue, 14 Feb 2023 13:34:26 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, mpatocka@redhat.com
Message-ID: <Y+vUMmatAkt6yS5u@redhat.com>
References: <53e65050-5be2-0037-b01f-60db5aea24b6@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
In-Reply-To: <53e65050-5be2-0037-b01f-60db5aea24b6@I-love.SAKURA.ne.jp>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] Planning to WARN_ON() when flush_scheduled_work() is
 used.
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Feb 11 2023 at  1:19P -0500,
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> Hello.
> 
> Like commit c4f135d64382 ("workqueue: Wrap flush_workqueue() using a macro")
> says, flush_scheduled_work() is dangerous and will be forbidden. But I haven't
> heard from you after https://lkml.kernel.org/r/YtF45oMcHMKXjIyy@redhat.com .
> 
>   https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
>   https://lkml.kernel.org/r/e170edc2-e5b9-4c8b-4ed3-7e2d7a2850dc@I-love.SAKURA.ne.jp
> 
> Please do clarify which work items does this flush_scheduled_work() need to wait.
> 
> Regards.
> 

WARN_ON() seems excessive, why not WARN_ON_ONCE()?

But that aside, sorry for not looking closely and responding with
findings sooner.

BUT, I did just have a quick look at drivers/md/dm.c and its use of
flush_schduled_work(): a quick 'git blame drivers/md/dm.c' told me it
was only introduced for the benefit of DM's deferred device removal
feature (commit 2c140a246dc0b "dm: allow remove to be deferred").

Given that, I've staged these 2 commits for 6.3 inclusion:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=68fb709113077f1f367d8a55deb01d2d6bf23b0f
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=cd4afc85b39c1b9dd63715c591829f67b07c86a8

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

