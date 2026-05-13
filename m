Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702029408
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778632797; cv=none; b=F/bjBikDl0zzTdJIv053/82KUS9WnBaCpuDKi7Oh/qt80+C5WDe56JQ7q8duAv9YtJ/I3OKwfjwKbtJCD3OCyt2YsZWeWd94Tnim/BOEBFzui8GqRsOPsidIW9QEGty1X1Uqslybmjm9320H8LLUzLaF1eW+L0V79+eQuelhH4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778632797; c=relaxed/simple;
	bh=25JaRbmKp/CongHxYVgwbRzIohBpZaud0A0cZcwcfnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sw/LaTUhVJSKrwhgfNtPC3k9Q7FZUUwdqGh90lUuRyXlcbciUERrqbO4jiRCvJBlFJewdBDswDQGn+k9VkoNjIzULT3XGNKa0tANJKKcT3iaGEbd5m08Uxb8MMhk0XH+DXxjrTuKp+MybnO+5R5CxOOxa7MY0mvDdsGXWlwXXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZgxwY0jh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgxwY0jh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778632794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bkk5Bu2M37/Gm8ELe3S4lyomYYs+xVmUptM4WkUJ7cI=;
	b=ZgxwY0jhjM+hIqd1BCRKLWgHuCkb26TXNKOkvNA3zuzrwv99Li7q1hh2/zHQcbAiwwYKjg
	UZboYh26XAOc9d2G6MqBwO2i1pW0KsrrUotFPwdZ6Qw0sinnovnkh/BZ2K0OjnYk631r4l
	6tO9VwkCUe2idPJjdeuC8K9axlieFrY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-292-Z874PLtCNjiDcKJA2eQICQ-1; Tue,
 12 May 2026 20:39:49 -0400
X-MC-Unique: Z874PLtCNjiDcKJA2eQICQ-1
X-Mimecast-MFC-AGG-ID: Z874PLtCNjiDcKJA2eQICQ_1778632788
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D769A195608D;
	Wed, 13 May 2026 00:39:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 806A9180034E;
	Wed, 13 May 2026 00:39:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0dkoR3331556
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:39:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0dkNk3331555;
	Tue, 12 May 2026 20:39:46 -0400
Date: Tue, 12 May 2026 20:39:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/18] libmultipath: checkers: add two generic checker
 messages
Message-ID: <agPIUtiKUd3w5Mok@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H4eVxRb5j6JEC9rPtr_Dx7iyMUd00NZ0GZwjCDMrxfY_1778632788
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:16PM +0200, Martin Wilck wrote:
> Add generic messages for "timed out" and "still running".
> They will be needed by follow-up patches.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

