Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C6EC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jul 2022 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658249744;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UFKsG3c2oRMgWkht+H6A5njlJzKT8VHNiCMPTZEvb+8=;
	b=aZhU9dR1rHi6k6cNhrwzC22kLil/J9b3UD5iUeItHHxfPUtGuO5SKQ9ES+fDpWjJUc5anN
	xhJsdlay+2jifXJzFWPGsgxJSFYo/gEt2cjQ/CMkTO1Lbu1YEmacjbH5x0RIXnRfv0B1Gr
	c+CXuTBoXJrPOnP8ZROteAK3PIz+8B4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-NOmccrWRPF6mlXHHLz7m2g-1; Tue, 19 Jul 2022 12:55:37 -0400
X-MC-Unique: NOmccrWRPF6mlXHHLz7m2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A6BC811E84;
	Tue, 19 Jul 2022 16:55:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD334C28100;
	Tue, 19 Jul 2022 16:55:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8FBA11947070;
	Tue, 19 Jul 2022 16:55:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 015761945DA7
 for <dm-devel@listman.corp.redhat.com>; Tue, 19 Jul 2022 16:55:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2599401E7B; Tue, 19 Jul 2022 16:55:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB255492C3B
 for <dm-devel@redhat.com>; Tue, 19 Jul 2022 16:55:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2269811E76
 for <dm-devel@redhat.com>; Tue, 19 Jul 2022 16:55:32 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-AoO7hrgtOdi8JBICP1E9ug-1; Tue, 19 Jul 2022 12:55:25 -0400
X-MC-Unique: AoO7hrgtOdi8JBICP1E9ug-1
Received: by mail-qt1-f175.google.com with SMTP id r24so4875049qtx.6;
 Tue, 19 Jul 2022 09:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8pLsGj2yA0zKoPD+qlP33Sp/ws8db3Asdu62Jo6m2Og=;
 b=RjivQ2UGqFC2D3PAJSe4VA4OYC5neSmEuxrkQfcUBREEhf0qpXqQqnOLA/lYxz7vkh
 9wPFvGuljP1/KW9gWydY+MLedsNcdoz1K1HJEE/KAIyD0jRqjzQpabJp0xf6GE63yXV4
 2hXgpYnd5xbu64GdjE3Uw/gWWnw7pLnRWsC6zmnvWYJkrbAuf/Lx06a/A/n3uFNwSahE
 emzhtLB5jNDBaGoM1Xlf34cXijaeWTjaaKmJCOOUIgk99MvsbpsFPkiOnoGOkGxVRZ+S
 uI4Bjmj5ahf5UGbT3bRaRLkXkLd/ktJHeIPxHejprE9u3IDiPdoW7F2iEmIgSLC4mX2w
 0p5g==
X-Gm-Message-State: AJIora/xbpVKWnrYuIjw5mkTL+HNDgBsxvJUOoCAkXiKW7cjfmwKSvyC
 WwA/qbZ20U12inKx124c5HEUsgSnXcpfwKh0buTWCqeduuo1kw==
X-Google-Smtp-Source: AGRyM1vQuFmeH8jLiMqvqBTeXxT8AXE6oUD8EX3cgwQfYlvJNXPb7WxwE9IX6JtpI6qx1POjRPfl/9VqhxugZpiao3A=
X-Received: by 2002:a05:622a:143:b0:31e:9c61:c1d7 with SMTP id
 v3-20020a05622a014300b0031e9c61c1d7mr24738012qtw.128.1658249724563; Tue, 19
 Jul 2022 09:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
In-Reply-To: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 19 Jul 2022 11:55:13 -0500
Message-ID: <CAAMCDefDsdjx1BVqgv6uPUTRR2fCH3WeZ87NX1_q7QP8sdAu+w@mail.gmail.com>
To: Wu Guanghao <wuguanghao3@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [Question] multipathd add/remove paths takes a long
 time
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, liuxing108@huawei.com,
 zhangying134@huawei.com, chenmao2@huawei.com,
 "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
 linfeilong <linfeilong@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

What does the cpu time look like when you are seeing this issue?

I have seen large numbers of scsi devices coming in and multipaths
getting built cause the system to seem to waste time.   With a high
numbers of udev_children (I believe the default is pretty high) it can
use excessive cpu on a big machine with a lot of paths and appears to
be interfering with itself.

In testing I was involved in it was found that setting udev_children
to 4 produced consistent fast behavior, whereas having it set to
default (lots of threads on large machines, exact number varies on
machine size/distribution/udev version) sometimes producing systemd
timeouts when paths were brought in. (>90seconds find PV for required
LV's).

The give away was udev accumulated 50-90 minutes of cpu time in a
couple of minutes of boot up with default udev_children, but with it
set to only 4 the paths processed faster and the machine booted up
faster and udev did the same real work faster with much less cputime
2-3 minutes of cpu time.

this is the option:
/usr/lib/systemd/systemd-udevd --children-max=4.

On Tue, Jul 19, 2022 at 7:33 AM Wu Guanghao <wuguanghao3@huawei.com> wrote:
>
> The system has 1K multipath devices, each device has 16 paths.
> Execute multipathd add/multipathd remove or uev_add_path/
> uev_remove_path to add/remove paths, which takes over 20s.
> What's more, the second checkloop may be execed immediately
> after finishing first checkloop. It's too long.
>
> We found that time was mostly spent waiting for locks.
>
> checkerloop(){
>         ...
>         lock(&vecs->lock);
>         vector_foreach_slot (vecs->pathvec, pp, i) {
>                 rc = check_path(...); // Too many paths, it takes a long time
>                 ...
>         }
>         lock_cleanup_pop(vecs->lock);
>         ...
> }
>
> Can the range of vecs->lock locks be adjusted to reduce the time consuming
> when adding/removing paths?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

