Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB04182DF
	for <dm-devel@lists.linux.dev>; Thu, 22 Aug 2024 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724343698; cv=none; b=m6J+5moEllAzOQNIAytXAUcTvYFM/GdrqwN6yj0M5YZrs/ds0lcuy/6wqwbMmMWRfj5TgIhSQa+BBdM78E+OB/urpfO8myKUAp47cT5zuyurNyxV9f9xWAXfHDJQvK49/hjd2Lx4K1NsP74GwXGAL7ez2lJy5LI6k8Gc1v07iT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724343698; c=relaxed/simple;
	bh=rY00msrCronJ+hillbBD8CRa+E5q5QkWZkXUOGBWDYg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Y6quckRsIenm6EDyS6ICeuFhPC3mYcGj1u7mlK9he4YH/2ukvxqdv0iIhuFTW2hD0fNfi8x+mKRQkjCVsRKWyfkLUs9qBPMu1rVizjqMewwebSi8JLN8VFhte7PmH/fqpyeuKrKRssX3Oo0tdWd7hCBm18cLg0jy+EBPFk6a9AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJGK6weM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJGK6weM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724343695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lA23TV9dqmcZnRPhu3Mh5U1Igzbf93lvxjkmGzEIYSI=;
	b=EJGK6weMmYg/DSlI6InmJVXgpo9bIgYxjM0xiPE886Ce6U6a899+8nVAvec10ntprvBKZS
	t14VuCFtYX5SF1wNRWzd9SRCX9edMrLkQLWLbF6kc50hyvdpsle44U6QwviuPh2pf30Cei
	2/I43Ngna8L6c9tl30qv1hJIKQ1bZNE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-cwBFxrXAOxuGeIxFrGUiog-1; Thu,
 22 Aug 2024 12:21:31 -0400
X-MC-Unique: cwBFxrXAOxuGeIxFrGUiog-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AC481955F43;
	Thu, 22 Aug 2024 16:21:30 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B8713001FE8;
	Thu, 22 Aug 2024 16:21:27 +0000 (UTC)
Date: Thu, 22 Aug 2024 18:21:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ingo Franzki <ifranzki@linux.ibm.com>
cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org, 
    gmazyland@gmail.com
Subject: Re: [PATCH] dm-crypt: Allow to specify the integrity key size as
 option
In-Reply-To: <5d1ae9a8-67cd-4787-9faf-2151f6b0fa4f@linux.ibm.com>
Message-ID: <4a5bb6f7-0ef8-eee9-21f3-3885923d9c21@redhat.com>
References: <20240816112133.2100537-1-ifranzki@linux.ibm.com> <d75574e8-a829-0f48-2a99-8d79b0fdfb00@redhat.com> <5d1ae9a8-67cd-4787-9faf-2151f6b0fa4f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 21 Aug 2024, Ingo Franzki wrote:

> On 20.08.2024 17:56, Mikulas Patocka wrote:
> > 
> > 
> > On Fri, 16 Aug 2024, Ingo Franzki wrote:
> > 
> >> For the MAC based integrity operation, the integrity key size (i.e.
> >> key_mac_size) is currently set to the digest size of the used digest.
> >>
> >> For wrapped key HMAC algorithms, the key size is independent of the
> >> cryptographic key size. So there is no known size of the mac key in
> >> such cases. The desired key size can optionally be specified as argument
> >> when the dm-crypt device is configured via 'integrity_key_size:%u'.
> >> If no integrity_key_size argument is specified, the mac key size
> >> is still set to the digest size, as before.
> >>
> >> Increase version number to 1.28.0 so that support for the new
> >> argument can be detected by user space (i.e. cryptsetup).
> > 
> > Hi
> > 
> > I know you already discussed it with Milan. I'd like to ask, what's the 
> > reason for this patch? Milan said that you need it for mainframes - 
> > please, describe the specific configuration when this patch is needed.
> > 
> > Mikulas
> 
> Hi Mikulas,
> 
> thanks for looking into this.
> 
> In short: Yes, we need it for a new function on Linux on IBM Z platform 
> (aka s390x), but the general concept of using wrapped keys is not 
> limited to that platform but can be used by other platforms as well. 
> Furthermore, the proposed change can also be beneficial for clear key 
> HMAC integrity protection, to allow choosing the size of the integrity 
> key.

Hi

Thanks for the explanation. I discussed it with Milan and we concluded 
that the patch is OK and that we can stage it for the kernel 6.12.

I added the patch to the device mapper repository. You can get it from 
"git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git", 
checkout branch "remotes/origin/dm-6.12".

I fixed two bugs in the patch:
1. crypt_status must report the new argument in its table line
2. sscanf(opt_string, "integrity_key_size:%u"...) should really be 
   sscanf(opt_string, "integrity_key_size:%u%c"...), so that we report 
   syntax error if there are trailing characters after the number.

Please, download the updated patch from the "linux-dm.git" repository and 
test it.

Mikulas

