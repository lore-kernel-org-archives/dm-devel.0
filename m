Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F852EE14D9
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694079914;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a4W5ou47aUbzb+3dkjYNUy4zh85ofcoovJig5HJPrrQ=;
	b=BETFluy3TpIwP4X3b8Eati3Frv5sFtwk8PFZ0pqMCfLTUdlRWbkjwbPa08bogG5kB/wBrp
	SBODicN1mKzTgv0nETmlRwW/mxIdh+gZCMbWT4u0Gyrk9DKtg4C8T9ELX7VJkWrTdKjROZ
	DHZUnouYGHXPP7J/KKM09kvNy16CdIo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-X7rsnTNYPbuCN1F7haJ5rQ-1; Thu, 07 Sep 2023 05:45:10 -0400
X-MC-Unique: X7rsnTNYPbuCN1F7haJ5rQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFF40802A6E;
	Thu,  7 Sep 2023 09:45:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B9161121314;
	Thu,  7 Sep 2023 09:45:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C7AD194658F;
	Thu,  7 Sep 2023 09:45:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC27F194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 09:45:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A93B940C84A6; Thu,  7 Sep 2023 09:45:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2ADE40C2070
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 09:45:01 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86898817077
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 09:45:01 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-JGrJwLb1MdidWFW73ZDweg-1; Thu,
 07 Sep 2023 05:44:59 -0400
X-MC-Unique: JGrJwLb1MdidWFW73ZDweg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 2E2F71F459;
 Thu,  7 Sep 2023 09:44:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B15C138F9;
 Thu,  7 Sep 2023 09:44:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4n+FBpqb+WT+QQAAMHmgww
 (envelope-from <jack@suse.cz>); Thu, 07 Sep 2023 09:44:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id 6D8EFA06E5; Thu,  7 Sep 2023 11:44:57 +0200 (CEST)
Date: Thu, 7 Sep 2023 11:44:57 +0200
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230907094457.vcvmixi23dk3pzqe@quack3>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
MIME-Version: 1.0
In-Reply-To: <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

On Wed 06-09-23 18:52:39, Mikulas Patocka wrote:
> On Wed, 6 Sep 2023, Christian Brauner wrote:
> > On Wed, Sep 06, 2023 at 06:01:06PM +0200, Mikulas Patocka wrote:
> > > > > BTW. what do you think that unmount of a frozen filesystem should properly 
> > > > > do? Fail with -EBUSY? Or, unfreeze the filesystem and unmount it? Or 
> > > > > something else?
> > > > 
> > > > In my opinion we should refuse to unmount frozen filesystems and log an
> > > > error that the filesystem is frozen. Waiting forever isn't a good idea
> > > > in my opinion.
> > > 
> > > But lvm may freeze filesystems anytime - so we'd get randomly returned 
> > > errors then.
> > 
> > So? Or you might hang at anytime.
> 
> lvm doesn't keep logical volumes suspended for a prolonged amount of time. 
> It will unfreeze them after it made updates to the dm table and to the 
> metadata. So, it won't hang forever.
> 
> I think it's better to sleep for a short time in umount than to return an 
> error.

I think we've got too deep down into "how to fix things" but I'm not 100%
sure what the "bug" actually is. In the initial posting Mikulas writes "the
kernel writes to the filesystem after unmount successfully returned" - is
that really such a big issue? Anybody else can open the device and write to
it as well. Or even mount the device again. So userspace that relies on
this is kind of flaky anyway (and always has been).

I understand the need for userspace to make sure the device is not being
modified to do its thing - but then it should perhaps freeze the bdev if
it wants to be certain? Or at least open it O_EXCL to make sure it's not
mounted?

WRT the umount behavior for frozen filesystem - as Al writes it's a tricky
issue and we've been discussing that several times over the years and it
never went anywhere because of nasty corner-cases (which current behavior
also has but trading one nasty case for another isn't really a win). Now
that we distinguish between kernel-initiated freeze (with well defined
freeze owner and lifetime) and userspace-initiated freeze, I can image we'd
make last unmount of the superblock wait for the kernel-initiated freeze to
thaw. But as Al writes with lazy unmounts, bind mounts in multiple
namespaces etc. I'm not sure such behavior brings much value...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

