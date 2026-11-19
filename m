Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092135;
	b=MC8bO0yRaMMqdb1+9eClE6RtbZuU+85bKaXB++KwvSDEbR9xRuaEjanpKbsbp0cCRw0h
	 6UwI+8WAF6lE0oA4UqUN41QW2HFbvN//8R6ZqAIeVhgCAkhdgVqv1QKVBjt8VWe8nM72s
	 R1BBus5u7KJOfl1yx/0uaUUpRSl1VO+3SLODfURHgZWIDfpgqZm0PRNVSGkjeLmlhClmR
	 rhGCF9fZ9hJrNd3xMX3KTIZeOxotUkz0u2Et6sqkaj+H2ooVlRYIp3z30qT/vGElAcMcP
	 MOWN06xTpDgC72+i+hLTs7puYyEKvQUqFx/72HdT9G75tdY//+DijvAAVXqEpZaYG8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092135;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type;
	bh=ih08oLQH5e08Wv4KUGN0f9qW7fs/EP8by6wJGIX3uS8=;
	b=xDwX8HVllgK6f8i6QFrHaabSagC5tJYZFuYVj94Mc9UnRx7CCQZUq4o7vZUCizNGSzgW
	 Ge6KTjzvxVpH9Gp18ylG7zQTKAJ2+CRhrjcjXRvXNXdsrdG3cZaQ2Uyp7QXFn6TdM788H
	 1CLgneW+wBwn02MtKvFg3Pttlu6uDXRjNQRY/wO2ouIPvu/HYr2ntCVBIV6AyN8ihFR23
	 Lqu7aYmjg7OXH059CA834Ccj4LfNIoH9nzFuS2EIhq8uNaSqWvP2kJEO4Qfx0xMg92ynZ
	 Or/NxDGswXFbS9bAwVCMH2hYkr2nRVp9WSa/7BTqXGZ9R1vbShuWo26EjZ80yvZ7i9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YrROCPbR;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7855E606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 12:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7855E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YrROCPbR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795092133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ih08oLQH5e08Wv4KUGN0f9qW7fs/EP8by6wJGIX3uS8=;
	b=YrROCPbR6TlKjC0tJECeHenj89A/pW8ClvOOhHuPRJdZ5TLBr3tdfy735DiddPtdYKjoWv
	zoqrxLecjr+uFrX3l6DDykVMYGZV4Vmy7VDAzZdQtNXX7igxzSEUN0w8R8jFew/ilWfWss
	/6oNfk6DnqIq5lGwB8DmCyTWpT3c/uU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-FRw8Ba8eMumEYr6U3z4UZA-1; Thu,
 19 Nov 2026 07:42:11 -0500
X-MC-Unique: FRw8Ba8eMumEYr6U3z4UZA-1
X-Mimecast-MFC-AGG-ID: FRw8Ba8eMumEYr6U3z4UZA_1795092130
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A71C6180059F;
	Thu, 19 Nov 2026 12:42:10 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B306195B3C9;
	Thu, 19 Nov 2026 12:42:08 +0000 (UTC)
Date: Thu, 19 Nov 2026 13:42:05 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    zkabelac@redhat.com, Ondrej Kozina <okozina@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a
 caller-chosen kobject
In-Reply-To: <20261119040155.1076781-1-yangyongpeng.storage@gmail.com>
Message-ID: <2033a6a7-b8c4-99cc-f351-e83579a238ec@redhat.com>
References: <d4fc9150-4768-f747-ca97-688bc9bebc46@redhat.com> <20261119040155.1076781-1-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eV04EB6SnlUMsT4TZV9JT5iOubuJsfZrACwgyKDauAU_1795092130
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 19 Nov 2026, Yongpeng Yang wrote:

> On Wed, Nov 18, 2026 at 05:41:42PM +0100, Mikulas Patocka wrote:
> > There may be multiple targets in a table - if you use the name of the md
> > device as the base directory, they will clash.
> 
> That would be a real problem, but none of the existing dm-bufio users
> can reach it for now: dm-verity, dm-thin and dm-integrity are all
> DM_TARGET_SINGLETON, so a table can hold at most one of them and the
> directory under a device holds at most one "hash"/"fec"/"fec-data"
> client per role.  If a custom targe_type which allows multi target and
> each of them have a dm-bufio client, that will be hard to handle. I just
> want to show the client info through sysfs, how about show such info via
> message?

Yes, showing the state in a message is better.

> > What do you think? Which of these two possibilities is better?
> 
> I prefer messages, please review [PATCH 4/4]:
> 1. The constructor line would have to be taught to veritysetup,
>    dmctl in android and lvm2; a message is one command, no userspace
>    change.
> 2. This knob wants runtime adjustment (raise at boot, drop later);
>    persisting it in the table line makes every tweak a suspend/resume
>    reload, while a message adjusts the live device directly.
> 
> Thanks for the review,
> Yongpeng

I see.

BTW. I'd like to ask another question - please describe in detail the 
performance problem that you are experiencing and that this patchset is 
fixing.

Is the kernel dropping dm-bufio buffers too aggressively? Or is it not 
dropping them so that they consume too much memory?

Could it be fixed through other means that are more general? (for example, 
having a global dm-bufio shrinker and dropping buffers from the client 
that has the longest unused buffer)

Mikulas

