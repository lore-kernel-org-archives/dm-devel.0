Return-Path: <SRS0=L0Bp=GY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C58C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 08:41:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 611F22399A
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 08:41:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 611F22399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-44ZHajhAM-aJ5NsIp58R-g-1; Thu, 21 Jan 2021 03:41:03 -0500
X-MC-Unique: 44ZHajhAM-aJ5NsIp58R-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43B7B800C78;
	Thu, 21 Jan 2021 08:40:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CBBC6A8E4;
	Thu, 21 Jan 2021 08:40:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50926180954D;
	Thu, 21 Jan 2021 08:40:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10L30xk2003989 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Jan 2021 22:00:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4671510FFE70; Thu, 21 Jan 2021 03:00:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42547100BFFE
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 03:00:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D2E0800161
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 03:00:56 +0000 (UTC)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
	[209.85.218.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-470-Z3K1tEsjMUOum4NWSBea9w-1; Wed, 20 Jan 2021 22:00:52 -0500
X-MC-Unique: Z3K1tEsjMUOum4NWSBea9w-1
Received: by mail-ej1-f47.google.com with SMTP id rv9so524273ejb.13;
	Wed, 20 Jan 2021 19:00:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=YdnR/g1AUsA802dFK4Bs9r1QCNRoeBKoAACTpgBxsAQ=;
	b=LK8aNumP27yDwXxSKkE8pDnk6r6Hu9GRJfFeF+NN1Tf7TKF4sKyFz7DO234OjCQ2O9
	Va/wewjwQT4smqi4hWATXrGPSdeziZ5ZktUh+tZyPZkPLcPjuQ9HqVlJQS+trU8HLfag
	0SNaU3DJfgFbbQjx0JEj7KpWcPcflxneNXIGewBYFMQ7gDVc7x3Z3bwdAfshFBHCz+uA
	4qGe1ZhJEVitFH7PucKxzGqI9arlrOV858SWSiArbaFApsyBuvKvv05cdDf/H8Qblky9
	iR2uLy736lSapPXrXvb6e2dGCWZNRKhZMNSdosSvPTelfYaQoX9vGtNACHXtgMWktEz+
	91cA==
X-Gm-Message-State: AOAM530YVAxo/SWMcq+Xv2hs1s9aPD4rBguIlh39V7e2vASePbRkanTM
	W84FMEXZNOAPU72zX+qjwUUKD6Ypq93g6poKevU=
X-Google-Smtp-Source: ABdhPJx4hIKkKiU2iBKXjdqE5eWNNe7e0osIQ9gJJ07rfesCCPovnPnhiYH+s1vpHW57b+spuuKB7GPDWGgtgfAiGN4=
X-Received: by 2002:a17:906:9619:: with SMTP id
	s25mr7999226ejx.345.1611198050485; 
	Wed, 20 Jan 2021 19:00:50 -0800 (PST)
MIME-Version: 1.0
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 21 Jan 2021 14:00:38 +1100
Message-ID: <CAGRGNgWLspr6M1COgX9cuDDgYdiXvQQjWQb7XYLsmFpfMYt0sA@mail.gmail.com>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 21 Jan 2021 03:40:54 -0500
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, snitzer@redhat.com,
	gustavo@embeddedor.com, linux-nvme@lists.infradead.org,
	philipp.reisner@linbit.com, song@kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, adilger.kernel@dilger.ca,
	Christoph Hellwig <hch@lst.de>, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	darrick.wong@oracle.com, osandov@fb.com,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	kent.overstreet@gmail.com, josef@toxicpanda.com,
	Denis Efremov <efremov@linux.com>, colyli@suse.de,
	linux-raid@vger.kernel.org, rpeterso@redhat.com,
	linux-bcache@vger.kernel.org, dsterba@suse.com,
	Al Viro <viro@zeniv.linux.org.uk>, drbd-dev@tron.linbit.com,
	bvanassche@acm.org, agruenba@redhat.com,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	damien.lemoal@wdc.com, tytso@mit.edu,
	"Martin K. Petersen" <martin.petersen@oracle.com>, clm@fb.com,
	LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
	jefflexu@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, lars.ellenberg@linbit.com,
	jth@kernel.org, asml.silence@gmail.com, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH 00/37] block: introduce bio_init_fields()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Chaitanya,

On Tue, Jan 19, 2021 at 5:01 PM Chaitanya Kulkarni
<chaitanya.kulkarni@wdc.com> wrote:
>
> Hi,
>
> This is a *compile only RFC* which adds a generic helper to initialize
> the various fields of the bio that is repeated all the places in
> file-systems, block layer, and drivers.
>
> The new helper allows callers to initialize various members such as
> bdev, sector, private, end io callback, io priority, and write hints.
>
> The objective of this RFC is to only start a discussion, this it not
> completely tested at all.
> Following diff shows code level benefits of this helper :-
>  38 files changed, 124 insertions(+), 236 deletions(-)

On a more abstract note, I don't think this diffstat is actually
illustrating the benefits of this as much as you think it is.

Yeah, we've reduced the code by 112 lines, but that's barely half the
curn here. It looks, from the diffstat, that you've effectively
reduced 2 lines into 1. That isn't much of a saving.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

