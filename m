Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92543EE14BB
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694020169;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1CqWj7YICg8OVHIKwnfXCtkPoVheRgdQ0S+kbROOQCM=;
	b=J0y2yqtutE5Gzcp6EilMkv6+Q80YxItE7CIC3//vPxAe55CZevLqoMAIT7W77p7Q8fH8qL
	gJX124nZve/32pw47tyNkrNmC3/GpoB9bPI47YBdrcd1oJIs6Av7LIBqTW+ZNu0Fncx9uC
	+tABAB23kOXFm3Vz9WkION/aMXXv+M4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-IBxQQKlJNRay1_kqVbnsdQ-1; Wed, 06 Sep 2023 13:09:25 -0400
X-MC-Unique: IBxQQKlJNRay1_kqVbnsdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B314D181BBD5;
	Wed,  6 Sep 2023 17:09:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19DA6400F26A;
	Wed,  6 Sep 2023 17:09:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D43EF194658D;
	Wed,  6 Sep 2023 17:09:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5272A194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 17:09:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3ECA540411F; Wed,  6 Sep 2023 17:09:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3838A404119
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:09:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C03BC280D228
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:09:14 +0000 (UTC)
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-bgB7Hg8CMlihMU8lJJBjyA-1; Wed,
 06 Sep 2023 13:09:07 -0400
X-MC-Unique: bgB7Hg8CMlihMU8lJJBjyA-1
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat
 Linux)) id 1qdw1Q-0040ad-0I; Wed, 06 Sep 2023 17:08:56 +0000
Date: Wed, 6 Sep 2023 18:08:56 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20230906170856.GA800259@ZenIV>
References: <59b54cc3-b98b-aff9-14fc-dc25c61111c6@redhat.com>
 <20230906-launenhaft-kinder-118ea59706c8@brauner>
 <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
MIME-Version: 1.0
In-Reply-To: <f5d63867-5b3e-294b-d1f5-a128817cfc7@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
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
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: zeniv.linux.org.uk
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Sep 06, 2023 at 05:03:34PM +0200, Mikulas Patocka wrote:

> > IOW, you'd also hang on any umount of a bind-mount. IOW, every
> > single container making use of this filesystems via bind-mounts would
> > hang on umount and shutdown.
> 
> bind-mount doesn't modify "s->s_writers.frozen", so the patch does nothing 
> in this case. I tried unmounting bind-mounts and there was no deadlock.

You are making *any* mount destruction hang if the sucker is frozen.
Which includes the things like exit(2) of the last process within
a namespace, etc.

And it does include the things like mount --bind /usr/bin/gcc /tmp/cc; umount /tmp/cc
if /usr happened to be frozen at the moment.

This is really not an option.

> BTW. what do you think that unmount of a frozen filesystem should properly 
> do? Fail with -EBUSY? Or, unfreeze the filesystem and unmount it? Or 
> something else?

It's not just umount(2).  It's exit(2).  And close(2).  And AF_UNIX garbage
collector taking out an undeliverable SCM_RIGHTS datagram that happens to
contain a reference to the last opened file on lazy-umounted fs, etc.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

