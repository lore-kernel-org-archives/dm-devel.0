Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E53C6FA99
	for <dm-devel@archiver.kernel.org>; Fri, 10 Mar 2023 07:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678432364;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GF/++/5YTK71vHV70bmJvL8GkjGNP2DTwrUUNNTMQvU=;
	b=XJ0l3Zu/U9957TQ8g3mHSUvO78xc7gYMcCNyPcXv7uJTBi2stxfFxD6o4EOK5B5xrYXYyO
	ub6sDu9iob8CozjZO1hUBDkyJ9dq2KOtulQxguWAL0kunNV588+XnRfJVPBGqDcdRQ3mvi
	pz7LAfc9M4x1VRbBUhZT5DnmMvU9lqM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-TBVSgOHmNiO614svQOhC7w-1; Fri, 10 Mar 2023 02:12:41 -0500
X-MC-Unique: TBVSgOHmNiO614svQOhC7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FF0D884340;
	Fri, 10 Mar 2023 07:12:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9360E492B04;
	Fri, 10 Mar 2023 07:12:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E3B919466DF;
	Fri, 10 Mar 2023 07:12:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0DA9719465B5
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 08:38:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E0906140EBF4; Thu,  9 Mar 2023 08:38:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D899E1402427
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 08:38:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBDFA3C0E453
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 08:38:58 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-YaKEKH9TOGyTN3AAR7rerA-1; Thu, 09 Mar 2023 03:38:55 -0500
X-MC-Unique: YaKEKH9TOGyTN3AAR7rerA-1
Received: by mail-wm1-f50.google.com with SMTP id
 l7-20020a05600c1d0700b003eb5e6d906bso670367wms.5; 
 Thu, 09 Mar 2023 00:38:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678351134;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=OkEI6G2+STx/pl7XouPsn1BXR8j1gz6yChT5skxEe2c=;
 b=mbWYweeOmm4m4nRcOmfP9lM/TI/M+fqlT9Y/8RYxclXE60OzGHwyTGrih8Vscx80s7
 DD6kUB/qNzSc19FhJDbRBNI5JKvpfOg36wKWGJkgYvzzGoYldiksawbbHTjefJtVksXB
 LwHAnbuXQs0vOb/ejubGeYB+CsJYJEGynqx4F6LUFVpIIeQojPtC8oi8Bv9C7Z6v75Jv
 ms3HUoGH2VUl82MLxDsKhogYyL7TNpQnRa937/18Z5mYS2bZocQ+Eoo29er6qyX6nQ1a
 A+mr6wQbLeg0IEiFSfAgKEsfO9635BZP+L0P8KjaqFKAhDGTxuvq3NpzFF9IlKAcQwVC
 eKKw==
X-Gm-Message-State: AO0yUKUgmiHlI7HawDERWfP+mQ4sDGFWNK6KyqMN8L+3UIlQjRAWXTI6
 KnFNIFrCJvNyg3hWVcaT4E0HSEI7M4zTDVG4
X-Google-Smtp-Source: AK7set8fNpIDus5m04T07BWnhfd7dCNGUmgYnUIp1FIpzj85MUfLSnn79YaeHrTwSZSph4BPPzkBEA==
X-Received: by 2002:a05:600c:1907:b0:3dd:af7a:53db with SMTP id
 j7-20020a05600c190700b003ddaf7a53dbmr18790356wmq.11.1678351133724; 
 Thu, 09 Mar 2023 00:38:53 -0800 (PST)
Received: from apollon.wilcks.net
 (dslb-002-203-204-105.002.203.pools.vodafone-ip.de. [2.203.204.105])
 by smtp.gmail.com with ESMTPSA id
 s10-20020a1cf20a000000b003dc4480df80sm1845119wmc.34.2023.03.09.00.38.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Mar 2023 00:38:53 -0800 (PST)
Message-ID: <14a2e53c90802d36259e024f813a21d081321816.camel@googlemail.com>
From: mwilck@googlemail.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
 <christophe.varoqui@opensvc.com>, Brian Bunker <brian@purestorage.com>
Date: Thu, 09 Mar 2023 09:38:51 +0100
In-Reply-To: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
References: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Fri, 10 Mar 2023 07:12:33 +0000
Subject: Re: [dm-devel] [PATCH 0/3] handle transitioning devices in TUR
 checker
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Brian,

could you give this patch set a test in your environment?

On Tue, 2023-03-07 at 16:49 -0600, Benjamin Marzinski wrote:
> This patchset is based on Brian Bunker's "libmultipath: return
> 'ghost' state when port is in transition" patch:
>=20
> https://listman.redhat.com/archives/dm-devel/2023-February/053344.html
> https://github.com/opensvc/multipath-tools/pull/60
>=20
> Instead of setting the state to PATH_GHOST, it uses PATH_PENDING. The
> other two patches are small cleanups to the TUR checker that I
> noticed
> while writing the first patch.
>=20
> Benjamin Marzinski (3):
> =A0 libmultipath: return 'pending' state when port is in transition
> =A0 libmultipath: set init failure message when init fails
> =A0 libmultipath: reset nr_timeouts if we freed the context
>=20
> =A0libmultipath/checkers/tur.c | 24 +++++++++++++++++++-----
> =A01 file changed, 19 insertions(+), 5 deletions(-)
>=20

I'd like to wait for Brian's results.=A0From code inspection, and with
Ben's explanation for the 3/3 logic,

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

