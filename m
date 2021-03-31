Return-Path: <SRS0=fKNG=I5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1BAC43460
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:32:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0455E61990
	for <dm-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0455E61990
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-N1spCNR7NyGXpK1tjPrGxw-1; Wed, 31 Mar 2021 09:32:52 -0400
X-MC-Unique: N1spCNR7NyGXpK1tjPrGxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C179883DD28;
	Wed, 31 Mar 2021 13:32:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A7AA19C59;
	Wed, 31 Mar 2021 13:32:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6707D4A7C9;
	Wed, 31 Mar 2021 13:32:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12VAmnlQ011640 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 31 Mar 2021 06:48:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1DA8E2026D7F; Wed, 31 Mar 2021 10:48:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 178E82026D64
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 10:48:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18F5385A5B9
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 10:48:44 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1617187723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkFrw+Ve+sBOgjcwjl/THH0DPxp0+bM4i1EJg3vC3S0=;
	b=VlT7XGkZCXJr4BP3KjSSt09FL5xn9t745+XBrKqq8j2KUtrRJK/hYPIkDpNARHRdUgRJWD
	RM3oaRPPaIF7wxLfiHUbnPcwvhvqpF126GKnnhrc9Qm3AHMxJauKbu36Ielg9EPb24Yy6l
	DhjPyi8pxZuU9B3B/Pkrrotf6Nx/6Nq3kEaiGeqRKVcwGPb+9Ee87hz1OySw6PR4m76RY/
	kqYlA8bj+BoVAmjNCuzJzWRRD2t95X+RpW0sN7resLYOdSrVBICXaUadTQ0t439kCX4KSa
	MKMH+H2tW90EqVaWLCMdujTd7/CCSOO5rgM2Atc+0cTUBxRhHLqda0kmDLoTCw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1617187723; a=rsa-sha256;
	cv=none;
	b=G4H2NVxmoMV5pIr9nrLjnfkdE2FE2uHhZUleAhSfotLizAvVXIRx5GjCoiUKrn8Bf13DjE
	a/EoCgG1jCofaAEL6W+tuGzpCVTmGnfastPI8I/7vfHySKQVzxbICtE8IYWsn1zidU8Omh
	MAbSkfJst7wUrQGswMpFp9mwGqAknIAcIQaiJh5gg8eEPGd3HIRjNzOBOXhQMt16akett1
	uEmjDBoeAcQPSrpmHpdIGlgaiMzbSwDdUKJ87ixeDvROiOjNZlpoWht2BwlXNepJfB7SZM
	ochCloonXaQKd14QKVqiXB2bx/U3IwvFV07pw/k2nBB5UMY2L5SSOzRgUiBP3Q==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=bqxPMop0;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.167.174 as permitted sender)
	smtp.mailfrom=muneendra.kumar@broadcom.com
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
	[209.85.167.174]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-304-SI6zk0MkMMyFgIABa43EIg-1; Wed, 31 Mar 2021 06:48:39 -0400
X-MC-Unique: SI6zk0MkMMyFgIABa43EIg-1
Received: by mail-oi1-f174.google.com with SMTP id n8so19552466oie.10
	for <dm-devel@redhat.com>; Wed, 31 Mar 2021 03:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=broadcom.com; s=google;
	h=from:references:in-reply-to:mime-version:thread-index:date
	:message-id:subject:to:cc;
	bh=u42OTsMBLM+NsOOwfXpxRpFpC/5L1VGqQjwWwvh1TQs=;
	b=bqxPMop0F6sx6RkXAB9kbK2s4aqvcuhZrSG6a6croEhVUkxwuckCwiyPz8WBM//4Wm
	oDJSBebs+fFXZ43ncyhiZfOrA3MyAXwPn81h2YGZzC5R9BH+uKeJcckUwqGA19rlDLXX
	HEjA5Plqg5BEugECPqf3BLE3l/Fm8isBMEFro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:references:in-reply-to:mime-version
	:thread-index:date:message-id:subject:to:cc;
	bh=u42OTsMBLM+NsOOwfXpxRpFpC/5L1VGqQjwWwvh1TQs=;
	b=j/0pNZ70HU8jdZnPxQrZWx1h48oveEHfZIVOEIinq1QcZSswjYQBCbJhIMbS2W26PG
	7CLD4/1TD6T1jXmaRwQOlwJw+/WmfiC2A8rvWuDKF52M+kqqREfYU0YJNH6HuCqeAt3l
	CVXInar4pecEEcSDydGQH5cyncDk/tZdyPMsT5oyZdG889ZA+rdVuE44jX0L0/lkWQuW
	mQGons7IoYEahwvlQX9DFHfIvwkhiV3oZM5OIi7gjqmFiSxRBzER9EKPORz6/hV1KNL2
	OWdWeXFdW7LYPYkYnSMhlWDJpR5R1PFO5X3EEUedrUU8D1CqN+RHvs3e9/ZQod5/0Zjt
	BRGA==
X-Gm-Message-State: AOAM533ctmACHnxUh8Q6trBrsJqZv7Gkbaty1Y7OK/hg99eYw0Bx206F
	+FLSTHdySbnLCaIFXjd7M2q7hZn5uINNIRuAEtbTxiLQ7MYmIRsdHPsZZ1cnz+YHipgcsM87qv+
	i1T/SGelWzJAYDtKFxco=
X-Google-Smtp-Source: ABdhPJxt1tZ8GL64S3e5+ENBD3yy3INCuFC7BtDthDYgAQ6O0KSuEV7BX0SrEXgXC1bl8W1fpSsYzkhGxmxXcmZK2AQ=
X-Received: by 2002:aca:c349:: with SMTP id t70mr1964844oif.87.1617187717012; 
	Wed, 31 Mar 2021 03:48:37 -0700 (PDT)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <5b87a64d88a13eb8b4917a1cc0d35691f9fc8227.camel@erwinvanlonden.net>
	<YFy1Q6nvJEcRzwyl@t480-pf1aa2c2.linux.ibm.com>	
	<b3025c4bf84fe357712fa0fe32bfa3e9@mail.gmail.com>
	<2c6ff107ccf5f0589520ef124cd9ecc4cdcc355e.camel@erwinvanlonden.net>
	<8966fcda-b1ca-5d50-398a-13195dab3c44@suse.de>
	<4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
In-Reply-To: <4fff162d56dd8eebaa7d13be9d6ff580cacbe15f.camel@suse.com>
MIME-Version: 1.0
Thread-Index: AQLUV1ngcOMspX6X38mhg1atAytU1gI8PjAEAcHXiSEBxD6w4wJahNoMAZbORjaoVd5DoA==
Date: Wed, 31 Mar 2021 16:18:34 +0530
Message-ID: <30cb8c2e97ea8303ee1dfef8a4c34599@mail.gmail.com>
To: Martin Wilck <martin.wilck@suse.com>, erwin@erwinvanlonden.net,
	bblock@linux.ibm.com, hare@suse.de
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=bqxPMop0;
	dmarc=pass (policy=quarantine) header.from=broadcom.com;
	spf=pass (relay.mimecast.com: domain of muneendra.kumar@broadcom.com
	designates 209.85.167.174 as permitted sender)
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Content-Type: multipart/mixed; boundary="===============3571374826945114452=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

--===============3571374826945114452==
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha-256; boundary="00000000000083ca1205bed2dbd4"

--00000000000083ca1205bed2dbd4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Martin,
Below are my replies.


>If there was any discussion, I haven't been involved :-)

>I haven't looked into FPIN much so far. I'm rather sceptic with it's
usefulness for dm-multipath. Being a property of FC-2, FPIN works at least
2 layers below dm-multipath. dm-multipath is agnostic against protocol and
transport properties by design. User space multipathd can cross these
layers and tune dm-multipath based on lower-level properties, but such
actions  have rather large latencies.

>As you know, dm-multipath has 3 switches for routing IO via different
paths:

> 1 priority groups,
> 2 path status (good / failed)
 >3 path selector algorithm

>1) and 2) are controlled by user space, and have high latency.

>The current "marginal" concept in multipathd watches paths for repeated
failures, and configures the kernel to avoid using paths that are
considered marginal, using methods 1) and 2). This is a very-high- latency
algorithm that >changes state on the time scale of minutes.
>There is no concept for "delaying" or "pausing" IO on paths on short time
scale.

>The only low-latency mechanism is 3). But it's block level, no existing
selector looks at transport-level properties.

>That said, I can quite well imagine a feedback mechanism based on
throttling or delays applied in the FC drivers. For example, it a remote
port was throttled by the driver in response to FPIN messages, it's
bandwidth would >decrease, and a path selector like "service-time"
>would automatically assign less IO to such paths. This wouldn't need any
changes in dm-multipath or multipath-tools, it would work entirely on the
FC level.

[Muneendra]Agreed.

>Talking about improving the current "marginal" algorithm in multipathd,
and knowing that it's slow, FPIN might provide additional data that would
be good to have. Currently, multipathd only has 2 inputs, "good<->bad"
state >transitions based either on kernel I/O errors or path checker
results, and failure statistics from multipathd's internal "io_err_stat"
thread, which only reads sector 0. This could obviously be improved, but
there may actually be >lower-hanging fruit than evaluating FPIN
notifications (for example, I've pondered utilizing the kernel's blktrace
functionality to detect unusually long IO latencies or bandwidth drops).

>Talking about FPIN, is it planned to notify user space about such fabric
events, and if yes, how?

[Muneendra]Yes. FC drivers, when receiving FC FPIN ELS's are calling a
scsi transport routine with the FPIN payload.  The transport
is pushing this as an "event" via netlink.  An app bound to the local
address used by the scsi transport can receive the event and parse it.

Benjamin has added a marginal_path group(multipath marginal pathgroups) in
the dm-multipath.
https://patchwork.kernel.org/project/dm-devel/cover/1564763622-31752-1-git
-send-email-bmarzins@redhat.com/

One of the intention of the Benjamin's patch (support for maginal path) is
to support for the FPIN events we receive from fabric.
On receiving the fpin-li our intention was to  place all the paths that
are affected into the marginal path group.

Below are the 4 types of descriptors returned in an FPIN:
=E2=80=A2=09Link Integrity (LN): some error on a link that affected frames,
which is the main one for "flaky path"
=E2=80=A2=09Delivery Notification (DN):  something explicitly knew about a
dropped frame and is reporting it. Usually, things like a CRC error says
you can't trust the frame header, so you it's a LI error. But if you do
have a valid frame, but drop it, such as a fabric edge timer (don't queue
it more the 250-600ms), then it becomes a DN type. Could be flaky path,
but not necessarily.
=E2=80=A2=09Congestion (CN): fabric is saying it's congested sending to "yo=
ur"
port. Meaning if a host receives it - fabric is saying it has more frames
for the host than it's pulling in so it's backing up the fabric.What
should happen is load by the host should be lowered - but it's across all
targets. Not all targets are perhaps in the mpio path list
=E2=80=A2=09Peer Congestion (PCN): this goes along with CN in that the fabr=
ic
is now telling the other devices in the zone sending traffic to that
congested port that the other port is backing up. So the idea is these
peer send less load to the congested port.  Shouldn't really tie to mpio.
some of the current thinking is targets could see this and reduce their
transmission rate to a host to the link speed of the host

On receiving the congestion notifications our intention is to slowdown the
work load gradually from the host until it stops receiving the congestion
notifications.
We need to validate the same how we can achieve the same of decreasing the
workloads with the help of dm-multipath.

As Hannes mentioned  in his earlier mail our primary goal is that the
admin first should be _alerted_, having FPINs showing up in the message
log, to alert the
admin that his fabric is not performing well.


Regards,
Muneendra.

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--00000000000083ca1205bed2dbd4
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
9dgalq0zfRWBQDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgEwSrk6UL9R/02B/Q
J3NBLu/cKfYfrMtgoYkCpzyGNB8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjEwMzMxMTA0ODM4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGV3aG9uJZCeH6srPMTJRVPCzAqSMIVQEntq
LvLTSC9ZBYi+Heo5mzmT9O5BsEJ1X+IETlByFHB9asIyR68V4BuAprF+4R4rprD/4cAj3HwieugI
tpRxE2oj50DQBRUwQJPPkSdjuB79FQTW9ocjHfrQvFCGisaiqS5tqLCAu/ZtEJTQ6TWRr2KbKuQl
XuH0PP+BGh+o8Z4tMT6yG9JBiPHPfwAURYQmQotAKBVZ8iiRGxTU7SucwPgFJEdmZaQeseTyLamB
uyKAVk3eCSjPojeyagqg9VnM5++CfYD14Hu0nN8bt82/DMTowUOqKaYPAUpgc454nkhHNAHJfNaZ
EIk=
--00000000000083ca1205bed2dbd4--


--===============3571374826945114452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3571374826945114452==--

