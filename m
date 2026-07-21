Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460DE37205C
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 11:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784632686; cv=none; b=CTn+cJNcXCGTkg8d6fFzstOxV4OxEozr4/YfFsp2AzjfsvVbYINGm7Ii/YOj89meo5KfI3NJzw25L39W/kJ7J0K88PMaI9hfZx6i8dO8IBwiNZRPxfMyD5+h/w+n0BonqdrZoVbDm1YNUsn+vN0CCKJzikhvX0e+mv5BcShdodo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784632686; c=relaxed/simple;
	bh=+lCp79zy/Rwqi85YLQRC1zBaX6r3P1g3KILUHS4A0ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oqZ4ou6zrZG940FnwXDz/m4x2AT43YR12EOuoxXd55FE0i0P70PKUeo8DlAA2ztjKdH2NC6CxP4tdCbkUWIMSH1+10OLd+/0oRYcocKiiwCQQBOEPNpkD18KuvWm7XwmsuX5sGONOJ2cfp2RLqc1j8XECwFKWZmhlLxcso0p9h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwWtApVO; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwWtApVO"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493a6258788so10033575e9.3
        for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784632683; x=1785237483; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dtcNHkRaLh2ZvPIBUqu2N5xhk2XEZbS6vZO+ROj0LBw=;
        b=NwWtApVODkg8r9W+ChICjt7+bqWqB5qdOdr7pyT5S5OG7fSdmEV1M8uyANcpDb7Bam
         dnF50+s8EicoIaz9Ye9IG8ohSXenXpuKYclvg/qNyWo9FMtiw/AT7nnVQEwduL7nsK+D
         U02fJHuLl7xjxunnC9/AikeNS+RYQTJKEAkOo/uF03O4qd0lBpFaXO/e/+ntsaIA8h9Y
         ItRS2J3iD1q9Z4Jz+2iP3HJIliRpLcgwrg/K7n6rmYEfV9py9D/m+OPrdCWG7wVsRx+7
         4z72obBfPkeaPZB4Z11m8KsB1NQcRiKMonArvyTZXzZWfBM367ig1Ff0SfYlFom/d0rj
         xXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784632683; x=1785237483;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dtcNHkRaLh2ZvPIBUqu2N5xhk2XEZbS6vZO+ROj0LBw=;
        b=nbzsBmNqyReaotxs96ZHVB6XXbo3mnpZg4O0TMBrwVZ8mz4uxhgXDgnE3qFv3DpbOA
         ljzTCzuyMJlhVn+zeSvA0fBOhlvvDePpz70zszBe0opdQ+fIBl1czOghRd9GtWoyErT/
         j91gBO7/AqKIcpBRmqTPgjQ4r4ru11H285P51ADqMmYkAb4HaQmETgPh+H5bs5sTxT57
         B+nFLcBjP4rEideL1Hdoxi75pf3gcwrLm0U7r5bqAj6rP04hnNh4m3SXk3ukbqU7fNCX
         stsOp8tcwV+oMPd3bb35Zlc3MLo0Nrms0cYfg+wvA/7reT14zu4L1lhfejxlW9Qc6L8x
         NytQ==
X-Forwarded-Encrypted: i=1; AHgh+RoHDMT8QoHKk5UROnvxObr0lTcNMzbSzwwEvsy2zbodmO+0mlu3DtDJ8jW3DIYo7gjjicS3/vqvDA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwBnS70nIokFFbZwvrJjgyY8bcl1Co1fS1LaRqD+0rR9usFWtrf
	GBoR3uroCCMcF/5hkUKt0sK6pK0eKsEY7YOxqw9YlJ9ry7XjEpfgqsg=
X-Gm-Gg: AfdE7cloVU2dzow+udCyAJHKTtI931JG785gqj06lEN82H8E353Uo/c/WU9n9Yp1RoR
	MFpoMuz6FMoF9aiZ/sV9eak+8dX7gKQX3El35Ci+fsYHwPVPlleEEimOUw72iTEHm3K+EqDYsTx
	CJk8CEHvq+iYUo0/F0jgFSS1ppC7ohykdwue5Wk+zwe9Ufh7LaOann5iYRJRzTxyD+jppWuP2Xo
	HwHw/5pAkuOTy/4aHiCbG9vpnXV2Oqy3cz/e7G3cc8Q1waJuF+WfeCZK6Wft6jw0RW/sehprskQ
	3hnFlTnKQWw25QfU4s9IBV4H3BEI708qTYce3Or0qS8nQrI78JoAibXnkn0BpvwaDa5RrbS6dRY
	Y1o9jzA/ptsNkJ2VM0OebN85UnV30wBFVmC4U1yCiJ3XbCG2IINWGFwf54rXePhlWSRQHZFcmzU
	C+mV3YfwwL4tSDoFJdySmzVJaFa5dqNXTeWcAQZHTqhT4=
X-Received: by 2002:a05:600c:4f09:b0:493:f7ca:bd6a with SMTP id 5b1f17b1804b1-4956599e049mr16758325e9.8.1784632683193;
        Tue, 21 Jul 2026 04:18:03 -0700 (PDT)
Received: from localhost (19.red-88-28-172.dynamicip.rima-tde.net. [88.28.172.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e65644sm36694912f8f.16.2026.07.21.04.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 04:18:02 -0700 (PDT)
Message-ID: <49c8f713-77fb-4e86-ba02-e98c25319c22@gmail.com>
Date: Tue, 21 Jul 2026 13:18:01 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: Obsolete features (was Re: [PATCH 0/4] minio cleanup patches.)
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 device-mapper development <dm-devel@lists.linux.dev>
References: <20260615190711.797573-1-bmarzins@redhat.com>
 <8b715fda-3e14-4a6d-bba0-a3e53481f567@gmail.com>
 <ajCDBM2lH7NvcuX8@redhat.com>
 <50a665f3-8bcc-42bf-ab33-5cdafa70440b@gmail.com>
 <467670f5-2a5e-4051-9d24-eafa15e2f565@gmail.com>
 <al4_1Ad2useO9bNR@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <al4_1Ad2useO9bNR@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/20/26 5:33 PM, Benjamin Marzinski wrote:

> On Sun, Jul 19, 2026 at 04:57:00PM +0200, Xose Vazquez Perez wrote:

>> Another candidate to drop is the retain_attached_hw_handler infrastructure:
>>   ( grep -Eir "hwhandler|hw_handler" )
>> Since Linux 4.3, the kernel always enforces "retain_attached_hw_handler yes".
>> Because this option is completely obsolete, could it be dropped from multipath-tools?

> I'm never sure how far back we need to support kernels. I could easily
> be convinced that we don't need to worry about kernels before 4.3 with
> the latest upstream code. If we still do care about 4.2, I would also be
> open to deprecating the option, and just always having it set to yes.


Only enterprise distributions with extended/long-term support use kernels
older than 4.3:

* SLES 11-SP4: 3.0
* RHEL 7: 3.10
* Ubuntu 14.04 LTS: 3.13
(Note that even CIP long-term kernel starts at 4.4)


Furthermore, the code handling older kernel behavior for hw_handler is
still properly maintained in the respective stable branches of
multipath-tools: stable-0.10.y through stable-0.15.y

Regards.
