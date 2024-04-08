Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61223F51B
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712601275; cv=none; b=CFIfv3aDiqjKe8haIFEitSYozdezPvJlmc4VeXISJ+m27XutO4gTDz/WEIUU0qTEjKbfKI3tWgJN1G5KG0NSeL8tj2N5FUPJptn/C0mthYFsrJYl6BBTzVpE1t8lovYZoTz3NQN7WSCLAIfIy3V28dNIrtAn2GM8rLCRl7M/VzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712601275; c=relaxed/simple;
	bh=OgFM1JsFP6GfH0ITmCv17PfjYf2pRA+Vakmnpr+7uhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=SR628tRslBbMe7liGyv3yTVuAWLI0UY7rdqN05Ia2/3CWHtGrVvJYLgoUHRHgeNFMlYh38RZZusa7KIH2R/8F2CbhUwpeCDhEB3I0Y4Hbgvmyt8EvDMwUa7lfNbEsFEcy4Hw5NbYpZbXX/F6VDcTx2cAHzV67md1sKexT/llWhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZKYO/Za; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZKYO/Za"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712601272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ysQG7whJGbC7ZKpLKwfj2Vv758B0qVDAdpJ9PVhOqlg=;
	b=UZKYO/ZaoNzn2I0oRI5mVytjwKm5R9Ytd1vxxjmqw2p/9lkWEQyZFYm0RZTcJKacRzDlQf
	fkw6QgdGsCmiryUTaFnXU35WaDwCY/rixn1ipqTCoX5elMOzc527VXhIJd1LRGfCzw2Nfb
	93Fzi0OUuS6b5xAlWL6RUUUjrxu9h5k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-23AMElL0OUmEE0aO5RfqSQ-1; Mon, 08 Apr 2024 14:34:27 -0400
X-MC-Unique: 23AMElL0OUmEE0aO5RfqSQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C68258877C1;
	Mon,  8 Apr 2024 18:34:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF4C62DD51;
	Mon,  8 Apr 2024 18:34:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 438IYQwa1818566
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Apr 2024 14:34:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 438IYQ1V1818565;
	Mon, 8 Apr 2024 14:34:26 -0400
Date: Mon, 8 Apr 2024 14:34:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 06/11] 11-dm-mpath.rules: don't import properties with
 new 13-dm-disk.rules
Message-ID: <ZhQ4svAaQzPOoAV9@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
 <20240404173814.3143-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240404173814.3143-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 07:38:09PM +0200, Martin Wilck wrote:
> With the late changes to 13-dm-disk.rules, we don't need to import any
> blkid-generated properties from the udev database, because they will
> be imported later.
> 
> Except for ID_FS_TYPE, this actually holds since lvm2 commit 94f77a4 ("udev:
> import previous results of blkid when in suspended state"), included in lvm2
> 2.03.19, but we have no simple way to detect the version of the lvm2 rules.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 5f547ca..95126bf 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -126,6 +126,10 @@ LABEL="scan_import"
>  # have never been properly set. Don't import them.
>  ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
>  
> +# DM rules v3 will import missing properties on 13-dm-disk.rules.
> +# No need to do it here.
> +ENV{DM_UDEV_RULES_VSN}!="1|2", GOTO="import_end"
> +
>  # Don't import the properties from db if we will run blkid later.
>  ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
>  
> -- 
> 2.44.0

