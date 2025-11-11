Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D71B33CE91
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762862531; cv=none; b=OpB66Z3Kx322J534Nh69usixw5CmwJhr2M9e5SrRJMy4p16W/JS/4GsmpdDDggVi5kkIR/FvWKM5Iew8V+A/CN36v9XHyMNMPZgbm4RS5vbfYccclngxj+LaxNc8EO8ZR1nS8pYe1z1BIb5QJtJj7krwOOrQn5nZ1bF1Sg24b90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762862531; c=relaxed/simple;
	bh=/0DRRtX7csdRXeNMnDN50ZJiSioLzxz512VFjh4jXHk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MxP+UxEYWcoFgwZYRlDQt9JhUgxgKEKdbNkpDeJOrTne8n8QZS7ldcwOv3UfHC05ypqKaCDYrVc3TqLVt+EPLrgsBWBxTzQN/Mapg8n4zABUEL/FWQugYTLrEq6FYLpEeALYsCS2znL7rKlkHk0y6igCQsy+DcITC0fOZCUlPas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g47Xi+VD; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g47Xi+VD"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b5a8184144dso539432066b.1
        for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 04:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762862527; x=1763467327; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/0DRRtX7csdRXeNMnDN50ZJiSioLzxz512VFjh4jXHk=;
        b=g47Xi+VDvUnlTQCe9zy183KRLD8rBxY+dUmbg7iZkfoK/iqFuIWJ/mcbU84gSEDdOJ
         BsceY1Bjb35PB7NPm1Ddvgr/2JuMFuWdmdn/BX6e4v0sdIQYv+LRktfzeIjfy1ujzMuy
         KOtxCgRTw6WadKM0+bjBK6kgtd6q0h4WQw2reRmB6lUpUvp/DRivf4+Fbp1zoW+L4l9C
         Fk2zHou14tmZRntEZTpyAmjRqk/iNselqoKDYdSGVartMe6+gyq7MsdKlB4BoCZ1JiCq
         A1ZZJvrZ9NF6XDlA82hrHpcnaC13wwXq52r1VmIsG3+9SkL2gU87VmvPWObxzx/9blO1
         6rZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762862527; x=1763467327;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0DRRtX7csdRXeNMnDN50ZJiSioLzxz512VFjh4jXHk=;
        b=ie7ZIEqDtOJvcH3nR8p/iFmh/0Wo3Ueb7Y5NRbiPqIV/YKubluocTlICAaMiURGaVu
         dI42xETQbwIgg080Mbe8ft6GiowE0seFq4UecO2nuxwTFDvgE3IDzQBx9KkuyqgeXKRb
         34NO7SKQ/zCSUVsmPc+WKM5StgAMS0jqgvpCMiRzFz2bmWBlEt1C4sFHFBtbdqrJZWia
         5ETLQ9i00dBDduBfSAap+uUfEeD0lu0k4gf9cBtvvfQGxCjRBSg+iU3XPbsp3bk0WCFc
         /TU0lHPd9pRbcAD2Zd23rR+gVm5AUKcQRP9puyrQ3CBs+CYKKT08g2zsQDqXRik0+t6j
         WTIw==
X-Gm-Message-State: AOJu0Yy2nWpyYCNgyfooHNq8iyDl8MGylJL/ySGLCarlyojOWUehPtRJ
	JOw4YVm0h68HzIXoENP94wWv3n7lDnOGPzSP9BlSCouJrSR8ZfWVqvZZQGD/OY7PWJkN0HaaBtJ
	ASOQJ
X-Gm-Gg: ASbGncu1ici8YrP6IjQTSFE5IxbeMsBAtkP8UOj6hsmtAT4PlZmCJ58pzk1t2ijelk8
	1bzuJZyovMwYm/8F8FD1TDX/qX3L2empLmTCgAx9qY7TcB/uTcHiKqAchYW/+qS5qmRvPMfemmZ
	fA0CYCdjKpn+749Q0PD1PDGt/vhewD2NQYuM2nyy4fAwJRi2T2Obis+l751rCGqtys5J4LlbPB0
	LOP0Li9GiRZb287h/b15qxQNvfprcRPN6cXOVa6Ax4/TlG5QT/OFoV7cq9fPSrfqMXeb6/rFowL
	smwBOIbtmt8g/X+uStRtmYXaDOWpw3vfmrWOl2frEQ4eqgmqLDnN9I16zp5fhBURlta3oaMUtEv
	XvUrybt4F7n5wIbD+pt4xBdH9ZYdhkAvCHbB0DDe6HM6dXVJ4kOl0Kzmte4e+TxyMN49BfQr5yW
	M5nLrVnFlMuaen75UovI1wyIUflCGifQ+I9AVNbb2FoYGDL4Z6t1gsjdabSlExwsmcOk+QzPyNt
	Khae/vA0eFw+Zb4wdSAhTyOhu8cHCA6NDnmN6UtahghdJI=
X-Google-Smtp-Source: AGHT+IFjWN/G5/ETDaKs61hVbd0B6hAAxyk9VJG0x8eh6Frgu/DGLDkAsWhYcg55wFcwJEsiRztJlw==
X-Received: by 2002:a17:907:869f:b0:b40:6e13:1a7f with SMTP id a640c23a62f3a-b72e0377907mr1220268866b.27.1762862527147;
        Tue, 11 Nov 2025 04:02:07 -0800 (PST)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bc09629fsm1379704366b.0.2025.11.11.04.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 04:02:06 -0800 (PST)
Message-ID: <e8caa2b5d707e8dbae143885ecb2334b6270ad95.camel@suse.com>
Subject: Re: [PATCH] mpathpersist: Fix REPORT CAPABILITIES type mask output
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 11 Nov 2025 13:02:06 +0100
In-Reply-To: <d5568bb0fca96dec88ca8fccfc68b2fa8191335f.camel@suse.com>
References: <20251110215156.589437-1-bmarzins@redhat.com>
	 <d5568bb0fca96dec88ca8fccfc68b2fa8191335f.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-11-11 at 12:59 +0100, Martin Wilck wrote:
> On Mon, 2025-11-10 at 16:51 -0500, Benjamin Marzinski wrote:
> > mpathpersist was incorrectly parsing the REPORT CAPABILITES service
> > action output. In reality, the type mask is two bytes where the
> > type
> > information is stored in bits 7, 6, 5, 3, & 1 (0xea) of the first
> > byte
> > and bit 0 (0x01) of the second byte. libmpathpersist was treating
> > these
> > two bytes as a big endian 16 bit number, but mpathpersist was
> > looking
> > for bits in that number as if it was little endian number.
> >=20
> > Ideally, libmpathpersist would treat prin_capdescr.pr_type_mask as
> > two bytes, like it does for the flags. But we already expose this
> > as a 16 bit number, where we treated the input bytes as a big
> > endian
> > number. There's no great reason to mess with the libmpathpersist
> > API,
> > when we can just make mpathpersist treat this data like
> > libmpathpersist
> > provides it. So, fix mpathpersist to print the data out correctly.
> >=20
> > Also, instead of printing a 1 or a 0, it was printing the value of
> > the
> > flag. Fix that too.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> LGTM, thanks.
>=20
> The way libmpathpersist treats this field is totally counter-
> intuitive,
> but it has always been like that, and I agree we shouldn't change the
> API now. However,=C2=A0it is not unlikely that other users of this API (i=
f
> any) also get the byte order wrong for pr_type_mask. Perhaps we
> should
> add a comment in mpath_persist.h. Could you add that?
>=20
> Also, while staring at the code in mpath_print_buf_readcap(), I
> noticed
> that the output for PTPL_C is also wrong (missing "& 0x01"). While at
> it, could you perhaps fix that, too?
>=20
> Regards,
> Martin

Please also add

Fixes: ae4e8a6 ("mpathpersist: Add new utility for managing persistent
reservation on dm multipath device")
