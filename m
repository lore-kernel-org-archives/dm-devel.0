Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8425A347FEA
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 16:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769446596; cv=none; b=p1nS3xqkY6+kkYUzqp7udw9rd6F3YQz/P6WzBlxlcJjZtleoJ26cob/aeTWftD+fUAWP3v8i7kBDTCqlUYRELIx3HLFRXcm32DfPp5CxWla6izDBoAShwSI3vqmZu5JVMO24I0OwsfaspkRBENLkEPjX/n1RXXRNBHBgiCEp010=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769446596; c=relaxed/simple;
	bh=j6YocmqoNoHwC4lNNSRLqCtxxUEk8b0GsCPyBT7tx0Y=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=ahU2MJQgnCYI+Qhj0ub4FCFa2f5t0m9oUfukNrMtsow/OrN7XsnTjS4HzqFgeIPAdwUuecsLccbV5iJ3ZmvzV4GldzySzGKMYHPrEmyL41Af4kWwsjrMIeqQOmbZKIgAEJXf5HLx1V9MApd8ELk10bzTi2rk6AWD7mKyOswxmZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FQWYGy7Y; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FQWYGy7Y"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42fbc544b09so3332579f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 08:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769446592; x=1770051392; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=j6YocmqoNoHwC4lNNSRLqCtxxUEk8b0GsCPyBT7tx0Y=;
        b=FQWYGy7Y+wQzoFpMnSkYfyFUJvX6HEznnwQsTxyGG+vFXzXXbUsgsgVs2BdzuK40PV
         NoqpX1NAKMta+X3rI6nxv0uG1r4tz60Rqk034XHR5ayAWWueE/jkUkmbIchyXcyGOhVL
         g1kK9ieMxF2fRzQLI0QH2LeqRbB43JvFDLV1SNAtDh2JXJpajpN73cNYPTJdSHFqVarh
         u5HJUaB4HGy/u/JFINR6aBWPfho+Qqic5UXlU8VI4YObcdpvCeOJCJJmZyg0du97MNEK
         wXS6gtwvBMcZr4ToSkl7hvX8jUkuKXLiO/lq5+Hpxeo4vx8G4lVvjcfGo/tTkpVoKpgJ
         sgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769446592; x=1770051392;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j6YocmqoNoHwC4lNNSRLqCtxxUEk8b0GsCPyBT7tx0Y=;
        b=s9HJXtMcxFeI+jlo9/xTwGSP+8gTicPOf5GG3Dr/EoMw+7aad8KpUodQmOM2v0qI5L
         xby5Scfdgib+syqrdc05vD9C2KjUe/5Ow3wNQu0OSmlGROKaGMTCd8lhjLz1p6isPVzn
         WDBluYbtP0J4bDFgeUn7EKqxgawKsilJqWdq6eio/IFTpI1BEgxdTVqw3bUC47VTkaOO
         cYxHfymhgsgy9SEqSTvnT4BmqdbhAqDTp/N0AwakEn6wCf26NJP3BX0leZdFGbV9m8NI
         MHXUBIUzobENbV0IkOvzeXZFiuLzrIvEg9sIhqYAnjQwJkVvQmZ7NWrkTWhIe+aM71Tw
         bNAA==
X-Gm-Message-State: AOJu0YzWoTMxGDKAlGdhIgSsj2KGGcJ3nFL5xlbggTcZeAopZxMs/LZZ
	cactrnmL5xsTkoaBKy0MVM4uOcKbRbZUrmnRch+3CL1xQFXUIunaNUpYDqjxH5HmQN9yB0kvhlA
	EDyxO
X-Gm-Gg: AZuq6aIVd10n+w4UuIJWxJob8fJW7dqq0oQ9CSZQaQbsK+R6MywhlUTRvZOpV5opBI+
	eJMoFOCbY+AnI0B+PcyJOlFeb9CYDhKYTq+Rm0vsEFxKtNMag51lXuphOB5gWD1+kPlTpw3pZHY
	wEqqRD8ohr2cnAYM6zA5viu07cirOSCtdp9cBh9yuIAPDknUbMx5Gz7p9xMDsqwpPuBEl214BKc
	Oo/zg5HfVIZrp1FVLPmqGW6hW7HfSRTxmlKFTKoRG1q0GfmY2sQMWbeKGqaW73Wo6ExKE3NVcVO
	QtKul/1ok65ttwsLaT0g38cYF18Tyonlz5dYlzY+EzV3scmDEU+nUFs5t1IeT16H1a1AAb36BzI
	Zs41rw0AznVZ4KU2/yqyjMbUZzpHmx1i6vfwmSyEvL+P4cnaTc0u2KNpWBVxHWEn2y0d8DtbBZi
	OEGea3pku5DKCnzL+2rwgPczEFibgzbeTD0ZsV+zNkle5COLWNureIPFnzdtmOdeeInTYyyd09t
	DvrdHg1QUO0JMd74yVfXuUYdl6qAJDv2ab6BstjD4jq3xg=
X-Received: by 2002:a05:6000:4210:b0:430:f6bc:2f8a with SMTP id ffacd0b85a97d-435ca138f6dmr7927752f8f.47.1769446592442;
        Mon, 26 Jan 2026 08:56:32 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24ac1sm31146963f8f.14.2026.01.26.08.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 08:56:32 -0800 (PST)
Message-ID: <938bceda7592f9257ccee0533027ca6c2f861d31.camel@suse.com>
Subject: multipath-tools 0.14.1, and new stable releases
From: Martin Wilck <martin.wilck@suse.com>
To: device-mapper development <dm-devel@lists.linux.dev>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Date: Mon, 26 Jan 2026 17:56:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hello all,

multipath-tools 0.14.1 has been released today after a nasty bug was
reported for 0.14.0. *If you have installed 0.14.0, please update
asap*.

New stable releases 0.13.1, 0.12.2, 0.11.4, and 0.10.6 have also been
created.

Please see=C2=A0https://github.com/opensvc/multipath-tools/releases for
details.

Regards,
Martin
