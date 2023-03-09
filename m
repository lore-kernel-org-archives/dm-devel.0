Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E3C8C742A7
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678374522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=99eZ1G5jpuuKjgKuyoxYhsrwrVTfd/Mg0HXlVr1kunk=;
	b=RLGaJlomOMS+T45n/Bch0V9bPnlDaiE8aZdp7kODNROyR3YqoNkdy1HUby8cuKUa0qTwrd
	xoF0KMo41QHqYVjduOM7yjNSE/0WBjyE8ulvTD0+QIs/K791IxWcS4PCns8vlt9MwAlMzF
	5suxA66opz4DmqnX+iAaSllKIrhk/pI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-4ytztLzHPliHUha4vo3sgQ-1; Thu, 09 Mar 2023 10:08:40 -0500
X-MC-Unique: 4ytztLzHPliHUha4vo3sgQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7415B18F0261;
	Thu,  9 Mar 2023 15:08:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26E2E2026D4B;
	Thu,  9 Mar 2023 15:08:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB62D19465B3;
	Thu,  9 Mar 2023 15:08:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D627F1946597
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 15:08:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2D4E492B00; Thu,  9 Mar 2023 15:08:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA59E492C3E
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 15:08:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F44928043C4
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 15:08:36 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-SczY0glHPjaG6hwM1fOKgg-1; Thu, 09 Mar 2023 10:08:34 -0500
X-MC-Unique: SczY0glHPjaG6hwM1fOKgg-1
Received: by mail-qt1-f169.google.com with SMTP id l13so2272217qtv.3
 for <dm-devel@redhat.com>; Thu, 09 Mar 2023 07:08:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678374514;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=JAGp/niDYPl9tE2lb010Sm39UNmzmvzWxLKZLFZSNTk=;
 b=sqJZkOlxvbxCbCsycrS1tOBP7dxVQlNQeobn/R5Y8VPrYQrNVPXGnjG9z5RkBto+yB
 MZnNp7yLLYa+U1TfzJ7QqTQOcj+5QtB3YExX2y2NcFTmv3nLiVeFjh463mf1zFwFP227
 bNOEgNNVGBPwi8PXQu1MjFMVLJ6BEq3QATtGJVP15msiDCUa7T4QuhTahDBPDX+WQkL8
 GFh8bJDJhR2VM6dXT9buIz7DIndFK5p9ofLt8bO1JGrKmmzvOqou16Qo3rfdtUl1uzn7
 3Jg6JxQj6GJLA/tM5oqmK1odVC7qhWPjCZYIb/v5zTXPRmCpVtjscpe3wBxpFOBhCxQm
 mjzA==
X-Gm-Message-State: AO0yUKXSUk2jJGvfzdeLf0z58hC3/upDQzP8TT7bgnFulEKuGg8To4F+
 LW4PuDuiSM782LQqNKCQGHW8tZw=
X-Google-Smtp-Source: AK7set/tuR7RN2otlN/wyOZB1+2otkM794OTWY78wg9UsxxFaFsGYxpwVPL4D492qNN20V0ocy1+Ug==
X-Received: by 2002:ac8:5f07:0:b0:3b8:682d:cebf with SMTP id
 x7-20020ac85f07000000b003b8682dcebfmr37175519qta.66.1678374514236; 
 Thu, 09 Mar 2023 07:08:34 -0800 (PST)
Received: from localhost ([191.101.160.138]) by smtp.gmail.com with ESMTPSA id
 e21-20020ac845d5000000b003bfd8e2ab40sm13826349qto.16.2023.03.09.07.08.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Mar 2023 07:08:33 -0800 (PST)
Date: Thu, 9 Mar 2023 10:08:32 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Dan Carpenter <error27@gmail.com>
Message-ID: <ZAn2cM75wc0WZgah@redhat.com>
References: <7df2de70-c883-4733-9c07-bf69a8ada5bb@kili.mountain>
 <5e9f73e8-26a3-47ff-aeee-7e723b66c7c9@kili.mountain>
MIME-Version: 1.0
In-Reply-To: <5e9f73e8-26a3-47ff-aeee-7e723b66c7c9@kili.mountain>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [bug report] dm crypt: conditionally enable code
 needed for tasklet usecases
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 09 2023 at  9:42P -0500,
Dan Carpenter <error27@gmail.com> wrote:

> On Thu, Mar 09, 2023 at 05:35:20PM +0300, Dan Carpenter wrote:
> > --> 2758         if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags) ||
> >                                                            ^^^^^^^^^
> >     2759             test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
> >                                                             ^^^^^^^^^
> > UAF.  This wasn't tested, right?  If this passes testing then it means
> > kfree_sensitive() is broken.  (Normally UAF bugs can only be detected
> > with KASan, but kfree_sensitive() should poison the data I thought).
> > 
> 
> Nope.  This is thing where you need KASan to detect the bug.  I'm wrong
> and continually demonstrate how even twenty years in to it I still don't
> understand pointers.

Thanks for the report, really appreciate it. Sorry for the oversight
(and lack of testing). But we decided to fix a different way and
linux-next was updated accordingly, I just tweaked it but here is the
final:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d9a02e016aaf5a57fb44e9a5e6da8ccd3b9e2e70

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

