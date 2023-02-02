Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75899C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675361816;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tYeZGUy5nYdul1c3gD07hKyJ+UT71a+eRDd0eF/BKHQ=;
	b=gZi+KugGg9wF5si5ozuRlZ2Lrrz73h8L7NTyZ9ENMf4e0OVAn3mgz/4AeN3d681LcAF0pj
	OLJO0BZnWfDHotq0ncV2HRE4997HGwYjpNK7T4pyyFeEblSS11VqKQCOBvCZ7gpC+3hOlg
	6/KId6vomY9cJJ8MtplaIleYEEUsbrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-adt30SHnOFC3qdurzSvw_w-1; Thu, 02 Feb 2023 13:16:41 -0500
X-MC-Unique: adt30SHnOFC3qdurzSvw_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63EF380391B;
	Thu,  2 Feb 2023 18:16:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C5C4140EBF6;
	Thu,  2 Feb 2023 18:16:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BEE94194658F;
	Thu,  2 Feb 2023 18:16:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87BDF1946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 18:15:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A23112026D76; Thu,  2 Feb 2023 18:15:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9972B2026D68
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:15:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A4DE80D0F5
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:15:35 +0000 (UTC)
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-CFtomfGuOUihcjt71uEdvA-1; Thu, 02 Feb 2023 13:15:31 -0500
X-MC-Unique: CFtomfGuOUihcjt71uEdvA-1
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ms.lwn.net (Postfix) with ESMTPSA id 48D347DE;
 Thu,  2 Feb 2023 18:09:05 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 48D347DE
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
Date: Thu, 02 Feb 2023 11:09:04 -0700
Message-ID: <875yckvt1b.fsf@meer.lwn.net>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Cc: nvdimm@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
 linux-doc@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 netdev@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
 sparclinux@vger.kernel.org, Neeraj Upadhyay <quic_neeraju@quicinc.com>,
 Alasdair Kergon <agk@redhat.com>, Dave Jiang <dave.jiang@intel.com>,
 linux-scsi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin
 K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Vinod Koul <vkoul@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, dmaengine@vger.kernel.org, "David S.
 Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Randy Dunlap <rdunlap@infradead.org> writes:

> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
>
> These patches are based on linux-next-20230127.

So I've applied a bunch of these

>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling

applied

>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling

These have been taken up elsewhere

>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling

I've left these for the SCSI folks for now.  Do we *really* want to be
fixing spelling in ChangeLog files from almost 20 years ago?

>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling

Applied.

Thanks,

jon

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

