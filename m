Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50A8C77B70
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 06:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681455128;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eiyFyx2QDNqeOLrE8LMLaNNsMGg6f7QA3mtWXUgLgzM=;
	b=d8mGgIPotmgxQ8b0L2BaUNq4iJu99lvlzoDaat7IWXFoNnAwUX5nAqeWbRnyy7HnNxZDx8
	5nJWpzZBbNLcj66uy12TvPpz29Oupy//qmyCnA+kNtkPpvt1eENEBKdkT83V49zyA4wByR
	BqvphF9peZ69dmO7hXDaFQ8CryQ9CZY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-p7x6-Q34Oniy3dLI1k_3qw-1; Fri, 14 Apr 2023 02:52:07 -0400
X-MC-Unique: p7x6-Q34Oniy3dLI1k_3qw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C3D388606D;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C121492B00;
	Fri, 14 Apr 2023 06:52:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DEAE31946A6D;
	Fri, 14 Apr 2023 06:52:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 12FD01946597
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 09:51:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E666040B3EDA; Thu, 13 Apr 2023 09:51:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DEF4E40B3ED9
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 09:51:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE4F7280A329
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 09:51:06 +0000 (UTC)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com
 [209.85.217.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-S2I_6pWwNXuGkuRaW2A68w-1; Thu, 13 Apr 2023 05:51:05 -0400
X-MC-Unique: S2I_6pWwNXuGkuRaW2A68w-1
Received: by mail-vs1-f46.google.com with SMTP id i8so5469371vsv.4
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 02:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681379464; x=1683971464;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=5/1cCA7ARMmBDMVmrz4hr0FRe4hg+/OHyteC+tHS04g=;
 b=ATywExTwo1DsAAs0SpzLdvTN4oSSEFn9LqoYCm7/tQE+ZV2Kdy/9fD7z3jvJpy5M6a
 MSnCqfmIpgJjyBVDYiIwqo4nRw+cvK0L7sJPkzO30dTcymWND38i52HUk5Shp6X576QR
 sY0xMJQ23jvoaI6bMnhjEJQPyZWfcFqpMeoDd2QTtPgfI2YpYHvwpsqV3h1s6g42Okhr
 OGNufMbrZ2EbbfaTGdnWnNLckbz3cLInJL3nhlv3ebBTXosBK1WLxBe2tYXhxo+ugyqb
 dTCl5mupwoVe/VGT64jnEwz9Ot6F4wTOqcIQCzcVxvw06uq754Fk9IgeWqDElYSxL9Iz
 NUpQ==
X-Gm-Message-State: AAQBX9e4funI8UDu3AkUTHb3n8csCOUsClspzs+Wa7iWB7iuSily9hJ2
 87LqNXcCEBb3w/VLPfokYzs33J88lWI3bPZ6yvYB6Q==
X-Google-Smtp-Source: AKy350aPWg8QPSOy/2PHkhrh6sAkwuh8+NOSRnErraPKD6xHUPGtdIg/0oa13IGXGEwruNWS6Z0XHf1YhCtKpgAgMbc=
X-Received: by 2002:a67:c30c:0:b0:42c:9c6e:a5d2 with SMTP id
 r12-20020a67c30c000000b0042c9c6ea5d2mr913874vsj.1.1681379464384; Thu, 13 Apr
 2023 02:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230412093617.285177-1-naresh.kamboju@linaro.org>
 <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
 <e85746b2-9736-9041-9327-1ad1299aa155@oracle.com>
In-Reply-To: <e85746b2-9736-9041-9327-1ad1299aa155@oracle.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Apr 2023 15:20:53 +0530
Message-ID: <CA+G9fYu5T3HwXzcU4ouNhYY0zOZhJgbc6AXFS0q1wHgV65AEDA@mail.gmail.com>
To: Mike Christie <michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 14 Apr 2023 06:52:02 +0000
Subject: Re: [dm-devel] [PATCH v6 00/18] Use block pr_ops in LIO
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
Cc: shy828301@gmail.com, roman.gushchin@linux.dev,
 linux-nvme@lists.infradead.org, james.bottomley@hansenpartnership.com,
 dm-devel@redhat.com, target-devel@vger.kernel.org, hch@lst.de,
 bvanassche@acm.org, linux-scsi@vger.kernel.org, willy@infradead.org,
 chaitanyak@nvidia.com, ryan.roberts@arm.com, keescook@chromium.org,
 snitzer@kernel.org, linux-block@vger.kernel.org, kbusch@kernel.org,
 vbabka@suse.cz, yuzhao@google.com, axboe@kernel.dk, martin.petersen@oracle.com,
 halbuer@sra.uni-hannover.de, mkoutny@suse.com, akpm@linux-foundation.org,
 mgorman@techsingularity.net, zokeefe@google.com,
 kirill.shutemov@linux.intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linaro.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 12 Apr 2023 at 23:59, Mike Christie <michael.christie@oracle.com> wrote:
>
> On 4/12/23 5:25 AM, Naresh Kamboju wrote:
> > On Wed, 12 Apr 2023 at 15:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >>
> >> [sorry for the adding you in CC]
> >>
> >> While running LTP controllers test suite on this patch set applied on top of
> >> the next-20230406 and the following kernel panic noticed on qemu-i386.
> >
> > Also noticed on qemu-x86_64.
> >
> > Crash log link,
> > ------------------
> > - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/test/check-kernel-panic/log
> > - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/tests/
>
> Can you point me to the original report? I don't think my patches are the cause of
> the failure, or if they are there is a crazy bug.
>
> Above, I think you pointed me to the wrong link above because it looks like that's
> for a different patchset. Or did I misunderstand the testing and that link has my
> patches included?
>
> I did see my patches tested:
>
> https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/
>
> but they seem to fail in similar places as other failures that day, and the
> failures don't seem related to my patches. It doesn't look like you are doing
> anything nvme or block pr ioctl related and just failing on forks and OOM.
> It looks like you are booting from a scsi device but I only touched the scsi
> layer's code for persistent reservations and the tests don't seem to be
> using that code.

Thanks for the analysis on these reports.
Since it is based on top of Linux next-20230306, I will re-validate the base
and get back to you with my findings.

- Naresh


>
>
>
> >
> > lore link,
> > https://lore.kernel.org/linux-block/20230407200551.12660-1-michael.christie@oracle.com/
> >
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

