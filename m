Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64660C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 11:56:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3DF36192B
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 11:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3DF36192B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-rzibFRDIPN-5hSEoJLXBbw-1; Mon, 29 Mar 2021 07:56:05 -0400
X-MC-Unique: rzibFRDIPN-5hSEoJLXBbw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79C8D190A7A0;
	Mon, 29 Mar 2021 11:56:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56A6B1349A;
	Mon, 29 Mar 2021 11:56:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2091C4BB7C;
	Mon, 29 Mar 2021 11:56:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QBFLet029197 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 07:15:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E666DFDCCE; Fri, 26 Mar 2021 11:15:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFD44FC74E
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 11:15:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68F6D805F4B
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 11:15:18 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1616757318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXPCuZes585DVYe3nzHXCTNRlJtGVN5ecU55Wc0vA70=;
	b=GSn4OSilG4QtxBjGQLbylqG+PcGdEL9INQJu7/Fz0dluhbAXSN4kHaHW2SmGLZJ2Lv9lP9
	ZJM+t7vTqnvuKwnbhRJ7OfDJsKxu9aG+PwlCyU6Ocg6PzO3PJ5zo8OkHGWdNYwk9LGUdB/
	iJKypmzORKOI8q5kBAa88kEtDNGWhft15H65xA9OhYR68+J7dbqI5OOtHC+jOYOnkA2bpj
	c5L/WR5TWLVACiPA+FOCwELmFb7AKx6rLw5vZ+1fC6uaHOZ1607RKl2HMunMuYxkFwsq3G
	WOaR0n+EvpSFtvjtLModMdOoWZkVJOVqTauNxirwanhGCH7IFH4Jm/OGIpXXsg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1616757318; a=rsa-sha256;
	cv=none;
	b=rsfoI94+9k1sGnIT7yTuFj222/30KRewwHsB5sFGNEeHN9faB5JmjJOA6SHtwGSwL37fmT
	B+74WQXzpQFt4qnYabtSR87hR7uf7TiQ4x5p+0hDI9qE9NmKf4EFBfNLiGoBive7sgtSpB
	kvT6oBor+A09d+wlTJKcRFeapbeRQrYbEa2JQnxfrGlMLNRg8ugV0rjAUOU66EU7b0qSHq
	A3uV51T9CykJsOe9krlJ9GstXJLA0T7oe2WBfH62Qikzq/CRQqtuz/TT0XCxm0LlMLp5Qr
	8F0OeqCkSZVtTmIv6NL3U5EXgs75nGpEMidZAyop+j3PmCrlCfarpz60fXyXzA==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b="iE0tX/56";
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.167.169 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
	[209.85.167.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-445-sq5ODtoqN3i2y6GxC_V3ZA-1; Fri, 26 Mar 2021 07:15:13 -0400
X-MC-Unique: sq5ODtoqN3i2y6GxC_V3ZA-1
Received: by mail-oi1-f169.google.com with SMTP id k25so5361386oic.4
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 04:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=broadcom.com; s=google;
	h=from:references:in-reply-to:mime-version:thread-index:date
	:message-id:subject:to:cc;
	bh=QXPCuZes585DVYe3nzHXCTNRlJtGVN5ecU55Wc0vA70=;
	b=iE0tX/567/LW96dOTedDB2JlqkVEoibVCO/2H8vBkUSgCJq4Qcz5PiTvTst7Bzj2KM
	zGA5xFZbSGLPuAw5c8avcr0q4dAwVJ6JOPXPJ4UfqqZ5+RfFlwp0yd4jEF6kG6V8+3rA
	pkVIK9mwBSXpAD3UgtmTl9kvOAGJaq3kVS8K8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:references:in-reply-to:mime-version
	:thread-index:date:message-id:subject:to:cc;
	bh=QXPCuZes585DVYe3nzHXCTNRlJtGVN5ecU55Wc0vA70=;
	b=JcKUn+xl0rusUJA27XFQb6+rxHNkHMBEkAD1LXW3wID+ObX//tGkiqzcIvssoSsOZQ
	MoLJSpCJB2nFTZfJhmLR55HKGexRPexsRDG3/mN7hvKNw5Gekeuj2fvidX03MG9BfoKY
	+Xu3ASsvTAKDo/mqKiatdQJIxsAFrYXEt17mup/Ky/Te2uOtHa4LC0I657V2Kbca69y2
	XzHpWF6hahdUfzJP2+ZxBIS2MLAyvPn6obvse1Z+mQdvkoy3iNiVXHmESnhD+6xKoQw6
	eJAunqa7X0myKHDCIHr2LXBLioDGTuRQ+6QDJxe8AVjZJwhNBp9JMsUWib4ZdvrluQgP
	aM9A==
X-Gm-Message-State: AOAM533tGWyC4q0fXio08TU+5HqQanxvn1QEKHd/4GT0WVIVwqWC14Cr
	aSxQmFTeXOz9rirFLJlrmFrihjUwpYOH220iPuH85RyQaT+UvQ0ldG++oVNGMI1SC3xk8U+A2f8
	l1qImNWY75vASLQ5wAkOw3Meq
X-Google-Smtp-Source: ABdhPJwXGObbH0YmVJu/E6zXOZFiKz/WPWb/mTvS7YCR2rWiyXdLJt1MElHD43DGXGUI/wcn50eVTYyAvWbr1OjY3AU=
X-Received: by 2002:aca:c349:: with SMTP id t70mr9873647oif.87.1616757311924; 
	Fri, 26 Mar 2021 04:15:11 -0700 (PDT)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
In-Reply-To: <YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>
MIME-Version: 1.0
Thread-Index: AQLUV1ngcOMspX6X38mhg1atAytU1gI8PjAEqInHG1A=
Date: Fri, 26 Mar 2021 16:45:09 +0530
Message-ID: <b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
To: Benjamin Block <bblock@linux.ibm.com>,
	Erwin van Londen <erwin@erwinvanlonden.net>
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b="iE0tX/56";
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.167.169 as permitted sender)
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
X-Mailman-Approved-At: Mon, 29 Mar 2021 07:55:44 -0400
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
Content-Type: multipart/mixed; boundary="===============2448357342734484587=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============2448357342734484587==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-256; boundary="0000000000004bd04205be6ea533"

--0000000000004bd04205be6ea533
Content-Type: text/plain; charset="UTF-8"

Hi Benjamin,
My replies are below


On Tue, Mar 23, 2021 at 05:52:33PM +1000, Erwin van Londen wrote:
>> Hello All,
>>
> >Just wondering if there were any plans to incorporate FPIN
> >congestion/latency notifications in dm-multipath to disperse IO over
> >non-affected paths.
>

>For whats worth, general support in Kernel for a new path state in answer
to existing FPIN notifications was added earlier this year:
>https://lore.kernel.org/linux-scsi/1609969748-17684-1-git-send-email-mune
endra.kumar@broadcom.com/T/

>But this only adds a new port-state and support of it for one particular
driver (lpfc). Not aware of any other driver supporting this new state
yet, but I might have missed it. Also, the port-state is not set in
kernel, but has to be set by something external, unlike with RSCNs, where
we set the >state in the kernel.

We had a discussion with Marvel and they are adding the support in
their(qlaxx) driver.


>What it does, once a path is set into 'Marginal' state, is to not retry
commands on the same shaky path, once it already failed one time already.
Yes

>As far as dm-multipath is concerned, I asked that as well when this patch
series was developed:
>https://lore.kernel.org/linux-scsi/20201002162633.GA8365@t480-pf1aa2c2/
>Hannes answered that in the thread:
>https://lore.kernel.org/linux-scsi/ca995d96-608b-39b9-8ded-4a6dd7598660@s
use.de/

>Not sure what happened in between, didn't see anything on the mpath topic
yet.

As Hannes mentioned in his reply we have an external daemon called fctxpd
which acts on fpin-li events and sets the path to marginal path group as
well as set the port state to marginal.
This daemon is part of epel8.
Below is the path for the same where we have changes
https://github.com/brocade/bsn-fc-txptd

The above code is reviewed by the Benjamin Marzinski from redhat .

Note:The latest release will be available on the epel8 where we have the
support to set the port state to marginal in a week time

As we have all the support in the kernel for fpin registration,
notifications and also setting the port_state to marginal
We had a initial discussion with Hannes adding the fpin based native
support in dm multipathd for FPIN Congestion/Latency notifications .
I will take the initiative and start the discussion with Benjamin
Marzinski and get this work done with the help of Hannes.




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

--0000000000004bd04205be6ea533
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
9dgalq0zfRWBQDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQge+i4A4DCH8p1rp2E
nI0/Thl1jXARY5cY0WzgnUuThsgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjEwMzI2MTExNTEyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAMbthP/MlUk6tU0y+pE/yCO68HBrMF2ORS/P
zI7ewrXArR9QMtO0C+mxuRkhlFajl4/d4ZjEf0oo2l805h9e++BjXd+3TGvK2cuxAymzO71TPZGM
flJLHaGIV3VQzQj4dFP/gxqALUNTzGEMGnoPSy1zcR8St1L5MFM1NGeAGBclR6A+mnGpmzZi2Jcr
vpnMxPij+HyZaO/oEyQSaQQUfhxM3+vYvVvd5qyBcvzFcBW8i15nK20g+3LJUbWXX3o2Qp9KSIi6
eXBUVNJc92Ui2JeAzZTvQX3zktbU1QJSSJFsfM9tqbChwOJU9oyb9AaQkIPVXxGtzH0iMiAbROSu
Zqs=
--0000000000004bd04205be6ea533--


--===============2448357342734484587==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2448357342734484587==--

