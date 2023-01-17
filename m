Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A4AC00A5A
	for <dm-devel@archiver.kernel.org>; Tue, 17 Jan 2023 23:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673996944;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5CYIV5PwiU+23cmhJpLZVP9rGoooRFSM3xwAF6dLkBA=;
	b=SDsMEo1Z+WQYyh6s81V0XskY054qna3L64npNaX1xQvcScbzb/xuTvbp0M+xkWe8Zjv72E
	eYkGc467YcsU5jg0vPv/loHZdFxBvwIh8iZ55AuUZKbCJIwKy4PnQDYsAs5bmnyfTqOVXr
	kzsQ2W8wm0JvVM6HEnoaa7hccwD0sPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-g-J2uSjlPqOI8y5F6qkn_Q-1; Tue, 17 Jan 2023 18:09:00 -0500
X-MC-Unique: g-J2uSjlPqOI8y5F6qkn_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 145221871D9B;
	Tue, 17 Jan 2023 23:08:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9B4F2026D4B;
	Tue, 17 Jan 2023 23:08:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 799AD19465B5;
	Tue, 17 Jan 2023 23:08:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 37C5819465B3
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 Jan 2023 23:08:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26FBE4078903; Tue, 17 Jan 2023 23:08:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FEA840C6EC4
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 23:08:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 033F61C04349
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 23:08:52 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-260-_3rxGum5Pgy0Swh4XiaR-g-1; Tue, 17 Jan 2023 18:08:49 -0500
X-MC-Unique: _3rxGum5Pgy0Swh4XiaR-g-1
Received: by mail-qk1-f198.google.com with SMTP id
 a3-20020a05620a438300b007069b068069so2301343qkp.2
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 15:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=hLUhE+N6wNGcOFfTldSYxDCBe/hAkHMsdAmNF17Xymc=;
 b=yorenI6jTsQ7Ncl8Wc27dHm5TZ6QtqU7rBHFEvWSjjA/fz9B6oWKGyBbm71w3HpZvm
 oHZ1ZJfrwS1FJaaXa2GQWXWCDApkaMm8ZefOsZwyU6gWI0meFvZxM01l09TflF5c8Xqt
 5jRjG+YIp6JdCFaVcSsGf7iJiFDdxEEIqqUgnvXpC7L7obvCvLea6uVewtVgpyuxpc+O
 bKf+NRHCuceBbXA2YeJrz/4ygS22HLwDARD96Lx6IXdEmgJ+nZYldUTc9tQHmgq1JQ24
 f93WXjJctJjJY0sjeLlzhfvq4gWyZBDuGGasqvwqvnwlcMgDkBrqlstCyAyDJx19um22
 +j4w==
X-Gm-Message-State: AFqh2krgDOXnRT+9Fj/+lpTBeFgq1Q8c2Y0hg8QNwQRruakXSHMMfCPB
 rKrNVIb0kyj0GF6s8mw7JhvqpxQdx1lIivzWUEyLICotJ+XWpIf72rertfuDAkmKFeXX/E9CMCv
 QO4C2qkBxkQwfTQ==
X-Received: by 2002:a05:622a:1dc4:b0:3b0:12fc:ff96 with SMTP id
 bn4-20020a05622a1dc400b003b012fcff96mr5892363qtb.23.1673996928004; 
 Tue, 17 Jan 2023 15:08:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs0vPxyl1XT+dxMILItLl3+pLEGdNv9Sv+NcGT7bP7sh98JIs9rjlnuL0rLpT8TgvsCATdexQ==
X-Received: by 2002:a05:622a:1dc4:b0:3b0:12fc:ff96 with SMTP id
 bn4-20020a05622a1dc400b003b012fcff96mr5892349qtb.23.1673996927779; 
 Tue, 17 Jan 2023 15:08:47 -0800 (PST)
Received: from localhost (pool-68-160-145-102.bstnma.fios.verizon.net.
 [68.160.145.102]) by smtp.gmail.com with ESMTPSA id
 p15-20020ac8460f000000b003ae33f9260dsm4659239qtn.49.2023.01.17.15.08.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Jan 2023 15:08:47 -0800 (PST)
Date: Tue, 17 Jan 2023 18:08:46 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Message-ID: <Y8cqfvrfd3pL9ToJ@redhat.com>
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
 <20230113001132.3375334-6-paulmck@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230113001132.3375334-6-paulmck@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH rcu v2 06/20] drivers/md: Remove "select SRCU"
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
Cc: linux-raid@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
 kernel-team@meta.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, rcu@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 12 2023 at  7:11P -0500,
Paul E. McKenney <paulmck@kernel.org> wrote:

> Now that the SRCU Kconfig option is unconditionally selected, there is
> no longer any point in selecting it.  Therefore, remove the "select SRCU"
> Kconfig statements.
> 
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: <dm-devel@redhat.com>
> Cc: <linux-raid@vger.kernel.org>
> Reviewed-by: John Ogness <john.ogness@linutronix.de>

Acked-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

