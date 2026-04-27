Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4537BE6A
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777318435; cv=none; b=fbyq2CdiFQqQtORBFZOV5FOVOgTNBWb4fNf57wIPRifGGD+4iciTnGCdOcVSsWQI1dppRqNJhBAJ2X39Is/yINZaRn2KqniFX5xwdRH0CwEJyPV30xYKL91iEu8VE6XmF4CZUOJOjDorWdtN1aoO0iBxTwocSQs0XCME2qLRN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777318435; c=relaxed/simple;
	bh=KS45z/As0ar/Z5Xqhyxpu0aZa+Ue0NXKWdbKvzeZkw4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=al09TcF3bd/mb79IPRCOz2R7ZcIC/g0nOWHovlvb0a6eYUXSBH0D3nEvGAWAjwyAl8gxyWZt68BHJpf5ayI+W4BzwtFY/hqWZ2Jw46iMtQVYT6AywzLRPQMu9p1zAKTEGKkSGaTYgHclRymrWHg9A1zE/bmhmvRtSd1ESov2uMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxxIaocA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxxIaocA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777318433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/k5vVoeUoyUVeEHSdQW+16kTNwgmVmfnWtj6Ni3pxQ0=;
	b=OxxIaocArZX6q/SCiwHTmbrueQyJsDFlgN0cCViNw5vfvr/nM6eL/AAQV04tRJ+WGmuEQu
	W/af1XDz3eYEpRn0PHu89d27G0jjxbQF4G+kthb+2iF5Nxh9+v7TvCEJEUObl45c/JpFAA
	grCjSG8OlzDIuucZlSCqIAbtocXWu0c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-300-WKEZHm81PxizuxW4xeD57A-1; Mon,
 27 Apr 2026 15:33:52 -0400
X-MC-Unique: WKEZHm81PxizuxW4xeD57A-1
X-Mimecast-MFC-AGG-ID: WKEZHm81PxizuxW4xeD57A_1777318431
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 534E11956050;
	Mon, 27 Apr 2026 19:33:50 +0000 (UTC)
Received: from [10.44.34.100] (unknown [10.44.34.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C6083000C22;
	Mon, 27 Apr 2026 19:33:47 +0000 (UTC)
Date: Mon, 27 Apr 2026 21:33:42 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, 
    Roberto Sassu <roberto.sassu@huawei.com>, 
    Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH 05/10] dm-ima: Fix UAF errors and measuring incorrect
 context
In-Reply-To: <20260414002244.1917447-6-bmarzins@redhat.com>
Message-ID: <75a6b1cf-9f0d-8fc2-57d5-f6dee4913c65@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com> <20260414002244.1917447-6-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: MjY89AcbBC5JTYvmnUuKPzUkGU-BUPzuZ1KH5HSx1Ys_1777318431
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi


On Mon, 13 Apr 2026, Benjamin Marzinski wrote:

> +	smp_mb__before_atomic();
> +	atomic_inc(&ima->measure_idx);
> +	wake_up_all(&ima->ima_wq);

There should be smp_mb__after_atomic() after atomic_inc() and before 
wake_up_all(). Otherwise, the increment of atomic_inc could be moved 
inside the wait queue spinlock in wake_up_all and executed after the wait 
queue is checked for being empty.

Generally, the atomic variables and barriers are very hard to get right, 
this is not performance-critical code that would justify the 
complications, so I suggest to use a normal spinlock instead.

You can use something like:
	spin_lock_irq(&ima->ima_wq.lock);
	ima->measure_idx++;
	wake_up_all_locked(&ima->ima_wq);
	spin_unlock_irq(&ima->ima_wq.lock);

--- this would be obviously safe and easy to verify.

Mikulas

