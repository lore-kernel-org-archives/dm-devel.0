Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B9CC7EE29
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 04:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685335920;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+LlA+FV5SNFv+89tx0KIYbiujrFVmvH4YTlBl9EUwJU=;
	b=IqZQlbAUiNsCtUSFZYxSdhe5qFVhfI4R14T+p6GtBeCeNk5iV9bixsjVFRamTCrildZA9K
	1uok8YNPoRSYntp8BJZbJ8Gc9vg/KZBjXJRxtGA02jscM5wEzidtN4cjQvWFgO6/Jw3kQB
	A2rQiTL6dskYTeLWC+lmIhWzasQSe0o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-O7FyIUu1PCaDyJiWH-VMwg-1; Mon, 29 May 2023 00:51:57 -0400
X-MC-Unique: O7FyIUu1PCaDyJiWH-VMwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F5B6811E9F;
	Mon, 29 May 2023 04:51:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEDCBC154D2;
	Mon, 29 May 2023 04:51:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 63C1419465A0;
	Mon, 29 May 2023 04:51:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8DE519465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 10:26:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AEB4F8162; Fri, 26 May 2023 10:26:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A77317AE4
 for <dm-devel@redhat.com>; Fri, 26 May 2023 10:26:40 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 880DA384708A
 for <dm-devel@redhat.com>; Fri, 26 May 2023 10:26:40 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
 (out30-132.freemail.mail.aliyun.com [115.124.30.132]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384)
 id us-mta-505-l0Z58c1rPz6BFSVZ4b2WKQ-1; Fri, 26 May 2023 06:26:38 -0400
X-MC-Unique: l0Z58c1rPz6BFSVZ4b2WKQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R391e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=durui@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjW4Oiz_1685096793
Received: from localhost(mailfrom:durui@linux.alibaba.com
 fp:SMTPD_---0VjW4Oiz_1685096793) by smtp.aliyun-inc.com;
 Fri, 26 May 2023 18:26:34 +0800
From: Du Rui <durui@linux.alibaba.com>
To: alexl@redhat.com
Date: Fri, 26 May 2023 18:26:33 +0800
Message-Id: <20230526102633.31160-1-durui@linux.alibaba.com>
In-Reply-To: <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
References: <CAL7ro1FPEqXyOuX_WPMYdsT6rW-bD5EU=v=oWKsd6XscykLF6Q@mail.gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 29 May 2023 04:51:50 +0000
Subject: Re: [dm-devel] dm overlaybd: targets mapping OverlayBD image
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
Cc: gscrivan@redhat.com, durui@linux.alibaba.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.alibaba.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Alexander,

> all the lvm volume changes and mounts during runtime caused
> weird behaviour (especially at scale) that was painful to manage (just
> search the docker issue tracker for devmapper backend). In the end
> everyone moved to a filesystem based implementation (overlayfs based).

Yes, we had exactly the same experience. This is another reason why
this proposal is for dm and lvm, not for container. 
(BTW, we are using TCMU and ublk for overlaybd in production. They are awesome.)


> This solution doesn't even allow page cache sharing between shared
> layers (like current containers do), much less between independent
> layers.

Page cache sharing can be realized with DAX support of the dm targets
(and the inner file system), together with virtual pmem device backend.

> Erofs already has some block-level support for container images

It is interesting. Erofs runs insider a block device in the first place,
like what many file systems do. But do you konw why it implements another 
"some block-level support" by itself?

> And this new approach doesn't help
No. It is intended for dm and lvm.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

