Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE89C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 08:08:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-af88VODzNN2yFR4qpYC1VQ-1; Tue, 14 Dec 2021 03:08:34 -0500
X-MC-Unique: af88VODzNN2yFR4qpYC1VQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 379A7101F7A4;
	Tue, 14 Dec 2021 08:08:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92E0860C9F;
	Tue, 14 Dec 2021 08:08:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E1C91809CB8;
	Tue, 14 Dec 2021 08:08:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BD8x18D007150 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 03:59:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1618940D1B9F; Mon, 13 Dec 2021 08:59:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 116C240D1B9E
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:59:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8748185A79C
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 08:59:00 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1639385940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yfal9JoQh02rxqdQAJ0zBzrPvsHnoLw2Dg34ivQy2fA=;
	b=laB8mXuDAJFCcfO9qgm8w8OYIKj2vOkiwI5FYRZJvvTx41trQUT24SzZ6FFMqvI+EHtS3B
	nd+CIqjnSqacTkbpjkViInIDvv36c2DrbYg9I8XevlJeOjsB16cAxfQN2PrlCG+fpEHPDO
	TrDnobDmKdipUjpIg0RC7FUXQEGZb7GcKQ6fHyQBQB0rg0Jytnv4o+omls7qPW1J2gR9ro
	nkHfozwK4nr7doA7Co1l3JphX5f1hDA2QoDN7tjUfQEWQJGYQhazN1wHGGlSgAvVQeT6F3
	DjxwL85nvQsfR5HfiFVg9mNYLFd7GmFu2+TMyZTwHGxcmIcD1bRa98RrIAAMcg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1639385940; a=rsa-sha256;
	cv=none;
	b=c9t4vtZ/xyZKpDSHBGYbPl6+SogKadINzYofEZFj6uTRW6ivUq0b9svaoPp1rZ5xnVJ+Kn
	9ku9B0LyiMTrFRa9Vm/JYgpcbQMULiGhYH0b4gGsXoWYJAVJv4CnaLJqewTrVmWbiYVxzn
	OJGFTE789fAqtIG/CVIn+806kJqpMrgfeoDKDmjS2IrSMFvXogAhEoVnd7yVz03qn8DTYF
	caXV90w98bBMweZK10WrTVWMIQtyF5Xp3ROXAFDLb41076eCQSx3rsoV4IzgFPDqGQuwnO
	aLY0O+9Ay1/PQTha4DHxl2PiZAeutCOkBqmtGmVfBrIEjCBRmZ3DGhpdeF6YZg==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=V7x4bB8d;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.208.43 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
	[209.85.208.43]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-474-V4TGs3l4Py6qLAGJeN0crA-1; Mon, 13 Dec 2021 03:58:58 -0500
X-MC-Unique: V4TGs3l4Py6qLAGJeN0crA-1
Received: by mail-ed1-f43.google.com with SMTP id t5so49292172edd.0
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 00:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=broadcom.com; s=google;
	h=from:references:in-reply-to:mime-version:thread-index:date
	:message-id:subject:to:cc;
	bh=Yfal9JoQh02rxqdQAJ0zBzrPvsHnoLw2Dg34ivQy2fA=;
	b=V7x4bB8dxQH442GMJDRwL6DQPirts6P4XKJHsP7NU3Nkh5e9nAfvJ8exelOmxyIUK1
	SFYZYvfaV7Z5RVrozs7kc10RRy3fwqKoc5YX5x5efvwozLFO/+oAGf+v7maRYVNhXmA3
	e0TuTEyX2TyzWxcWEH03BytVMpNpKBw6ZhsW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:references:in-reply-to:mime-version
	:thread-index:date:message-id:subject:to:cc;
	bh=Yfal9JoQh02rxqdQAJ0zBzrPvsHnoLw2Dg34ivQy2fA=;
	b=hT69bPdiRNp+nXVrvYUgdQYaPiclStqVpfpkGWIWXmfUHBvwQvU+FxjhlCf86Sq11w
	4gg4JkRZmN/I4yjT8nYxYTWJYzNWQ4lyyP8qUqbnGtSb81af6FogN/cHmkKkRkcESLJv
	8gwM2kWBxq3KeoSzmVAuEHitdoV43vClboTjldkbwpo8IAyC4vyi14SUKSzRTQScs45p
	VdeV+K/eLl92m3UCe0hdcTXWYBnE0Pnd35SEPBzMkSQ1yIWH4KcFHP9c6Io9qAoX78sz
	zPekR2fcqdHfB1Jmkt87wSjg/sbSNh6jUgu2hKOlRlp0GjXld0K5ot3YwGK5G/8MDtYJ
	VBcQ==
X-Gm-Message-State: AOAM533ZenRQelTTY30WdPFJVtUBDV/5sd82PbsIKM3uVMkZX+eoS4/g
	P6yFmxX8prtLznqIZCMHhpuInCHax2dhAqeERxc5Znbh8nTpc/BedE1URzZT22byUdPwPy5oHi0
	Syzh8i8eKywA5Ywnq2yU=
X-Google-Smtp-Source: ABdhPJzN2uoICQ5XConZMfD/b8aISVCAsxWhUnBjDprCfl5shRM+vyGIhW5rI9TILwH3ab8Tscm60ac2G59mA6pkdxs=
X-Received: by 2002:a05:6402:3496:: with SMTP id
	v22mr60859811edc.177.1639385936914; 
	Mon, 13 Dec 2021 00:58:56 -0800 (PST)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
	<f7ab2f4c696a7e17806d08b796324ca53cefbb6f.camel@erwinvanlonden.net>
	<b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
In-Reply-To: <b8ca37a3cadcd877c92c8d9b970c17661c946380.camel@suse.com>
MIME-Version: 1.0
Thread-Index: AQJIhVvpY68t3HQC/n44lC230yUqLwJKGHWlAW73NagCE2TiGQExJ+o3qxbYYFA=
Date: Mon, 13 Dec 2021 14:28:54 +0530
Message-ID: <266050393293d390e4252f0220b7a8cf@mail.gmail.com>
To: Martin Wilck <martin.wilck@suse.com>, erwin@erwinvanlonden.net,
	dm-devel@redhat.com
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=V7x4bB8d;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.208.43 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
X-Mimecast-Spam-Score: -5
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 14 Dec 2021 03:08:25 -0500
Cc: mkumar@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1949732952665257461=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============1949732952665257461==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-256; boundary="0000000000006e54a305d3034889"

--0000000000006e54a305d3034889
Content-Type: text/plain; charset="UTF-8"

Hi  Martin,
Apologies for the delayed response .

>Interesting idea. Are you aware of a technology for non-FC transports
that could take the role of FPIN? I have to admit I'm not, but that
doesn't mean they don't exist or won't exist in the future.
....
...
>If we want to modularize this, we need a *generic* event listener thread.
A module would basically provide an fd for that thread to poll on, and a
callback to be called when an event occurs. This idea appeals to me a lot,
in particular because we already have an event listener (the uevent
listener thread) >which is sitting idle most of the time.
>So Muneendra, instead of creating a new receiver thread, you would extend
the existing uevent listener to handle the FPIN events as well.
>The thread would now add uevents to the uevent list and FPIN events to
the FPIN events list.

[Muneendra] Could you please refer to my query below
....
....
....

>One word of caution here: we must be careful not to over-engineer.
>As long as no other mechanism like FPIN for other transports is
conceivable, generalizing the concept makes only so much sense.
>Therefore we shouldn't hold back the FPIN patches until we have conceived
of a generic mechanism, which may take a lot of time to develop. If
another mechanism becomes available, we could still try to generalize the
concept, if we keep the current additions clean and well-separated from
the core >multipathd code.

>However I am really thrilled by the prospect of generalizing event
handling and reusing the uevent threads for FPIN. That would reduce
complexity a lot, which is a good thing IMO.

I have a query with respect to generalizing event handling and reusing the
uevent threads  .
Please correct me if iam wrong.

FPIN events work on NETLINK_SCSITRANSPORT
	netlink_kernel_create(&init_net, NETLINK_SCSITRANSPORT,  &cfg);
==>scsi_netlink.c

whereas uvents  works on NETLINK_KOBJECT_UEVENT.
	   netlink_kernel_create(net, NETLINK_KOBJECT_UEVENT, &cfg);
==>kobject_uevent.c


I am not sure whether we can reuse the uevent threads for both uevents and
fpin events.
In case if my understanding is wrong could you please clarify on the same.

Best
Martin

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

--0000000000006e54a305d3034889
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
6dyIRB5g0cWmkcO89O0W56d+wWwa7GeeTIJHMzJ0rco8nzcXkz/oeEmXSjZU3erpKBaLCQBkZud1
iNM/8mFL1vZxCwUACcMw+a8FhrHJq29QwrBHqDJ1ocrJlDaZcn1UDQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTMJfPJzmVP
1lwJptwb21ozx4G7wzANBgkqhkiG9w0BAQsFAAOCAQEAmz4/3oyLhfXMYVZWtDEKcP5Bk/6JAhfa
9q4eZDy1W/1FSuRfEWMq7xi9T3DvxUQqJtpJ8bM6SU37fZAvvMdRF23qdKRy6gBZ9NkYOCP7Tr2u
wNYznMfaHEGY/aa65EiywAsbVn1X7vKMKqSj3cmpEUO2I+FcRtPdyicqyU2E3856b5d+fMc01FRg
pQQRz3kWlIpG/CJ2SiOg0gpkZIkUde0r4e6ipDi+xVSoBdOOJzirs8IkwOeJ4w9GPS9uOkB1bRvJ
RU+Nz1h4p9eH2nsPAq7S5l6y/n3+g/olazbUoiEx8GRFqzoHLudsqmnzISDPoe+rczkpYreF/mEU
Y6pL2DGCAm0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDHE+
9dgalq0zfRWBQDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgRG/RyT5HcMN3CwxE
1wwgf2aqZlWjCfphHy5Kq/FpJXYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjExMjEzMDg1ODU3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADkIFBeXIa60mOYzI5sQGjOnWDzzacS3gJTG
MrfGsrs/Af2a/K4AKywlO+BXm4jCYgqK+m9dHWW8JAEYqFDaO3Ed2As/j82A/tOmdcEdhE7GKOMG
rf2/X7Iux544do92fQNUymKo4pnlRaWlxuE0TBe3auUVrkmRq0HbfUyXZ3LfWb2V9v2exKWJEjdW
evA8StDL+KSIIRfJra5LV4GOv/1gH0Pi9yiWDu2CWKR/glbPPo2JFJzBA+sjkPSicpIka46gi1GP
3KMRH2h80II2yAfFRzESd+KM2GhydT1FJlwFMilahq9fyetuF7vfzEib1fVoaNVAQln+ZNM3Jsdx
lGc=
--0000000000006e54a305d3034889--


--===============1949732952665257461==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============1949732952665257461==--

