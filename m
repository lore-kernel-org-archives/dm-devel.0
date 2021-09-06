Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD05C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:14:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4890361039
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4890361039
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-EXblRysJMMqqdQ4mcCv5Xw-1; Mon, 06 Sep 2021 04:14:52 -0400
X-MC-Unique: EXblRysJMMqqdQ4mcCv5Xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC917180FD9C;
	Mon,  6 Sep 2021 08:14:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FDF15D9F0;
	Mon,  6 Sep 2021 08:14:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7402944A5E;
	Mon,  6 Sep 2021 08:14:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1862Efgq008916 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 5 Sep 2021 22:14:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5CD08202E4C1; Mon,  6 Sep 2021 02:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58590202E4BF
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 02:14:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3300811E76
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 02:14:38 +0000 (UTC)
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155]) by
	relay.mimecast.com with ESMTP id us-mta-290-knyKj4XINT-OL6JXe_IbWg-1;
	Sun, 05 Sep 2021 22:14:30 -0400
X-MC-Unique: knyKj4XINT-OL6JXe_IbWg-1
Received: by ajax-webmail-mail-app2 (Coremail) ; Mon, 6 Sep 2021 10:14:24
	+0800 (GMT+08:00)
X-Originating-IP: [10.214.16.36]
Date: Mon, 6 Sep 2021 10:14:24 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: dinghao.liu@zju.edu.cn
To: "Heinz Mauelshagen" <heinzm@redhat.com>
X-Priority: 3
In-Reply-To: <CAM23VxrzCk4XxbsG3dwqCq2PAnxNiEXoFXyp=t4t41o32THYrA@mail.gmail.com>
References: <20210903075531.20310-1-dinghao.liu@zju.edu.cn>
	<CAM23VxrzCk4XxbsG3dwqCq2PAnxNiEXoFXyp=t4t41o32THYrA@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <37fdfa89.be2a1.17bb8e29eee.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgC3aBWBeTVhbF5gBQ--.28492W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgYABlZdtVpN8wABsZ
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1862Efgq008916
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 06 Sep 2021 04:14:38 -0400
Cc: dm-devel@redhat.com, kjlu@umn.edu, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm raid: add missed unlock in raid_ctr
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> > On Fri, Sep 3, 2021 at 10:02 AM Dinghao Liu dinghao.liu@zju.edu.cn> wrote:
> > mddev_unlock() is called on all paths after we call mddev_lock_nointr(),
> > except for three error handling paths, which may cause a deadlock. This
> > bug is suggested by a static analysis tool, please advise.
> > Hi,    
> >     
> >     correct, those unlock calls are missing.    
> >
> >     As we are bailing out after md_run() with lock held,     
> >     we can clean the lot of error paths underneath up by jumping to before
> >     md_stop() and add the mddev_unlock upfront it like:    
    
Thanks for your advice! I will fix this and send a new patch soon.

Regards,
Dinghao


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

