Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA724C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 04:17:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-JKoXXYUYOsWRJ032KVKn5A-1; Mon, 22 Nov 2021 23:17:35 -0500
X-MC-Unique: JKoXXYUYOsWRJ032KVKn5A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2B121030C21;
	Tue, 23 Nov 2021 04:17:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE71619729;
	Tue, 23 Nov 2021 04:17:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A7AC4A704;
	Tue, 23 Nov 2021 04:17:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN4HToe014251 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 23:17:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E844C4047279; Tue, 23 Nov 2021 04:17:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E46774047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 04:17:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9596801E6E
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 04:17:28 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
	[209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-487-VG3kIvhON8-8qTfIowi0rQ-1; Mon, 22 Nov 2021 23:17:26 -0500
X-MC-Unique: VG3kIvhON8-8qTfIowi0rQ-1
Received: by mail-pf1-f173.google.com with SMTP id x131so18113894pfc.12
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 20:17:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ZQsMyZujMjnowhAwZ2baLD9uO7OCrRs7T2rtVARAjVk=;
	b=s1/66kRvzw1HI7iUWB9fMbPENFac/kOe1cyTqtve4ujCVZXW1RRfpYbquh6HcdcqpC
	v+WKriJjLYBJGBVFWlomO7BiH1S2M7rvHaRwLcPYX+Z392hkj/zOEVVYsdAQ4Z6SujUR
	5c4H5xKEkUDED3gwbsPd6J7B90rIco2Y0R8BxS9XSst4ZtbIdDnm0AI7Or7k3KX1OLFy
	nOSB5okgrZOh+30ru1zX9q/iWlzBG6CdXQeRFGC1sN+e5I6stZKZdoVXy+rQwRr2ZQ/x
	4M+i3SrzBxp9uvwnpgxgFISBeynVCXDXi0OuRajSsEab3FBjbISXA2nfRJGoZIRH2NEv
	Afnw==
X-Gm-Message-State: AOAM530L5RMmtsjt6LnQhkpCgajofu6wF4GeSdp+tR5TeKc+LJN/Phd2
	Vxuu3UHKpAHjEkKWaM/nDXdN5fDDX4Mxp+tMf63mrA==
X-Google-Smtp-Source: ABdhPJyduKiEJGam42hMgnTTV6OAgsDuX6QGWziIbZi1yEyOpgOf+OAOhzM4qFm0U34fEtUNE/R0JNCPUbjj9GmSWQ0=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr1612542pgd.377.1637641045591;
	Mon, 22 Nov 2021 20:17:25 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-13-hch@lst.de>
In-Reply-To: <20211109083309.584081-13-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 20:17:14 -0800
Message-ID: <CAPcyv4g_ZeZCZwfSvoAXL_xnnM2dTSCgN8atodfr8vfJTbYOXA@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 12/29] fsdax: remove a pointless __force cast
	in copy_cow_page_dax
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Despite its name copy_user_page expected kernel addresses, which is what
> we already have.

Yup,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

