Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6643188A3A
	for <dm-devel@lists.linux.dev>; Fri, 10 Jan 2025 06:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736489269; cv=none; b=K48ZkCq0XEEC3lLtaJ2iUzJerZ5tfgMroJxO5kmJFf1jT4xAZ4TY6P6dDySj4cBgBzQRlmL4V1PbzZu5XTQSBuSZ3NurYf6w8BSG8n26o6PTN6aEJmWCKJLrQCfj+kXMYDbOeOqt0qrRz0hgx4WU04CgKB7fphKnOtcXBHpl2jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736489269; c=relaxed/simple;
	bh=ZVoWyOCrpGarg44j7l0yKo585lFr9Zt4rMolEU/aa6A=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NG8lTgeuqBrLl2bmHm4+SakesFFC7CvmN6BUWUeuwr1a9inqiS0r4GgYohpfhfiFowjppKf1uDNA/0GqGQFx8wYlUtyNnp2FTEE8XnrA/h1UI60JsStj2E+d7ZliaBNWdhnvjUP5Kf0tXM/+m2yc4/AytCi1VIm/9gDrL1qNTTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Phatj4eC; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Phatj4eC"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f441791e40so2280312a91.3
        for <dm-devel@lists.linux.dev>; Thu, 09 Jan 2025 22:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1736489267; x=1737094067; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ctj2avSKBtWNNCtOTF74TfBUaCFGH8Q0QhgEP8brXQ=;
        b=Phatj4eCWnqq2NqnpjbOU8nQc9GI9ktFi+wU+1Fld2drlBAMWddDwqhvAXVMRqWz5f
         Zv8hX19HJsT4H2qZrtheFe0bWBv5R28P4R3OBjd7Z9VQ7kihMmk1Clqyq08k2hXoU2od
         n7K/7meRLzdOpYFmcBb8SbVhw1qn3P8g34bIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736489267; x=1737094067;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ctj2avSKBtWNNCtOTF74TfBUaCFGH8Q0QhgEP8brXQ=;
        b=stEMcKYjJth25qVAb55Uqpf9rq4VKNo4ZIyuc7jD4gA/M7qyS/e6Z/AsJiWMg6PXY9
         ERyjcgQrJjdeA3rhjGUshG8H2bXaIahg25tWajmHYOeSwoTJzDTrZGrlcd9GqegSZp1k
         m42ESTk4ZfAsv8D6GCMpANMH+Mz53hKP+sa1AHw02jk95HvHk/ve3oNW4Of3R8Zak4Lv
         BatPl1bJdWCIKIp5UAd3sk8S8L0GFhG8GveaoPeBhNzXFN72Lj1lZsIzauLLwrdKFJ6F
         T99ZhVeepu+Xz/xj2EXFH3CDaTel3oFRLGOOIilJn5AxI5+7gm3TjS2wLQi6X1dfvOGI
         dqDg==
X-Gm-Message-State: AOJu0YyQRMg80fax0xz32GvmOwPYVtZ6ihu4FA9AFk7utCyOhCExP2x4
	P7dSgzhNhUin1TwJvUggsq6XFTg2mog/+T/KIT/yv7mFeAKu/4aHN8ERXmfHR9REpA9fGwxfsc3
	F2RFN0IYi1wUwDSrX0ALcYQCRtHb1jrIu470B7/vkSMoTulnkdkOhYVkfrJtrbyUKfihKHnIW4M
	jaB7KvgmIEXkuJlK8MIz7C
X-Gm-Gg: ASbGncue9yysrGMKfFxULCSL34hO5F7ZGpyB11g4FZ1WiAbzhXV6TukESljDk1QRlZ4
	LB9FWArk/Cbbjy0ZzbgnialWpcu11WQoHD3KwJZs=
X-Google-Smtp-Source: AGHT+IHGubp4CEKJunSET+CUT8Rajh/L9d0/z52WNwK3oBkkn01vLMK5CRbHbQ4F2xcxtntVsvFHKHUYh9DyPbQLoEQ=
X-Received: by 2002:a17:90b:33d2:b0:2f1:4715:5987 with SMTP id
 98e67ed59e1d1-2f548f32f7fmr14853994a91.9.1736489267130; Thu, 09 Jan 2025
 22:07:47 -0800 (PST)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com> <20241220020235.1759375-2-bmarzins@redhat.com>
In-Reply-To: <20241220020235.1759375-2-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK+UvY9qFv7vwQ9njHSAGX1b/VgggJlia8ZsTZ5crA=
Date: Fri, 10 Jan 2025 11:37:43 +0530
X-Gm-Features: AbW1kvZlUcpsZ5uNE4ua7S8pv7PqRpBJ4XyuCWEH7-J0W0QpBugHYzvy9TtqihE
Message-ID: <6225db84e3c8ee78c5b677cc3a577e8a@mail.gmail.com>
Subject: RE: [PATCH 1/2] libmultipath: export udev pthread cleanup functions
To: Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Martin Wilck <Martin.Wilck@suse.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f03cd1062b53e959"

--000000000000f03cd1062b53e959
Content-Type: text/plain; charset="UTF-8"

Hi Benjamin,
Change's looks good.

Reviewed-by: Muneendra Kumar <muneendra.kumar@broadcom.com>



-----Original Message-----
From: Benjamin Marzinski <bmarzins@redhat.com>
Sent: Friday, December 20, 2024 7:33 AM
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>; Martin Wilck
<Martin.Wilck@suse.com>; Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH 1/2] libmultipath: export udev pthread cleanup functions

A future patch will make use of cleanup_udev_enumerate_ptr() and
cleanup_udev_device_ptr().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c          | 4 ++--
 libmultipath/discovery.h          | 2 ++
 libmultipath/libmultipath.version | 6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c index
b5851561..72ea0c98 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -146,7 +146,7 @@ path_discover (vector pathvec, struct config * conf,
 		return pathinfo(pp, conf, flag);
 }

-static void cleanup_udev_enumerate_ptr(void *arg)
+void cleanup_udev_enumerate_ptr(void *arg)
 {
 	struct udev_enumerate *ue;

@@ -157,7 +157,7 @@ static void cleanup_udev_enumerate_ptr(void *arg)
 		(void)udev_enumerate_unref(ue);
 }

-static void cleanup_udev_device_ptr(void *arg)
+void cleanup_udev_device_ptr(void *arg)
 {
 	struct udev_device *ud;

diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h index
7d42eae5..1f7a6e20 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -59,6 +59,8 @@ bool has_uid_fallback(struct path *pp);  int
get_uid(struct path * pp, int path_state, struct udev_device *udev,
 	    int allow_fallback);
 bool is_vpd_page_supported(int fd, int pg);
+void cleanup_udev_enumerate_ptr(void *arg); void
+cleanup_udev_device_ptr(void *arg);

 /*
  * discovery bitmask
diff --git a/libmultipath/libmultipath.version
b/libmultipath/libmultipath.version
index 6bdf6944..63f970b7 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -244,3 +244,9 @@ global:
 local:
 	*;
 };
+
+LIBMULTIPATH_27.1.0 {
+global:
+	cleanup_udev_enumerate_ptr;
+	cleanup_udev_device_ptr;
+} LIBMULTIPATH_27.0.0;
--
2.46.2

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000f03cd1062b53e959
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ys9fYL+GlV3PS9wS3h0MI90cAfs5ZQjER5eWqMBARhfrW70fFVMSdZzBpXljqRjD+GOJm711FgvN
RsH9iq2Ndn7XY7jpnxND6cwSKympBXWuvQ54YyFDLr0m9eC6BNU5bQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTJvvnIS4Qf
Z+gEeC51xAB2l3lqOzANBgkqhkiG9w0BAQsFAAOCAQEAE6G8pLIpwrdO0Dmi603StqsNLN3t3i5m
SU/J+ZHnSeVNQFmfJjYSlZHSeAYrw+nsLEw08xiT4N2dPLbnowDKw0cVDRV5hL6+Uis2nqNkp9Kk
dXMVNlGeqGqBo98QRdRdzLgc/3FBQp3XIGUo2VDOMYW/RPbI1muHQOBKaVx4q8jqitNbqThvZkt/
t8KBiojEq4d7/scDRRtEsaL6Hl7cAYNMrS5EpijZrYjNYercaQNHcHP38l/XM9n36jllylt12koc
Dfj3D142STRRnexoNURmkc9EAKyZPRv/JRGz6YP0i2y1JqgpjF8CggD2osV3pA9e8ecXWQ7/ZJly
zHlFgjGCAm0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDEnR
Sel9Ku9INR0BhDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgyptfcAF7Z6KPuc28
ddCRIPpbA5R8DMRozt6NDq4JCtEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjUwMTEwMDYwNzQ3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKj1/tLrrew0hEhnzj2RHxmD14lGGx4EzJUm
SyMuLy4Q3MNsqYshwvODDaj5cMvq42i7Og//vr42610waS2JGrDoDq1S0LyZClBUgl+YqVdU/cfl
/7ajT3dfk2AJaI5247i/sEqBumA3Anyz/qnVrSQ/BE42RWUstFK1jmf/vnR6PO42MrfxoM4rdiGU
NxRNu68cw+G9KQ0q1fgjqUnsufXQ9T1W1mbQABr7c14fZSQlya9aZGzO0oJW7MCdmY4ti7KJD9kh
F3R6/s8JhzVFsICfHqN2/LReFlelg4dde0ifPtiTEdZRQf/MGwNdBGO9SFrvMOmd7LTI1OH+0dOd
cxs=
--000000000000f03cd1062b53e959--
