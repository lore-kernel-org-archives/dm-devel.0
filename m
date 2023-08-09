Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102DBC0015E
	for <dm-devel@archiver.kernel.org>; Wed,  9 Aug 2023 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691604188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OTuy1MEi1iABz9BJBFZutSrbcTHgR8ST4SdUGMBtu/8=;
	b=OMyqYz/d7LsICY3QF4tY8Osd2tA7ABwIWh9wenkQcklTyUPwDYbd1RdWzBkoClx1folSBz
	q8bbthsWUzCTfKS+0dtLXBx/IMR2ZgKgdQlGyX9a/6m4Ci9anpC85FQGX6Y+6feKJkfLmd
	5v7pn5hq0tSe/eKvAJEqQwFviWhtryw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-y34FW-mqNSOvTrKOxX6zTw-1; Wed, 09 Aug 2023 14:03:06 -0400
X-MC-Unique: y34FW-mqNSOvTrKOxX6zTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CDE485C70E;
	Wed,  9 Aug 2023 18:03:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 467E22026D4B;
	Wed,  9 Aug 2023 18:02:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E80531946589;
	Wed,  9 Aug 2023 18:02:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D63E81946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Aug 2023 18:02:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6D0E1121315; Wed,  9 Aug 2023 18:02:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AEC001121319
 for <dm-devel@redhat.com>; Wed,  9 Aug 2023 18:02:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF83F85C70E
 for <dm-devel@redhat.com>; Wed,  9 Aug 2023 18:02:47 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-44-3uqbhxorPpSmhSHjft_Yww-1; Wed,
 09 Aug 2023 14:02:44 -0400
X-MC-Unique: 3uqbhxorPpSmhSHjft_Yww-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id F276320FC4C4; Wed,  9 Aug 2023 11:02:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F276320FC4C4
Date: Wed, 9 Aug 2023 11:02:42 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@kernel.org>,
 corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
 serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
 linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, audit@vger.kernel.org,
 roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>
Message-ID: <20230809180242.GA23396@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
 <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
 <20230808224503.GA20095@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20230808234023.GC120054@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20230808234023.GC120054@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH v10 11/17] dm-verity: consume root hash
 digest and signature data via LSM hook
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 09, 2023 at 12:40:23AM +0100, Alasdair G Kergon wrote:
> On Tue, Aug 08, 2023 at 03:45:03PM -0700, Fan Wu wrote:
> > On Tue, Jul 25, 2023 at 04:43:48PM -0400, Paul Moore wrote:
> > > Where would the finalize() hook be called?
> > 
> > It is in the __bind function in drivers/md/dm.c, calling just before 
> > rcu_assign_pointer(md->map, (void *)t) which activates the inactive table.
>  
> That would be after the existing commit point, meaning the table swap
> cannot be cancelled there, so is the finalize() you are proposing void()
> i.e. designed so it always succeeds?
> 
> Alasdair

Thanks for the input.

Actually, no, the hook can be failed. I noticed the existing call before rcu_assign_pointer(md->map, (void *)t);
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/md/dm.c#n2255)
can also be failed so I was following the same pattern.

Could you explain a bit more about the "commit point"? It sounds like it might be better to move
the hook call just before the commit point instead.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

