Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8AC19AD6B
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721142982; cv=none; b=QWKLRzlHnlPeANeA+jpwyisnQ8x0owp4m8Pw1SsqC87nrTWXyauyRSIJa8+94XTgxO+ZIf0rMkpWw4C7MdVVCzBYWhXT+NvuFlpaQ7FE6gZ8eBv4K2dTw65Uouej5MWexGa0q+yF0QUFL3j9jeaZ0sZopWMdgdqT09XRPHb5r8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721142982; c=relaxed/simple;
	bh=nereEYH8bcYAIil6EwWPqPsBAPfuXXeq7+Co0EkVSNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=jSSAJXb844cdhD9nu9XpDC8DwyxJBn6cGHmbEYD1sagOYWON+TORsQ4yO7LEaX4MGqbxcKesINumA2Ay9N2mHKKWYU2QZZ66Ok9VqX2o3pjbE3izeZAEOutLACqwavrci5KPu6adMnebB5ajMwU1CrxKtjo8wR+0NzxHzNcWMhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EoPyJPxC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EoPyJPxC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721142979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3/2PJQ39r6LiOQqPg/Xq8UvwF4Ua+O+MNW7+SlZ0rU=;
	b=EoPyJPxCCni/9OXKbRZTKWE3U6AMZVLaBQnrBYtnnXsSPNcrIVaKzi0oHbykhiwXfKY2R+
	crAjG756uQ/7Yd6jSmK3xslz/hdCl4ltZjCKl+O0Cz0OdzF/YDqnPP0O8bcUwWWeMv9ZO3
	jdZ5vr9pUBIbvuvbi1kVo6LgSxdQ5ks=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-LkqbR8y3NM6cfrBOsofGfA-1; Tue,
 16 Jul 2024 11:16:17 -0400
X-MC-Unique: LkqbR8y3NM6cfrBOsofGfA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0370E1955D4A;
	Tue, 16 Jul 2024 15:16:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EE141955D45;
	Tue, 16 Jul 2024 15:16:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GFGFwW2121833
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 11:16:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GFGFSw2121832;
	Tue, 16 Jul 2024 11:16:15 -0400
Date: Tue, 16 Jul 2024 11:16:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 16/22] multipathd: correctly handle paths removed for a
 wwid change
Message-ID: <ZpaOv8zMWrY6Jjm6@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-17-bmarzins@redhat.com>
 <694ee49e785ac6f1e67c201590694a8afffd28fc.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <694ee49e785ac6f1e67c201590694a8afffd28fc.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2024 at 09:16:32PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> > If check_path() exitted because the path's wwid changed and it was
> > removed, checkerloop() wasn't decrementing the pathvec loop count.
> > This caused the next path to be skipped by the checker loop.
> > 
> > To solve this, make check_path() return -1 when a path is removed,
> > make handle_uninitialized_path() also remove the path if it was
> > blacklisted, and make checkerloop() just decrement the loop count
> > when a path returns -1.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Would you mind making these return values symbolic? Other than that,
> LGTM.

Yeah, I can do that.


> 
> Martin

