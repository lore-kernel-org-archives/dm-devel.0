Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1DB42EEC3
	for <dm-devel@lists.linux.dev>; Mon,  2 Mar 2026 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772473238; cv=none; b=n46kbaH+YTk8yVcSsebLjEr4w2c+pXzKMqFnkO/LmKKmJJd8Xr3SrLCaXlRfjy4Xc76DBjhZqK1lRyVN23aVYPPblSXgN1grL9NSA1lgVq6qrjA3TastrezvhT0YHLA//exjJ91eLmjM4FG/R/S7ikTJcc0279g+so/qJKnerQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772473238; c=relaxed/simple;
	bh=9Rb9eG3gVnkobLqIXjM8OA571fWMdtFK9Lgtde+Nhe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ToeCpkdqs1DoHivrOCuNu/t2gqU9X8oWaQy8VvtFUYo7uxtuvnGl6EkD9nUMdGPgfIw+zN03+i4GHKfCHMEQbrBxHx1EdtxVgngPao7X9UyIgCwSOWvqSUAPlqAykP+Ng3TC/z+L+01D5QyMB2F6IMCVsuK7YsLZ7pa9pTwigv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xu4N6p0n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xu4N6p0n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772473236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1t9B6i7CkrMpK3fAOhI5ntt/5KcYm7iE2MiLICu1shs=;
	b=Xu4N6p0n4Xm8VxHXkPcw5+gmIhsdpxnT+5M1+d/5NnGNqAchfCAl5ZHXOgo3QW/roZyO6v
	1hg7qW40YlLUCaOunQrp+VgB4nXjiuLeJPejAZaVNyaNcNjiV0z6FrI29tGg1U6Tp9wE1S
	Z8QU7t9OSBGI0cZavZOn02EMk/X468Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-4BRSKHqtPKOqlqJhZcJTAQ-1; Mon,
 02 Mar 2026 12:40:33 -0500
X-MC-Unique: 4BRSKHqtPKOqlqJhZcJTAQ-1
X-Mimecast-MFC-AGG-ID: 4BRSKHqtPKOqlqJhZcJTAQ_1772473231
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B678F195609F;
	Mon,  2 Mar 2026 17:40:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 711A219560A3;
	Mon,  2 Mar 2026 17:40:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 622HeUEv1853785
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 2 Mar 2026 12:40:30 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 622HeUJb1853784;
	Mon, 2 Mar 2026 12:40:30 -0500
Date: Mon, 2 Mar 2026 12:40:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Junrui Luo <moonafterrain@outlook.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>
Subject: Re: [PATCH] dm mirror: fix integer overflow in create_dirty_log()
Message-ID: <aaXLjmY-Zf5Bni4U@redhat.com>
References: <SYBPR01MB78818AAF59CB119B833C535DAF71A@SYBPR01MB7881.ausprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <SYBPR01MB78818AAF59CB119B833C535DAF71A@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: shluzgfSXRNjU71nCVDAfUytOkFZfyxt7e41DCAypTA_1772473231
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 01, 2026 at 09:10:58PM +0800, Junrui Luo wrote:
> The argument count calculation in create_dirty_log() performs
> `*args_used = 2 + param_count` before validating against argc. When a
> user provides a param_count close to UINT_MAX via the device mapper
> table string, this unsigned addition wraps around to a small value,
> causing the subsequent `argc < *args_used` check to be bypassed.
> 
> The overflowed param_count is then passed as argc to dm_dirty_log_create(),
> where it can cause out-of-bounds reads on the argv array.
> 
> Fix by comparing param_count against argc - 2 before performing the
> addition, following the same pattern used by parse_features() in the
> same file. Since argc >= 2 is already guaranteed, the subtraction is
> safe.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

