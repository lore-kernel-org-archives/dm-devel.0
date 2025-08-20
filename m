Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028B62745E
	for <dm-devel@lists.linux.dev>; Wed, 20 Aug 2025 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755717321; cv=none; b=OoxyELV+Sl0vv7a85iiHjxKRWktpLxLsrbmSFav81YCunHFuXQSQLYQquPG8bZROHds4X63hlDUzkPKreExcfZLwhhKcsqInGioDhU4TvE2iY2cLjEFq/wKETr/0a6MsVWQbKt6SVFKB+9ZUQWjw7x0NQzkVbeOUdYRt1hsknss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755717321; c=relaxed/simple;
	bh=Twx8BDIeo3GjdZAr+DKOvj8AcBrP78P5X9/NP/DwJ6A=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=qmEvqD/3uQwep/S/vrQEMbHOupmV58gIJsfJA4Qxt/yK5JNdxASU8HeyeJaY6dBYX4hQfFelkaLTxXg9HMGOCM7gs8ij1Ufeqw+DZTmp1jgRmIzAaQ1eww9PI+YyctMOv4b4vyetacUYpynz5LoerN/1QtACi/UACGJ3yUT1k3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RU2g/0Md; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RU2g/0Md"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e931cddb0e2so210723276.3
        for <dm-devel@lists.linux.dev>; Wed, 20 Aug 2025 12:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755717319; x=1756322119; darn=lists.linux.dev;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Twx8BDIeo3GjdZAr+DKOvj8AcBrP78P5X9/NP/DwJ6A=;
        b=RU2g/0MdYEWgf3ZN5Vvsa4jw5qrJU0aiAFJOfFxp4ewWW/N4RJH7jN1MLy5Pax54ax
         wHC5EsDudKNq7s+MqvqEOptbolVSVkfOP3ewBWyKZ6puthCQvBD+gPSkyWX0v5ZDQINP
         ZUO+sX/r52cWvVrWZ0ZcnoHa+T8A5+SGyWLk/Dx5ny+uLz8QSn7l0vmP+C/Z+stoQz78
         KhwhguOGYQObZW7j/RWFrVJk1D9E8DfS9TVVq6F8dV+gF1NLlnDcOmFSg+VjFuyvV/va
         LRAguIh9nQ/djfAvopAjXEdJLRoHHv8nPz1fzyON3sG8dkqCifMqihGTKPStvNHFK0Dk
         /1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755717319; x=1756322119;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Twx8BDIeo3GjdZAr+DKOvj8AcBrP78P5X9/NP/DwJ6A=;
        b=qlWf7hu7ZHK/9WU801BqLXiBZf9kU7HJEyob1Aq5ALj3tLc7YDkb5Q/mgJamiM2Uxz
         +aLBcHjSMhq5lbUcZsJl2x+Q1xyF8tYKCppxGB2tyGAtEZq/xPCqZpD/MayVGWsvucBG
         Erk0Xm11RTbTbKv1VkfLQn0l5PKkx+cE8VmSSgySIfWfVVoZQWGG24hEKzuZ2IEiBMvl
         M5QXi8mbqBzzXWs1mH0mPOccfz2MmzjlcgkG32Q3Nvy+uMCig/gLKFd7eytBetpkeFol
         S3uSkG4YEGKS5WSjtFo7l+zPezvhsNQ909Gt8RazdrCqlZyPp3RMU8WptGOiMeLHrvFW
         kMKQ==
X-Gm-Message-State: AOJu0Yy7UOr82ZJSaFXjsrJuuCa9VGW9hOGWZdfCFmaysLth6XS3fkQ6
	AxpkqCI7avWvDIle6em/WB4eLvPAX/aRO0axNEYwEZ7t1FfGaK84dzSuZVPZSI80
X-Gm-Gg: ASbGncsWYQhqybh/OAVgoyOt8lKBe6uKFI56aH1oGMWXdz8FqChUNMsqsuWLoqqGY62
	YwV1sWSCsiID29fcDHK4CGyOJ60UBm/ssiSQHxmxVSVOowe2YKKqACAYv71UfyKEae9Be1TlYo3
	VFsbSU8n6DYpa7SLT1caggbv1VjFTxwTJZbOTj2utHqyB7E6RuVQklqX9Eiv9mWLepWz34mj6Ns
	3rsJiGJaWuqikNcVg5K4K/kX5pfgOXEZSJJWz7Ju6MgxYjsU6kPcppzvq1N+llKGQmmpRGO/YLU
	PfR3acFS2hqzA/c7ZqRZvSKjEkGM6jk5uX3+WknaGgQYGO2za/k+Ztdvb5Et4WmImyiYWgtFeOt
	w4epc/tusmkfuAmzNX3XjG03Y7FsGMzIjTmQRpYK/8YYEWStbg+hMMur/63NbzGO1aPwYAkSzsj
	jkHrFKmg==
X-Google-Smtp-Source: AGHT+IFTU94lWtiNA63J+1XQAfG1IEit5BtNbMzCnpUFjvPFqJwxyhrcP6Vd9kO2F9+6kJSxGFSXhg==
X-Received: by 2002:a05:6902:620a:b0:e94:2e5f:cb99 with SMTP id 3f1490d57ef6-e94f672c86amr4396546276.27.1755717318334;
        Wed, 20 Aug 2025 12:15:18 -0700 (PDT)
Received: from smtpclient.apple (75-3-197-93.lightspeed.miamfl.sbcglobal.net. [75.3.197.93])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94fa4aa84bsm799040276.19.2025.08.20.12.15.17
        for <dm-devel@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Aug 2025 12:15:17 -0700 (PDT)
From: Giovanni Francesco <gioflux@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: RFC Request: NVMe backend support in dm-pcache
Message-Id: <CBAE8F39-7448-43F1-AA8D-1F4457530970@gmail.com>
Date: Wed, 20 Aug 2025 15:15:07 -0400
To: dm-devel@lists.linux.dev
X-Mailer: Apple Mail (2.3826.700.81)

Hello,

I would like to ask for consideration of adding NVMe disk support to the =
caching layer in `dm-pcache`. At present, `cache_dev` only supports =
`pmem`.

=46rom my perspective, extending `pcache` to support NVMe devices (along =
with an LRU-based eviction policy) could make it a strong alternative to =
`bcache` in certain use cases. For example, `pcache` appears to work =
without requiring the backing storage devices to be reformatted, which I =
see as a practical advantage.

For my home server workloads, I experimented with `lvmcache`, but I =
found both writeback and read performance unsatisfactory compared to =
what I was hoping for. My test notes and benchmarks are available here =
for anyone interested:
https://github.com/TheLinuxGuy/ugreen-nas/tree/main/experiments-bench

Would adding NVMe support (and potentially configurable caching policies =
like LRU) be of interest to the project? I am happy to assist with =
testing or provide more detailed feedback from my benchmarks if that =
would be useful.

Thanks for your time and consideration.
Giovanni=
