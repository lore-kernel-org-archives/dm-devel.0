Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD82D433CD
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 22:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711493912; cv=none; b=KYQX4v0WAvYZtZkW/DUZyxXDTjyCaoKbSQ/ueOWZcG58KFHkqiqcoQPhBvd8CYxyffe2fBZG0FpIhHWUxGW3kSMmPWrE1CaVKfKdnq2t5UARKs3BQawle70LBQaUMNGYB7j581TPmS2HjZ9kE6I5IWdIhaZyZxqt0DvdfvpwNVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711493912; c=relaxed/simple;
	bh=QckrZICiM8k5Aq7c7ZU9rdOoLZu8zz6/3giQRLDUhLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fJR2hZBTN7YMnO6rTmtveBfyZtoLkF3VR2owomuJzyhizbtaGUnRIkNKga6lZZ1CkL2AhxBB4DBUzE/00tknMjs13zcTR4tjjm1xtY4dtgKIIJie/hPvLBigQAm7CrduHTXrv+PYcsOJKocMppvKhdPDX+XWrl7na3bah5XN2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NW/i1zS1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NW/i1zS1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711493909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aVNddCdA/3wJJAjuY1JRe2y1zhFCrFeEAUfJ/hDrN/c=;
	b=NW/i1zS19Rh3HccmycD8CTX/JmmPZZC8/Ubf2dO0TxBq4eQSywp1dDG5qGZukXsYDNXV+R
	+Qv+ADV/2PqY51qLbQ2lvdq1MdhmLqIsPS6zdVWt3spOHHhBoBPTx6r1BwN8jQwWRl2fBs
	i7T7vWgH2IfmGNRxrkRZoAuvEUIhjDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-ETaXj_diN_ed_IcFMAcwPw-1; Tue, 26 Mar 2024 18:58:24 -0400
X-MC-Unique: ETaXj_diN_ed_IcFMAcwPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF44785A58C;
	Tue, 26 Mar 2024 22:58:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D943B107A8;
	Tue, 26 Mar 2024 22:58:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QMwNTd1407610
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 18:58:23 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QMwNb61407609;
	Tue, 26 Mar 2024 18:58:23 -0400
Date: Tue, 26 Mar 2024 18:58:23 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 06/11] 11-dm-mpath.rules: don't import properties with
 new 13-dm-disk.rules
Message-ID: <ZgNTD3rBRD-yxfc_@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:56PM +0100, Martin Wilck wrote:
> With the late changes to 13-dm-disk.rules, we don't need to import any
> blkid-generated properties from the udev database, because they will
> be imported later.
> 
> Except for ID_FS_TYPE, this actually holds since lvm2 commit 94f77a4 ("udev:
> import previous results of blkid when in suspended state"), included in lvm2
> 2.03.19, but we have no simple way to detect the version of the lvm2 rules.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index cf004fd..8f22954 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -124,6 +124,10 @@ LABEL="scan_import"
>  # have never been properly set. Don't import them.
>  ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
>  
> +# DM rules v3 will import missing properties on 13-dm-disk.rules.
> +# No need to do it here.
> +ENV{DM_UDEV_RULES_VSN}=="3", GOTO="import_end"

Again, I'd rather
ENV{DM_UDEV_RULES_VSN}!="1|2"

> +
>  # Don't import the properties from db if we will run blkid later.
>  ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
>  
> -- 
> 2.43.2

