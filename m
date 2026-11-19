Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795065870;
	b=4KpArjYmFFiIvr+boTYmzVEIE2MNPhCYl8+dp0GWGKNDL1GEKkRsIQTERPsywDbfCt3z
	 eDIyvpydrjQSjT5yGQDSNO/7QfFSWGTnyKU6ssBxYAFPN72gOiPer05kVWbuM/Mx/IfLS
	 iGcF861i0bnXirYOCabo3sztbD2KYeAvtw8lhTSWgcU5bf+wb9zDwAgRlTfVAdthKGGeq
	 gzr7gDEaWyBZp476X49mKin5cz9gc/L/f2CWj208CGxoBBNyNGjGydhSfsed9XvIoPPVT
	 s1i+QL0xoWFC1UfA+JDNS6nFLa2ErwEniPkrGJNV9JNpUWIfG/SN3grBxTR+faa86Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795065870;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=5Xv6WBUpVDFZ/e1zS9/XkeBEM7xgEyFcyanxdGCDPeM=;
	b=dlauJ7SlDnAJumLZTpS7mdZQaKR5fEllwVfS6eYuemSXRI6GcpMtLsxNAx63KPrecJCD
	 NjDtzI+o9Rj0+M6XyCRBLNkmj/f+CvQMAcbVpRvmDcOdFemQSOoOH3dW3lAKTH8T8mzAI
	 ZON4jBr3o/swztuRIAe5tpuPYom34Y0hALze//CLN/0ge0rOeZ7b+djfE0kr68OOZaBLM
	 H7APYUpVemdZowNSuEvLw4IxMMaukJCeJd03t89AxBVEKoupNIedWhhZ7Uuesahh7IZNx
	 r9u/vbCSWEpjTDn7zEOJc3cr4EhxYVTW1OXk2WJ3Np8f/VAr5LnkEcw2SeZ0KYE0vwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Su6avpzs;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888AE606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 05:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 888AE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Su6avpzs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795065868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Xv6WBUpVDFZ/e1zS9/XkeBEM7xgEyFcyanxdGCDPeM=;
	b=Su6avpzsqwf/XNpkVkaMflWEQlJuaqWxvp4LB6tvChy4+MGD51wp6LKr7dK8LIXoyInyuX
	WMVF2oS2WxrQtEb5TpG2/g1Tl3WgRb5HobmDqlwAUlZY2q09QSp8/BnERsh32H394hHRFX
	jGrDbxDcbHpjR3aytBPHE41ccoOAcwY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-SOq5PNKmOZSnqGuDgEI0kA-1; Thu,
 19 Nov 2026 00:24:24 -0500
X-MC-Unique: SOq5PNKmOZSnqGuDgEI0kA-1
X-Mimecast-MFC-AGG-ID: SOq5PNKmOZSnqGuDgEI0kA_1795065863
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A32661954B1E;
	Thu, 19 Nov 2026 05:24:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4950A30000E8;
	Thu, 19 Nov 2026 05:24:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJ5OLoa510804
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 00:24:22 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJ5OLA2510803;
	Thu, 19 Nov 2026 00:24:21 -0500
Date: Thu, 19 Nov 2026 00:24:21 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm thin: stop waiting for grace periods when
 activating and removing thins
Message-ID: <av6IBa44Erp0gWBN@redhat.com>
References: <20261116-bug-dm-thin-rcu-gp-v1-0-14ed3567da3e@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261116-bug-dm-thin-rcu-gp-v1-0-14ed3567da3e@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: FnZyeRFd1l0g-V5zG2DR0oWD4JddhJ2HnoO6AQO4dPY_1795065863
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 16, 2026 at 12:12:02AM -0500, Qiliang Yuan wrote:
> Activating a thin device waits for an RCU grace period in thin_ctr(),
> and removing one waits for another in thin_dtr(). Tools that create and
> remove thin snapshots for every container, such as the containerd
> devmapper snapshotter, pay for both each time.
> 
> Patch 1 drops the grace period from thin_ctr(), which isn't needed.
> Patch 2 lets the active_thins walkers skip thins whose last reference is
> gone, so that thin_dtr() can free the thin with kfree_rcu() instead of
> waiting. Activating a thin device gets 51% faster and removing one 15%.
> 
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

I posted an alternate version of your [PATCH 2/2] that fixes the issue
I mentioned. Can you verify that it works for you?

I squashed it with your patch, since it your original patch did most of
the work of fixing the issue, and it seemed easier to just have one
patch to backport to fix it. I could refactor it into two patches: one
the fixes the bug, and a second that just swaps the synchronize_rcu()
for kfree_rcu(), if people would rather not mix the bug fix and feature.

-Ben

> ---
> Qiliang Yuan (2):
>       dm thin: drop the grace period from thin_ctr()
>       dm thin: free thins with kfree_rcu() instead of waiting in thin_dtr()
> 
>  drivers/md/dm-thin.c | 37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
> ---
> base-commit: 23c62304dde29abe92013d85910d03a77dada35d
> change-id: 20261114-bug-dm-thin-rcu-gp-d29d4b74a0b8
> 
> Best regards,
> -- 
> Qiliang Yuan <qiliang.yuan@linux.dev>
> 

