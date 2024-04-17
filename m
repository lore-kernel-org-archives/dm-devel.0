Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED249139F
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 09:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713344854; cv=none; b=WMUp1vEc9z/umrqf3x8KiUz/YEZBnEQASQsNHo0PriCO9svSBmYGvUHUxW5rm5MRJn9jnP3YS03UsKWxbekWI2p8PcSUTzF5Svd8cVTDg9uLogU+pvx/zObTqCkG6UqG0uPmn2q2XPwBeWre2RObgAmRDHBtGIBUkRGDPOxmGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713344854; c=relaxed/simple;
	bh=guvdQiCYCCILGQqzKEfYAWQ4cfAvAu2F34n01HpP97U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qpCTCxoKkHuja6ReVfw90fTcV7mY7ZxiTZ8WZla28Jb/BAZlL9xKY4ComKfwdkSBBJr+lgxdBlbgP+HYgX+l25MkzUwjG+p9qUaJ1hpmD+5JkxTMl7ddIwCbvsKj5kDnTZ/5B15B8wfuDiOOUaPuyer+DO6L1MKW7qogOKFpxvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FftNt7Xv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FftNt7Xv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713344851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4COQ6nzo8Fw0/F8QZkGeo7QfzK+0whj3M+5WYwuBjw=;
	b=FftNt7XvxnNSbBTKzve7CCdm02pOA25camnopug4FLV3G8ICXzaOnTCDoZE0N1ehWPTD2z
	m1K0xS4nIBAciOY+ogo3A/CNDgvqhnpXvuANK4gYntwdcY83Tq3YJN6KzTbtd1j8v+cU9c
	J+CeloYBAoSILjSjngO4UMWz/1aOveI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-sox2cBpEMWmiy8qUeiwM5Q-1; Wed,
 17 Apr 2024 05:07:29 -0400
X-MC-Unique: sox2cBpEMWmiy8qUeiwM5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60D091C4C394;
	Wed, 17 Apr 2024 09:07:29 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B5DC40B497E;
	Wed, 17 Apr 2024 09:07:29 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 4629F30C2BF7; Wed, 17 Apr 2024 09:07:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 42E813FD7A;
	Wed, 17 Apr 2024 11:07:29 +0200 (CEST)
Date: Wed, 17 Apr 2024 11:07:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: Mike Snitzer <msnitzer@redhat.com>, Guangwu Zhang <guazhang@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH v2] dm-io: don't warn if flush takes too long time
In-Reply-To: <c5e8c781-24e6-4f06-8a97-7667e888aa82@kernel.org>
Message-ID: <7efe37a2-a1bc-99e-60ff-a93a1ea77919@redhat.com>
References: <c183dd5c-da91-c71-dccc-c923977bc77@redhat.com> <715f0135-2a64-4c95-9e8f-b20e1dd3b02d@kernel.org> <21b8a171-ea95-9eef-8c68-8cee98c7367@redhat.com> <c5e8c781-24e6-4f06-8a97-7667e888aa82@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 17 Apr 2024, Damien Le Moal wrote:

> On 2024/04/16 0:23, Mikulas Patocka wrote:
> >>> @@ -119,4 +120,16 @@ extern void complete(struct completion *
> >>>  extern void complete_on_current_cpu(struct completion *x);
> >>>  extern void complete_all(struct completion *);
> >>>  
> >>> +static inline void blk_wait_io(struct completion *done)
> >>
> >> Since you move this function outside of the block layer, the "blk_" prefix seems
> >> out of place. What about renaming this to something like
> >> "wait_for_completion_blk_io()", or to make it clear that it is not the same as
> >> wait_for_completion_io(), may be "wait_for_completion_long_io()" ?
> > 
> > Yes. Here I'm sending a second patch that renames this function to 
> > wait_for_completion_long_io.
> 
> This looks good to me, but you sent this new version as a reply. Please post a
> properly formatted new patch. And since you are touching the block layer, this
> needs to be sent to linux-block and Jens as well.

OK. I've resent it.

Mikulas

