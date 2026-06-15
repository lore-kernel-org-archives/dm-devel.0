Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263D23B2FC2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 22:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781564171; cv=none; b=MHQDHJibVjArnu2as/4SlOBSogPv/IgqG2GesJTXZHvRPeSRHvUkOq+iouL+n97AGbQ4jXVdHs9qNyDvU5FNzNIdN16gFTFSR38suOOrBpKfUStNYLTm/3HUCz2Cb7SDcHcFB4nitevsS7w1o/TQhf5HaisO9QRo+ZJk3uK6jSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781564171; c=relaxed/simple;
	bh=S8s7mOjEUascmOBDMdeut41cRviWoKyWN0vySlIxbBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=gdnPymIzSPm89js3bk4w5UTyX/uRTZ5R3j2mB0XLseVTHxF5OUkvTFSax0bjVSgCTT43bmmbc6DNc59HSekbmmnBcTNh66fkan/u5kZek84vUEJO6sqZQX4F0jjLVZyfbSdo9u+RYUIcO+PrgU8rYdR/hLeDMYESo1FcLwYyFlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0WA9w2T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0WA9w2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781564169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZKDbTnzzGvyqFi1IB4PuGxZ8Cq6orcUMtS4uXViJI3Q=;
	b=a0WA9w2Ty1C6LpReePkXcuLH5jNUNZifiVvoBo2T8b2UExMA4k+ujvlc4pRmNB9j26IXNa
	nc5YhQOphBlE4pYV/ibvzGsPGF6yl7tkRT0246W7HHo1VaOtXKSIwb1+jtKWhIHQ86xJfT
	RFUxmy+YXmap1yjsJvx76DgNbCzZPvc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-neMTdBEOO8WY6beTuvwlAA-1; Mon,
 15 Jun 2026 18:56:07 -0400
X-MC-Unique: neMTdBEOO8WY6beTuvwlAA-1
X-Mimecast-MFC-AGG-ID: neMTdBEOO8WY6beTuvwlAA_1781564166
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AD841954B14;
	Mon, 15 Jun 2026 22:56:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC8E6D6E;
	Mon, 15 Jun 2026 22:56:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FMu4UD803634
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 18:56:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FMu4Tp803633;
	Mon, 15 Jun 2026 18:56:04 -0400
Date: Mon, 15 Jun 2026 18:56:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 0/4] minio cleanup patches.
Message-ID: <ajCDBM2lH7NvcuX8@redhat.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
 <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _BT_MnWmyupYjLTsapSoZcv9Qwuo1WX-0pYHrB6XtEc_1781564166
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 15, 2026 at 11:00:48PM +0200, Xose Vazquez Perez wrote:
> On 6/15/26 9:07 PM, Benjamin Marzinski wrote:
> 
> > This patchset is to deprecate the rr_weight, rr_min_io_rq, and rr_min_io
> > multipath config options. It's a companion of the patchset to handle
> > their deprecation in the man pages.
> > https://lore.kernel.org/all/20260607103831.336833-2-xose.vazquez@gmail.com/
> > 
> > It does not completely remove the minio setting code, since there are
> > ideas for reusing this in the future. The final patch is simply a change
> > to avoid a kernel warning message that I hit while testing these
> > patches.
> > 
> > Benjamin Marzinski (4):
> >    libmultipath: deprecate rr_weight, and make it do nothing
> >    libmultipath: deprecate rr_min_io_rq, and make it do nothing
> >    libmultipath: deprecate rr_min_io
> >    libmultipath: don't set hwhander for bio based devices
> > 
> >   libmultipath/config.c    |  6 ---
> >   libmultipath/config.h    |  6 ---
> >   libmultipath/configure.c |  1 -
> >   libmultipath/defaults.h  |  2 +-
> >   libmultipath/dict.c      | 90 +++++++---------------------------------
> >   libmultipath/dmparser.c  | 28 +------------
> >   libmultipath/hwtable.c   |  3 --
> >   libmultipath/propsel.c   | 54 ++++++------------------
> >   libmultipath/propsel.h   |  1 -
> >   libmultipath/structs.h   |  1 -
> >   tests/hwtable.c          | 13 ++----
> >   tests/test-lib.c         |  1 -
> >   12 files changed, 33 insertions(+), 173 deletions(-)
> > 
> 
> Ben, thanks for this cleanup.
> 
> I ran grep to see what remains of these options in the codebase.
> Could you please check if any of the following occurrences should have been
> removed, or if they are intended to stay for now?
> 
> 8<---
> $ git grep -Ei "rr_weight|minio|min_io" | grep -vE "multipath.conf.5.in|deprecated"
> 

Good catch. It appears I misses some things.

> libmultipath/config.c:  merge_num(minio);
> libmultipath/config.c:  merge_num(minio);
> libmultipath/config.c:  hwe->minio = dhwe->minio;
> libmultipath/config.h:  int minio;
> libmultipath/config.h:  int minio;
> libmultipath/config.h:  int minio;
> libmultipath/configure.c:       select_minio(conf, mpp);
> libmultipath/configure.c:       if (cmpp->minio != mpp->minio) {
> libmultipath/configure.c:               select_reload_action(mpp, "minio change");
> libmultipath/defaults.h:#define DEFAULT_MINIO           1
> libmultipath/defaults.h:#define DEFAULT_MINIO_RQ        1

> libmultipath/defaults.h:#define DEFAULT_RR_WEIGHT       RR_WEIGHT_NONE
> libmultipath/dict.h:int print_rr_weight(struct strbuf *buff, long v);
These were supposed to go.

> libmultipath/dmparser.c:        int minio;
> libmultipath/dmparser.c:        minio = mp->minio;
> libmultipath/dmparser.c:                        if (print_strbuf(&buff, " %s %d", pp->dev_t, minio) < 0)
> libmultipath/dmparser.c:        int def_minio = 0;
> libmultipath/dmparser.c:                                        def_minio = atoi(word);
> libmultipath/dmparser.c:                                        if (def_minio != mpp->minio)
> libmultipath/dmparser.c:                                                mpp->minio = def_minio;
> libmultipath/prioritizers/path_latency.c:#define MIN_IO_NUM             20
> libmultipath/prioritizers/path_latency.c:       if ((io_num < MIN_IO_NUM) || (io_num > MAX_IO_NUM)) {
> libmultipath/propsel.c:select_minio_bio (struct config *conf, struct multipath * mp)
> libmultipath/propsel.c: mp_set_mpe(minio);
> libmultipath/propsel.c: mp_set_ovr(minio);
> libmultipath/propsel.c: mp_set_hwe(minio);
> libmultipath/propsel.c: mp_set_conf(minio);
> libmultipath/propsel.c: mp_set_default(minio, DEFAULT_MINIO);
> libmultipath/propsel.c: condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
> libmultipath/propsel.c:int select_minio(struct config *conf, struct multipath *mp)
> libmultipath/propsel.c:         return select_minio_bio(conf, mp);

> libmultipath/propsel.c: do_default(mp->minio, DEFAULT_MINIO_RQ);
This should be mp_set_default(). The generated code is the same, but
there's no reason not to use the standard call here.

> libmultipath/propsel.c: condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
> libmultipath/propsel.h:int select_minio(struct config *conf, struct multipath *mp);

> libmultipath/structs.h:enum rr_weight_mode {
> libmultipath/structs.h: RR_WEIGHT_UNDEF,
> libmultipath/structs.h: RR_WEIGHT_NONE,
> libmultipath/structs.h: RR_WEIGHT_PRIO
More missed rr_weight stuff.

> libmultipath/structs.h: int minio;

> tests/test-lib.c:       /* pretend new dm, use minio_rq,  */
This comment no longer makes any sense, since select_minio no longer
checks the kernel version.

I'll clean these up and resend. If anyone has opinions on what I did
choose to keep around (you could easily make an argument that
DEFAULT_MINIO_RQ should go), let me know.

-Ben

> tests/test-lib.c:       select_minio(conf, mp);
> 8<---
> 
> Regards.

