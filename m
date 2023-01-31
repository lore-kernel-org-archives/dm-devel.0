Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6D50C6379F
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lhKueu07ce3hQ1FeSCiBYcDmXDbfaHsuxOxyHOSLBgA=;
	b=Uasp4OfzlN684zFMM5YJdSjG0ioADTPOoRoL3kCz3RkfScuP4yVHcZOqHwY+BOcCLI+tyD
	CU3M716Qpie876NBPo2zT0XNMbe1PNMX1R3xyajzTNyznJUV6QZzEduvgX8ObZwfGNUM8M
	K3g/jBwrm2Vcl94J5z1dF7JZAcOymYI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-6bu9h2zNPBWJxJRTkNtC8w-1; Wed, 01 Feb 2023 03:03:54 -0500
X-MC-Unique: 6bu9h2zNPBWJxJRTkNtC8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D36B9280604B;
	Wed,  1 Feb 2023 08:03:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1CCE53A0;
	Wed,  1 Feb 2023 08:03:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A7B819465B2;
	Wed,  1 Feb 2023 08:03:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 54B971946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 23:01:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 988BCC15BAE; Tue, 31 Jan 2023 23:01:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90AB3C15BAD
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 23:01:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76BAA811E6E
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 23:01:05 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-230-IYuxpGdWNJeoO-U_d37JTQ-1; Tue,
 31 Jan 2023 18:01:02 -0500
X-MC-Unique: IYuxpGdWNJeoO-U_d37JTQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 02B2720E1A45; Tue, 31 Jan 2023 15:01:01 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02B2720E1A45
Date: Tue, 31 Jan 2023 15:01:00 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20230131230100.GA30104@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-10-git-send-email-wufan@linux.microsoft.com>
 <Y9jXJ8FrmAnzob7w@infradead.org>
MIME-Version: 1.0
In-Reply-To: <Y9jXJ8FrmAnzob7w@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 01 Feb 2023 08:03:52 +0000
Subject: Re: [dm-devel] [RFC PATCH v9 09/16] block|security: add LSM blob to
 block_device
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
 paul@paul-moore.com, dm-devel@redhat.com, corbet@lwn.net,
 roberto.sassu@huawei.com, Deven Bowers <deven.desai@linux.microsoft.com>,
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31, 2023 at 12:53:59AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 30, 2023 at 02:57:24PM -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > 
> > block_device structures can have valuable security properties,
> > based on how they are created, and what subsystem manages them.
> 
> That's a lot of cloudy talk but no real explanation.

Sorry for being too general here. Currently the only use target of this hook is dm-verity. We use the newly added security hook to save the dm-verity roothash and signature to the new bdev security blob during the bdev creation time, so LSMs can leverage this information to protect the system. 

I will add this example in the next version.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

