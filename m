Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D60C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 08:37:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-bugUiSw8OKm6PjCugtCGFA-1; Thu, 17 Feb 2022 03:37:01 -0500
X-MC-Unique: bugUiSw8OKm6PjCugtCGFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDAC01006AA3;
	Thu, 17 Feb 2022 08:36:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3ED7105C892;
	Thu, 17 Feb 2022 08:36:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A76414BB7C;
	Thu, 17 Feb 2022 08:36:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21H8ahot011175 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 03:36:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B51E4778A; Thu, 17 Feb 2022 08:36:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B08D8776C
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 08:36:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FEC018A01B3
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 08:36:39 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
	[209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-295-aQQlfGRGP1igsyYjf0uRPA-1; Thu, 17 Feb 2022 03:36:37 -0500
X-MC-Unique: aQQlfGRGP1igsyYjf0uRPA-1
Received: by mail-pf1-f173.google.com with SMTP id y11so120274pfa.6;
	Thu, 17 Feb 2022 00:36:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=c0pu3AOa7Jqr4q26ebNJ4LdMU0x/lC3tR2Tx7zL6lHg=;
	b=348y5hSI40P+aHygTKF41x+UhLA+OTNzrn2p2ZsR7vHZ9v2z4hlP+3O82VeqHd6iK1
	mZYBMihGdsg4m0/8gmSVFVUPplLrJaNTEJk0vJeyZax46OQLWOMLAhpG78txh7TPhKuT
	AfQcv/Zcu0pPm6WB2KB0pIwBf5Gzq+oX1wS0c8bSlp3ZcDOd6Y29q6YeN09IMLW/G62J
	LUOCFn4co2xwS0YLhrrnIaqjUBvhdieKqwoN/K2BRSefP+8wBJbJXzld67GAFJhBo1rU
	dwPiZxo2j8EgXeXexP4vsnaJlWlg3l0kg/YeEvr/ua2fPV/zqIuYDY0VkS9XHJ+5r/C8
	0LAA==
X-Gm-Message-State: AOAM5316BNtvVpZXqTnnuXK5BjXsz0YQFnrVn5Lm7QnfahjfLPHSztoP
	BDoEGJOFZO4z0J36ramKAvs=
X-Google-Smtp-Source: ABdhPJxBt7Z+O4vFbpVhfGNT3TGbLxz1vmlCiZLvikj1oSVLWqBDGQ3nJ/8d9qgUnXxcV37sMxYLVg==
X-Received: by 2002:a05:6a00:23cd:b0:4e1:7ab2:334c with SMTP id
	g13-20020a056a0023cd00b004e17ab2334cmr2123595pfc.4.1645086995489;
	Thu, 17 Feb 2022 00:36:35 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
	by smtp.gmail.com with ESMTPSA id
	g1sm44078801pfu.32.2022.02.17.00.36.33
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 17 Feb 2022 00:36:34 -0800 (PST)
Date: Thu, 17 Feb 2022 00:36:31 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20220217083631.34ii6gqdrknrmufv@garbanzo>
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9@epcas5p1.samsung.com>
	<20220214080002.18381-2-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220214080002.18381-2-nj.shetty@samsung.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 01/10] block: make bio_map_kern() non
	static
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 14, 2022 at 01:29:51PM +0530, Nitesh Shetty wrote:
> From: SelvaKumar S <selvakuma.s1@samsung.com>
> 
> Make bio_map_kern() non static
> 
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>

This patch makes no sense on its own. I'd just merge it with
its first user.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

