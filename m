Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CA4C05027
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 18:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675362838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X89YYZa5QwwoFoyVa+cjqv3j8qodot1iuTODrRYZyJE=;
	b=dxfCKcvHlzms8UC+fGwmmqwoicmuYqHnv+S8i+k7inSJj3e/zBrLu6cb7PSaPCJx2LMtAX
	40LZ8yNmz8yyi7Q4d6DerwsE3a+ssTG0GgNtDPKR6ochtCb++zSgi4fSvbe+8s3dEdzlGO
	acep27Y8VyZW99Fksz5SQ1NZw21yX6s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-UgU5Qlg_NKCTJQq_cidyCA-1; Thu, 02 Feb 2023 13:33:54 -0500
X-MC-Unique: UgU5Qlg_NKCTJQq_cidyCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60C753813F38;
	Thu,  2 Feb 2023 18:33:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0BBC1404BEC0;
	Thu,  2 Feb 2023 18:33:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D426C194658C;
	Thu,  2 Feb 2023 18:33:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A98861946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 18:33:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 887812026D68; Thu,  2 Feb 2023 18:33:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 811912026D4B
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:33:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EA2B101A52E
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:33:50 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-531-LZGezGyKM-yhv37XxCHChA-1; Thu, 02 Feb 2023 13:33:48 -0500
X-MC-Unique: LZGezGyKM-yhv37XxCHChA-1
Received: from [2601:1c2:d00:6a60::9526]
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1pNeOf-00Gxdl-15; Thu, 02 Feb 2023 18:33:21 +0000
Message-ID: <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
Date: Thu, 2 Feb 2023 10:33:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <875yckvt1b.fsf@meer.lwn.net>
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
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, netdev@vger.kernel.org,
 Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>,
 Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-usb@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Vinod Koul <vkoul@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2/2/23 10:09, Jonathan Corbet wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
>> Maintainers of specific kernel subsystems are only Cc-ed on their
>> respective patches, not the entire series. [if all goes well]
>>
>> These patches are based on linux-next-20230127.
> 
> So I've applied a bunch of these
> 

>>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>  [PATCH 7/9] Documentation: scsi: correct spelling
> 
> I've left these for the SCSI folks for now.  Do we *really* want to be
> fixing spelling in ChangeLog files from almost 20 years ago?

That's why I made it a separate patch -- so the SCSI folks can decide that...

-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

