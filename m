Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9079EB8FB1
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 12:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694088314;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o7I/1cKL4uMhRoRJczrmQXbxNv18QlxCDJHxfWPnqHs=;
	b=HRC2v7nbJ8UqOfN2L9xNtXqLNGZLoKnU5vAcow3O7FAOMGlzG3JT+WbK2fNkrJBFnp7R5R
	skF35B+XgAoX498YhdlPR7QGt/cffNs3Di9Axc9DDN3G1eRJJTR8UpagSsnnQKggopE6+L
	x1jJP2Z4Je4ztPfzt671I0YRKNwYd/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-680-uLOePBpdNlCVn_DQvUVA7Q-1; Thu, 07 Sep 2023 08:05:11 -0400
X-MC-Unique: uLOePBpdNlCVn_DQvUVA7Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96C208007CE;
	Thu,  7 Sep 2023 12:05:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4640D493110;
	Thu,  7 Sep 2023 12:05:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC180194658F;
	Thu,  7 Sep 2023 12:04:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DF9F194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 12:04:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CBD44403171; Thu,  7 Sep 2023 12:04:51 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D48D4060E1;
 Thu,  7 Sep 2023 12:04:51 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 7631030C1C07; Thu,  7 Sep 2023 12:04:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 71E2E3FD6A; Thu,  7 Sep 2023 14:04:51 +0200 (CEST)
Date: Thu, 7 Sep 2023 14:04:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christian Brauner <brauner@kernel.org>
In-Reply-To: <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
Message-ID: <513f337e-d254-2454-6197-82df564ed5fc@redhat.com>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
 <20230906-aufheben-hagel-9925501b7822@brauner>
 <60f244be-803b-fa70-665e-b5cba15212e@redhat.com>
 <20230906-aufkam-bareinlage-6e7d06d58e90@brauner>
 <818a3cc0-c17b-22c0-4413-252dfb579cca@redhat.com>
 <20230907094457.vcvmixi23dk3pzqe@quack3>
 <20230907-abgrenzen-achtung-b17e9a1ad136@brauner>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Alexander Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 7 Sep 2023, Christian Brauner wrote:

> > I think we've got too deep down into "how to fix things" but I'm not 100%
> 
> We did.
> 
> > sure what the "bug" actually is. In the initial posting Mikulas writes "the
> > kernel writes to the filesystem after unmount successfully returned" - is
> > that really such a big issue?

I think it's an issue if the administrator writes a script that unmounts a 
filesystem and then copies the underyling block device somewhere. Or a 
script that unmounts a filesystem and runs fsck afterwards. Or a script 
that unmounts a filesystem and runs mkfs on the same block device.

> > Anybody else can open the device and write to it as well. Or even 
> > mount the device again. So userspace that relies on this is kind of 
> > flaky anyway (and always has been).

It's admin's responsibility to make sure that the filesystem is not 
mounted multiple times when he touches the underlying block device after 
unmount.

> Yeah, agreed.
> 
> > namespaces etc. I'm not sure such behavior brings much value...
> 
> It would in any case mean complicating our code for little gain imho.
> And as I showed in my initial reply the current patch would hang on any
> bind-mount unmount. IOW, any container. And Al correctly points out
> issues with exit(), close() and friends on top of that.
> 
> But I also hate the idea of waiting on the last umount because that can
> also lead to new unexpected behavior when e.g., the system is shutdown
> and systemd goes on to unmount all things and then suddenly just hangs
> when before it was able to make progress.

Would you agree to waiting on the last umount only if the freeze was 
initiated by lvm? (there would be no hang in this case because lvm thaws 
the block device in a timely manner)

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

