Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4680E1311A1
	for <dm-devel@lists.linux.dev>; Tue,  4 Jun 2024 15:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516007; cv=none; b=LgiaJrpmf6iFbsbyjff084+C+6vdRlXcOARP5O55svqHzPnX3CU7thniYlaU8rCJQ3VnGwFs/sb/aKlDb8CZDZxIOPjXonQm92Pa8SSSIITKBSJhr4iY69bIWulmf2JWkHy1ASxFFDEfne+DlDH7lCtDTlW+XkJsnCOnXT5yVqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516007; c=relaxed/simple;
	bh=tc6h8e0HWlMSI/ALeKg5ODcxvUolnjD8PX+xso7wJOE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fAuhB2k4LaVG5nL2HCaSv+h7Km0wL8WbltT+pm1BFHIC2Tg4LnBJiw0lM9WYcOMg4hYmHYS9+g25DLt8ov9Re92hMnj8tmJ32knUFFdsxK3yXPN//svDUHJWPxtqf3QQdn+hEG4hiBwzjWKwKTA+xvJSOcmW9HZIQ7QeoHWpqQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Mcj+0+Oq; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Mcj+0+Oq"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5751bcb3139so7039484a12.1
        for <dm-devel@lists.linux.dev>; Tue, 04 Jun 2024 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717516003; x=1718120803; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tc6h8e0HWlMSI/ALeKg5ODcxvUolnjD8PX+xso7wJOE=;
        b=Mcj+0+OqTBsaoEcgKKPmcpBxOxaC7SbTe4DOJLzRxdv2wyQGW99Q01RvLzvSiq67U5
         FZJC79wORAdqO7i07qydo/9PU6JTZjums8QC8uU39UoHqvgU7INQbV5GNg7mML+AHzZ9
         kOp0CyyGoKT+ofNVE64Egkt7MmCw4ac/jkkogCFDSBIRjC/JdkQO3LaiGJX4xXDiWcJp
         gKRK7uBMwvJwjm1b3odzcl99fG8ohBaBsf847JodBXkwqi1KmFMQIfdbpF4BdArUAp7e
         mtbtLzd7iXdcZs0zENMgVQkaXu5Kb8Fo8nm5KpCKD+V0Z0eAIwsMeUQCwio/VkH0FsWp
         f07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516003; x=1718120803;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tc6h8e0HWlMSI/ALeKg5ODcxvUolnjD8PX+xso7wJOE=;
        b=C+x+l0SEB0ZLMeEo7S9L0I8J/FwRkIBffrVhu3HAsvIhWRgyOK7nl+AIZ9FPZjLcCM
         KF0xg7dThxbv23hDl3wVsfIR6yA54kEtYuZh35bmMY3+MXDkECgSxdEC3n/0/w4YSI+S
         DEidfoehq/h+zWyN8k3PcyiWJBCtmpg0AAp3q24cculsyjBQJahV7UGMBEv/kMtMqe3n
         YzrrWW4M1f5wrsgKaE1K2zMF8qlvvAE4GR8QlBjs+EyT/2LPUCs8eAsnQFHuZJqUiECw
         hSdKGincITnorTrSCL9rVD98+uzX4Ia+8SsJqWiWBYsuUcTJfK3Tt2DaaadsfpHq0EEH
         6/Uw==
X-Gm-Message-State: AOJu0YxyyrG/GQs81Vjgd+KSnWXyt4FY+eQOp8ByakITq/Ev8RLiQg6w
	DU39hZKo+nPqWIGI/wZFEJ0w8/O/JRY1sNLtKOZD79YWaBSeNT0sW2km8M4TlYc=
X-Google-Smtp-Source: AGHT+IEN+unoe/9J2tGe/nR1VOGTL/wZUK3XEomKjvM1MbvpZvjJdeIs+I3A5ZijfF/RNNEWpgYk6A==
X-Received: by 2002:a05:6402:2153:b0:578:973d:4fc6 with SMTP id 4fb4d7f45d1cf-57a8b67712emr19195a12.6.1717516003598;
        Tue, 04 Jun 2024 08:46:43 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a8134e238sm1504959a12.95.2024.06.04.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:46:43 -0700 (PDT)
Message-ID: <d1b9f76356c8608a5be1b06812061e6ea6c3a449.camel@suse.com>
Subject: Re: [PATCH v2 7/7] multipath-tools man pages: Add format wildcard
 descriptions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Nitin Yewale
	 <nyewale@redhat.com>
Date: Tue, 04 Jun 2024 17:46:42 +0200
In-Reply-To: <20240530165500.397009-8-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
	 <20240530165500.397009-8-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-05-30 at 12:55 -0400, Benjamin Marzinski wrote:
> Suggested-by: Nitin Yewale <nyewale@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

