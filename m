Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B38C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 16:29:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-SVZ9ZZJJOOW6_p2FpfYRUQ-1; Thu, 14 Apr 2022 12:29:51 -0400
X-MC-Unique: SVZ9ZZJJOOW6_p2FpfYRUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29B75811E7A;
	Thu, 14 Apr 2022 16:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFBA6111D3DB;
	Thu, 14 Apr 2022 16:29:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C22AE1940344;
	Thu, 14 Apr 2022 16:29:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 402AD19451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 16:29:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F1F543E79C; Thu, 14 Apr 2022 16:29:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B21043E79B
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 16:29:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7DAB85A5BC
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 16:29:42 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-4SPpW64KMMO-azOFs4yzNA-1; Thu, 14 Apr 2022 12:29:41 -0400
X-MC-Unique: 4SPpW64KMMO-azOFs4yzNA-1
Received: by mail-qt1-f170.google.com with SMTP id o18so3886949qtk.7
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 09:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=J8HID19Q8B8HZA/NjZ+E3p+UXxrSu3cxNQ/w6L3ksOI=;
 b=ro+SaA2m3JdTrxCrVSroK8zzZnOiA6PkN+eseLsyKe2Gy/T29F9aqRvfnhusL9YtLi
 GzkxALFhLuLTL0sr11KQfEmIyQMKoA4g5x34xU8r+048ZZk9TiDOIVvOLz9z49ZOKj3k
 oH4jlndvJSDBMS8NNp1Wm/1iLE9fO7W1yHCPMYXITYwBs1aL/jkP53Hu6BJCb5yUnrU7
 WcDkAa3Vq9Cpyx707ib+TqEu+OxWKzNhthKi9WqxctK6TV+qvzS6o1r5PynBugfXUW3/
 HTkDYYJJIcSTThrtsDwhXDor0hFLF2JllKwCO+71MQJBEZKkTSQyje+3Xvx2JwuKRgMq
 llCg==
X-Gm-Message-State: AOAM53160YxDhdLDyNfWx/9CMbhpiIct81Pctxzc0LsCJvwgYT59QiMI
 wB87XNRG0qildpNYmn3fyqU2B3BRPYae96c=
X-Google-Smtp-Source: ABdhPJwHArNeOEc32Cv7CYMuIlz2AFJAHWnc8uBMzLlwuw5pMXm8ispj2rTH2VNZzubll9Erl/2FPA==
X-Received: by 2002:a05:622a:650:b0:2e1:e5cb:e47d with SMTP id
 a16-20020a05622a065000b002e1e5cbe47dmr2468137qtb.223.1649953780373; 
 Thu, 14 Apr 2022 09:29:40 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 a200-20020a3766d1000000b0069c1125b7bbsm1199951qkc.57.2022.04.14.09.29.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Apr 2022 09:29:40 -0700 (PDT)
Date: Thu, 14 Apr 2022 12:29:39 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Message-ID: <YlhL878nAVPkNK1n@redhat.com>
References: <20220414083436.pweunapygdtuzwaf@shindev>
MIME-Version: 1.0
In-Reply-To: <20220414083436.pweunapygdtuzwaf@shindev>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [bug report] BUG for REQ_OP_WRITE_ZEROES to dm-zoned
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Damien Le Moal <Damien.LeMoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 14 2022 at  4:34P -0400,
Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:

> Hello Mike,
> 
> Let me share a BUG I observed with v5.18-rcX and ask comments for the fix.
> 
> BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO)) in dm_accept_partial_bio()
> was triggered for dm-zoned. It happens when a bio with REQ_OP_WRITE_ZEROES and
> sector range which goes across zone boundaries of the zoned devices that
> dm-zoned maps. For such bios, dm-zoned calls dm_accept_partial_bio() to trim the
> bio to fit in a zone. And dm core sets the flag DM_TIO_IS_DUPLICATE_BIO to the
> tio of the bio.
> 
>     The BUG_ON symptom can be recreated with command as follows:
> 
>     # xfs_io -C "fzero 4096 $((512 * $(</sys/block/sdf/queue/chunk_sectors)))" /dev/dm-0
> 
>     In this command, /dev/dm-0 is the dm-zoned device. /dev/sdf is the zoned
>     block device. Its zone size is obtained from sysfs chunk_sectors attribute.
> 
> The trigger commit is e6fc9f62ce6e ("dm: flag clones created by
> __send_duplicate_bios") which introduced the new flag (it was named
> is_duplicated_bio, and following commit renamed it to DM_TIO_IS_DUPLICATE_BIO).
> I understand that the flag is set to the bios cloned in __send_duplicate_bios()
> to guard tio->len_ptr shared among the cloned bios from updates in
> dm_accept_partial_bio().
> 
> One point I can not understand is that the flag is set even when
> __send_duplicate_bios() clones only single bio. I think bio is not duplicated in
> this case, and there is no need to guard tio->len_ptr. Dm-zoned sets 1 to
> ti->num_write_zeroes_bios (and ti->num_discard_bios), then I think
> __send_duplicate_bios() always clones single bio for dm-zoned. I tried
> following patch below, which removes the flag set for the single bio clone case.
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f2397546b93f..d886c57e49ed 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1363,7 +1363,6 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
>                 break;
>         case 1:
>                 clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
> -               dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
>                 __map_bio(clone);
>                 break;
>         default:
> 
> With this patch, the BUG is no longer triggered. Is this a right fix approach?
> It looks for me the DM_TIO_IS_DUPLICATE_BIO check is too tight and I think we
> can relax it for the single clone case.
> 
> If I miss anything and the len_ptr guard by DM_TIO_IS_DUPLICATE_BIO is required
> even for the single bio clone case, I will think about dm-zoned change to avoid
> dm_accept_partial_bio() call, which will need bio split within dm-zoned.

Thanks for the report, I've staged a fix here (btw, your change above
needs to be paired with the 2nd hunk of my fix otherwise you won't get
the bio split you desire):

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=3dfb6f5e95f26215ca08d348ca2ddb5ea6ea2349

I'll be sending this to Linus later today or tomorrow.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

