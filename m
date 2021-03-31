Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F2DC433B4
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81AC861985
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81AC861985
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-y4RNBSvZMpebz2MQG5U22w-1; Wed, 31 Mar 2021 09:33:03 -0400
X-MC-Unique: y4RNBSvZMpebz2MQG5U22w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7358083DD28;
	Wed, 31 Mar 2021 13:32:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EEF84F3C6;
	Wed, 31 Mar 2021 13:32:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EBEE318155DD;
	Wed, 31 Mar 2021 13:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12VBvi62017149 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 07:57:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D16D385788; Wed, 31 Mar 2021 11:57:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CABD785784
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 11:57:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 052A3100DE7D
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 11:57:41 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1617191860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTRz/2CJNva6cXvqbSedqIlRhiKVdKWzSbTy26NDQ8g=;
	b=JxhZnH4jcLiqs1xrNPJOcKxGuvm9kqLidAKFCIEDrFSCwKG4KEoXGo4JJ00NSQEFW8CI32
	XHtTBj1RRCgdsuArCvVaRFznQMa9phfV51uzSD7ZE1eew2hsuBSisAhcQm5vy8foaxUmPd
	n7jiWA9y1Iq9JEVtn3vf3Q+BZS4sb71ddWEzMLbx0LETlTjM1vvVmXL11ICVg+p1jylYfh
	VC4v4YUB46vt5Jx3f0MNcWeTLZfuw2JjkBjiGbqmKtK8t68sDuz2DePMJr1XdmMcM8qUju
	M/Hz42rJwReIR2V9b6Q7B10t93WUbI2iq+pvSq+XQDTpzEE3kECcYA99rSC3XQ==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1617191860; a=rsa-sha256;
	cv=none;
	b=gpVsXTHs5bSv7GLC1xZAo2WyZuPk+RzAH2mTtWaII/WT/z4zguBFlChj5T+AFAa9nPTIgV
	PMdXQ5XTIur/2mXlyCSVcrSkZS7/SYbxcNZBRD9NFHDwLPkb8EUec5J9VheJAA7Bq5E+JZ
	Vw7MY2LeHq5uy65fgcHQaifuZByaScyQ16jezupzoqnk08krFSCJlzbKiShg/Ra1FvSIvz
	lH1Tyg7+6n1WUJEQd/ngCM86aN4h3ohzgAWGo/RDZqZaw6XHu38bgEYLOxHi7wqQ79ADWP
	QbKeUD/fBWlW2TunJaiZnx096Gd8Zqzt8JkkMRXOvZ3KyWgEAIEMvmr4BAgjxw==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=EAxmOFWu;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.210.47 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
	[209.85.210.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-208-8v-mkIwpMrmdxZ8g9Hg2IA-1; Wed, 31 Mar 2021 07:57:38 -0400
X-MC-Unique: 8v-mkIwpMrmdxZ8g9Hg2IA-1
Received: by mail-ot1-f47.google.com with SMTP id
	91-20020a9d08640000b0290237d9c40382so18645288oty.12
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 04:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=broadcom.com; s=google;
	h=from:references:in-reply-to:mime-version:thread-index:date
	:message-id:subject:to:cc;
	bh=HTRz/2CJNva6cXvqbSedqIlRhiKVdKWzSbTy26NDQ8g=;
	b=EAxmOFWu/zP7U97DgtTxFHUqwf3P/uNYCcfopC9SewkcR+at4LYXxwE415z2+WJ5uf
	FT6f/A8zlDj2nHD1SUBXDiPsO9Lvw/QluRuF7BjED1Pg5jx4qgTbyagCpUzn5i9E6JkY
	gT7slbF2yP3FC+17jHr4TJ3wdobD2V8B0NQa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:references:in-reply-to:mime-version
	:thread-index:date:message-id:subject:to:cc;
	bh=HTRz/2CJNva6cXvqbSedqIlRhiKVdKWzSbTy26NDQ8g=;
	b=Av60yi7l8tqQ1+hfllxbodJIb2t6z9b8NRAV1aGZFGAuOSF1zEjXtJXnMCK6d26PkU
	NGFx7pScCt0nD2eTN2oxZp1XnuL0fJB9WNk4FELMln+k9movYkBfStfrqn0zdOAQlsMG
	NDjtbqc/jeaRBS7P7Xm8ChWAwVRsQcokPkwIsDg8eNA/OEgu+fGtg7KoNvt/zm7qbPc3
	H9JZwUb9twS9l1eMkCmsCDm7/GRW7tta0rBiDsLpmsWG2j2WD7sTwuL5TA8MW+PiwVqa
	gUAHywm7zcIvlMTzQQ9zvKUPcH27FtmS6ISFAm5Op3fK0Zld08lb16mAnaKBEYs9iNlJ
	CsoQ==
X-Gm-Message-State: AOAM531s1P93nWH9u7aIgHL5/ePJFGTVZkmQwJf49a6Ipz6k788ac53x
	LBL7znqHpoSRhwHQYyJubYuKYWnKgiqLS1zI1aTUia7qGQ4HMCB2Qa2VLFLkoVv/26bGIDCHLOd
	LIYGWTbPL10GtD2UfHv4=
X-Google-Smtp-Source: ABdhPJz+8CvthkxedKNGrLLzxD7wR/9NfxNOiI7RU6gEm86AXhtPqIcO0PlTVRh4HR2yiQCf6yHnU32DIJsS0yiBH54=
X-Received: by 2002:a9d:2f04:: with SMTP id h4mr2358330otb.364.1617191857579; 
	Wed, 31 Mar 2021 04:57:37 -0700 (PDT)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
	<30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
	<7b7663da1edf9fcb3e2515e41602ab68de02d2a9.camel@suse.com>
	<0419387c-071c-2c5e-79f4-8873553e5da3@suse.de>
In-Reply-To: <0419387c-071c-2c5e-79f4-8873553e5da3@suse.de>
MIME-Version: 1.0
Thread-Index: AQLUV1ngcOMspX6X38mhg1atAytU1gI8PjAEAcHXiSEBxD6w4wJahNoMAZbORjYBrNJNuwFYuwXHAqJvYLmoKL1usA==
Date: Wed, 31 Mar 2021 17:27:35 +0530
Message-ID: <c661804f254c8dec17b57c6b95f0fe05@mail.gmail.com>
To: Hannes Reinecke <hare@suse.de>, Martin Wilck <martin.wilck@suse.com>,
	erwin@erwinvanlonden.net, bblock@linux.ibm.com
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=EAxmOFWu;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.210.47 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
X-Mimecast-Spam-Score: -1
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 31 Mar 2021 09:32:18 -0400
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-multipath - IO queue dispatch based on FPIN
 Congestion/Latency notifications.
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
Content-Type: multipart/mixed; boundary="===============7620927685154239394=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============7620927685154239394==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-256; boundary="00000000000039077405bed3d2f8"

--00000000000039077405bed3d2f8
Content-Type: text/plain; charset="UTF-8"

Hi Martin,

>>
>> I'm aware of Ben's work, but I hadn't realized it had anything to do
>> with FPIN. As of today, multipathd doesn't listen on the
>> NETLINK_SCSITRANSPORT socket. Does any user space tool do this?
> >Google didn't show me anything.
> >
>I did, once, but that was years ago.

We have user space daemon(Broadcom'sFiber Channel Transport Daemon) called
fctxpd (Benjamin was talking in his patch) which acts on fpin-li events
by listening  on NETLINK_SCSITRANSPORT socket
And it sets the path to marginal path group on receiving FPIN events.
This daemon is part of epel8.
Below is the path for the same where we have changes
https://github.com/brocade/bsn-fc-txptd

Regards,
Muneendra.

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

--00000000000039077405bed3d2f8
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
9dgalq0zfRWBQDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg5vxthizNWXVR7VHQ
mqTj9Iz5WkEygTR8p6/xH7dEPB0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjEwMzMxMTE1NzM3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABKvPmEE5K5/2QitJND2Hc0RFwwiVe1mQW7M
c6rsyvfPj1UxLDrpjF4f5xc+zg9Y1ikwYp6nBc+3sbZyxViarnMaHUj8ZBHR0OkSAAqGmdxkzON7
6OfScQVP0zv8+2rkD2aPC4MlfEu8frY0GM3Yctr+IRiQrb4qkZK9mD7OyN1gUdmZ4OC/+Hay/1U0
FsunopVBq64FPwbHXJb2luk6jzqZKrkbV1hGkFELLgbSmen8yNdNkIajXWlR9oYXimk8324h0le6
Ls74yX5nnN6abaY8PhJmgarka6ns8weYvbO0KG1iCW2nxof56bNg1ccJl0Od09HcPCl+Hbxetv+Z
be0=
--00000000000039077405bed3d2f8--


--===============7620927685154239394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============7620927685154239394==--

