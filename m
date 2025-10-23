Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D4534A3B7
	for <dm-devel@lists.linux.dev>; Thu, 23 Oct 2025 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241208; cv=none; b=JK4pQkSEZSAWa5cmbjnC4uOgR6DlteGOB1sBBjtR/8sxB2UXZmGQ8hjNZ44ZvWjtqA1MKsHrRvlLrVATFZQYtmpuZIJkjhpsFDwTvi5otULie5+zPBMduk6QQ3/G6PrUwnnZXSkGDAk+iPvC6MfkpbYnxztqpFZEd3EdN6y9+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241208; c=relaxed/simple;
	bh=O+RQ7OWqVbOzU7hG46qOvfG1DM4oGXlG2wy5N59BguM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtwHd6zpsXuO6dW6Z1TSQwJfRqLJW6+KbOSFbVn79zeLPaycXnFFQC1VWORhvOlG8MerKDEkm58nbqb2AxedOFyCDo54DaYIBZKBLZh9s8KH+C8z2yhO98YafWpPg1AYS8RkbhwWBO0lvxAtrPvetWADUeFRB74nmCP8JYcuBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqR2AeYb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqR2AeYb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761241205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmRKsT5NLdIEoEk3J/KbOH4zUzuQlGDoHcEV8wY5He4=;
	b=eqR2AeYbpVfu1EBRzgQLTownowYJoYOZubeUxTYFObHkc6L6SvVhjcvJuzMQgFl1NkhR4B
	JM6W/YJR8+dOghhKKt0X2n4YHa47Ab0yQCl6+g+Ue5KQm6zpDWkezKeGKR7xSUxO2zbptZ
	2WmQbtjPv36fDG0Av2rMQsiI+gJJ3cU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-134-L3JIB9OENSad5Od3p9Xv2Q-1; Thu,
 23 Oct 2025 13:39:59 -0400
X-MC-Unique: L3JIB9OENSad5Od3p9Xv2Q-1
X-Mimecast-MFC-AGG-ID: L3JIB9OENSad5Od3p9Xv2Q_1761241198
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 664F8180035D;
	Thu, 23 Oct 2025 17:39:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9FF819560B8;
	Thu, 23 Oct 2025 17:39:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 59NHduhQ3546010
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 23 Oct 2025 13:39:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 59NHdud53546009;
	Thu, 23 Oct 2025 13:39:56 -0400
Date: Thu, 23 Oct 2025 13:39:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
Message-ID: <aPpobIv6j2qEmt4u@redhat.com>
References: <20251009030431.2895495-1-bmarzins@redhat.com>
 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
 <aOg2Yul2Di4Ymom-@redhat.com>
 <e407b683dceb9516b54cede5624baa399f8fa638.camel@suse.com>
 <aPfcAfn6gsgNLwC7@redhat.com>
 <a186416aa03bb995b2f04fdb47315c1d12a87cab.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a186416aa03bb995b2f04fdb47315c1d12a87cab.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Oct 22, 2025 at 04:11:58PM +0200, Martin Wilck wrote:
> On Tue, 2025-10-21 at 15:16 -0400, Benjamin Marzinski wrote:
> > On Fri, Oct 10, 2025 at 12:19:51PM +0200, Martin Wilck wrote:
> > > On Thu, 2025-10-09 at 18:25 -0400, Benjamin Marzinski wrote:
> > > 
> > > 
> > > > I did check to see if holding it for the entire suspend would
> > > > cause
> > > > issues, but I didn't see any case where it would. If I missed a 
> > > > case where __noflush_suspending() should only return true if we
> > > > are
> > > > actually in the process of suspending, I can easily update that
> > > > function to do that.
> > > 
> > > If this is necessary, I agree that the flag an related function
> > > should
> > > be renamed. But there are already generic DM flags to indicate that
> > > a
> > > queue is suspend*ed*. Perhaps, instead of changing the semantics of
> > > DMF_NOFLUSH_SUSPENDING, it would make more sense to test 
> > > 
> > >   (__noflush_suspending || test_bit(DMF_BLOCK_IO_FOR_SUSPEND)
> > > 
> > > in dm_swap_table()?
> > 
> > Won't we ALWAYS be suspended when we are in dm_swap_table()? We do
> > need
> > to refresh the limits in some cases (the cases where multipath-tools
> > currently reloads the table without setting noflush). What we need to
> > know is "is this table swap happening in a noflush suspend, where
> > userspace understands that it can't modify the device table in a way
> > that would change the limits". For multipath, this is almost always
> > the
> > case. 
> 
> Ok, getting it now. The semantics of the flag are changed from "device
> is noflush-suspending" to "device is either noflush-suspending or
> noflush-suspended". It isn't easy to express this in a simple flag
> name. I'm fine with not renaming the flag, if a comment is added that
> explains the semantics clearly.
> 
> > > 
> > > I find Bart's approach very attractive; freezing might not be
> > > necessary
> > > at all in that case. We'dd just need to avoid a race where paths
> > > get
> > > reinstated while the operation that would normally have required a
> > > freeze is ongoing.
> > 
> > I agree. Even just the timing out of freezes, his
> > "[PATCH 2/3] block: Restrict the duration of sysfs attribute changes"
> > would be enough to keep this from deadlocking the system.
> > 
> 
> OK, let's see how it goes. Given your explanations, I'm ok with your
> patch, too.

I see Mikulas pulled this commit into linux-dm. Bart, does this solve
your issue? Looking at your hang, it should. Also, do you have any
interest in attempting again to get your fixes upstream?

-Ben

> 
> Martin

