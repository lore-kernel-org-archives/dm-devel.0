Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C29C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686337007;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Cxm+uSupPcnOQVjN37bL9FrWuxKW20wCjWjRUWshPVQ=;
	b=VVg2C2hBZC5MwHSq2nysXTT1RpsQK/JjuaCM1I9Eb8cueGC8SsfG4cQKXIV/AQbRqVtvYT
	dIDLgQKfB/96SIUhQS4R/kZYjzpzT80NfEY07uC44c/SJwaR5ddk/2OQXrE7CtaI6cifuM
	+JXI0jSaSKLj2rWVCmHpyC5eIOfcxK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-19OQhvHbMwuG-MMUdVMvFQ-1; Fri, 09 Jun 2023 14:56:43 -0400
X-MC-Unique: 19OQhvHbMwuG-MMUdVMvFQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC2338039C9;
	Fri,  9 Jun 2023 18:56:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1009740D1B66;
	Fri,  9 Jun 2023 18:56:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE79619451C1;
	Fri,  9 Jun 2023 18:56:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2CD94194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 18:56:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E34A310BDF; Fri,  9 Jun 2023 18:56:37 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D18E810ED7;
 Fri,  9 Jun 2023 18:56:37 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id C04E930C0502; Fri,  9 Jun 2023 18:56:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 BE97D3F7CF; Fri,  9 Jun 2023 20:56:37 +0200 (CEST)
Date: Fri, 9 Jun 2023 20:56:37 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20230602011355.GA16848@frogsfrogsfrogs>
Message-ID: <7bf96e58-7151-a63d-317f-1ddedd4927ad@redhat.com>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <20230602011355.GA16848@frogsfrogsfrogs>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] fuzzing bcachefs with dm-flakey
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
Cc: linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 dm-devel@redhat.com, Kent Overstreet <kent.overstreet@linux.dev>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 1 Jun 2023, Darrick J. Wong wrote:

> On Mon, May 29, 2023 at 04:59:40PM -0400, Mikulas Patocka wrote:
>
> > #!/bin/sh -ex
> > umount /mnt/test || true
> > dmsetup remove_all || true
> > rmmod brd || true
> > SRC=/usr/src/git/bcachefs-tools
> > while true; do
> >         modprobe brd rd_size=1048576
> >         bcachefs format --replicas=2 /dev/ram0 /dev/ram1
> >         dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` linear /dev/ram0 0"
> >         mount -t bcachefs /dev/mapper/flakey:/dev/ram1 /mnt/test
> >         dmsetup load flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"
> 
> Hey, that's really neat!
> 
> Any chance you'd be willing to get the dm-flakey changes merged into
> upstream so that someone can write a recoveryloop fstest to test all the
> filesystems systematically?
> 
> :D
> 
> --D

Yes, we will merge improved dm-flakey in the next merge window.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

