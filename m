Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C9DC7EE29
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 19:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686339553;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JQ99VQnkSgF2wc4DmlbVS1l++diN1/QNz7AX1K6EjDU=;
	b=F19/PPw0P0WosNYRlAaJY/FI1E9y/XaHRMtRn1I74YKUvkLFQRIGEBN+toK5ohARFekRGG
	IG3o2Ma4mtlX6p/yN5XkQyDStrPVjWhEMhw4ZLcim1rqte+r6+VNWc/AZezlO0k83MOAF6
	g2yn46FFPgqlDKX36xncDozb2jvv5uA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-B_KsiF-LP7CrE6XEtkd9gQ-1; Fri, 09 Jun 2023 15:39:10 -0400
X-MC-Unique: B_KsiF-LP7CrE6XEtkd9gQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2082E280D588;
	Fri,  9 Jun 2023 19:39:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BEC4810BDF;
	Fri,  9 Jun 2023 19:39:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9660819451C1;
	Fri,  9 Jun 2023 19:39:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A026194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 19:39:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 167E22166B26; Fri,  9 Jun 2023 19:39:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E6202166B25
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 19:39:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCCE7101A53A
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 19:39:03 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-B8y-_DTNMhe9VoYdD-oVow-1; Fri, 09 Jun 2023 15:38:54 -0400
X-MC-Unique: B8y-_DTNMhe9VoYdD-oVow-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7DBF465B2E;
 Fri,  9 Jun 2023 19:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8656C433EF;
 Fri,  9 Jun 2023 19:38:52 +0000 (UTC)
Date: Fri, 9 Jun 2023 12:38:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230609193852.GI72224@frogsfrogsfrogs>
References: <alpine.LRH.2.21.2305260915400.12513@file01.intranet.prod.int.rdu2.redhat.com>
 <20230602011355.GA16848@frogsfrogsfrogs>
 <7bf96e58-7151-a63d-317f-1ddedd4927ad@redhat.com>
MIME-Version: 1.0
In-Reply-To: <7bf96e58-7151-a63d-317f-1ddedd4927ad@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 09, 2023 at 08:56:37PM +0200, Mikulas Patocka wrote:
> 
> 
> On Thu, 1 Jun 2023, Darrick J. Wong wrote:
> 
> > On Mon, May 29, 2023 at 04:59:40PM -0400, Mikulas Patocka wrote:
> >
> > > #!/bin/sh -ex
> > > umount /mnt/test || true
> > > dmsetup remove_all || true
> > > rmmod brd || true
> > > SRC=/usr/src/git/bcachefs-tools
> > > while true; do
> > >         modprobe brd rd_size=1048576
> > >         bcachefs format --replicas=2 /dev/ram0 /dev/ram1
> > >         dmsetup create flakey --table "0 `blockdev --getsize /dev/ram0` linear /dev/ram0 0"
> > >         mount -t bcachefs /dev/mapper/flakey:/dev/ram1 /mnt/test
> > >         dmsetup load flakey --table "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 4 random_write_corrupt 100000000 random_read_corrupt 100000000"
> > 
> > Hey, that's really neat!
> > 
> > Any chance you'd be willing to get the dm-flakey changes merged into
> > upstream so that someone can write a recoveryloop fstest to test all the
> > filesystems systematically?
> > 
> > :D
> > 
> > --D
> 
> Yes, we will merge improved dm-flakey in the next merge window.

Thank you!

--D

> Mikulas
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

