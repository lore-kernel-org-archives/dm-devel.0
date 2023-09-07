Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE35EE8016
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694185594;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hTbJceCfAR0UfsQMwenwzzDBdW/X31QpQ6hOI2AvWYI=;
	b=EZL43Y5YcaKmvSSiKDOtLE4TFaQ/8Fe2hiuivgS1dwOsPUJMjJAaFb+sxMVrb2kAlwuWbv
	rPxq2fnVvzk2gA4pY+KvfH+eBe2PTmOPUUwzEWqO+fnAgUvlux+JukR3sU6YDDDD3uG60J
	hzqWzgkECxhjtp4aWH6MMmlM3Y7E6kg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-P_1rvxqoMA2hyDgVpiJYDg-1; Fri, 08 Sep 2023 11:06:30 -0400
X-MC-Unique: P_1rvxqoMA2hyDgVpiJYDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 551EC1C18C73;
	Fri,  8 Sep 2023 15:06:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CA4D63F67;
	Fri,  8 Sep 2023 15:06:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 667B519465B6;
	Fri,  8 Sep 2023 15:06:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B9A7194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 10:43:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 55D6C1121319; Thu,  7 Sep 2023 10:43:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DDEF1121314
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 10:43:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31CE480D75F
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 10:43:54 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-bvp5SSp4Nwe1_9Xye6zYuA-1; Thu,
 07 Sep 2023 06:43:50 -0400
X-MC-Unique: bvp5SSp4Nwe1_9Xye6zYuA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id E48F7CE192C;
 Thu,  7 Sep 2023 10:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47749C4163D;
 Thu,  7 Sep 2023 10:43:43 +0000 (UTC)
Date: Thu, 7 Sep 2023 12:43:40 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Message-ID: <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
MIME-Version: 1.0
In-Reply-To: <20230907094457.vcvmixi23dk3pzqe@quack3>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Fri, 08 Sep 2023 15:06:24 +0000
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
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> I think we've got too deep down into "how to fix things" but I'm not 100%

We did.

> sure what the "bug" actually is. In the initial posting Mikulas writes "the
> kernel writes to the filesystem after unmount successfully returned" - is
> that really such a big issue? Anybody else can open the device and write to
> it as well. Or even mount the device again. So userspace that relies on
> this is kind of flaky anyway (and always has been).

Yeah, agreed.

> namespaces etc. I'm not sure such behavior brings much value...

It would in any case mean complicating our code for little gain imho.
And as I showed in my initial reply the current patch would hang on any
bind-mount unmount. IOW, any container. And Al correctly points out
issues with exit(), close() and friends on top of that.

But I also hate the idea of waiting on the last umount because that can
also lead to new unexpected behavior when e.g., the system is shutdown
and systemd goes on to unmount all things and then suddenly just hangs
when before it was able to make progress.

And returning EBUSY is tricky as well as we somehow would need to have a
way to refcount in a manner that let's us differentiate between last-
"user-visible"-superblock-reference" and
last-active-superblock-reference which would complicate things even more.

I propose we clearly document that unmounting a frozen filesystem will
mean that the superblock stays active at least until the filesystem is
unfrozen.

And if userspace wants to make sure to not recycle such a frozen
superblock they can now use FSCONFIG_CMD_CREATE_EXCL to detect that.

What might be useful is to extend fanotify. Right now we have
fsnotify_sb_delete() which lets you detect that a superblock has been
destroyed (generic_shutdown_super()). It could be useful to also get
notified when a superblock is frozen and unfrozen?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

