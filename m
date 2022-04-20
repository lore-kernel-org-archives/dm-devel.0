Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4ABC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 19:47:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-cqFVtCvgOOOouVHMp1yynQ-1; Wed, 20 Apr 2022 15:47:50 -0400
X-MC-Unique: cqFVtCvgOOOouVHMp1yynQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A433785A5A8;
	Wed, 20 Apr 2022 19:47:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 153C714A4F80;
	Wed, 20 Apr 2022 19:47:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9A23E1949763;
	Wed, 20 Apr 2022 19:47:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7F9E519451EC
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 19:47:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 43FEB14A4F82; Wed, 20 Apr 2022 19:47:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FF5314A4F80
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 19:47:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 260E129AB42F
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 19:47:43 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-azbvkabqPeK__L3ayDUETA-1; Wed, 20 Apr 2022 15:47:41 -0400
X-MC-Unique: azbvkabqPeK__L3ayDUETA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 863276126E;
 Wed, 20 Apr 2022 19:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C871C385A0;
 Wed, 20 Apr 2022 19:42:07 +0000 (UTC)
Date: Wed, 20 Apr 2022 12:41:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <YmBiAQ/IZbFhRc6o@sol.localdomain>
References: <20220420064745.1119823-1-hch@lst.de>
 <20220420064745.1119823-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220420064745.1119823-3-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 2/2] blk-crypto: fix the blk_crypto_profile
 liftime
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
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
 linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
 Ritesh Harjani <riteshh@codeaurora.org>, linux-block@vger.kernel.org,
 Avri Altman <avri.altman@wdc.com>, dm-devel@redhat.com,
 Alim Akhtar <alim.akhtar@samsung.com>, Asutosh Das <asutoshd@codeaurora.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 20, 2022 at 08:47:45AM +0200, Christoph Hellwig wrote:
> Once the blk_crypto_profile is exposed in sysfs it needs to stay alive
> as long as sysfs accesses are possibly pending.  Ensure that by removing
> the blk_crypto_kobj wrapper and just embedding the kobject into the
> actual blk_crypto_profile.  This requires the blk_crypto_profile
> structure to be dynamically allocated, which in turn requires a private
> data pointer for driver use.
> 
> Fixes: 20f01f163203 ("blk-crypto: show crypto capabilities in sysfs")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Can you elaborate on what you think the actual problem is here?  The lifetime of
the blk_crypto_profile matches that of the host controller kobject, and I
thought that it is not destroyed until after higher-level objects such as
gendisks and request_queues are destroyed.  Similar assumptions are made by the
queue kobject, which assumes it is safe to access the gendisk, and by the
independent_access_ranges kobject which assumes it is safe to access the queue.

I suppose this wouldn't have worked with the original sysfs design where opening
a file in sysfs actually got a refcount to the kobject.  But that's long gone,
having been changed in Linux v2.6.23 (https://lwn.net/Articles/229774).

Note that commit 20f01f163203 which added this code got an "all looks good" from
Greg KH (https://lore.kernel.org/r/YaH1CmHClx5WvDWD@kroah.com).  I'd have hoped
that he would've noticed if there was a major problem with how kobjects are used
here!  Greg, would you mind taking a look at this part again?

>  int blk_crypto_sysfs_register(struct request_queue *q)
>  {
> -	struct blk_crypto_kobj *obj;
>  	int err;
>  
>  	if (!q->crypto_profile)
>  		return 0;
>  
> -	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
> -	if (!obj)
> -		return -ENOMEM;
> -	obj->profile = q->crypto_profile;
> -
> -	err = kobject_init_and_add(&obj->kobj, &blk_crypto_ktype, &q->kobj,
> -				   "crypto");
> -	if (err) {
> -		kobject_put(&obj->kobj);
> -		return err;
> -	}
> -	q->crypto_kobject = &obj->kobj;
> -	return 0;
> +	err = kobject_add(&q->crypto_profile->kobj, &q->kobj, "crypto");
> +	if (err)
> +		kobject_put(&q->crypto_profile->kobj);
> +	return err;
>  }

In any case, this proposal is not correct since it is assuming that each
blk_crypto_profile is referenced by only one request_queue, which is not
necessarily the case since a host controller can have multiple disks.
The same kobject can't be added to multiple places in the hierarchy.

If we did need to do something differently here, I think we'd either need to put
the blk_crypto_profile kobject under the host controller one and link to it from
the queue directories (which I mentioned in commit 20f01f163203 as an
alternative considered), or duplicate the crypto capabilities in each
request_queue and only share the actual keyslot management data structures.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

