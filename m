Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06494160
	for <dm-devel@lists.linux.dev>; Wed, 27 Mar 2024 00:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498057; cv=none; b=kKs+uNWroOr9ahKOJJgyg/zJI0CoefZUjKhLHiYYaVXg/K3l2k5m6hX2V6lbAFKpAtPYaSkbBe1AhC+K4QPwJiK183afyPNlBNh+qCVlrzfkRceAGg4X9o7Jlf9gKmZdpj9+gGMAbnicOTA0BM2gFhYAuLxQ3JbvHo1+YyY+eaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498057; c=relaxed/simple;
	bh=kajEPUW66t7PIK+gdTGORj7DuoGBJ5sycluuMJWzMnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZqOVti75Iv0zT9ushmOPLOPoebrI7Ql+sKGYhOQUXHqJokdzrV7fJdchBaUOmIhqFHwj13c7k3sfLHZZXI2q188/H2X9lVAiE1i/UktRDB5zPpJsXvSfjaoKLKNm3J7QobyqSFjjb6HDHHjhUdtlxQEUVTzIHPfOQD4mWOI4rGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W1nCqmNE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W1nCqmNE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711498055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mOhycHOxXlUADSoC4Iz2uIi/usUXEtrCOlurYpc71bY=;
	b=W1nCqmNEzQ5JsXdDJUaLKm3Ilmb5Oa8BKgmOfpMsn8b34Z/KEZYu7m5RLzPC5nAX8tOpQj
	BthR8fTK6+HNwHGAXQG3S0Hfr/Ko/p/KnnBfgiHpSMCjwh5ATXWAYNBswxRjbJFtg+tceA
	iQQx4wkVpQP35CeWuhnCJOjuK1gFChs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-_fd0oZJ7NV6TjK36q82WZw-1; Tue, 26 Mar 2024 20:07:30 -0400
X-MC-Unique: _fd0oZJ7NV6TjK36q82WZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FC4F8007A1;
	Wed, 27 Mar 2024 00:07:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4937E2166B31;
	Wed, 27 Mar 2024 00:07:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42R07Usr1408221
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 20:07:30 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42R07UFE1408220;
	Tue, 26 Mar 2024 20:07:30 -0400
Date: Tue, 26 Mar 2024 20:07:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 11/11] kpartx.rules: ignore DM_SUSPENDED
Message-ID: <ZgNjQvNXikt-cW5h@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-12-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-12-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:13:01PM +0100, Martin Wilck wrote:
> DM_SUSPENDED=1 implies DM_UDEV_DISABLE_OTHER_RULES_FLAG=1, no
> need to check it again. The DM_NOSCAN check needs to remain in
> order to keep compatibility with dm rules v2.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/kpartx.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> index 1969dee..8dd3369 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules
> @@ -27,7 +27,7 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="mpath_kpartx_end"
>  ENV{MPATH_UNCHANGED}=="1", GOTO="mpath_kpartx_end"
>  
>  # Don't run kpartx now if we know it will fail or hang.
> -ENV{DM_SUSPENDED}=="1", GOTO="mpath_kpartx_end"
> +# This is required for device mapper rules v2 compatibility.
>  ENV{DM_NOSCAN}=="1", GOTO="mpath_kpartx_end"
>  
>  # Run kpartx
> -- 
> 2.43.2

