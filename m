Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362A9C43334
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jul 2022 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657653112;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lhSC/dSPicxhoXyTyonVy0oynn0v6TL+GayXwyDrXSI=;
	b=FfqJ44OqYhTCU4dMr8jtuPxEInolNrMAUbabowlJu0E99LOTVYolUTA7xE3Z6IZGbtdCbO
	ktzXXs3tItlpoXqrbsIoyeHYLmBKDg/FFYrUHikUc88s6LNc/3u4rOJcYcsIz4KXWzhaRL
	BFE1qxc7wpUofgL5iBlLPndQxwxjiww=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-n6n045t5MNGjYxW98t0F7Q-1; Tue, 12 Jul 2022 15:11:49 -0400
X-MC-Unique: n6n045t5MNGjYxW98t0F7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76BFC3C0F36D;
	Tue, 12 Jul 2022 19:11:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 619531121315;
	Tue, 12 Jul 2022 19:11:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 382011947060;
	Tue, 12 Jul 2022 19:11:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D1C4B1947060
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Jul 2022 19:11:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1E812026D07; Tue, 12 Jul 2022 19:11:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E6872026D64;
 Tue, 12 Jul 2022 19:11:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26CJBiq0005497;
 Tue, 12 Jul 2022 14:11:44 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26CJBiTN005496;
 Tue, 12 Jul 2022 14:11:44 -0500
Date: Tue, 12 Jul 2022 14:11:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220712191143.GR10602@octiron.msp.redhat.com>
References: <20220706143822.30182-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220706143822.30182-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 00/14] multipath: fixes for sysfs accessors
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 06, 2022 at 04:38:08PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This set fixes some strangeness in our sysfs accessors which I
> found while looking at
> https://github.com/opensvc/multipath-tools/issues/35#issuecomment-1175901745.
> (The patches don't fix this issue, which seems to be related to
> Debian's initramfs setup).
> 
> Most importantly, sysfs_attr_get_value() and sysfs_attr_set_value()
> would return 0 if the number of bytes read/written was different from
> the expected value, which is non-standard and unexpected. This
> series changes the return value semantics of these functions:
> 
>  - in sysfs_attr_get_value(), if a read buffer is too small to hold
>    the string read plus a terminating 0 byte, the return value
>    equals the buffer size.
>  - in sysfs_bin_attr_get_value(), no 0 bytes are appended. It's not
>    an error if the read buffer is completely filled, and no warning
>    is printed in this case.
>  - sysfs_attr_set_value() always returns the number of bytes written
>    unless an error occured in open() or write().
> 
> Tests for the new semantics are added. Moreover, the sysfs.c code
> is slightly refactored to avoid code duplication.

For all except 8/14:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Martin Wilck (14):
>   libmultipath: alua: remove get_sysfs_pg83()
>   libmultipath: remove sysfs_get_binary()
>   libmultipath: sysfs_bin_attr_get_value(): no error if buffer is filled
>   libmultipath: common code path for sysfs_attr_get_value()
>   libmultipath: sanitize error checking in sysfs accessors
>   libmultipath: get rid of PATH_SIZE
>   libmultipath: sysfs_attr_get_value(): don't return 0 if buffer too
>     small
>   libmultipath: sysfs_attr_set_value(): don't return 0 on partial write
>   libmultipath: sysfs: cleanup file descriptors on pthread_cancel()
>   libmultipath, multipathd: log failure setting sysfs attributes
>   multipath tests: expect_condlog: skip depending on verbosity
>   multipath tests: __wrap_dlog: print log message
>   multipath tests: add sysfs test
>   libmultipath.version: bump version for sysfs accessors
> 
>  libmultipath/configure.c              |  30 +-
>  libmultipath/discovery.c              | 120 +++----
>  libmultipath/libmultipath.version     |   8 +-
>  libmultipath/prioritizers/alua_rtpg.c |  57 +--
>  libmultipath/propsel.c                |   6 +-
>  libmultipath/structs.h                |   3 -
>  libmultipath/sysfs.c                  | 191 ++++------
>  libmultipath/sysfs.h                  |  23 ++
>  libmultipath/util.c                   |   8 +-
>  multipathd/cli_handlers.c             |   2 +-
>  multipathd/fpin_handlers.c            |  11 +-
>  multipathd/main.c                     |  40 ++-
>  tests/Makefile                        |   5 +-
>  tests/sysfs.c                         | 494 ++++++++++++++++++++++++++
>  tests/test-lib.c                      |   1 -
>  tests/test-log.c                      |   5 +
>  16 files changed, 751 insertions(+), 253 deletions(-)
>  create mode 100644 tests/sysfs.c
> 
> -- 
> 2.36.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

