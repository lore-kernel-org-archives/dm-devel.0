Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235BA18C2E
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 19:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjb8kdNd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698435277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rBwz5ZOA4l4RmaCzipLxnp+jb6Dg9ZkVhmpUrZXEM9I=;
	b=gjb8kdNdCPJWTOwbix8OSSNs650p8QIOjTw5BuHIprTRhr2aFknlH1VsVLo5CLXveudC/n
	dDRoiN0ZIu+Me2FDg4pFU5uzK7Uq0sq9kX52p0K2mnmSNl76npx6aREZkGlszRLgM2K+bp
	4JTnBix+TQTmsp7zndwzrsCMl004oSU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-OrnaJfcHOjSZeOrDIX8b2w-1; Fri,
 27 Oct 2023 15:34:34 -0400
X-MC-Unique: OrnaJfcHOjSZeOrDIX8b2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72B753C0E647;
	Fri, 27 Oct 2023 19:34:34 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BF6640C6F7B;
	Fri, 27 Oct 2023 19:34:34 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RJYYeg049777
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 15:34:34 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RJYYeZ049776;
	Fri, 27 Oct 2023 15:34:34 -0400
Date: Fri, 27 Oct 2023 15:34:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2 13/14] README.md: Extend the section about NVMe
Message-ID: <ZTwQyicsA2swvpbv@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-14-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-14-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:52PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  README.md | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/README.md b/README.md
> index b2ed1f2..2fb423b 100644
> --- a/README.md
> +++ b/README.md
> @@ -273,15 +273,25 @@ To enable ALUA, the following options should be changed:
>  
>  NVMe
>  ====
> -To use Device Mapper/multipath-tools with NVMe devices,
> -if the Native NVMe Multipath subsystem is enabled
> -( "Y" in `/sys/module/nvme_core/parameters/multipath` ),
> -it has to be disabled:
>  
> -`echo "options nvme_core multipath=N" > /etc/modprobe.d/01-nvme_core-mp.conf`,
> -regenerate the initramfs (`dracut -f` or `update-initramfs`) and reboot.
> +Using dm-multipath with NVMe
> +----------------------------
>  
> -Check that it is disabled(N) with:
> -`cat /sys/module/nvme_core/parameters/multipath`
> -or
> -`systool -m nvme_core -A multipath`
> +NVMe multipath is natively supported by the Linux kernel. If for some reason
> +you prefer using device mapper multipath with NVMe devices,
> +you need to disable native multipathing first:
> +
> +    echo "options nvme_core multipath=N" > /etc/modprobe.d/01-nvme_core-mp.conf
> +
> +Afterwards, regenerate the initramfs (`dracut -f` or `update-initramfs`) and reboot.
> +
> +Using multipath-tools with native NVMe multipath
> +------------------------------------------------
> +
> +If native NVMe multipathing is enabled, you can still use multipath-tools
> +for displaying the topology and some other information about native NVMe
> +multipath setups. This feature is disabled by default. To enable it, set
> +`enable_foreign nvme` in the `defaults` section of `multipath.conf`.
> +Commands like `multipath -ll` will then display information about NVMe
> +native multipath. This support is read-only; modifying the native multipath
> +configuration is not supported.
> -- 
> 2.42.0

