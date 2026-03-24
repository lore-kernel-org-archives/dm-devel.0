Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579A023D7E6
	for <dm-devel@lists.linux.dev>; Tue, 24 Mar 2026 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774367332; cv=none; b=kAmv57AUmU2J9PKzoN+2QCSFG/p6kzAE+0QkU5T8VqkdlnF5FX1Jnf68s1SERBtb7hz/q0tNgFxTgFoZ5XXxCk8Yh9JioTTODAPPBhPivHn8pmI0snY76+haW3RkcOQ60bZ7uYZyVwTJGTKQZGUW0jvKhG6dCxs7ySGxLPzqCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774367332; c=relaxed/simple;
	bh=nPKJzSlPKmzZDrLZ6540Z4pthdImph+ML90NBW1cebY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iF7ZsSsDr5IwJYV10CgqVmm2eAi7SXTHulp+cYRp/O9uzKwomERG7ipUPitDDNGrx3OOo6ZPZgrkfrZdyQXbxptpWPt0f/o94wx4rFxYsP9m/Ax77HIMnQSokwxZBH+wwn1JzuUHW7BYnir+oH4z9C3yF5C6whq3uctPpoBEPPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FFuvtSEF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FFuvtSEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774367329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6sYTQsR4r0P90gD1IPGxk5ceU2E1+b/EiFHPyg0IyOI=;
	b=FFuvtSEFWn5jv3SGCnZmgzbqW3lkh224ptM6PUz9uLESMkuEMC9OBhdEFRRQ1r5qDypzxV
	vcPYXJBMp0jkbvMwifn4OvoSs7RfgaA8Drwtic7ZD6x9FOPsI9Z6YNEsRSSSrBf95AG4R+
	9DQCxrQNCgjOHdQLnhfwjk4gRmV+10o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-cztVxnP1Oe6ut57dclxDRA-1; Tue,
 24 Mar 2026 11:48:47 -0400
X-MC-Unique: cztVxnP1Oe6ut57dclxDRA-1
X-Mimecast-MFC-AGG-ID: cztVxnP1Oe6ut57dclxDRA_1774367326
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43B8B19560B1;
	Tue, 24 Mar 2026 15:48:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 906FC19540C4;
	Tue, 24 Mar 2026 15:48:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62OFmimg1062653
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 11:48:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62OFmhsp1062652;
	Tue, 24 Mar 2026 11:48:43 -0400
Date: Tue, 24 Mar 2026 11:48:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
Message-ID: <acKyW6IPMhhZ_eF8@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: vq90KMGGdn5HT6eOigNpyK7Zb620sbCLIqy0eGafgkE_1774367326
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2026 at 03:12:38PM +0000, John Garry wrote:
> On 24/03/2026 13:58, Benjamin Marzinski wrote:
> > > > If it allowed device handlers to get attached, these two
> > > > developement efforts (native scsi multipath and refactoring the alua
> > > > support) could go on in parallel.
> > > > 
> > > > Or am I missing something here?
> > > It just seems to be about this DH stuff is that there is bad history there
> > > and no more users are wanted.
> > Just to be clear, if the idea was that the Native Multipath code
> > shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
> > I don't see why it can't make use of the results of the existing
> > implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
> > to do that.
> 
> We would need something like the following to ensure that DH ALUA is present
> to update sdev access_state:
> 
> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>         bool "SCSI multipath support"
>         depends on SCSI_MOD
>         select LIBMULTIPATH
> +       select SCSI_DH_ALUA
>         help
>           This option enables support for native SCSI multipath support for
>           SCSI host.

DM_MULTIPATH doesn't force the device handlers to be built. You just
don't have their support if they aren't there. Granted, it does make
sure that if they are built, you can't build dm-multipath directly into
the kernel, if the device handlers are built as modules.

> 
> And that is even enough, as Kconfigs should only specify build requirements.
> 
> We really should be also calling something like scsi_dh_attach() for scsi
> multipath to ensure that DH is attached (and running to update
> sdev->access_state).

That isn't necessary. If there is an alua device handler, kernel will
auto-attach it to any device that supports alua (see scsi_dh_add_device
and scsi_dh_find_driver). DM-multipath's calling of scsi_dh_attach() is
mostly a historical relic.

> And I am not sure how the dh alua module is even autoloaded. I think that on
> my ubuntu machine the multipath-tools.service does it - something like this
> would not be nice for native SCSI multipath support.

Fair point. Depending on how the kernel is built, there could be system
configuration work that needs to happen if implicit alua support
wasn't in the generic scsi code. But as far as the kernel code goes, I
still see them as parallel efforts. 

-Ben

>  That shouldn't interfere with any refactoring that people
> > want to do of how the scsi layer actually handles ALUA support. Again,
> > this is more for Hannes than you, John.
> 
> Thanks,
> John

