Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048D1A83E4
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145921; cv=none; b=ahfiMxWG/t6q+ieNiCR7HxupB1FPLKKl440WPiCMSF2zkofRRr7ESR0U5xQxMpbclWiH3l4xFmXD28/3ZmQMBGKEnWlCBws/DxRXoT5lH9ilGVVQbxG6Yhla/eDrgT+7Bbh8LKoJUTBhx3BJ+4yqp2E1q6metmBndGdBI9exnek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145921; c=relaxed/simple;
	bh=flbCUDmVP6s0lQdmr37xAAe4IcPwbRBgv+LxjAXOvjM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jDBDNgJlgznCiGjdTXVYbG93gSVMDQooMJuEGGy75cPbBMtoxL4XuxB+Sl93SAqXOGwjDoej6ZhYj14T3PsPMnnHWNHaIh3Z5+GNn7VNY01MOdD1e8V8nwjZwS68yc+zgqRRk9ni0YoaaO8Eeg90CjWyyS6j8k0T17cY1T20eNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W2peV5nk; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W2peV5nk"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3862d161947so1406601f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145918; x=1737750718; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=flbCUDmVP6s0lQdmr37xAAe4IcPwbRBgv+LxjAXOvjM=;
        b=W2peV5nkAs9GK6mWX4u7A0LuMJlklbnxmCj0b+v7cAbYfvpNHfqMGX8E3+yDKPtxv4
         WxD1nzGaNHakA9I54+1xw2uNxzVmSPrlGWe5+RmLGfuY/2rRLzA+No5nsMncl03V3mpj
         w6KkjAkrPFDR0/yQL6eIWbVVsmmAUq22mhAh71csWAugVcmpMlsWMKXtKtSCb4NVU8Uo
         7btfI0qFvIR0ltR4YfmdvY/5jk0a62HBE90K8CBXQfzunI7+D+Zw7gOqaJpFHvW8Ns3k
         xJCfFN74/NFZmu2MFl7a1+URd4gwhnANjNLqPSOhPLEca/nvLcSToRBhZa4s7VKNqv+a
         GKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145918; x=1737750718;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flbCUDmVP6s0lQdmr37xAAe4IcPwbRBgv+LxjAXOvjM=;
        b=Vm88Nw4u09eJQ3HTK/kuss5hLZcUBdTytfy8T/8n2mFo+5thYSZ7/mn+ACXa9m+YOE
         gDcPhJdK/uItBKpMSvZSAO98XEkCfGVlO2At6I5E1UcaZJ5XET+dsm5OTDG4Muu4EhRa
         g83B242IM+z9K3QnpdcyZWQ2quF+spEA0xNnJNnACep4/tjGPfpWY0SG2iCEcMBm+yaV
         UK8yW0quYL6BmxxQmvqTGFUBm8e7mdu2wKWef/JOPGXUniQTW3MS/AtYYtTfEePGW9od
         hwjQzr2B+E2FtMjCXVEYEdp26teS6B4svrGQeCjjN8x4lIi0KEuuUvBVUaoiZ/U+GyY5
         BCdg==
X-Gm-Message-State: AOJu0YzeV+T9WhV9Zc6EIboT902GhObXjmeZYxX54/1F3oXqyD5Qer5A
	1Sj8VzNBK7g94oLaF5YgMQ+kuUWPxlzxWhZRdIPkOxjUww3OP3zd2d4KQ3NtpchUhGDPbQHo8cJ
	V
X-Gm-Gg: ASbGncvuIwR6KYkSRSUmOHYHwRfO1lAIKKshnG7fyefNKG44uVU0wtQ00iXLimmlMhU
	GJIlLB7miNNHSCP0nygdF8UUwayetWwGiseJZb/XR8lkcxhiO/uRMCP4bwCOUzX5si0JUD7w7Jq
	5cf8mqxd2s/r+jxz+58cqF8OaaOcXWIbUBd+RkZHYqju1hYneUAAgR49bl+wsyuZIchVNwxQWVN
	av6QtL4i1zlGfQuaXPmEr+dM8qwD7oVio/59ZnAFqfjju4E9BZ5P5N1ChFQsRiQ3BM8khKiuot1
	qlcSfJxArP0Tdjm6ysBcDiSIzmR5ktG9eLNlCVOf0vXf/auqKs22PTy7WvjXl0PQP2Q7I0s+GOM
	T2DZTHXjnYGhy
X-Google-Smtp-Source: AGHT+IEbi1o0q7WYyvyBxTPSiXFrsl6XjBXSSw2IqrU0uTrRNJ9IEvl9t4l7IpxGD59C7bk6MhV22A==
X-Received: by 2002:a05:6000:1bca:b0:386:4a0d:bb21 with SMTP id ffacd0b85a97d-38bf5663c0emr3396697f8f.22.1737145918157;
        Fri, 17 Jan 2025 12:31:58 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221b70sm3308576f8f.26.2025.01.17.12.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 12:31:57 -0800 (PST)
Message-ID: <d367bc44ef71db074b8a57a7552651539e336495.camel@suse.com>
Subject: Re: [PATCH v2 0/2] multipath: set rport port_state on NVMe FPIN
 events
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 17 Jan 2025 21:31:57 +0100
In-Reply-To: <20250116202234.2753960-1-bmarzins@redhat.com>
References: <20250116202234.2753960-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-01-16 at 15:22 -0500, Benjamin Marzinski wrote:
> When multipathd handles link integrity FPIN events, it sets the rport
> associated with the effected SCSI paths to Marginal. These patches
> make
> it do the same thing for NVMe paths.
>=20
> Changes in v2:
> - commit message change to add more detail
> - multipathd now stops looking as soon as it finds the matching
> rport.
>=20
> Benjamin Marzinski (2):
> =C2=A0 libmultipath: export udev pthread cleanup functions
> =C2=A0 multipathd: set rport port_state to marginal for NVMe devices
>=20

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

> =C2=A0libmultipath/discovery.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0libmultipath/discovery.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 2 +
> =C2=A0libmultipath/libmultipath.version |=C2=A0 6 +++
> =C2=A0multipathd/fpin_handlers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 79 ++++++++++++++++++++++++++++-
> --
> =C2=A04 files changed, 83 insertions(+), 8 deletions(-)
>=20

