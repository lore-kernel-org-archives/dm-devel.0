Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01B2C6FD1D
	for <dm-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680630516;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZhPrq0oFDv5RysRHIJw+rfQMgY26kYwqQqKnWPfBdD8=;
	b=Vzz5WZ7J+itLLVAmdWYdxlH8QB52XbGeZ3uQ5l6IFNksW5lAKIZPMqwUTPzo6WeItulLOl
	fOGrl2XJ4EnelJTFjvO3AY9/5CSOTMTQwpEtt1OeP9d4aE4MgBq15/gMMxybc/ejumJYXS
	rBdayGSh6rq4kWI8EE1XkAePaEKRjAQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-o3jbSpkAOJOG9MEh5OU-KA-1; Tue, 04 Apr 2023 13:48:35 -0400
X-MC-Unique: o3jbSpkAOJOG9MEh5OU-KA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F00EC181821A;
	Tue,  4 Apr 2023 17:48:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DE68140EBF4;
	Tue,  4 Apr 2023 17:48:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C19FC1946597;
	Tue,  4 Apr 2023 17:48:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CCBF1946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Apr 2023 17:48:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F31B492C14; Tue,  4 Apr 2023 17:48:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57814492C13
 for <dm-devel@redhat.com>; Tue,  4 Apr 2023 17:48:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC5E3815F79
 for <dm-devel@redhat.com>; Tue,  4 Apr 2023 17:48:29 +0000 (UTC)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com
 [209.85.219.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-os39irK8MzOSeZ3aS-rhbQ-1; Tue, 04 Apr 2023 13:48:27 -0400
X-MC-Unique: os39irK8MzOSeZ3aS-rhbQ-1
Received: by mail-qv1-f53.google.com with SMTP id m16so24108009qvi.12
 for <dm-devel@redhat.com>; Tue, 04 Apr 2023 10:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680630506;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=mb4UlbgNUBjFEiIuxVNvAB9dErFsvyXvvy0R6TUZ3Og=;
 b=PJU2OI/cKsLiCWHyMrVtQoyLrEyZ8+fQ01e9vz8N9IeHrUu5XsWwOGWYgFAcNKH0FK
 z4MBC5AK8uW+plru0qIjkrWP9qgb9wmcRYLI5ZmL4zAuLsSKTIxwNpK2zG+7468yLXB/
 MHXKita5iUVmCHvjcnQNEat4laUOYcPAM2X0jbGVkeRaz+2GhrOF7SroUrkLConPRiG/
 J6DnSgEntMynQOHNc4dKIR851oRMiohmDR4c1NDLU/7U852IMrq8sUAnmatBNaaxfInp
 YRp2s3+xy7JSESG+t5G5U/45vnxZxAHwQJqC4hlLuHdGGXRZ04Vh7d6NQJhvwSjzl0Rh
 AVhA==
X-Gm-Message-State: AAQBX9c48PwKE+B5zSH/dL0Raey++FVzVADburitrFSUMBSw8uG/bZFX
 H5N9XnahY6HsZca0HCa7627IqXk=
X-Google-Smtp-Source: AKy350a/8D9NxKsEY8kuTWND8t08XKRZNRiPqVXk15c5G0YDBaTT31CfCtDZqcD3EWyLnQhy9dLOWw==
X-Received: by 2002:a05:6214:27ea:b0:5ce:6636:a45 with SMTP id
 jt10-20020a05621427ea00b005ce66360a45mr5360407qvb.25.1680630506534; 
 Tue, 04 Apr 2023 10:48:26 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 o207-20020a3741d8000000b007486052d731sm3343606qka.10.2023.04.04.10.48.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Apr 2023 10:48:26 -0700 (PDT)
Date: Tue, 4 Apr 2023 13:48:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Yangtao Li <frank.li@vivo.com>
Message-ID: <ZCxi6A5iXt5N0HNL@redhat.com>
References: <20230318131633.41573-1-frank.li@vivo.com>
MIME-Version: 1.0
In-Reply-To: <20230318131633.41573-1-frank.li@vivo.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] dm: Add error information printing for
 dm_register_target()
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Mar 18 2023 at  9:16P -0400,
Yangtao Li <frank.li@vivo.com> wrote:

> Ensure that all error handling branches print error information. In this
> way, when this function fails, the upper-layer functions can directly
> return an error code without missing debugging information. Otherwise,
> the error message will be printed redundantly or missing. BTW, remove
> redundant printing information.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>

Hi,

I've picked this up with a few changes (your patch caused me to look
closer at some of the target code and we had some missed cleanup):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.4&id=6827af4a9a9f5bb664c42abf7c11af4978d72201
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.4&id=6b79a428c02769f2a11f8ae76bf866226d134887

So I rebased your patch and tweaked it slightly (and splitting it), see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.4&id=e6c908b5d86faf3dbcf314b1c07c342268e32def
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.4&id=2a455a0b418f972d61b68f9321b7d1892c16b4f7

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

