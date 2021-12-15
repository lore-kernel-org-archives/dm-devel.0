Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8CC3C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 21:01:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-mBAOjGGbOJGiTRZHOTsosw-1; Wed, 15 Dec 2021 16:01:53 -0500
X-MC-Unique: mBAOjGGbOJGiTRZHOTsosw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D631624;
	Wed, 15 Dec 2021 21:01:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C59E5E48D;
	Wed, 15 Dec 2021 21:01:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D92C4BB7C;
	Wed, 15 Dec 2021 21:01:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFL1fDq004349 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 16:01:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B228D53CF; Wed, 15 Dec 2021 21:01:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD33E53CE
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 21:01:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C813D800B28
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 21:01:38 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-156-BbU9ZXWAPpyVzE44_Dj-8A-1; Wed, 15 Dec 2021 16:01:36 -0500
X-MC-Unique: BbU9ZXWAPpyVzE44_Dj-8A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54E36210FF;
	Wed, 15 Dec 2021 21:01:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12C0213BA3;
	Wed, 15 Dec 2021 21:01:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kvJjAq9XumH0fQAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 15 Dec 2021 21:01:35 +0000
Message-ID: <bcabbd3ebf3edbd8245f91baf90f6dbaa5df7d36.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 15 Dec 2021 22:01:34 +0100
In-Reply-To: <00f998ccfd2ee9893b27e4eb536fa26c59608e8b.camel@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
	<20211118225840.19810-4-mwilck@suse.com>
	<20211124204118.GP19591@octiron.msp.redhat.com>
	<52ddff9a6d2b1813d1269a008eb92ee522c3d6ad.camel@suse.com>
	<20211129192729.GD19591@octiron.msp.redhat.com>
	<d9260ceb655395864041a5037bac5aab6f722cf0.camel@suse.com>
	<20211130165251.GK19591@octiron.msp.redhat.com>
	<c6893070dd0d70420104ed071f7f45a365bd7faf.camel@suse.com>
	<1e0efe64215f399ca2f248590b48b4ec5024d8ed.camel@suse.com>
	<20211214232526.GB19591@octiron.msp.redhat.com>
	<00f998ccfd2ee9893b27e4eb536fa26c59608e8b.camel@suse.com>
User-Agent: Evolution 3.42.2
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
 functionality to lock.c
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Ben,

On Wed, 2021-12-15 at 08:33 +0100, Martin Wilck wrote:
> 
> I just wanted to say that my previous argument that addition or
> removal
> of symbols can be ignored was wrong, and that we should keep the
> treatment of minor versions as originally designed. I am fine with us
> not touching the .version files while we work on new patch sets, and
> leaving it to the person perparing a PR for Christope (likely myself)
> to fix it up when a patch series is finished. In practice, it'll
> probably result in just a major version bump per submission to
> Christophe, but that isn't cast in stone (if we submit a smaller set
> of
> patches, it might be just a minor bump, or none at all).
> 
> Distros are free to modify the last digit as they please.

Here's what I think I should do: I'll keep one patch on top of the
"queue" branch that includes the necessary ABI bumps. I'll fix this
patch up as commits are added to "queue". This means the queue branch
(more precisely, the topmost commit) will need to be rebased. It won't
be a problem as this commit will only touch the .version files, nothing
else. This way builds from "queue" will be "safe" against library
incompatibilities wrt the official release, and yet we won't need to
bump the major version multiple times for a single submission to
Christophe. Submissions to Christophe will come with either no bump, or
a single-step minor bump, or a single-step major bump.

Does this make sense?

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

