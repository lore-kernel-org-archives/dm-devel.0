Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320671B0120
	for <dm-devel@lists.linux.dev>; Thu, 29 Aug 2024 16:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724949392; cv=none; b=GqnX8tuNupE3ZjdknJOvPHqRp+T2VGsYE+ej/J5L8iB152+h/UNDb96i1w9ptWfWZpSwR20jwenGpepPNwzimqulb0AfDMOO2v/LWgfqKkU45BDWMHe37bLL2MjQqkSHq/wF3a2B2cihre7XGZgwbTfUxkBiSQpgh1aC1KFJhls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724949392; c=relaxed/simple;
	bh=r/hJsBBSQhrsn+qMeGEP/u3bKYCsL2u2Ah2tH5bd69s=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aEleT/Sr+0RkJmwaQyuiNrK8VBrrNMPTJKmJCxdgx94mnQGf9dkn/aR2SxAOPR0V9Aqg331pTdtkq8TuzRP2wY7YLq/pCRgIAE/g+u7pPxRbOxZ8A2THZnL0/D47Ltg2A6B+zk+MVL2Nr2alr13iz8zdLYPRrKrOX4BAWfGOlQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itKlKB2m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itKlKB2m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724949390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4BuLtCbqqKPEZApIQn+oYYzJfovva5LukqAAjxFsloU=;
	b=itKlKB2mAsF6OYKAlOG1rWFsQJbv3+WTip/0tWrdXWyi5Vy1nP0uCCxNZSJwpbn5g1pUi8
	5vBcWLYQKBw3okGGkDjwLt7KDH8DmgX1oG9ZMSPFw1tmruUxsQzjYxF43OXTctKjdmlzh3
	2PfJKnq2iG4g4RJ8nRVRPER2WeKEnX0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-f3XQEiZYNpCugYVoyCMKig-1; Thu,
 29 Aug 2024 12:36:27 -0400
X-MC-Unique: f3XQEiZYNpCugYVoyCMKig-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96A3918BC4E6;
	Thu, 29 Aug 2024 16:36:25 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87E3919560A3;
	Thu, 29 Aug 2024 16:36:23 +0000 (UTC)
Date: Thu, 29 Aug 2024 18:36:19 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?GB2312?B?s8LT8bey?= <chenyufan@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "opensource.kernel" <opensource.kernel@vivo.com>
Subject: Re: [PATCH v1] Device-mapper(LVM): Convert to use time_after_eq
 macro
In-Reply-To: <e9a9f9f7-6c38-4ca7-8ccf-40275662cd34@vivo.com>
Message-ID: <a8231a22-3610-8e44-7fdf-dfc9d047dfa2@redhat.com>
References: <20240822015416.3627-1-chenyufan@vivo.com> <1abae895-7fb4-0342-21b9-1fd8e085dc9a@redhat.com> <bc1025c5-fa3c-4a49-9d91-d2d90e7423b4@vivo.com> <6f732dc5-b80e-0e79-a1dd-faebd0d91933@redhat.com> <de43d61e-05c0-466f-b004-a97f2bf2ec39@vivo.com>
 <9cdc4de9-82b8-87fe-4845-6b18ffe26d18@redhat.com> <e9a9f9f7-6c38-4ca7-8ccf-40275662cd34@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-872353911-1724949385=:996563"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-872353911-1724949385=:996563
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Thu, 29 Aug 2024, 陈玉凡 wrote:

> When "jiffies" is 0x10 (because of wraparound) and 
> "container_of(wc->lru.prev, struct wc_entry, lru)->age" is 0x1(I'm not 
> sure if it can be such a small value), the result will change from a 
> large value to a small value.
> 
> Chen

So, the when you subtract the numbers, you get 0xf. There's nothing wrong 
with it.

Mikulas
---1463811712-872353911-1724949385=:996563--

