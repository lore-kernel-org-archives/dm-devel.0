Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FAD1C001B0
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 23:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691538270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D0fya27QBI0rItUA0EKKjwqh9KrkuhLLmKkmRNAfqLQ=;
	b=jDm2pyoDIujrKfsIkoUyCevO8IIAkIfIhwddl7CBN7hctsJAxZ+7PScxpkex2KGL24llmd
	Wg6irR/QRX5e9Tzr7/dKnDYbRbxDV7XVMgtay4e6AJpUxn+CsqNpIZYXjuYjkk6ABFM2CP
	483VVTjug7z3yet6G395f0lYv/7l0QU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-HOggMdTHPEKsxI93P9d9ZA-1; Tue, 08 Aug 2023 19:44:26 -0400
X-MC-Unique: HOggMdTHPEKsxI93P9d9ZA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6A78087B9;
	Tue,  8 Aug 2023 23:44:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B493492C13;
	Tue,  8 Aug 2023 23:44:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BFE71946588;
	Tue,  8 Aug 2023 23:44:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 818231946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 23:44:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21058492C14; Tue,  8 Aug 2023 23:44:23 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
 (agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A3551492C13;
 Tue,  8 Aug 2023 23:44:22 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
 from userid 3883)
 id 7C2AE403A55F; Wed,  9 Aug 2023 00:40:23 +0100 (BST)
Date: Wed, 9 Aug 2023 00:40:23 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Fan Wu <wufan@linux.microsoft.com>
Message-ID: <20230808234023.GC120054@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: Fan Wu <wufan@linux.microsoft.com>,
 Paul Moore <paul@paul-moore.com>, Mike Snitzer <snitzer@kernel.org>,
 corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
 serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
 linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, audit@vger.kernel.org,
 roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
 <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
 <20230808224503.GA20095@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
In-Reply-To: <20230808224503.GA20095@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 Paul Moore <paul@paul-moore.com>, dm-devel@redhat.com, corbet@lwn.net,
 roberto.sassu@huawei.com, Deven Bowers <deven.desai@linux.microsoft.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 jmorris@namei.org, zohar@linux.ibm.com, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 08, 2023 at 03:45:03PM -0700, Fan Wu wrote:
> On Tue, Jul 25, 2023 at 04:43:48PM -0400, Paul Moore wrote:
> > Where would the finalize() hook be called?
> 
> It is in the __bind function in drivers/md/dm.c, calling just before 
> rcu_assign_pointer(md->map, (void *)t) which activates the inactive table.
 
That would be after the existing commit point, meaning the table swap
cannot be cancelled there, so is the finalize() you are proposing void()
i.e. designed so it always succeeds?

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

