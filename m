Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC211991DB
	for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727107213; cv=none; b=esZPo3sjWLY1HxU8ufc4yiK/MtRsHrxEDM9Kh2w2W1gUEvbOwuq6AO3ixjoqx5lc/g6uC+AF3tcDdfM+LHO+sJJH6qdsodKVH2De59Gzgv8X4UVsIYOahMTfX3OiJdnPqiDlK+Yo1F3Z6+/mEFADKEW5cQNfK/+KZHxba9e61iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727107213; c=relaxed/simple;
	bh=qj7DaoRlIWX6NLsPirWOuOANvT+LJGyu1Zv9Q2wmZwI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TRW4R8XvpIGQORIvP4uE7VRxUtCc8Q8yX92FNnT+hc5O/mxMP3lOsc/HB/5FwZudMa+/wLbqIVvuY18jyDvRsedWW5oNKHW0xJyqiHy2medQ1sL9WuVaQ6geXrisvuESHDcVWMp4HkCJIyB+nl2d8Qc07EgQW07f91LNmicfk2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JXaH2H3E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXaH2H3E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727107210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6wufZYUaRfdDOylxiBpmrq0uRSbAgGnFclsfc0VtO7c=;
	b=JXaH2H3Ef9u9XEt1v82QLIvrSdViWZOxLvuGffYNrlaMh7gwQ4t285w/ul/fLuXbTX1r2r
	OMambc9+IQC6KPvvDV5YTCQhrwmZ5wglyBT69qmo5If+um/H+LcdfvVbcIarktJGD4APy5
	Qspj5WNFISDExQpn7QJmsQuF0+ZrqQc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-fG_seZ7NPmOCVFXjPOnkLg-1; Mon,
 23 Sep 2024 12:00:07 -0400
X-MC-Unique: fG_seZ7NPmOCVFXjPOnkLg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A2DE18EA96C;
	Mon, 23 Sep 2024 16:00:05 +0000 (UTC)
Received: from [10.45.226.79] (unknown [10.45.226.79])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3ED9F1954B3A;
	Mon, 23 Sep 2024 16:00:02 +0000 (UTC)
Date: Mon, 23 Sep 2024 17:59:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dipendra Khadka <kdipendra88@gmail.com>
cc: Ming-Hung Tsai <mingnus@gmail.com>, agk@redhat.com, snitzer@kernel.org, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return error code for failure input for sscanf in
 parse_cblock_range()
In-Reply-To: <CAEKBCKMv4-dhWU=a2UnX2rBcQjVTJcF+wg6z6f3qtjA4td-62Q@mail.gmail.com>
Message-ID: <28e1f99d-eb8e-2357-0afb-a9bb0d5b0a06@redhat.com>
References: <20240922164702.49615-1-kdipendra88@gmail.com> <CAAYit8TfBD40aRchLiOWsvqwpAR0x6nW9zObza4vLVzg93N+eA@mail.gmail.com> <87139a89-4256-fceb-5ca2-c1077b036eef@redhat.com> <CAEKBCKMv4-dhWU=a2UnX2rBcQjVTJcF+wg6z6f3qtjA4td-62Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-612676868-1727107203=:2868575"
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-612676868-1727107203=:2868575
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 23 Sep 2024, Dipendra Khadka wrote:

> Hi,
> 
> On Mon, 23 Sept 2024 at 20:55, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> >
> > On Mon, 23 Sep 2024, Ming-Hung Tsai wrote:
> >
> > > On Mon, Sep 23, 2024 at 12:47 AM Dipendra Khadka <kdipendra88@gmail.com> wrote:
> > > >
> > > > Smatch reported following:
> > > > '''
> > > > drivers/md/dm-cache-target.c:3204 parse_cblock_range() warn: sscanf doesn't return error codes
> > > > drivers/md/dm-cache-target.c:3217 parse_cblock_range() warn: sscanf doesn't return error codes
> > > > '''
> > > >
> > > > Since, the only negative value that is returned by sscanf is -1.
> > > > Returning -ENVAL when sscanf returns -1.
> > > >
> > > > Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
> > > > ---
> > > >  drivers/md/dm-cache-target.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> > > > index 17f0fab1e254..c35d65e310d6 100644
> > > > --- a/drivers/md/dm-cache-target.c
> > > > +++ b/drivers/md/dm-cache-target.c
> > > > @@ -3200,8 +3200,8 @@ static int parse_cblock_range(struct cache *cache, const char *str,
> > > >          * Try and parse form (ii) first.
> > > >          */
> > > >         r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> > > > -       if (r < 0)
> > > > -               return r;
> > > > +       if (r == -1)
> > > > +               return -EINVAL;
> > > >
> > > >         if (r == 2) {
> > > >                 result->begin = to_cblock(b);
> > > > @@ -3213,8 +3213,8 @@ static int parse_cblock_range(struct cache *cache, const char *str,
> > > >          * That didn't work, try form (i).
> > > >          */
> > > >         r = sscanf(str, "%llu%c", &b, &dummy);
> > > > -       if (r < 0)
> > > > -               return r;
> > > > +       if (r == -1)
> > > > +               return -EINVAL;
> > > >
> > > >         if (r == 1) {
> > > >                 result->begin = to_cblock(b);
> > >
> > >
> > > Could you please clarify how to reproduce unexpected results? From
> > > what I observe, the kernel's sscanf doesn't return -1 on an empty
> > > input. Even if a negative value other than -EINVAL is returned, it is
> > > handled by the callers.
> > >
> > > Hank
> >
> > I applied the patch, but I deleted the conditions "if (r == -1) return
> > -EINVAL;"
> >
> > sscanf in the kernel doesn't return negative numbers.
> >
> 
> Do I have to send v2 with
> if (r != 2)
>  return -EINVAL;
> 
> or what should I do now?
> > Mikulas
> 
> Best Regards,
> Dipendra

You can do nothing :)

I fixed the patch and I'll send it to Linus in this merge window.

Mikulas
---1463811712-612676868-1727107203=:2868575--

