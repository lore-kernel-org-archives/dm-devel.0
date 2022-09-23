Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826A6C6FA82
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663943023;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Era/hVdmFb8jNsJ8qJ+W+F+uHK8F1Cp/U0gHgHCta9I=;
	b=bZo6YGO23jSfEVobmYlQDO3V8bY6VvL7y1jPxHHumNQ9lt6LHjRtB6y2i/eKWsNloQaUaf
	ATj/SDw/AP0Oq69xwF6j3k3T2svSZxqODP8xCrR9j2cdOoRolVjWfigZBQMUO3fSY9cQ0z
	v+K55xzXkn7t7SDEXME9vxAVMA1SvIQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-ZI4Zk4QjNLe853IvDjquzA-1; Fri, 23 Sep 2022 10:23:40 -0400
X-MC-Unique: ZI4Zk4QjNLe853IvDjquzA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D202185A7AA;
	Fri, 23 Sep 2022 14:23:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7F9249BB60;
	Fri, 23 Sep 2022 14:23:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9317C19465B6;
	Fri, 23 Sep 2022 14:23:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5318319465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 14:23:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C1A1492B0A; Fri, 23 Sep 2022 14:23:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 346E4492B09
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 14:23:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A768B877CA4
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 14:23:28 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-569-5Oq0tR3tPXOHXyLGt-i-1g-1; Fri, 23 Sep 2022 10:23:27 -0400
X-MC-Unique: 5Oq0tR3tPXOHXyLGt-i-1g-1
Received: by mail-qk1-f200.google.com with SMTP id
 az15-20020a05620a170f00b006cece4cd0beso94864qkb.22
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 07:23:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=MtMta5sZ7F8zj2gNZ2FUjMLqWdc2TCa8gGZwFvL5igI=;
 b=3/vII51kO6CloE/81bfdnR63HPcUBCrnYHuBiEkBdbzqtZU0JMhpbRfKjmhrfZA++8
 dPUppOhzkJia+kM2I+TVZCkTGqdGfFoequRoeJ/KwnHNwb15mz1uVjne3v76wQ4+j+CL
 aE9eff+dgP4JSHecxeOOTL2QR95yJ61ApUKDq4Wn2a5OPs+Zwx8JantEUi81nKpaiMVr
 hAh8w8V8VfVeI74b+QfRwUua4OR3/jwbQ7CcdPYyQ3h2Inkix3dPUcXsf3H/TjzcOlzk
 aDHCO/snGxA9nLhEaklVMHm07glghgV3zJbgNzd88YU2q9n6wV9szPbHjmq61Wo81Oi4
 uqZw==
X-Gm-Message-State: ACrzQf0O7UvyZfmQRAH1ZyRdAzWBbbFleysKG9neUZBpwPMNi2f+mZJK
 uiUAReDMnH6YwdJ2ayE/SsiBzwUOo9ahg+3r8Fh6oo59U7tl995GsyZxDL8K/w5Nb+2pj0Whwia
 2wG5fs1kpE+ssBg==
X-Received: by 2002:a37:ef18:0:b0:6ce:175f:409a with SMTP id
 j24-20020a37ef18000000b006ce175f409amr5781671qkk.572.1663943006692; 
 Fri, 23 Sep 2022 07:23:26 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7XaeBSmIgCS5xVoX7O37KV2Q4BatIbL+4W7934TQWhD9AMaj+EBoxQ49sZN/jgeEabR6YtNA==
X-Received: by 2002:a37:ef18:0:b0:6ce:175f:409a with SMTP id
 j24-20020a37ef18000000b006ce175f409amr5781650qkk.572.1663943006470; 
 Fri, 23 Sep 2022 07:23:26 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 y26-20020a37f61a000000b006ceb933a9fesm5847674qkj.81.2022.09.23.07.23.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Sep 2022 07:23:26 -0700 (PDT)
Date: Fri, 23 Sep 2022 10:23:25 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <Yy3BXc9wf4PH6Rby@redhat.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-3-sarthakkukreti@google.com>
MIME-Version: 1.0
In-Reply-To: <20220915164826.1396245-3-sarthakkukreti@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH RFC 2/8] dm: Add support for block
 provisioning
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org,
 Evan Green <evgreen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 15 2022 at 12:48P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> 
> Add support to dm devices for REQ_OP_PROVISION. The default mode
> is to pass through the request and dm-thin will utilize it to provision
> blocks.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  drivers/md/dm-crypt.c         |  4 +-
>  drivers/md/dm-linear.c        |  1 +
>  drivers/md/dm-table.c         | 17 +++++++
>  drivers/md/dm-thin.c          | 86 +++++++++++++++++++++++++++++++++--
>  drivers/md/dm.c               |  4 ++
>  include/linux/device-mapper.h |  6 +++
>  6 files changed, 113 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 159c6806c19b..357f0899cfb6 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3081,6 +3081,8 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>  	if (ret)
>  		return ret;
>  
> +	ti->num_provision_bios = 1;
> +
>  	while (opt_params--) {
>  		opt_string = dm_shift_arg(&as);
>  		if (!opt_string) {
> @@ -3384,7 +3386,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	 * - for REQ_OP_DISCARD caller must use flush if IO ordering matters
>  	 */
>  	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
> -	    bio_op(bio) == REQ_OP_DISCARD)) {
> +	    bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_PROVISION)) {
>  		bio_set_dev(bio, cc->dev->bdev);
>  		if (bio_sectors(bio))
>  			bio->bi_iter.bi_sector = cc->start +
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 3212ef6aa81b..1aa782149428 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -61,6 +61,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ti->num_discard_bios = 1;
>  	ti->num_secure_erase_bios = 1;
>  	ti->num_write_zeroes_bios = 1;
> +	ti->num_provision_bios = 1;
>  	ti->private = lc;
>  	return 0;
>  
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 332f96b58252..b7f9cb66b7ba 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1853,6 +1853,18 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
>  	return true;
>  }
>  
> +static bool dm_table_supports_provision(struct dm_table *t)
> +{
> +	for (unsigned int i = 0; i < t->num_targets; i++) {
> +		struct dm_target *ti = dm_table_get_target(t, i);
> +
> +		if (ti->num_provision_bios)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +

This needs to go a step further and verify a device in the stack
actually services REQ_OP_PROVISION.

Please see dm_table_supports_discards(): it iterates all devices in
the table and checks that support is advertised.

For discard, DM requires that _all_ devices in a table advertise
support (that is pretty strict and likely could be relaxed to _any_).

You'll need ti->provision_supported (like ->discards_supported) to
advertise actual support is provided by dm-thinp (even if underlying
devices don't support it).

And yeah, dm-thinp passdown support for REQ_OP_PROVISION can follow
later as needed (if there actual HW that would benefit from
REQ_OP_PROVISION).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

