Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1EA33D8
	for <dm-devel@lists.linux.dev>; Thu, 19 Sep 2024 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726741521; cv=none; b=PrnMK6M2MD5yBLeZE86IM2JhYAH8q86P6Hjy7UncOwuirIM9OWzsYwfnjFfR6AVaMl+9op/OwMJUavIvddeBIOwrj3Kl7fMtV7CxHWd4mU16RTn1DK1DR3fhRIw8NW6NOcjNUo3cv58aeSu5EQ0FRqyDC0u0ppFe+D/TBtA7wZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726741521; c=relaxed/simple;
	bh=6qMNbT2JVmvlhDFs92LJyJ+bHXGnMpOHQZsHCFm9Fjw=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g6CinuD5Rr9nKXDr74KPQMrozwmOqPbvoY7GdcOMYo9H0qYNhTzhVnrlyYpeiw4jKsq8Q1gz8mWF9jJebgJIIrt81TAxnceWcMyR+bD/5/XoBcemJZXo82WDiYrRF/QU0PIpgxrD6tAX+qjFCLE2OpZYdDUDCo0l/LXPK6DoW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X0ndGBZH; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X0ndGBZH"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7178df70f28so512325b3a.2
        for <dm-devel@lists.linux.dev>; Thu, 19 Sep 2024 03:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1726741519; x=1727346319; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2khLJNEJk4n0Ti3hZ2TaLbNJXZY7gxl5JHjpuU1SEE0=;
        b=X0ndGBZHjYrEpIuHGDs9hPsJo8/xaWQ+pQ5Y7TGx1F21ZxMiF7ITTa5RUR4ejcSC/C
         CaYgUp6FobC8P5Hd+XdrdSSPyeINbxZhtU7vXQlRJw98cLJ4+zI9kPIRNEgC7xlfuvnN
         X6wanTBL4cw1AaRlHdH9CGA9Vu7D3MWYqharU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726741519; x=1727346319;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2khLJNEJk4n0Ti3hZ2TaLbNJXZY7gxl5JHjpuU1SEE0=;
        b=rHdKkIBMmGD5mEVIujaQQKRrx0Y7FfmoFQkeg765LDulJJg6LhcXuaudqwkEjmoDpn
         soxG7g5klufQr6qKmfpbjNL2Umze/hQmH6+uY6jRV0jS/ZURBGy5/SP7uvsbED0J3JbP
         Akc8l/bVv+Ah5PUsbIaobtbNE3+fe6WKspNWJcUhnyYIaVOd52yw6RODLJCQRHf1MFwO
         zk4uk8i7nHr0nh++RGg2UDPkHsG6qqEE0YhFj2ViQ2biqe1P00RGu9f8Fr8+DweVXp3k
         mAbk9P5UY8hbnVP+6M63MqXIcOgUQr4uZrXNxCp9YTBwPE+kObExUEk5hXRw2wxaType
         ghEQ==
X-Gm-Message-State: AOJu0YxOnvML/bNKKyQrcYnm1o/Bri6vVA/1mG5mW56TxTzQIl2D13Ij
	fLVUEAA15KiYQYdTkSnMSF+etrbaAYoYGWq4C3Wa2wa2Sp+GfBM+k7DcZo7UXoWW68Wd9AFeEU6
	DrstGVcc2sowBTcEEe8ajB4xgEkPCB+2L/LQICX9E8JNGy60bSF38z8rVhORtyLRNsh7zJWPLUg
	ipriMUE1W1Tb+NXc1svZgp
X-Google-Smtp-Source: AGHT+IFh12y2Vy3TOpJOY2NmbuSd/kC1XKWkvGrXQoXJm6wkSEKWIzRW4WwyRJcdKGCWQr7CWzoUm2A0eQieFr43M6M=
X-Received: by 2002:aa7:8883:0:b0:714:340c:b9ee with SMTP id
 d2e1a72fcca58-7192605a08emr36666220b3a.1.1726741519002; Thu, 19 Sep 2024
 03:25:19 -0700 (PDT)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20240917155858.959835-1-bmarzins@redhat.com>
In-Reply-To: <20240917155858.959835-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGwSUj1dumsaT77OZ5jSHQeLhVN4bK0aW+Q
Date: Thu, 19 Sep 2024 15:55:14 +0530
Message-ID: <c084cc5740e57061745ef2ffa2f7e6ac@mail.gmail.com>
Subject: RE: [PATCH] multipathd: checker port_state before setting it.
To: Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Martin Wilck <Martin.Wilck@suse.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000e36875062276568e"

--000000000000e36875062276568e
Content-Type: text/plain; charset="UTF-8"

Hi Benjamin,
Changes looks good .
Thanks for the fix.

Regards,
Muneendra.

-----Original Message-----
From: Benjamin Marzinski <bmarzins@redhat.com>
Sent: Tuesday, September 17, 2024 9:29 PM
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>; Martin Wilck
<Martin.Wilck@suse.com>; Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH] multipathd: checker port_state before setting it.

If the rport port_state is already Marginal, trying to set it to Marginal
causes an error like the following:

multipathd[365376]:
/sys/devices/pci0000:c0/0000:c0:01.1/0000:c4:00.0/host0/rport-0:0-5/fc_rem
ote_ports/rport-0:0-5: failed to set port_state to marginal: Invalid
argument

To avoid causing this confusing error message, check if the port_state is
already marginal before trying to set it.

Cc: Muneendra Kumar <muneendra.kumar@broadcom.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/fpin_handlers.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c index
be087ca0..6b56f9b7 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -169,9 +169,14 @@ fpin_els_add_li_frame(struct fc_nl_event *fc_event)
/*Sets the rport port_state to marginal*/  static void
fpin_set_rport_marginal(struct udev_device *rport_dev)  {
+	char old_value[20]; /* match kernel show_fc_rport_port_state()
size */
 	static const char marginal[] = "Marginal";
 	ssize_t ret;

+	ret = sysfs_attr_get_value(rport_dev, "port_state",
+				   old_value, sizeof(old_value));
+	if (ret == sizeof(marginal) - 1 && strcmp(old_value, marginal) ==
0)
+		return;
 	ret = sysfs_attr_set_value(rport_dev, "port_state",
 				   marginal, sizeof(marginal) - 1);
 	if (ret != sizeof(marginal) - 1)
--
2.45.0

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

--000000000000e36875062276568e
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
Sel9Ku9INR0BhDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgTf61wvFFa0aHMUg+
RU6SaqRqpBG+TzqF8584YdEJcH8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjQwOTE5MTAyNTE5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHXFqSO+rD3Cx5SmKe3kM3IaaUnAl3YXPSN/
nPfOCkSg34ME3DfAtRasosNQcCQOVM5rSOHw/1+a8cjGO/tfBiB76Kc3qHfjrUAyEsy++cqBL0zB
MLZu10Yjg08P9HCJjD68DvOaweX1OJGfWzCUtq3e7SCE/QjBxDSiYmn6FQfesJhj1Oh0tA6nl9XI
vUnsSsgQQ9ReoB7jJ7nHdySD5UoBB/i60aNo1tRDwIpL4ypUhqijzQd7qj/5BnPnK3D6Dej1iB1z
N0JmNwXipj1btsbDbE2INDmLUBnNz8kplKhN1iA9gsJ9LJ8B1yMgnNPewCDsD+6PnmPjF8uqLR/p
zCA=
--000000000000e36875062276568e--
