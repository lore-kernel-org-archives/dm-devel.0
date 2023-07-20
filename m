Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDADCEB64DC
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 04:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689826871;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bdoQ9I4STky+90CVH/Kd6QiIeXQq0jqCv8PWuNECrPc=;
	b=VoHA+Un3N3K+R5+eAxd1M6sJtQKaXycfRNw5Wr2vrWZL18bJ1vY25JQcdgwEBVugD14zao
	CuGKSuc7dJGsOGFTOB9UTU8GMkGg8N/r0dDyzh1f/2YK62EVohaG3XOmEItVAhsCeiWa1e
	C9jfKaX5fR1D4siRQAohhTdmKk0dSo8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-M50s2mcZMwqg5OPjqnuJ7w-1; Thu, 20 Jul 2023 00:21:10 -0400
X-MC-Unique: M50s2mcZMwqg5OPjqnuJ7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 651A3858290;
	Thu, 20 Jul 2023 04:21:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57332F6CCD;
	Thu, 20 Jul 2023 04:21:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CA8019465B9;
	Thu, 20 Jul 2023 04:21:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BD5C71946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 04:20:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED7691454145; Thu, 20 Jul 2023 04:20:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4CC11454142
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 04:20:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6DAE936D22
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 04:20:49 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-NbDmSADbNH6jj2_AM7Nxbw-1; Thu, 20 Jul 2023 00:20:48 -0400
X-MC-Unique: NbDmSADbNH6jj2_AM7Nxbw-1
Received: from cwcc.thunk.org (pool-173-48-116-181.bstnma.fios.verizon.net
 [173.48.116.181]) (authenticated bits=0)
 (User authenticated as tytso@ATHENA.MIT.EDU)
 by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 36K4KYAp010027
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 20 Jul 2023 00:20:35 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
 id 681A615C026A; Thu, 20 Jul 2023 00:20:34 -0400 (EDT)
Date: Thu, 20 Jul 2023 00:20:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <martin@lichtvoll.de>
Message-ID: <20230720042034.GA5764@mit.edu>
References: <20230717075035.GA9549@tomerius.de>
 <CAG4Y6eTN1XbZ_jAdX+t2mkEN=KoNOqprrCqtX0BVfaH6AxkdtQ@mail.gmail.com>
 <20230718213212.GE3842864@mit.edu>
 <4835096.GXAFRqVoOG@lichtvoll.de>
MIME-Version: 1.0
In-Reply-To: <4835096.GXAFRqVoOG@lichtvoll.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] File system robustness
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
Cc: linux-embedded@vger.kernel.org, dm-devel@redhat.com,
 Kai Tomerius <kai@tomerius.de>,
 =?iso-8859-1?Q?Bj=F8rn?= Forsman <bjorn.forsman@gmail.com>,
 Ext4 Developers List <linux-ext4@vger.kernel.org>,
 "Alan C. Assis" <acassis@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: mit.edu
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 19, 2023 at 08:22:43AM +0200, Martin Steigerwald wrote:
> 
> Is "nobarrier" mount option still a thing? I thought those mount options 
> have been deprecated or even removed with the introduction of cache flush 
> handling in kernel 2.6.37?

Yes, it's a thing, and if your server has a UPS with a reliable power
failure / low battery feedback, it's *possible* to engineer a reliable
system.  Or, for example, if you have a phone with an integrated
battery, so when you drop it the battery compartment won't open and
the battery won't go flying out, *and* the baseboard management
controller (BMC) will halt the CPU before the battery complete dies,
and gives a chance for the flash storage device to commit everything
before shutdown, *and* the BMC arranges to make sure the same thing
happens when the user pushes and holds the power button for 30
seconds, then it could be safe.

We also use nobarrier for a scratch file systems which by definition
go away when the borg/kubernetes job dies, and which will *never*
survive a reboot, let alone a power failure.  In such a situation,
there's no point sending the cache flush, because the partition will
be mkfs'ed on reboot.  Or, in if the iSCSI or Cloud Persistent Disk
will *always* go away when the VM dies, because any persistent state
is saved to some cluster or distributed file store (e.g., to the MySQL
server, or Big Table, or Spanner, etc.  In these cases, you don't
*want* the Cache Flush operation, since skipping it reduce I/O
overhead.

So if you know what you are doing, in certain specialized use cases,
nobarrier can make sense, and it is used today at my $WORK's data
center for production jobs *all* the time.  So we won't be making
ext4's nobarrier mount option go away; it has users.  :-)

Cheers,

					- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

