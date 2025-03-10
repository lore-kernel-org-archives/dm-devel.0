Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E362317A31A
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 16:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741624706; cv=none; b=DlHGafAhDTUbpipwQcFW75R+aaGqU/QrBIYZGKazpSw6rIqUClBjTYrH+HUOUI2OsGdku8ADLDbMznfsfuUr0zO8DO+YMPuiG0AlUDXvXyd2UtNL0lR2BrsBbSyznBp8vTdV0vEcGixBSebwsDJssbkBJfjgSLJ27q0IQvdmM+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741624706; c=relaxed/simple;
	bh=F0TV6Rk6Zcx1GHCBXLKpCdRT4AOxDxa2Bg09sF4XB/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lk/LfDn8ziumoOHrCQ5V2d5cCdmzWtaB+2NZ0rGG64xe2p46irElx+lqAhj7lgc5m+1V8AHmkWCVSle0FvXz2Zt686uunSqxHaz4MjERH3vXAfwl03T+A/dfHvZ4V2q9WWjj8o539rJ2Oqd3RRukLWJjqlbtmdQ/ShL+ajiFJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OPbx6m+p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OPbx6m+p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741624703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x7Ycf+sGGSuWNxpIMqWQVimADkX1n8yhQykV6AE9qE0=;
	b=OPbx6m+pDniKo00+UuMBdQTQsMniRmgUX5WyqJFYActPho9uGwInHVcKmxACdeIu+sX8XE
	81fNhPB0BT99Ls8jhTkRGrOEqQa5XcCi4i4ldWZqNbNsK4eRkA1DSsNq9swXY/AlnDpHXd
	oQd9fjv0FUViPtmnWtiDJfaSyNgPR8E=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-IgnaVD0KMByN3mwO1BGhLg-1; Mon,
 10 Mar 2025 12:38:20 -0400
X-MC-Unique: IgnaVD0KMByN3mwO1BGhLg-1
X-Mimecast-MFC-AGG-ID: IgnaVD0KMByN3mwO1BGhLg_1741624697
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F29211955D81;
	Mon, 10 Mar 2025 16:38:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE8D519560B9;
	Mon, 10 Mar 2025 16:38:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52AGcE4w478701
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 10 Mar 2025 12:38:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52AGcDST478700;
	Mon, 10 Mar 2025 12:38:13 -0400
Date: Mon, 10 Mar 2025 12:38:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/7] dm: fix issues with swapping dm tables
Message-ID: <Z88VdfOmo1MU73ue@redhat.com>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <788a1ec4-ac86-40fb-a709-eba7e6d5535f@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <788a1ec4-ac86-40fb-a709-eba7e6d5535f@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Mar 10, 2025 at 08:16:43AM +0900, Damien Le Moal wrote:
> On 3/10/25 07:28, Benjamin Marzinski wrote:
> > There were multiple places in dm's __bind() function where it could fail
> > and not completely roll back, leaving the device using the the old
> > table, but with device limits and resources from the new table.
> > Additionally, unused mempools for request-based devices were not always
> > freed immediately.
> > 
> > Finally, there were a number of issues with switching zoned tables that
> > emulate zone append (in other words, dm-crypt on top of zoned devices).
> > dm_blk_report_zones() could be called while the device was suspended and
> > modifying zoned resources or could possibly fail to end a srcu read
> > section.  More importantly, blk_revalidate_disk_zones() would never get
> > called when updating a zoned table. This could cause the dm device to
> > see the wrong zone write offsets, not have a large enough zwplugs
> > reserved in its mempool, or read invalid memory when checking the
> > conventional zones bitmap.
> > 
> > This patchset fixes these issues. It does not make it so that
> > device-mapper is able to load any zoned table from any other zoned
> > table. Zoned dm-crypt devices can be safely grown and shrunk, but
> > reloading a zoned dm-crypt device to, for instance, point at a
> > completely different underlying device won't work correctly. IO might
> > fail since the zone write offsets of the dm-crypt device will not be
> > updated for all the existing zones with plugs. If the new device's zone
> > offsets don't match the old device's offsets, IO to the zone will fail.
> > If the ability to switch tables from a zoned dm-crypt device to an
> > abritry other zoned dm-crypt device is important to people, it could be
> > done as long as there are no plugged zones when dm suspends.
> 
> Thanks for fixing this.
> 
> Given that in the general case switching tables will always likely result in
> unaligned write errors, I think we should just report a ENOTSUPP error if the
> user attempts to swap tables.

If we don't think there's any interest in growing or shrinking zoned
dm-crypt devices, that's fine.  I do think we should make an exception
for switching to the dm-error target. We specifically call that out with
DM_TARGET_WILDCARD so that we can always switch to it from any table if
we just want to fail out all the IO.

-Ben
 
> > This patchset also doesn't touch the code for switching from a zoned to
> > a non-zoned device. Switching from a zoned dm-crypt device to a
> > non-zoned device is problematic if there are plugged zones, since the
> > underlying device will not be prepared to handle these plugged writes.
> > Switching to a target that does not pass down IOs, like the dm-error
> > target, is fine. So is switching when there are no plugged zones, except
> > that we do not free the zoned resources in this case, even though we
> > safely could.
> 
> This is another case that does not make much sense in practice. So instead of
> still allowing it knowing that it most likely will not work, we should return
> ENOTSUPP here too I think.
> 
> > If people are interested in removing some of these limitations, I can
> > send patches for them, but I'm not sure how much extra code we want,
> > just to support niche zoned dm-crypt reloads.
> 
> I have never heard any complaints/bug reports from people attempting this. Which
> likely means that no-one is needing/trying to do this. So as mentionned above,
> we should make sure that this feature is not reported as not supported with a
> ENOTSUPP error, and maybe a warning.
> 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

