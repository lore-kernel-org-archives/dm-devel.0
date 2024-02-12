Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E626287
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 22:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707777563; cv=none; b=rzJ43YmJOqLv2ahLZQn4MHI82LsXSSRw184hEbvZEEEil3pJRA6vyWMSjkCpR2PuRZgeI46Jk2mlVmjvGMcujN8a0xWMKfk0yVe3pnqWzsYoxvA0glWhmUfSAEgAnhVt24vUUyoZO4tNYIimziibShndnt+kC1jYsgYova62sag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707777563; c=relaxed/simple;
	bh=DSTpgFi0hGarWjvN2lVfKE68efBi2bnq189fUlmtg0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mRL/WhdcpDWCEQBzh7oGTtxhKIJx1Nj0eUwORQeO+VlBpS0IWijaMKNMsdIyylc8u8KnRp8Yld8kRC1FwTDv8G0u94FvAwY5unUAfFQSew8k4lSgJOjcHRctrU0ORAgbwToeGeK1rcV6IxiRkAuF5lw5hz7zn/7BhTcE45ILJC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PwHdjVD2; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PwHdjVD2"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-42dac9f7183so41821cf.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 14:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707777560; x=1708382360; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DSTpgFi0hGarWjvN2lVfKE68efBi2bnq189fUlmtg0s=;
        b=PwHdjVD2r+rXlnNk/Krg7cc3XE7xW/U5KxTMN1p8bvctNqynGp6DMWwYRu42K1EttK
         N83g3A04suIC8duYqwRyonSM26W3D3LkUddxbOHLrIySC71mwd7rGf4Yy4RVgIOx10rK
         7oIiOBNsz2uscTrOMUR+WD4L1MA0GUtVPQvMoPZzCDTqWNbZCmQVK0veTMrzRxC2gSL9
         RnLmb/zdSfMQ3ENQ2QzDAFG7ThR7i4P1Rl0Gnwid+hbKxgAW5+YCCtIFw9KBaH92epvJ
         nY49yH99qvs0BbEkFBqhfriPuUEyAZyuhONy7//V/ORm3BymZONNmdU6gF9NEykEoEJs
         HeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707777560; x=1708382360;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DSTpgFi0hGarWjvN2lVfKE68efBi2bnq189fUlmtg0s=;
        b=iATG/4uMu02eXt+jzPEqo5sd2azr9lSy85VrrT5whR9P4bQQ8UMo8WnNz6sTH/S79i
         a3OjwuaMTVS3ocpPPVYd4NBOA4TB2Pq+acWDZXNCX/wGwi4bn8ts4mu71/ZbZ+K9/y40
         H7PfGFBsvWUr6H2YDE8tXz1+ZM+cW92IRjldZZAW26XmDQzlO4142BTd0qCAZ+Gs4gBZ
         vzGYrW1Pg7EGiHeRs97ciMGHsWBBdogzX76rXtbpMOEv9whaah5EpISeGHE300isu72w
         ifMBkqyQ7+2Mv/8vqW3uZF+KFto3EPPZIZG4jFO3U6vfeNLihnd+/K3Kf+cgu7Ke6k1R
         Wdeg==
X-Gm-Message-State: AOJu0YxA189RGieC+Sbn8Mq+zyilMTALGyOTJyt6Rp/Jkc26p+eUiGKN
	i+UOthMN9mLppqSIQCHeO0F+q6D3u5EDAinzArTmQvy7ZQCp4ffd512igfuTCiOECl67Ao0z0fh
	AtZD22Zy/JxmOHfuQZ2PNSLJ0ISNjITlN0p4v
X-Google-Smtp-Source: AGHT+IEvdQndILyU0yLsK1JmFeStdZtm8LhMnIkzmxUPgo1OUPba+BgwGeQHluiOzJy1PIxXYsSoS+FPJnlkbqs0ZEg=
X-Received: by 2002:ac8:4f13:0:b0:42c:6905:c449 with SMTP id
 b19-20020ac84f13000000b0042c6905c449mr39135qte.12.1707777560338; Mon, 12 Feb
 2024 14:39:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CACGdZYJ=djg1yDbZxd1AjH1Qa7rWa=vj8Swz33oFCsG63DsVWQ@mail.gmail.com>
In-Reply-To: <CACGdZYJ=djg1yDbZxd1AjH1Qa7rWa=vj8Swz33oFCsG63DsVWQ@mail.gmail.com>
From: Khazhy Kumykov <khazhy@google.com>
Date: Mon, 12 Feb 2024 14:39:06 -0800
Message-ID: <CACGdZYKdr9UVBvDuc-f5K9JzChT-hcseiSrsnVCp3Y56wznS+w@mail.gmail.com>
Subject: Re: dm-ps-historical-service-time should probably set QUEUE_FLAG_STATS
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000ddb364061136f254"

--000000000000ddb364061136f254
Content-Type: text/plain; charset="UTF-8"

(urgh, apologies for the html)

We use io_start_time_ns in dm-mpath.c, but the only actual user is
historical-service-time currently. We need
blk_stat_enable_accounting()/blk_stat_disable_accounting() calls
somewhere.

I was considering adding a new multipath feature flag, but we already
have "DM_PS_USE_HR_TIMER", which seems similar in spirit. Would that
re-use make sense?

Khazhy

--000000000000ddb364061136f254
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPpgYJKoZIhvcNAQcCoIIPlzCCD5MCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg0AMIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
SPh60fMS/BAZAfowVwYDVR0gBFAwTjAJBgdngQwBBQEBMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUF
BwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAMBgNVHRMBAf8EAjAA
MIGaBggrBgEFBQcBAQSBjTCBijA+BggrBgEFBQcwAYYyaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5j
b20vY2EvZ3NhdGxhc3Izc21pbWVjYTIwMjAwSAYIKwYBBQUHMAKGPGh0dHA6Ly9zZWN1cmUuZ2xv
YmFsc2lnbi5jb20vY2FjZXJ0L2dzYXRsYXNyM3NtaW1lY2EyMDIwLmNydDAfBgNVHSMEGDAWgBR8
zApo16LrHixyG9HNXZVvjfvyYzBGBgNVHR8EPzA9MDugOaA3hjVodHRwOi8vY3JsLmdsb2JhbHNp
Z24uY29tL2NhL2dzYXRsYXNyM3NtaW1lY2EyMDIwLmNybDANBgkqhkiG9w0BAQsFAAOCAQEADOZ8
1d6SfBe6MGM7BIlBPciQOrQUSP3rMxR9IE7z3I8RKn1UhC2fZsBwS90WZslOrHe4noODOUIgLEBx
R7b1mDlfU/lqCYTSUVRwXLAq/pn9IOyciHvLwN5MUx6rmSmRK618tzTVuD+qmFP4kMULdZe9FNBZ
PUKVmJrtrPKvOHNkrlJiVcwXkAAyOkwIVYAmFvCmi2GQRPmB/sFLFXQ8fGgLSFL9KuRyJW5nKVCK
xOH0gU9pHCw1g/FCYilgOAckCr2dolz81fhW9l3OKxOrl+qJ3RhQpKQTDjUgxYoSCxwQ49udL4x/
3puQPCKgQeylpHKOhHAnXNa1hxaF02dNhTGCAmowggJmAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAX
BgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01J
TUUgQ0EgMjAyMAIQASMN+3btH9LyJdhI6aKMFTANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0B
CQQxIgQgP3nqv2ONAmR6QEMgSvAZ1q34O3n65z3VyQcTkdnOuQAwGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwMjEyMjIzOTIwWjBpBgkqhkiG9w0BCQ8xXDBaMAsG
CWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3
DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADBJ209bvROn
qd7TCeugmHM8vR8CAEeFoSuW1O13IZytzIl1kVY35AK4OV8Pa6tY78Dw3FPrs5AnfKerB9Rl768O
TVpUADlgM+adb1C+9ibU6HRTybDtgoApY8GzdZ1jUbnvIpoLTHEwzocCp3fxKB0EhGaTaBK4IPmb
a8mHZGFm/3Ul4joXbU4I5V4ckDKhNfXrUn9ERSkbbUIGYZLlNRf+gYdKWXs8Ty4fG1v1v3/+HQ7A
bgNsvAGpdVoCxABM04xEAqCTSNSQoWIAAwVZ+y+ZyTsu3a/HHD1OQzRxAw5tEjMY6B2pm3V2zCKs
KyY0tJzUyF32fORtQxfcYKxgzjw=
--000000000000ddb364061136f254--
