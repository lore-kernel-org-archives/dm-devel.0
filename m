Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1252C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:36:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-QqqfNfQzN2Oyw4ItNBOnFA-1; Fri, 04 Feb 2022 00:36:30 -0500
X-MC-Unique: QqqfNfQzN2Oyw4ItNBOnFA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C50091F6B3;
	Fri,  4 Feb 2022 05:36:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90EB05F909;
	Fri,  4 Feb 2022 05:36:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 513861806D1C;
	Fri,  4 Feb 2022 05:36:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2145YhWW024700 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 00:34:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5B0C279D2; Fri,  4 Feb 2022 05:34:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57158776C
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:34:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 499642B16869
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 05:34:40 +0000 (UTC)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
	[209.85.210.178]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-186-cSAQnk4wPfWS4Q9EqlAr9A-1; Fri, 04 Feb 2022 00:34:38 -0500
X-MC-Unique: cSAQnk4wPfWS4Q9EqlAr9A-1
Received: by mail-pf1-f178.google.com with SMTP id v74so4198065pfc.1
	for <dm-devel@redhat.com>; Thu, 03 Feb 2022 21:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=3aYp4Y6S+6Gb2kVa9/dfBS0YmJLNZ9g5MDY83trp3jE=;
	b=JXWNoHkMSLAqxUfbrjvT8cezKg+hkskAI4AfOFDxJAupUGtZim3Mpjm55Jn8jTxBMk
	EceXYkoHlnaEwzjqqelfBfy3bJRASLqOA4xbLsBNyg5s7qEpEvkjvOt99YbGiPzHH04r
	b+xcKWrx2Dfo+IRkqtcBQgkkXxAJrx8H2y2+PTiNs9J01j4dUubwue5C0Bw72QkMTEqZ
	IeLDLfp7afhrle6WVNshfWR2qfMlq3BM5Egl/21Fd8hOm5HAHk5cjltPMsipxnd5+7La
	NCoejN8NN233QiGXuWhVfnQ5RS2vAL97Od5jn8cqJgyD6FL7ZdePAP+2N8dkWGHpn6Ei
	AXJA==
X-Gm-Message-State: AOAM530VuWG3mR5lz8FIRQ2Wd2NXotyt+/3MAjO5L44isN/I1z/sKGEO
	2ojyVq09Hax8cQ1JWr3Gp4BiiLUglU5pKOD782Xnbw==
X-Google-Smtp-Source: ABdhPJxkwin78+MQJeCI7c5YXNEsK0mcEauKNshyhXHK8pXn7gbTrlWDvF68YcAOEJJFUIqSHpEVknWFvdBz/Brte1A=
X-Received: by 2002:a05:6a00:1312:: with SMTP id
	j18mr1391861pfu.61.1643952877343; 
	Thu, 03 Feb 2022 21:34:37 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-4-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-4-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 21:34:25 -0800
Message-ID: <CAPcyv4jw+meUy-DrLgqn_4kPCF2WAZrMJ8Nan4xCncr7-4Y0hw@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 3/7] dm: make dm aware of target's
	DAXDEV_RECOVERY capability
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> If one of the MD raid participating target dax device supports
> DAXDEV_RECOVERY, then it'll be declared on the whole that the
> MD device is capable of DAXDEV_RECOVERY.
> And only when the recovery process reaches to the target driver,
> it becomes deterministic whether a certain dax address range
> maybe recovered, or not.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index e43096cfe9e2..8af8a81b6172 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -844,6 +844,36 @@ static bool dm_table_supports_dax(struct dm_table *t,
>         return true;
>  }
>
> +/* Check whether device is capable of dax poison recovery */
> +static int device_poison_recovery_capable(struct dm_target *ti,
> +       struct dm_dev *dev, sector_t start, sector_t len, void *data)
> +{
> +       if (!dev->dax_dev)
> +               return false;
> +       return dax_recovery_capable(dev->dax_dev);

Hmm it's not clear to me that dax_recovery_capable is necessary. If a
dax_dev does not support recovery it can simply fail the
dax_direct_access() call with the DAX_RECOVERY flag set.

So all DM needs to worry about is passing the new @flags parameter
through the stack.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

