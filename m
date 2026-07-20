Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84D1382377
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784561631; cv=none; b=QaKV0KTnG73EQXbDKUldCIMLZlgbvQAhbw4nYqGN26MCKhhng/d0bMJrlVC/HkSJUe7cDVxwa0971JIDDr+SECtOgbQSPDfV82bQbRhixbTJBJKEF0I1j3Pbg2/YnsnLOB5LcnQWLdD8XoepxkxUNFTJYosFkthhoS1uk+iK/T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784561631; c=relaxed/simple;
	bh=gQVR5vM6d7FA92UaCPvN7AP6AUv91k0ChR6nDzZ5DsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rigxUikxBDhd98FIiqY6JIeoHXoWpr7yufAf2YpBiNUVHXMg9BIXZkHei/vQOypBr/HvmYAxA8PZXhe4B1+s81xzvmVZWAkhS2/06/lRe1VZ3mBqkJbHbi26fzujfVbxglFyXwu4XqZUwPiWrDPxXFVwE7r9GiBxFpT0nCWTpmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KOfP1FJ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KOfP1FJ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784561628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVnXFKcckiQMJ5R7ZjdspRn/4XPj8dVOySGqM2dSm2s=;
	b=KOfP1FJ9lq5ou8Vayuqs8jn7rV7EIlGMKqbTDsJznb7ve5/LXemmDJxfKTmMZII+OKYTnq
	3wdItLg2/oKv8iXUDTMWoAUsGG7mWIMCbEzxMIh3sxyDx74sEwv8LILuSqUKgH/U/zWe54
	yqpsqVF3h9EMSyRo6QLSehgcr95VHg8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-rcOcnyc5M_aZNm-1b7R58A-1; Mon,
 20 Jul 2026 11:33:45 -0400
X-MC-Unique: rcOcnyc5M_aZNm-1b7R58A-1
X-Mimecast-MFC-AGG-ID: rcOcnyc5M_aZNm-1b7R58A_1784561624
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94B371944ABE;
	Mon, 20 Jul 2026 15:33:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C51B30001BE;
	Mon, 20 Jul 2026 15:33:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66KFXfFq2453733
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 11:33:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66KFXesA2453732;
	Mon, 20 Jul 2026 11:33:40 -0400
Date: Mon, 20 Jul 2026 11:33:40 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: Obsolete features (was Re: [PATCH 0/4] minio cleanup patches.)
Message-ID: <al4_1Ad2useO9bNR@redhat.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
 <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
 <ajCDBM2lH7NvcuX8@redhat.com>
 <50a665f3-8bcc-42bf-ab33-5cdafa70440b@gmail.com>
 <467670f5-2a5e-4051-9d24-eafa15e2f565@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <467670f5-2a5e-4051-9d24-eafa15e2f565@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PmQ5rQYJzuSYApX5BDJaIvnOtVtZkp_dXMDS6QXNs4Y_1784561624
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Jul 19, 2026 at 04:57:00PM +0200, Xose Vazquez Perez wrote:
> On 6/16/26 9:47 AM, Xose Vazquez Perez wrote:
> 
> > On 6/16/26 12:56 AM, Benjamin Marzinski wrote:
> > 
> > > On Mon, Jun 15, 2026 at 11:00:48PM +0200, Xose Vazquez Perez wrote:
> > > > On 6/15/26 9:07 PM, Benjamin Marzinski wrote:
> > > > 
> > > > > This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
> > > > > multipath config options. It's a companion of the patchset to handle
> > > > > their deprecation in the man pages.
> > > > > https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/
> > > > > 
> > > > > It does not completely remove the minio setting code, since there are
> > > > > ideas for reusing this in the future. The final patch is simply a change
> > > > > to avoid a kernel warning message that I hit while testing these
> > > > > patches.
> > 
> > > > Ben, thanks for this cleanup.
> > > > 
> > > > I ran grep to see what remains of these options in the codebase.
> > > > Could you please check if any of the following occurrences should have been
> > > > removed, or if they are intended to stay for now?
> > > > 
> > > > 8<---
> > > > $ git grep -Ei "rr_weight|minio|min_io" | grep -vE "multipath.conf.5.in|deprecated"
> > > > 
> > > 
> > > Good catch. It appears I misses some things.
> 
> > I ran the following command to locate previous "deprecated keywords":
> > $ for i in $(git grep -h  deprecated libmultipath/dict.c | grep install_keyword | sort | uniq | awk -F\"  '{print $2}') ; do printf "\\n\n--- $i\n\n" ; git grep -i $i | grep -vE "install_keyword| multipath.conf.5.in|\.md|deprecated_handler" ; done
> > 
> > It looks like there is some leftover code that could also be cleaned up, such as:
> > 
> > --- disable_changed_wwids
> > 
> > libmultipath/defaults.h:#define DEFAULT_DISABLE_CHANGED_WWIDS 1
> > 
> > and also some checks in tests/hwtable.c.
> Is this still necessary in "write_defaults : tests/hwtable.c" ?
> 
>                { "bindings_file", NULL },
>                { "config_dir", NULL },
>                { "multipath_dir", NULL },
> 

Yeah. don't think we need to included deprecated config options in our
tests, except possibly in a test to make sure that deprecated values
aren't used.
 
> Another candidate to drop is the retain_attached_hw_handler infrastructure:
>  ( grep -Eir "hwhandler|hw_handler" )
> Since Linux 4.3, the kernel always enforces "retain_attached_hw_handler yes".
> Because this option is completely obsolete, could it be dropped from multipath-tools?

I'm never sure how far back we need to support kernels. I could easily
be convinced that we don't need to worry about kernels before 4.3 with
the latest upstream code. If we still do care about 4.2, I would also be
open to deprecating the option, and just always having it set to yes.

-Ben

> 
> 
> Regards.

