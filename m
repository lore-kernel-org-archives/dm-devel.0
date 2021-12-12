Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E696DC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 12 Dec 2021 14:24:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-89ZiiKD_MsWnCF7dxzv79Q-1; Sun, 12 Dec 2021 09:24:04 -0500
X-MC-Unique: 89ZiiKD_MsWnCF7dxzv79Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 979DC1006AA6;
	Sun, 12 Dec 2021 14:23:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 753C945D71;
	Sun, 12 Dec 2021 14:23:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 682204BB7C;
	Sun, 12 Dec 2021 14:23:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BCENt64029714 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Dec 2021 09:23:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 098C740CFD11; Sun, 12 Dec 2021 14:23:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04C7640CFD0F
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:23:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E02BE1C04B6B
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:23:54 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
	[209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-579-W08jmNlYOoWzrCeQC33f6w-1; Sun, 12 Dec 2021 09:23:53 -0500
X-MC-Unique: W08jmNlYOoWzrCeQC33f6w-1
Received: by mail-pj1-f51.google.com with SMTP id v23so10087183pjr.5
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 06:23:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=8lwwZWzMg5a3s7lwMASlg5tu9b+fzGmp/D7TMwKxKFc=;
	b=wqsQGCRMwXYXuF8Qm2mseI6yeOrc4MfA8QTjIYVAmW29AEgmLT610bs2aLLDN5mNlC
	jgWawTdkn4xyseFTuCkt3y2pRywI4toWxY9dgYuMQG8H1YgUKW8YOpswTgXmjdKyhziK
	nMhra0gSOGz470vohm8QFYCfkipEWSmDFxkbb/ITe28YBidhUb8YT03n+LMxQ+L7ld/f
	ncQcEIobqYVUq+U+AMmZrWQb2gXIGWhKmfM9EtQaEBV/9t06UBg/mw/YUAH7jDyh48n2
	r3QQMWrjnss/jEfX0i92FKuyFs0hCbMGJx172VdHEE7lCpjnGChoPnuyuDh0Urcxy6sM
	zVRg==
X-Gm-Message-State: AOAM53028irUXVWYV+Zbr2eoB2GVzXvtqdB6kK4ZMbtZrpKazr1zYGWV
	3zKqImioVkj3dU+t0LNV9dcFI1Kf8FqcGIvyNeyO4A==
X-Google-Smtp-Source: ABdhPJwD+M0MBopqkFuJGa9sgfSVBzZnNozNDZqwXOq1RFaO0zbunOMva9BpA++y2ooxKRxQrM2G01fpVQgDA3WnFR8=
X-Received: by 2002:a17:90b:1e49:: with SMTP id
	pi9mr38028565pjb.220.1639319032132; 
	Sun, 12 Dec 2021 06:23:52 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-3-hch@lst.de>
In-Reply-To: <20211209063828.18944-3-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:23:41 -0800
Message-ID: <CAPcyv4gZvE69C8wCukFGgFLqzD49U8Wn8X4F9N6RmMFebgyqzg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/5] dax: simplify dax_synchronous and
	set_dax_synchronous
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove the pointless wrappers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, not sure why those ever existed.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  drivers/dax/super.c |  8 ++++----
>  include/linux/dax.h | 12 ++----------
>  2 files changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e7152a6c4cc40..e18155f43a635 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -208,17 +208,17 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
>
> -bool __dax_synchronous(struct dax_device *dax_dev)
> +bool dax_synchronous(struct dax_device *dax_dev)
>  {
>         return test_bit(DAXDEV_SYNC, &dax_dev->flags);
>  }
> -EXPORT_SYMBOL_GPL(__dax_synchronous);
> +EXPORT_SYMBOL_GPL(dax_synchronous);
>
> -void __set_dax_synchronous(struct dax_device *dax_dev)
> +void set_dax_synchronous(struct dax_device *dax_dev)
>  {
>         set_bit(DAXDEV_SYNC, &dax_dev->flags);
>  }
> -EXPORT_SYMBOL_GPL(__set_dax_synchronous);
> +EXPORT_SYMBOL_GPL(set_dax_synchronous);
>
>  bool dax_alive(struct dax_device *dax_dev)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 87ae4c9b1d65b..3bd1fdb5d5f4b 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -48,16 +48,8 @@ void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
> -bool __dax_synchronous(struct dax_device *dax_dev);
> -static inline bool dax_synchronous(struct dax_device *dax_dev)
> -{
> -       return  __dax_synchronous(dax_dev);
> -}
> -void __set_dax_synchronous(struct dax_device *dax_dev);
> -static inline void set_dax_synchronous(struct dax_device *dax_dev)
> -{
> -       __set_dax_synchronous(dax_dev);
> -}
> +bool dax_synchronous(struct dax_device *dax_dev);
> +void set_dax_synchronous(struct dax_device *dax_dev);
>  /*
>   * Check if given mapping is supported by the file / underlying device.
>   */
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

