Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A1BC636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319079;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yUgdBvtz2HdPOvFy3Gngic8r1CFQx9aeWniaF6gdXvk=;
	b=Dt8RS92RBVmHcwRU5n/QfKDQnGL3foiHwGKRS2MQYSqiurvva7+ui6k0XXtMquu1cqERPk
	1CH287FfRNWtv8wCDD+MZCj0g2s2Ba72K6zqe46dcSLFSZ+BjMGwox4oxXFYkuItpjiQDy
	7N3LH7/NNecdJoGtjaD/3OEAB4Rk/DA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-oT5sH2rjNOyB3JkKOMqf8A-1; Mon, 13 Feb 2023 15:11:16 -0500
X-MC-Unique: oT5sH2rjNOyB3JkKOMqf8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF4CB1871CDE;
	Mon, 13 Feb 2023 20:11:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80BC218EC7;
	Mon, 13 Feb 2023 20:11:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 63F551946588;
	Mon, 13 Feb 2023 20:11:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 268E21946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:09:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 02DC9C04483; Mon, 13 Feb 2023 20:09:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF347C158BB
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:09:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D10B938123A0
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:09:20 +0000 (UTC)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-0SKY66LGOlWl-Xer5nRCdQ-1; Mon, 13 Feb 2023 15:09:19 -0500
X-MC-Unique: 0SKY66LGOlWl-Xer5nRCdQ-1
Received: by mail-qv1-f49.google.com with SMTP id j5so6880263qvi.3
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:09:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=l7Hf9fmmEQxJxZE5V1Mlv9i2jR0V9mjM3+4VQm57K3k=;
 b=YfbKfQQZTUFdXIqvZnRlVKUbc8Ujob0L+5ajNMrkxSnegLwrys0mGmt1UhsuXjlvHk
 cUceP5yoObFtbSf8oscV5avxjt330lfcQfDMfZbA/Kx1oKVLIBDXrleOEyOqeA2tKQ9E
 SuVfSGGBbmLgxQv+dfffpotm/AVM2ZGdEnnQVMUqFcOmfFdq5B7vLIi5AaJELszqjTV6
 LdaIsFcL6auP25XUJtWbZVjfjpupIGXo/KvyqOf6USUK5VgtgPlG6TZB6dItWzgvpah5
 zClIOd2CAXe5sEmiLZH2z8y8rARq3Ef0Ozak7t6qjyTlUPGFbE3If+CG+64RX20yOJn9
 c45w==
X-Gm-Message-State: AO0yUKV2Gi5Sypw0R80WZ3dDpcAuVH6QEtHGGSs3vEW1LGPnOEBgUbee
 489qf52kjzLLR5NmHkI7AR8MNsPgtxVrcmEFZg==
X-Google-Smtp-Source: AK7set8slIeFGMSmulQ2GG5JHDzdTAdX8wEdqFzx+0Xxl/+wuVn8BJRRLQroB8tNqrkclBL3vAWvDA==
X-Received: by 2002:ad4:596d:0:b0:56b:f48d:fa42 with SMTP id
 eq13-20020ad4596d000000b0056bf48dfa42mr217482qvb.30.1676318958438; 
 Mon, 13 Feb 2023 12:09:18 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 u123-20020a379281000000b0073b4d9e2e8dsm1228731qkd.43.2023.02.13.12.09.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:09:17 -0800 (PST)
Date: Mon, 13 Feb 2023 15:09:16 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Message-ID: <Y+qY7Kr+B7rZi4iZ@redhat.com>
References: <Y+qUl1sDqYwEPPo3@gmail.com>
MIME-Version: 1.0
In-Reply-To: <Y+qUl1sDqYwEPPo3@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] "dm: prefer kmap_local_page() instead of deprecated
 kmap_atomic()" is broken
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 13 2023 at  2:50P -0500,
Eric Biggers <ebiggers@kernel.org> wrote:

> Hi Mike and Heinz,
> 
> The following commit in linux-next is causing "BUG: scheduling while atomic"
> bugs.  Probably because it is still using kunmap_atomic(), not kunmap_local().
> 
> 	commit 621d8807771e430b44136e48dfe3c53540c9953d
> 	Author: Heinz Mauelshagen <heinzm@redhat.com>
> 	Date:   Tue Feb 7 20:22:58 2023 +0100
> 
> 	    dm: prefer kmap_local_page() instead of deprecated kmap_atomic()
> 
> This patch does not appear to have been sent to the mailing list (why not?), so
> I started a new thread.

Thanks for letting me know.  And sorry for the trouble.

I meant to send the patchbomb after rebasing Heinz's series that he
shared with me privately.  I obviously forgot to do so which is both
embarassing and problematic.

Will email what I have just staged via rebase (after fixing to use
kunmap_local).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

