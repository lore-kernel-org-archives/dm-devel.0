Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2C4C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 26 Apr 2022 17:30:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-vW37mWw0MvSfwqKXvAQlKQ-1; Tue, 26 Apr 2022 13:30:17 -0400
X-MC-Unique: vW37mWw0MvSfwqKXvAQlKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52BF21C0BF06;
	Tue, 26 Apr 2022 17:30:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C607120111A5;
	Tue, 26 Apr 2022 17:30:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5A6591947BBB;
	Tue, 26 Apr 2022 17:30:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 421B019451EC
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 17:30:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B5D5551CF6; Tue, 26 Apr 2022 17:30:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17FD4551CF3
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 17:30:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00556802C16
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 17:30:12 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-teDWgGmmOx2n4tqwZHQ7FQ-1; Tue, 26 Apr 2022 13:30:10 -0400
X-MC-Unique: teDWgGmmOx2n4tqwZHQ7FQ-1
Received: by mail-qv1-f47.google.com with SMTP id jt15so8610231qvb.13
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 10:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SEwqid2cqU5z1FQfUADU6++wJRZ5uOwQWBCECyhyBEs=;
 b=Ad9pSraQiHP00BJfe7Yuu9Lvc/m31zn7cPjOr/LyWElfc435PjbDnRnkZBqQWV2RSH
 aIZOmEepqo8IGA8uHZkRc/eG9aXmdH6IHiT9zmXNphvyWr7NM9vRI3VcBPa4QVPLr0NC
 B6BP8bw9wY3VerC9fz4hcGz5ZboO+AynnmgVyCfdbWH1sD/fJhviSF6hAVbkVBn2zEFD
 lghQmiDtRrcR/RGgnjKzjNc0gLKGSouXJ03qGWoywTorSm27KBBBzTWYNGCue8iDWO5p
 l4CqnfRi2NkVpdLxrSefDTHOA+8iSRn1XJAvmrPyqWPey2VgK8Qkiquwo1rQZouFaqUs
 j8/Q==
X-Gm-Message-State: AOAM5307TJvCPeOBwqc/uRVphzgrARD2C5E6+503aIA6ivZo1/kYNXh7
 c3zA3cjNhMBn4QG9p0XKfk8D6gY4E2UH43M=
X-Google-Smtp-Source: ABdhPJxBM/S+k8uviQRJFWKzy6Mj03NOVNPmwTQC5uQw6kwCRZ4DuQzmHuTyvCw1QEQCb2vGucXO0A==
X-Received: by 2002:a05:6214:2a82:b0:443:a395:cc23 with SMTP id
 jr2-20020a0562142a8200b00443a395cc23mr16948937qvb.67.1650994209996; 
 Tue, 26 Apr 2022 10:30:09 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 q27-20020a05620a039b00b0069c8307d9c4sm6688016qkm.18.2022.04.26.10.30.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Apr 2022 10:30:09 -0700 (PDT)
Date: Tue, 26 Apr 2022 13:30:08 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YmgsIA9asIxxpRlt@redhat.com>
References: <YkRM7Iyp8m6A1BCl@fedora> <YkUwmyrIqnRGIOHm@infradead.org>
 <YkVBjUy9GeSMbh5Q@fedora> <YkVxLN9p0t6DI5ie@infradead.org>
 <YlBX+ytxxeSj2neQ@redhat.com> <YlEWfc39+H+esrQm@infradead.org>
 <YlReKjjWhvTZjfg/@redhat.com> <YlRiUVFK+a0DwQhu@redhat.com>
 <YlRmhlL8TtQow0W0@redhat.com> <YmQvgdqHlsQVpxR+@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YmQvgdqHlsQVpxR+@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] block: remove redundant blk-cgroup init from
 __bio_clone
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Dennis Zhou <dennis@kernel.org>, tj@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Apr 23 2022 at 12:55P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> So while I'm still diving into the somewhat invasive changes to
> optimize some of the cloning all we might relaly need for your
> use case should be this:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/blk-clone-no-bdev
> 
> Can you check if this helps you?

Passing NULL will be useful for targets that do call bio_set_dev() but
there are some that inherit the original bdev.  I'll audit all targets
and sort out how best to handle the conditional initialization to
avoid needless work.

This change is useful and a requirement for relevant follow-on DM
changes:

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

