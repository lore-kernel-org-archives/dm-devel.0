Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3AFC4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 10:44:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDA2F20809
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 10:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDA2F20809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-IX0I8KXoOhGVu7HjtW0L2g-1; Mon, 26 Oct 2020 06:43:59 -0400
X-MC-Unique: IX0I8KXoOhGVu7HjtW0L2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACA22805F00;
	Mon, 26 Oct 2020 10:43:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D70A85B4A4;
	Mon, 26 Oct 2020 10:43:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C46E1826D3A;
	Mon, 26 Oct 2020 10:43:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QAhoGK009883 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 06:43:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 56BC86379A; Mon, 26 Oct 2020 10:43:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5192063536
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 10:43:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD1C800161
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 10:43:47 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-375-Wr1chZMNMuew74TuXkvhOg-1;
	Mon, 26 Oct 2020 06:43:43 -0400
X-MC-Unique: Wr1chZMNMuew74TuXkvhOg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 25F19B301;
	Mon, 26 Oct 2020 10:43:42 +0000 (UTC)
Message-ID: <6b99062343bcbf097421d5a3f12b96ebe32cdcb8.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Mon, 26 Oct 2020 11:43:40 +0100
In-Reply-To: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
References: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
User-Agent: Evolution 3.36.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 0/6] multipath-tools history bug in 0.4.9
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Lixiaokeng,

On Mon, 2020-10-26 at 17:23 +0800, lixiaokeng wrote:
> Hi,
> 
> There are some old patches in our multipath-tools code. They fix some
> bugs in old version (0.4.9). I'm not the auther of these patches,
> but I send them. Please review.Thanks.

Thanks for the patches, but unless you can provide evidence that the
issues are still present in recent upstream code, we likely won't
bother with this on dm-devel. Please report this to the distribution(s)
you are using that are still shipping the old multipath-tools versions.

Regards,
Martin

> 
> lixiaokeng (3):
>   fix multipathd resize when not all sizes of paths are equal
>   fix lun expansion failure when there is offline path
>   flush and sync before reboot
> 
> sunguoshuai (3):
>   check pgp to avoid NULL dereference in enable_group
>   fix change reservtion key to uint8 for memcmp
>   ignore for clear mismatch key
> 
>  libmpathpersist/mpath_persist.c  | 27 ++++++++++++++++++++-------
>  libmultipath/configure.c         | 18 ++++++++++++++++++
>  libmultipath/prioritizers/alua.c |  4 ++++
>  libmultipath/prioritizers/emc.c  |  2 +-
>  libmultipath/prioritizers/hds.c  | 19 +++++++++++--------
>  libmultipath/structs.c           |  1 +
>  libmultipath/structs.h           |  1 +
>  libmultipath/structs_vec.c       | 10 +++++++---
>  libmultipath/util.c              |  7 +++++++
>  multipathd/cli_handlers.c        | 19 ++++++++++++++++++-
>  multipathd/main.c                |  5 +++++
>  11 files changed, 93 insertions(+), 20 deletions(-)
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

