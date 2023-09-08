Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4866EE57CA
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 07:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694158377;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oVApz9nlsA95gO2gAiyiDUajX7jiMPKhW52Gz43fdnI=;
	b=fa1p1fGmgnoQfMKiQZ50DG4qf/cu1xGM9d+/Uj2fyWrfC0mYj8xmNOMavpOS+LIu7hlFDZ
	+wkbH43g+5Qb5YrYlGU8qGFgS34m8cvEYZq2ia+sapWyf9/wc81Zgh8mvPmmDxM8fY5bQg
	LwFE+mTTNidO96xY3b3YnA7sijooaiQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-684-gLU-Pf0hNnG79nzHe-3A1Q-1; Fri, 08 Sep 2023 03:32:53 -0400
X-MC-Unique: gLU-Pf0hNnG79nzHe-3A1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D64AC2812957;
	Fri,  8 Sep 2023 07:32:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7585A1121318;
	Fri,  8 Sep 2023 07:32:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5284C194658F;
	Fri,  8 Sep 2023 07:32:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F4EB194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 07:32:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 09FC11121318; Fri,  8 Sep 2023 07:32:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01A731121314
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 07:32:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDE968001EA
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 07:32:48 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690--b-PhEVPNOu7y65hcmgsuw-1; Fri,
 08 Sep 2023 03:32:47 -0400
X-MC-Unique: -b-PhEVPNOu7y65hcmgsuw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 8339E1F45A;
 Fri,  8 Sep 2023 07:32:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 66765132F2;
 Fri,  8 Sep 2023 07:32:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id n5D2GB3O+mRBEQAAMHmgww
 (envelope-from <jack@suse.cz>); Fri, 08 Sep 2023 07:32:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id DBF11A0774; Fri,  8 Sep 2023 09:32:44 +0200 (CEST)
Date: Fri, 8 Sep 2023 09:32:44 +0200
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230908073244.wyriwwxahd3im2rw@quack3>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
 <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
MIME-Version: 1.0
In-Reply-To: <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] fix writing to the filesystem after unmount
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
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Zdenek Kabelac <zkabelac@redhat.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.cz
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 07-09-23 14:04:51, Mikulas Patocka wrote:
> 
> 
> On Thu, 7 Sep 2023, Christian Brauner wrote:
> 
> > > I think we've got too deep down into "how to fix things" but I'm not 100%
> > 
> > We did.
> > 
> > > sure what the "bug" actually is. In the initial posting Mikulas writes "the
> > > kernel writes to the filesystem after unmount successfully returned" - is
> > > that really such a big issue?
> 
> I think it's an issue if the administrator writes a script that unmounts a 
> filesystem and then copies the underyling block device somewhere. Or a 
> script that unmounts a filesystem and runs fsck afterwards. Or a script 
> that unmounts a filesystem and runs mkfs on the same block device.

Well, e.g. e2fsprogs use O_EXCL open so they will detect that the filesystem
hasn't been unmounted properly and complain. Which is exactly what should
IMHO happen.

> > > Anybody else can open the device and write to it as well. Or even 
> > > mount the device again. So userspace that relies on this is kind of 
> > > flaky anyway (and always has been).
> 
> It's admin's responsibility to make sure that the filesystem is not 
> mounted multiple times when he touches the underlying block device after 
> unmount.

What I wanted to suggest is that we should provide means how to make sure
block device is not being modified and educate admins and tool authors
about them. Because just doing "umount /dev/sda1" and thinking this means
that /dev/sda1 is unused now simply is not enough in today's world for
multiple reasons and we cannot solve it just in the kernel.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

