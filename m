Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C435275852
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745406663; cv=none; b=BtzRS4xbbXxDzRg5BVbYTHF74BKt2MeV0B1pRCyHe/uVCSmdWNh/cOnaF4NB7AhUv6CpqaDHDJTGunH/gXI109lOaJ/rbXHUapG3NDWIM66w1gotFfPEOXWHdnR87tS1HD4YLrf607j0USTCIg4ThyNJKGXo9YwqQHio4fUf5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745406663; c=relaxed/simple;
	bh=7kxs5fONHBDrEEMpfHF6Me5LwhXZkaU4RpiH+9S3EE4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tnRB7vdmSB7bKgOq7IGyGuMlTQLj4QepoTr+btvLtqGltYgx7pln5uw+Z2/LOhLeyE5mq3JlK4WBsXnBEPng8feSJKv4ItSXiSupgsclcpyhjS0DbZ7cK3YT2FGxBYwLDIER1EAZWZ3h4EODR56VRe44JxhdhjcqgModY8hR9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WHLLeDsn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WHLLeDsn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745406660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4lg4wZ0wblbf41bBwsUniFt++jBlLXVgcLDNP8JKtI=;
	b=WHLLeDsnqbJ0vReaU/jSlExdWniSuwSLvqrStzNh+bhR0sJWF3ojIm3SGZGvEeIUA2Ithb
	V+/Rx84+eC2VO8+PL/FedG0tqUXhh/4jze54MFeqnj8LEiqHCZBQ74Qf6Nh6UQZ421OKZ0
	rRgiDgwB5vwWZL5iOo32VakDsbKyLvw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-l0E6DSaRNjKHasabmbIslw-1; Wed,
 23 Apr 2025 07:10:54 -0400
X-MC-Unique: l0E6DSaRNjKHasabmbIslw-1
X-Mimecast-MFC-AGG-ID: l0E6DSaRNjKHasabmbIslw_1745406652
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 262A919560A6;
	Wed, 23 Apr 2025 11:10:52 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A9AA19560B1;
	Wed, 23 Apr 2025 11:10:50 +0000 (UTC)
Date: Wed, 23 Apr 2025 13:10:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Stultz <jstultz@google.com>
cc: LongPing Wei <weilongping@oppo.com>, dm-devel@lists.linux.dev, 
    guoweichao@oppo.com, snitzer@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] dm-bufio: don't schedule in atomic context
In-Reply-To: <CANDhNCrpSApv55_0LN816nNaGhPWiWZNODr-_1egjPpgGGb1-A@mail.gmail.com>
Message-ID: <116e97a7-ea27-8c01-cbeb-09e10188d77a@redhat.com>
References: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com> <20250417030737.3683876-1-weilongping@oppo.com> <CANDhNCrpSApv55_0LN816nNaGhPWiWZNODr-_1egjPpgGGb1-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-295574454-1745406651=:1915902"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-295574454-1745406651=:1915902
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Tue, 22 Apr 2025, John Stultz wrote:

> On Wed, Apr 16, 2025 at 8:07 PM LongPing Wei <weilongping@oppo.com> wrote:
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index 9c8ed65cd87e..3088f9f9169a 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -2424,8 +2426,13 @@ static void __scan(struct dm_bufio_client *c)
> >
> >                         atomic_long_dec(&c->need_shrink);
> >                         freed++;
> > -                       cond_resched();
> > -               }
> > +
> > +                       if (unlikely(freed % SCAN_RESCHED_CYCLE == 0)) {
> > +                               dm_bufio_unlock(c);
> > +                               cond_resched();
> > +                               dm_bufio_lock(c);
> > +                       }
> > +       }
> >         }
> >  }
> 
> I realize this has been queued by the maintainer, but in
> cherry-picking it for the Android kernel, I noticed there's a
> whitespace oddity with the closing bracket indentation. Might deserve
> a followup fix.
> 
> thanks
> -john

OK. I rebased the dm-6.15 branch and fixed this commit.

Mikulas
---1463811712-295574454-1745406651=:1915902--

