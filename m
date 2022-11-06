Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8243CC4167B
	for <dm-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667810415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Gms/s3jAACt03/y4/mIwejRMEZaMBEBVzef/ZaqSy3s=;
	b=EhKjxWBq3mmSB6VThkeaIyZWbxkM3dKZBmTkrkCxxpMimjnihA9/BO911HvkFGFlR7VZyb
	tIzpig3idgzy5/HNekaKWCGmOKE30WaCeFMI2B6/R0piOyj/2mI7DDzRDLGgR0uv3fnZFe
	cITxHwbRBVPHPEal7Ge8+Kr3RD2bDi4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-RVFU9GPZNxOhfCkURFGaxA-1; Mon, 07 Nov 2022 03:40:12 -0500
X-MC-Unique: RVFU9GPZNxOhfCkURFGaxA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4B53101A592;
	Mon,  7 Nov 2022 08:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03C95492B11;
	Mon,  7 Nov 2022 08:40:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 47B0619465B3;
	Mon,  7 Nov 2022 08:40:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0052A1946587
 for <dm-devel@listman.corp.redhat.com>; Sun,  6 Nov 2022 11:06:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C869C40C6EE9; Sun,  6 Nov 2022 11:06:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C04C740C6EC5
 for <dm-devel@redhat.com>; Sun,  6 Nov 2022 11:06:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9C2E85A583
 for <dm-devel@redhat.com>; Sun,  6 Nov 2022 11:06:32 +0000 (UTC)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-zc8cyl55Ncqz9EwWs9GtQQ-1; Sun, 06 Nov 2022 06:06:30 -0500
X-MC-Unique: zc8cyl55Ncqz9EwWs9GtQQ-1
Received: from fsav312.sakura.ne.jp (fsav312.sakura.ne.jp [153.120.85.143])
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2A6AU5oj049054;
 Sun, 6 Nov 2022 19:30:05 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav312.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp);
 Sun, 06 Nov 2022 19:30:05 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
 (authenticated bits=0)
 by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2A6ASnfQ048798
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
 Sun, 6 Nov 2022 19:28:50 +0900 (JST)
 (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e170edc2-e5b9-4c8b-4ed3-7e2d7a2850dc@I-love.SAKURA.ne.jp>
Date: Sun, 6 Nov 2022 19:28:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
To: MPT-FusionLinux.pdl@broadcom.com, dm-devel@redhat.com,
 DRI <dri-devel@lists.freedesktop.org>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 07 Nov 2022 08:40:06 +0000
Subject: [dm-devel] How is the progress for removing flush_scheduled_work()
 callers?
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Like commit c4f135d643823a86 ("workqueue: Wrap flush_workqueue() using a
macro") says, flush_scheduled_work() is dangerous and will be forbidden.
We are on the way for removing all flush_scheduled_work() callers from
the kernel, and there are only 4 callers remaining as of linux-20221104.

  drivers/gpu/drm/i915/display/intel_display.c:8997:      flush_scheduled_work();
  drivers/gpu/drm/i915/gt/selftest_execlists.c:88:        flush_scheduled_work();
  drivers/md/dm.c:234:    flush_scheduled_work();
  drivers/message/fusion/mptscsih.c:1234: flush_scheduled_work();

I'm planning to start emitting runtime messages in linux-next.git tree.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

