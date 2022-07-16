Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AA7C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jul 2022 08:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658131524;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mkOYQS1lEmn8jvR+OEMV7A6qUGvHiAyxC+vvsRYDeYM=;
	b=aE/rxJx8WYybAoz3oW3q/oS5QG79QGBMg6hZw7sEg4P+9z1DekGljkWByy7DY+clTVMrG2
	EOYgUvefdozsSabe0aCkn4bSOftVGGgULFI3D4cUILBUjZswihgr/wRCSqX94dkuIOWePX
	A0uCLyONsjfpUGsk08aGmkmF6qY5eEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-VUp2r8xmMVSHWMiGjuJNuA-1; Mon, 18 Jul 2022 04:05:21 -0400
X-MC-Unique: VUp2r8xmMVSHWMiGjuJNuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A9081019DE2;
	Mon, 18 Jul 2022 08:05:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08D0C2026D2D;
	Mon, 18 Jul 2022 08:05:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A8C15194705E;
	Mon, 18 Jul 2022 08:05:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 729141947041
 for <dm-devel@listman.corp.redhat.com>; Sat, 16 Jul 2022 05:33:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54A132EF9E; Sat, 16 Jul 2022 05:33:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50D00909E7
 for <dm-devel@redhat.com>; Sat, 16 Jul 2022 05:33:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33F75801755
 for <dm-devel@redhat.com>; Sat, 16 Jul 2022 05:33:49 +0000 (UTC)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-JosEAjaNPX-lKa5VVBOuUg-1; Sat, 16 Jul 2022 01:33:43 -0400
X-MC-Unique: JosEAjaNPX-lKa5VVBOuUg-1
Received: from fsav312.sakura.ne.jp (fsav312.sakura.ne.jp [153.120.85.143])
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26G5Xak6058403;
 Sat, 16 Jul 2022 14:33:36 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav312.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp);
 Sat, 16 Jul 2022 14:33:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
 (authenticated bits=0)
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26G5XavB058398
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
 Sat, 16 Jul 2022 14:33:36 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fd68a776-6df0-fdb1-1520-239d639dee2b@I-love.SAKURA.ne.jp>
Date: Sat, 16 Jul 2022 14:33:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Snitzer <snitzer@kernel.org>
References: <e3ac2722-01c4-decb-2b79-bfd1b6c2b782@I-love.SAKURA.ne.jp>
 <a41b962e-8423-75b5-ef89-74e8b9f25259@I-love.SAKURA.ne.jp>
 <6deb326e-0b0e-84f5-5d1e-2f321d5816ca@I-love.SAKURA.ne.jp>
 <YtF45oMcHMKXjIyy@redhat.com>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YtF45oMcHMKXjIyy@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Mon, 18 Jul 2022 08:05:17 +0000
Subject: Re: [dm-devel] dm: Avoid flush_scheduled_work() usage
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks for responding.

On 2022/07/15 23:25, Mike Snitzer wrote:
> I'm not applying such a fundamental change to the DM subsystem when
> the header for the change leads with: "Note: This patch was made
> blindly and completely untested."

Of course, I don't think this patch will be applied as-is.

> 
> I've been busy... when is the deadline for this conversion?  I read
> commit c4f135d643823a86 but it doesn't say.

There is no deadline. I estimate we need about 6 months for getting rid of
all in-tree flush_scheduled_work() users.

> 
> I don't think I have the time to make and test such change in time for
> 5.20 as I'm working to resolve other issues.

That's no problem. This patch was proposed for heads-up purpose.

Please clarify which work items does flush_scheduled_work() from local_exit()
needs to wait. Depending on the clarification result, we might be able to
simply remove flush_scheduled_work() from local_exit() and/or replace with
flush_work() instead of introducing dedicated workqueues.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

