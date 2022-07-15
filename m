Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABDDC43334
	for <dm-devel@archiver.kernel.org>; Mon, 18 Jul 2022 08:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658131525;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tWjGGfGeg7xgEbsYagDwQNDKK1CXpc5EdvBpNN1nIdg=;
	b=TaJqk9juxham0eEIh3zjPXSV4ML0KgKBnt6tzibSjXXFnUn1qVNPvKiqoo+K9/SnxrymGm
	su/DH8mCa7lYJt3NlapyB4bZcEsAeOvPwJ7vn/2XKhULmGxn0ls8+prcCYYQNIjYVys1vN
	nl/h8KjpIYL0LuPA3YiON/iKxbyfpAI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-CcB9h6QJOCGLWyaT8zSnvA-1; Mon, 18 Jul 2022 04:05:22 -0400
X-MC-Unique: CcB9h6QJOCGLWyaT8zSnvA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A4AD1C06909;
	Mon, 18 Jul 2022 08:05:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2098492C3B;
	Mon, 18 Jul 2022 08:05:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E4641947054;
	Mon, 18 Jul 2022 08:05:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7CA2119466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 13:28:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6733C40E8B05; Fri, 15 Jul 2022 13:28:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62AB440E8B04
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 13:28:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AAA4280048D
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 13:28:01 +0000 (UTC)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-DncilJwmPnuSdHF4QIcylA-1; Fri, 15 Jul 2022 09:27:58 -0400
X-MC-Unique: DncilJwmPnuSdHF4QIcylA-1
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26FDRkYh037205;
 Fri, 15 Jul 2022 22:27:46 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Fri, 15 Jul 2022 22:27:46 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
 (authenticated bits=0)
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26FDRjb1037202
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
 Fri, 15 Jul 2022 22:27:46 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <6deb326e-0b0e-84f5-5d1e-2f321d5816ca@I-love.SAKURA.ne.jp>
Date: Fri, 15 Jul 2022 22:27:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <e3ac2722-01c4-decb-2b79-bfd1b6c2b782@I-love.SAKURA.ne.jp>
 <a41b962e-8423-75b5-ef89-74e8b9f25259@I-love.SAKURA.ne.jp>
In-Reply-To: <a41b962e-8423-75b5-ef89-74e8b9f25259@I-love.SAKURA.ne.jp>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 18 Jul 2022 08:05:17 +0000
Subject: Re: [dm-devel] [PATCH] dm: Avoid flush_scheduled_work() usage
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Ping?

On 2022/06/13 18:52, Tetsuo Handa wrote:
> Please see commit c4f135d643823a86 ("workqueue: Wrap flush_workqueue()
> using a macro") for background.
> 
> What should we do for this module?
> 
> On 2022/04/20 14:12, Tetsuo Handa wrote:
>> Flushing system-wide workqueues is dangerous and will be forbidden.
>> Remove flush_scheduled_work() from local_init() in dm.c and instead
>> use local workqueue to dm-mpath.c, dm-raid1.c, dm-stripe.c.
>>
>> Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> ---
>> Note: This patch was made blindly and completely untested. Maybe simply
>> removing flush_scheduled_work() from local_init() is sufficient. But I
>> don't know dependency across all files. Therefore, please carefully check
>> which schedule_work() needs to be converted to queue_work().
>>
>> As far as I can see, dm-stripe.c which contains dm_stripe_exit() which is
>> called via _exits[] before local_exit() calls flush_scheduled_work() is
>> the only file which calls schedule_work(). Therefore, I used dm_stripe_wq
>> for dm-stripe.c.
>>
>> Since I don't know dependency, and dm-raid1.c and dm-mpath.c are also calling
>> schedule_work(), I used dm_raid1_wq and dm_mpath_wq. But these changes might be
>> unnecessary because of not calling flush_scheduled_work().
>>
>>  drivers/md/dm-mpath.c  | 17 +++++++++++++----
>>  drivers/md/dm-raid1.c  | 14 +++++++++++---
>>  drivers/md/dm-stripe.c | 12 ++++++++++--
>>  drivers/md/dm.c        |  1 -
>>  4 files changed, 34 insertions(+), 10 deletions(-)
>>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

