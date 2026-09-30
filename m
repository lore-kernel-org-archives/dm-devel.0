Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE94A99A7
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 23:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790811388; cv=none; b=KEEiBa28//4x3ki/h3u+PGyk2cnzBB8XaYTkVrKDolB9I4zcqNV6I0NBKE0bFyvHwaf9IGO7Lh4Uv8NaKfqVzPSnneuMtCy7NXUtoGpajm3MDccXbypyGqpBJ3QTcIxGxQZ4bj4P1VRurhlvI0al57RMaES1Fv9jvDPJC4DxJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790811388; c=relaxed/simple;
	bh=vACwImubVvJri6CbclQ2gGfCVqvla70Mqv5GOXVb/uY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=nbLNHK82Emldw30Fc1bNBd2yPl016xlhlnkUEvDwR0GysJFtIITeD1lCJRSEzCXz9mMzmBavaLYWkBLyITN0jH3yyc/6c0faeaHMLcNdiSxB4KOIwzuRsQ2UV8eHp4KrVvdOyY/s5PAamytQbbKjXZI1PAKRXqjsvrpi2IXay1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZlY63O76; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZlY63O76"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790811386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/YUJ9S21yP3kCdTr4Q7eXnFqGHSLZAg3hpFUrTgVV+I=;
	b=ZlY63O76gdImzK3gC3o8aTmFEOKqnGLGinH2Y7V2KDvwpKjVYVm9brogDlUn0SNZ9o/Vc8
	czN0Pz41Sjw0GoYJvp9OYIao7rTo/W4XHfKpIQyhK0ttj6ijrmL1UAQ6BdrJ9iNaIeWT/N
	q9Ir7t24gAq9VMTO0sViaVOQmocot1I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-kjwocvbgMeuuy6C9wlB3jg-1; Wed,
 30 Sep 2026 19:36:20 -0400
X-MC-Unique: kjwocvbgMeuuy6C9wlB3jg-1
X-Mimecast-MFC-AGG-ID: kjwocvbgMeuuy6C9wlB3jg_1790811379
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18DDA18DEB24;
	Wed, 30 Sep 2026 23:36:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5AF61956042;
	Wed, 30 Sep 2026 23:36:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 68UNaH48746508
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 19:36:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 68UNaGD6746507;
	Wed, 30 Sep 2026 19:36:16 -0400
Date: Wed, 30 Sep 2026 19:36:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.de
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/4] libmultipath: constify functions in wwid.c
Message-ID: <ar2c8OYWqSWN5kaG@redhat.com>
References: <20260925214014.2464499-1-mwilck@suse.de>
 <20260925214014.2464499-2-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260925214014.2464499-2-mwilck@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hs02a8VDApJw2fPcg6CgtQ_sWKSF69eYB-FNtUFE19c_1790811379
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 25, 2026 at 11:40:06PM +0200, mwilck@suse.de wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use `const char *wwid` where possible.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

