Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1C12DDA7
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713536686; cv=none; b=eK4gZ1F5r3j8NPwK/Mzj3+xoO9fAPFQSpwydsvijqmTUsu9Yk3GF6BBhS0IIiXu6fUGOUyccDzlxRoJyaxPYuoDKAoFEZzVJFYdxg/1dt+XpVKMEYzxGgnT/utCVHnkMvH03Ygx4qL1hr3K5ho6tGMgvSG0f2XRdS9fW1HH5Zgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713536686; c=relaxed/simple;
	bh=4yDV3B9dyRYKT0zu6cyjd7RyrABG1054GU4V4KzmhKw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mS/BvioMhOJ7xKnhV8yJi7J9zLueyTa8lnh/OmgvI7UHeaVAp9zjAhN+Ep+rg7DxzZyRIfKxRoehXWbZvAdIY870wAaj8+7IOS0Cqpv7EOPbfAYXXdwvUtqmi8Eud3aWW2uEQtg6mPhkgOMtWde/wwbXEEncO/X1o2+2wXX4eUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SpZK8xJe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SpZK8xJe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713536683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B+qdgHxA0OadxW4gAWC8onT7U2GBQTR6WNClAFvOV8o=;
	b=SpZK8xJeec9BZ6rzep3A2X2CgvaUdmo8zCfdz0TCAZxCa+y7tDBXrw28+pHlRmlJE82pXg
	dqd083gkTm+rZLFYfgr636er/4fV+M0tMgkv3peybnAKbfEPYQiZ1834g+/WOMDsglQA6f
	IHA14NWw8ZavDI5cfYqHOx3cyqA9Y7I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-dmhw7hNrNWe-gmmMW77_7A-1; Fri, 19 Apr 2024 10:24:41 -0400
X-MC-Unique: dmhw7hNrNWe-gmmMW77_7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D36B1887319;
	Fri, 19 Apr 2024 14:24:41 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36DCC49104;
	Fri, 19 Apr 2024 14:24:41 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 1B24B30C2BF6; Fri, 19 Apr 2024 14:24:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 176A13FB54;
	Fri, 19 Apr 2024 16:24:41 +0200 (CEST)
Date: Fri, 19 Apr 2024 16:24:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
cc: libc-alpha@sourceware.org, Zdenek Kabelac <zkabelac@redhat.com>, 
    Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
Message-ID: <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com> <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="185210117-860206134-1713536681=:2767205"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-860206134-1713536681=:2767205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Fri, 19 Apr 2024, H.J. Lu wrote:

> On Fri, Apr 19, 2024 at 7:08 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > I'd like to ask what to do with it? We could use LD_BIND_NOW=1 (or
> > -Wl,-z,now) - it mostly works, but not entirely - the key may still be
> > present on the stack even if we use LD_BIND_NOW=1.
> 
> Since vector registers are saved on stack only during symbol lookup,
> shouldn't disabling lazy binding solve this issue?

It should, but it doesn't fix this problem entirely.

If I set "GLIBC_TUNABLES=glibc.cpu.hwcaps=-AVX512F,-AVX2" "LD_BIND_NOW=1", 
I still get a failure (I don't get the failure if I don't set 
GLIBC_TUNABLES and set only LD_BIND_NOW).

So, even if we use plain SSE, the data somehow end up on the stack.

Mikulas
--185210117-860206134-1713536681=:2767205--

