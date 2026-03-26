Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98861421F0B
	for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774545982; cv=none; b=TKWDaOPfo/43LvFk6wYlDCk/L9NdU9pOzIwjFvMGgmf53r0wsq+SkRn0coeHU0cBnvr4s+9CQ0VJzBYWSl1ZRiAEg4floOIz2oLITDvhRSUa9YlQsClBiv3/STA2HGgT6v0eR10S233DsNf4hWS4W8XF1HZjGNgq4ie6gurogzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774545982; c=relaxed/simple;
	bh=z5lLvBjGpcPfiV2p5QSQNWZHLsA76yGRnR7618cYt6w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RjRf6rN5GJdPi0QeHpamLhb15WDjUiwNZxTM3EAhteTRLSnqOTKFd5E3TGoFapuZgCg3hCHq87vGaG1sCSkIwQ9fAV8DngXZ8GolPreXt5vaXC7dLkXpyBADIo6HKVyuxcdbogem38RM1QV13D7KpN/sZWjinIqEuuDQPX4+qRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dT+jXJAU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dT+jXJAU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774545974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z5lLvBjGpcPfiV2p5QSQNWZHLsA76yGRnR7618cYt6w=;
	b=dT+jXJAU/03M8xGSawNlOpcpqd/Vxugm5iUB9OodBY7HjXt5tr7Sr35xjL4GgkK2bIDRCl
	SdzB8jfyG6WIiW3pfx5dTy0r19WCdnHZ8N56FBp3Y1urQq9gQJFNkT+4jzoZx42HaC0Gbx
	4uv7Z+jdt+1Q0FozkYfswo1BHfTqQC0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-OyxzjlTqOzOzWDCx_lUkMw-1; Thu,
 26 Mar 2026 13:26:12 -0400
X-MC-Unique: OyxzjlTqOzOzWDCx_lUkMw-1
X-Mimecast-MFC-AGG-ID: OyxzjlTqOzOzWDCx_lUkMw_1774545971
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AAE8180049D
	for <dm-devel@lists.linux.dev>; Thu, 26 Mar 2026 17:26:11 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1A13180035F;
	Thu, 26 Mar 2026 17:26:09 +0000 (UTC)
Date: Thu, 26 Mar 2026 18:26:06 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Bruce Johnston <bjohnsto@redhat.com>
cc: dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>, 
    Matthew Sakai <msakai@redhat.com>
Subject: Re: [PATCH 0/9] dm vdo: add in-kernel vdoformat support
In-Reply-To: <20260324180652.69439-1-bjohnsto@redhat.com>
Message-ID: <0e6d8fea-1765-dd54-a95f-8ca4901afea1@redhat.com>
References: <20260324180652.69439-1-bjohnsto@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bGrrK3LmNyBVZEktqtvhpw45g2zfwllXdDoM43RkMkQ_1774545971
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Applied, thanks.

Mikulas

