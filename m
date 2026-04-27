Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B91D5170
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 19:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777318968; cv=none; b=CScE2GhoThd5vmbkYh658z+rP1pnwbTP44qLptGjNpUh2x+5T51ehTJAA18uabbAX9Xl8RbsA0eWsDsDHXJTuwUS7GpVAPtBShJ4f3EsGxfv1cLJfUKNFN2QWzSJWhd8tg/NDg+jf0ttKe6p3LkdFkrz6sy73cnWVQrsp3y8W6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777318968; c=relaxed/simple;
	bh=8C4x7vxUOOlQr8sDYVkiRViYRsHDFk8NOhZROPC7a3Y=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ggYIH2mbFKEMCzNYgfg5Q7ayXZX1zOF/JL+BrSJHBAVCoSMGqpiBlslJxco0zd1NhEw6dXxgTc24LFOyJN0NwYalGFd4iSfryyxJk0xEArvIt7k8Pm9rmERlJ3LO3w7SQ2wzpO3Wl+rc8Ppfe6Dq6I6u3ZI0J+qrQbO0JltLDOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NWepH8iU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWepH8iU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777318966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thRMuDd+G1UhyHlG+VcSH87KRUvT6lfoxtzBUqqH42M=;
	b=NWepH8iUeUdEu2+2qObTtyv4SMHaW/TuDh4/r2KLft39hvse0D3aHa12fuwYFPYZnzkCuW
	GaV64u/1V7XVvn6uEtFTJXk59duEtSLU7nwzDSCXzGuIgSn+yJGdmotyfzNux5ufs7MgUx
	KYtW9AuRtkrcX9gAuiDbRXXTxejTx54=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-x9JmcEjNMUODkqwL8Cqm1A-1; Mon,
 27 Apr 2026 15:42:43 -0400
X-MC-Unique: x9JmcEjNMUODkqwL8Cqm1A-1
X-Mimecast-MFC-AGG-ID: x9JmcEjNMUODkqwL8Cqm1A_1777318962
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF5761956050;
	Mon, 27 Apr 2026 19:42:41 +0000 (UTC)
Received: from [10.44.34.100] (unknown [10.44.34.100])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D332319560AB;
	Mon, 27 Apr 2026 19:42:39 +0000 (UTC)
Date: Mon, 27 Apr 2026 21:42:37 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, 
    Roberto Sassu <roberto.sassu@huawei.com>, 
    Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH 05/10] dm-ima: Fix UAF errors and measuring incorrect
 context
In-Reply-To: <75a6b1cf-9f0d-8fc2-57d5-f6dee4913c65@redhat.com>
Message-ID: <a137657f-64e7-6796-33db-51b200b87fa5@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com> <20260414002244.1917447-6-bmarzins@redhat.com> <75a6b1cf-9f0d-8fc2-57d5-f6dee4913c65@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: c7YwmlNiuqlnuYBldH3F8w0I11Au4apgLEBIVVe3ss4_1777318962
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 27 Apr 2026, Mikulas Patocka wrote:

> Hi
> 
> 
> On Mon, 13 Apr 2026, Benjamin Marzinski wrote:
> 
> > +	smp_mb__before_atomic();
> > +	atomic_inc(&ima->measure_idx);
> > +	wake_up_all(&ima->ima_wq);
> 
> There should be smp_mb__after_atomic() after atomic_inc() and before 
> wake_up_all(). Otherwise, the increment of atomic_inc could be moved 
> inside the wait queue spinlock in wake_up_all and executed after the wait 
> queue is checked for being empty.
> 
> Generally, the atomic variables and barriers are very hard to get right, 
> this is not performance-critical code that would justify the 
> complications, so I suggest to use a normal spinlock instead.
> 
> You can use something like:
> 	spin_lock_irq(&ima->ima_wq.lock);
> 	ima->measure_idx++;
> 	wake_up_all_locked(&ima->ima_wq);
> 	spin_unlock_irq(&ima->ima_wq.lock);
> 
> --- this would be obviously safe and easy to verify.
> 
> Mikulas

BTW. you can see "&ic->endio_wait.lock" in drivers/md/dm-integrity.c for 
an example, how to use this pattern.

Mikulas

