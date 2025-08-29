Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EB42727F0
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 07:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756452940; cv=none; b=UEqfIB1g6pOmj+tW/rTnQIUgLlnmume4COw34WNBZyd3s3kxT4YIBnU7kmiooVnbsJ3bMXuEANxOVyST9Z26qjwkdgyiWOxlUM+sV+NeJD1G4oeuFPzXa83SR2SDlJ5ncP28D6IILhWJNAKHFqEWuW3c//LlN9FJCxltcA5oF5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756452940; c=relaxed/simple;
	bh=7MQHvHE0M7z8IzLWyKW3Lyo3zYk/f71o4/hAi460hV8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XJk18BzRaxMhi5EhQIsFGxyjvnC0HTzAmUY6liu1rdxccHe+OERq6DOnBtd5LtSylJTme6ZIkfU0G3BElq+ITCvif3uEhBi7yN4gI+EGMdtacycRnqkc84vEBNNoiXpiH3N5hccZ410WkNn0PSRFf5OMlfQw9r4CcuqJbI7pz/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JJD2o8ik; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JJD2o8ik"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afec56519c8so291305666b.2
        for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 00:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756452936; x=1757057736; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7MQHvHE0M7z8IzLWyKW3Lyo3zYk/f71o4/hAi460hV8=;
        b=JJD2o8ikk9gtiLqhwew9zjHiiCUtl4wIx/Wq8T2kE21I10R0lbdb6TCxJ3f5Zd6NCC
         NZe5K/WUwTNAKlDGIANfpwijcHGr+1Qr4zfKJ3PooRrtmsotRrKFB03VE4ZWn5bMm5AM
         rTvxev2KIRgXVc1jQDLfijBHgKFBkzplKk/WeYf5BQgzw613GFxXNKR0/0rQTb2GlWHg
         a/1As0jTOrYZl+J1vJcM0xPbyfTdt1oVTJNqPs/D8dTFL+afbjrzb3+m2Lnrq1WfZy4e
         UvGWmw25TmejDLY9m68a8v9tx9L4n/vEB8Eiu1C2r767PPVx0zBFkADJMGCoCvgneiRh
         GgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756452936; x=1757057736;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7MQHvHE0M7z8IzLWyKW3Lyo3zYk/f71o4/hAi460hV8=;
        b=luulpXuK9yUJEL/F70T3D/2oidm5wajcKDlrK5uuyQE8e+p7QORp6K8flHUjHs0zOK
         6CuJQLL18HMayhM9LUKkv7hseMK3nHOYozm43+IHw/CXJOiO3h+o4dqyPVwKBPWGyXEo
         b1UwEuVGlrICNM+KuQo6Gs4ltBAR4w4nEFjbfFaLUsh+YcTcVIbq9mFKBB/AA0ALoxDZ
         LiCFNPcsHUzpbBrBpu2oZoEvJV5oo/RgFtQN8s5AaHIxYfZxx1ajTUd/x++CxP+OllNq
         WN9bNA2a6RQrU6kvsOtgd2Sc7pr6QErM3NLn4fXqwEsCOj+ox6/0GToWpU4cLP8fRCNN
         XjEw==
X-Forwarded-Encrypted: i=1; AJvYcCUCO9ked9bobT3M0F9YSwcn21CErQNHKDFEYygmG7kRMxkpeuEeMo1zSlt4b75/PQauHLls7xFJow==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3ZsZ6w1Gqm24RjzrYJDVqSnNo1CasuzfyeD8vPSAQ+DAQyLBU
	sgcybAffcTmxBDyFgzOK1+dYYiNlZ1i6rZ30cyNxp+Iw3bGyHx9/ikoGtGDrgwFSwzR1at3E7N3
	QcqhsL70=
X-Gm-Gg: ASbGnctdTH3RfHWVRl+WvL31d1Z1l7mG14Ichc9Sp380i2DVA12q31tHwYeet2/TmNg
	KyR8sgtSbjYkrAhQ1l1g4N7ZR1bbi67fbELRqF0k4C3fORPMKaV8TPZa+T0Rlfv6hWpPMhlZZqu
	PyAgLCXi85+z7bHa5J+yY1HZEftNKxv0w46K3sWhrfipkOyb93p5FCT5VL9lc+ktu70h+yp5Nd3
	2q3vo2HvysNgSA6XkmQh0GNGlmiZzYaDWH0WX6184+vgWc0naOEsVI7RlvWL76jacz8K3N57Kvt
	1ZAcc9JPzEhoAMLfjCSUfmDNXGCN/pDLNq+8fl/LvyDbMxCVVgrYP4rf1nwlGMOJfgVCxb+A8NM
	u3WH3mZcyJLjyVdSyRz27RIl+oSTCtwiOx5n0e0pF7AKkH1ub3KP13skN6Nc8h4kStm5c+QqiSr
	LwjHUsWFstzXP7S5Ls43XWR5FgS2OXtywR2ziA+yvSfsgz+JyybXGdabsP9hNeqg3Hmw==
X-Google-Smtp-Source: AGHT+IFg1p7I6BHHE+RQo5tm4mN1WQWSBtU/ZLWZU79qOOt1fEK/orup2G0xSKRgnleOeL7PLzB8vA==
X-Received: by 2002:a17:907:dac:b0:ae3:f524:b51 with SMTP id a640c23a62f3a-afe28ffcee8mr2624957066b.10.1756452936417;
        Fri, 29 Aug 2025 00:35:36 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7edb6fsm142840666b.18.2025.08.29.00.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:35:36 -0700 (PDT)
Message-ID: <0c7528d6a18a639583669454d9a06799de8fa681.camel@suse.com>
Subject: Re: [PATCH 12/14] libmpatpersist: update reservation key before
 checking paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Fri, 29 Aug 2025 09:35:35 +0200
In-Reply-To: <aLEgiGGxvEySW397@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
	 <20250726035855.363290-13-bmarzins@redhat.com>
	 <aad385f3a960df921765001f35f1a6f3cf39edb7.camel@suse.com>
	 <aLEgiGGxvEySW397@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-08-28 at 23:37 -0400, Benjamin Marzinski wrote:
> On Mon, Aug 25, 2025 at 06:36:18PM +0200, Martin Wilck wrote:
> > On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> > > There is a race condition when changing reservation keys where a
> > > failed
> > > path could come back online after libmpathpersist checks the
> > > paths,
> > > but
> > > before it updates the reservation key. In this case, the path
> > > would
> > > come
> > > up and get reregistered with the old key by multipathd, and
> > > libmpathpersist would not update its key, because the path was
> > > down
> > > when it checked.
> > >=20
> > > To fix this, check the paths after updating the key, so any path
> > > that
> > > comes up after getting checked will use the updated key.
> >=20
> > In do_mpath_persistent_reserve_out(), you call update_prkey_flags()
> > before checking for MPATH_PR_SYNTAX_ERROR. Perhaps you should check
> > the
> > key parameters first?
>=20
> We could, but the way the code currently is, if you called
> update_prkey_flags() earlier, you can't fail those
> MPATH_PR_SYNTAX_ERROR
> checks.
>=20
> You can only call update_prkey_flags() if rq_servact is
> MPATH_PROUT_REG_IGN_SA or MPATH_PROUT_REG_SA, so we only need to look
> at
> the True branch of the outermost if statement in those
> MPATH_PR_SYNTAX_ERROR checks. We also cannot fail those checks if
> unregistering is true, so we only care about the case were
> paramp->sa_key is non-zero. And when we call update_prkey_flags(), we
> also copy the value of paramp->sa_key to mpp->reservation_key, so it
> too
> must be non-zero. This means that can't fail the checks since they
> check if mpp->reservation_key is zero or not equal to paramp->sa_key.
>=20
> But it doesn't hury anything to move the update_prkey_flags() call to
> after those checks either. So I'm fine with either solving this by
> adding an explanation of why we don't need to worry about failing
> these
> checks if we updated the key to the comments above the checks, or by
> just moving the update_prkey_flags() call to after them. Do you have
> a
> preference?

I gather that the conditional would become more complicated when we
move the code. A comment with an explanation will do the job.

Martin

