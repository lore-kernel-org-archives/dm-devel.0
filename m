Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D2F9C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 06:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666248346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AlqnRY6lBu5Wqh9BwJqfM+c4zP6zOOl1dvAVL+kCP0w=;
	b=DMjQcv4oFEwH3JAwQTWSM5F3RHUBp6D+1SUUTj5eh7SrSASp/bYYHRMcm19TYzxhcPYDGy
	ZxN7Ww2BlwW6BK3cYniM5BNJBt4BqjMuMX9o4n5/+GkA9bmHsR1lrHui/P/HELmiTz8IBV
	RNRBPPT+7haG654kFwoHvl9TNGXd0vA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-7b7nAt0cOUK6oZiDGaczRg-1; Thu, 20 Oct 2022 02:45:42 -0400
X-MC-Unique: 7b7nAt0cOUK6oZiDGaczRg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC589864763;
	Thu, 20 Oct 2022 06:45:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 421C14021CA;
	Thu, 20 Oct 2022 06:45:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C6961946595;
	Thu, 20 Oct 2022 06:45:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C36571946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Oct 2022 06:27:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23046202323C; Wed, 19 Oct 2022 06:27:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2BD200C0EA
 for <dm-devel@redhat.com>; Wed, 19 Oct 2022 06:27:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C83E1C0A59F
 for <dm-devel@redhat.com>; Wed, 19 Oct 2022 06:27:38 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-zJPfKCIMMvma0Nm_V2vPzA-1; Wed, 19 Oct 2022 02:27:36 -0400
X-MC-Unique: zJPfKCIMMvma0Nm_V2vPzA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A7F95615FD;
 Wed, 19 Oct 2022 06:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE66CC433C1;
 Wed, 19 Oct 2022 06:18:56 +0000 (UTC)
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f995c9c5
 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO); 
 Wed, 19 Oct 2022 06:18:54 +0000 (UTC)
Date: Wed, 19 Oct 2022 00:18:52 -0600
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y0+WzAZMiQAhQdgj@zx2c4.com>
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 20 Oct 2022 06:45:37 +0000
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: linux-block@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Shaomin Deng <dengshaomin@cdjrlc.com>,
 Mike Snitzer <snitzer@kernel.org>, Nathan Huckleberry <nhuck@google.com>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Genjian Zhang <zhanggenjian@kylinos.cn>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 11:54:49AM -0700, Linus Torvalds wrote:
> I think we have one major interface that is string-based (apart from
> the obvious pathname ones and the strings passed to 'execve()').
> 
> It's 'mount()' (and now fsconfig() etc), and it's string-based mainly
> because it has that nasty "arbitrary things that different filesystem
> may need for configuration"). And it has some nasty logging model
> associated with it too for output.
> 
> But no, we absolutely do *not* want to emulate that particular horror
> anywhere else.

This might ruin your day, but FYI, Netlink

   [...did you already run off screaming at the mention of Netlink?...]

Netlink has the whole "extack" extended acknowledgement mechanism, in
which netlink replies can and do contain error strings. Grep the kernel
for NL_SET_ERR_MSG and you'll see a bunch of these. (And as you
suggested, I wouldn't be surprised if some bad userspaces parse them.)

Jason

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

