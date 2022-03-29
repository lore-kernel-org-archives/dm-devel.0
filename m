Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB73BC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 13:30:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-z8zET4-XNV2PSQNjZKYzag-1; Tue, 29 Mar 2022 09:30:49 -0400
X-MC-Unique: z8zET4-XNV2PSQNjZKYzag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 366218001EA;
	Tue, 29 Mar 2022 13:30:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FCD240CF8ED;
	Tue, 29 Mar 2022 13:30:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEC1D1940345;
	Tue, 29 Mar 2022 13:30:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11B9B1940342
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 13:30:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E538E401E24; Tue, 29 Mar 2022 13:30:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1AE0401E48
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 13:30:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6944833968
 for <dm-devel@redhat.com>; Tue, 29 Mar 2022 13:30:42 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-c6Fi8C2sNZuaj0M8cvLugg-1; Tue, 29 Mar 2022 09:30:40 -0400
X-MC-Unique: c6Fi8C2sNZuaj0M8cvLugg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nZBaf-00CICc-HL; Tue, 29 Mar 2022 13:08:53 +0000
Date: Tue, 29 Mar 2022 06:08:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kirill Tkhai <kirill.tkhai@openvz.org>
Message-ID: <YkME5ZS2CpXuNmN6@infradead.org>
References: <164846619932.251310.3668540533992131988.stgit@pro>
MIME-Version: 1.0
In-Reply-To: <164846619932.251310.3668540533992131988.stgit@pro>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 0/4] dm: Introduce dm-qcow2 driver to attach
 QCOW2 files as block device
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
Cc: snitzer@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org,
 dm-devel@redhat.com, agk@redhat.com, khorenko@virtuozzo.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 28, 2022 at 02:18:16PM +0300, Kirill Tkhai wrote:
> This patchset adds a new driver allowing to attach QCOW2 files
> as block devices. Its idea is to implement in kernel only that
> features, which affect runtime IO performance (IO requests
> processing functionality).

From a quick looks it seems to be like this should be a block driver
just like the loop driver and not use device mapper.  Why would
you use device mapper to basically reimplement a fancy loop driver
to start with?

> The maintenance operations are
> synchronously processed in userspace, while device is suspended.
> 
> Userspace is allowed to do only that operations, which never
> modifies virtual disk's data. It is only allowed to modify
> QCOW2 file metadata providing that disk's data. The examples
> of allowed operations is snapshot creation and resize.

And this sounds like a pretty fragile design.  It basically requires
both userspace and the kernel driver to access metadata on disk, which
sounds rather dangerous.

> This example shows the way of device-mapper infrastructure
> allows to implement drivers following the idea of
> kernel/userspace components demarcation. Thus, the driver
> uses advantages of device-mapper instead of implementing
> its own suspend/resume engine.

What do you need more than a queue freeze?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

