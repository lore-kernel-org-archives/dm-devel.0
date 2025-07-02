Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81051285079
	for <dm-devel@lists.linux.dev>; Wed,  2 Jul 2025 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751465339; cv=none; b=KKZpjfFqTs8S/LkL2iHVwKU4oWmCL/BSuqDSHdfEC+e0jehDZqF8mI0M+33o91MCIm1NaDGpEZPhXZU55eSouYAzYGASxyRlSzb4kw7miWqMolF87GTUb+HMhHKMhDVBo6h91OdVHGVhUs3FY9cREK8rqr1j0EYOnJEY1a2lVhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751465339; c=relaxed/simple;
	bh=udkqrQvnVo4RtQQvYPowipcr8LIhibLJYAbEXhqyk8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=En2T8VWEU3QwOmnLYF2XmVJDzLETlvi19jqHh1BqesMPv4oL0j/MHbqidgJNimwsrjP29XnJXTuMNI9k+OHEtHySnn4Nss+xlKTvI3HiDS946qnvvCIAFeifSiH3skJv0+hhnrldUt/846bgNOCU8WJmTStjU7HuBW8keUkt+OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fa1AZ7M4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fa1AZ7M4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751465336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NmpFPS9LBgw3dn2ZELfQ3w9zSUQEM1HAAcc1XXF6Vsk=;
	b=fa1AZ7M4/Lo2ERnsBz0zdDX3fqErkRXsXGxDWgWnACT9qeHgLTVKYrtkbU/L47EAcFsdXY
	dJQwhl4JhyJl5GUjRVR0zoVyO3aiDWjw/+vAfbJjgzVcCr6NCr6Hdk8eOQsDndYd0117CR
	eVVTcNzEAaQfkrAi6Csj0nYD0wtUGUw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-269-0pp4VaZ_NCCwBAuKhDJQvw-1; Wed,
 02 Jul 2025 10:08:55 -0400
X-MC-Unique: 0pp4VaZ_NCCwBAuKhDJQvw-1
X-Mimecast-MFC-AGG-ID: 0pp4VaZ_NCCwBAuKhDJQvw_1751465334
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D19718089B8;
	Wed,  2 Jul 2025 14:08:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB1E41956087;
	Wed,  2 Jul 2025 14:08:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 562E8qoW3641587
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 2 Jul 2025 10:08:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 562E8pDg3641586;
	Wed, 2 Jul 2025 10:08:51 -0400
Date: Wed, 2 Jul 2025 10:08:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipathd: cli_reinstate(): avoid reinstated paths
 being failed again
Message-ID: <aGU9c-nUF5PiaZ3k@redhat.com>
References: <20250701220933.156676-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250701220933.156676-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1unmdIPqG2MHxod085sE4gSplj5TuXC_37qucOWpFCU_1751465334
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2025 at 12:09:33AM +0200, Martin Wilck wrote:
> After manually failing some paths and then reinstating them, the
> following pattern of events has been observed:
> 
> [1535664.790944] localhost multipathd[26335]: mpathc: reinstate path 8:48 (operator)
> [1535664.791422] localhost multipathd[26335]: mpathc: devmap event #4
> [1535664.793140] localhost kernel: device-mapper: multipath: 254:6: Reinstating path 8:48.
> [1535665.219024] localhost multipathd[26335]: mpathc: reload [0 125829120 multipath 1 queue_if_no_path 1 alua 2 1 queue-length 0 2 1 8:144 1 8:240 1 queue-length 0 2 1 8:48 1 65:80 1]
> [1535665.290268] localhost multipathd[26335]: sync_map_state: failing sdd state 2 dmstate 2
> [1535665.292442] localhost kernel: device-mapper: multipath: 254:6: Failing path 8:48.
> [1535669.291320] localhost multipathd[26335]: sdd: tur state = up
> [1535669.291531] localhost multipathd[26335]: mpathc: sdd - tur checker reports path is up
> [1535669.291531] localhost multipathd[26335]: 8:48: reinstated
> 
> We see that sdd (8:48) is first reinstated, then failed again during
> the reload operation, and finally reinstated in the checker.
> 
> This happens because multipathd doesn't update the internal path state when it
> calls dm_reinstate_path(). If sync_map_state() is called, it will see the path
> in PATH_DOWN state and fail the path again.
> 
> Fix it by setting pp->state to PATH_UNCHECKED.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

