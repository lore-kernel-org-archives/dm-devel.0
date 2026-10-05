Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040554C6536
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791221643; cv=none; b=oRaspGme2vdqALsGLRp1TT/wd+phfwVi+Vq2PYD06OvowtssN+eW0Gd+nVtLbnzaLNJBBfTuvskKS0FyuyPunuD7JCQHrwgimML3ONnlbUFP5jd9iNzvpMKAsBH5mev7qmJewMeFHHGSR+t0VHrg167BpVA9kFhEtkGO9bWP184=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791221643; c=relaxed/simple;
	bh=iNHEq8X1XvLMbxw3swIJYkfspx7SrCSJ2fTG99jq+t8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MmRVgldR4L+kaoSeiDBIuwcsWmn4r7PBxJsD/sWXdvlFXtzUhGn/nTYZCzeXUt+ZJ+RvmrdIE5mPkL3UtXX4Dqof5B4WdqoXpBZj8dDdR6dqbUkDFcn1NfoBt8YFwFHVI1GUfYlA6NTI26IX/HhJ+RDKCacvLjRnEl5/Y/SDUxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fRWTKiVv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fRWTKiVv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791221640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GhSEKXbekKLqqejKZ0krdUPLaYPTmf4IDN0lJa7G9o4=;
	b=fRWTKiVvjeQFCTgjrRbbuyaF80kbce5tXB+UR+BKqKm/VOG0hjr5e+Oh5dbbQWYYdHddIY
	2+151SjV0x5o0XaUhP6zs+S2skEmCNychAeD+sGfMlHGGhyx7v01a5jPgQfp+q5gEvad8B
	RIo1idsXF/nX/T6dlFXxqT9TSeCcc64=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-xlh36Fp1OM65tnHC33wzhg-1; Mon,
 05 Oct 2026 13:33:57 -0400
X-MC-Unique: xlh36Fp1OM65tnHC33wzhg-1
X-Mimecast-MFC-AGG-ID: xlh36Fp1OM65tnHC33wzhg_1791221635
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80180180075E;
	Mon,  5 Oct 2026 17:33:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2A61426;
	Mon,  5 Oct 2026 17:33:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 695HXrjV2151257
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 13:33:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 695HXrv82151256;
	Mon, 5 Oct 2026 13:33:53 -0400
Date: Mon, 5 Oct 2026 13:33:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Suresh Thelkar <suresh.thelkar@yahoo.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: dm_flush_map__: do not treat query
 error as external removal
Message-ID: <asPfgTUiqKK0IFiI@redhat.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
 <20261005045726.71858-2-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20261005045726.71858-2-suresh.thelkar@yahoo.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9sqSMaxCy0nFts_h9LkbF8yY__UsQz7PFdXjW-0siq8_1791221635
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 05, 2026 at 04:57:25AM +0000, Suresh Thelkar wrote:
> On a failed DM_DEVICE_REMOVE, dm_flush_map__() classified anything that
> was not DM_IS_MPATH_YES as "removed externally" and returned DM_FLUSH_OK
> without resuming the map it had just suspended. dm_is_mpath() also
> returns DM_IS_MPATH_ERR (-1) when the status query itself fails, which
> happens transiently under a heavy ioctl load (e.g. LUN-number recycling
> plus ALUA transitions). A transient error was thus misread as a
> successful external removal, and the map was left suspended
> indefinitely, wedging later I/O node-wide via sync().
> 
> Only DM_IS_MPATH_NO now counts as "removed externally". A query error is
> logged and falls through to the resume path instead of being reported as
> success.
> 
> Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

