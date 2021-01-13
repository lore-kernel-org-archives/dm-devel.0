Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08470C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 19:20:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EFCB217BA
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 19:20:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EFCB217BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-94AiSDewNGOohXG3jO36qA-1; Wed, 13 Jan 2021 14:19:49 -0500
X-MC-Unique: 94AiSDewNGOohXG3jO36qA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BA7410151FB;
	Wed, 13 Jan 2021 19:19:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E44221980F;
	Wed, 13 Jan 2021 19:19:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD73B5002C;
	Wed, 13 Jan 2021 19:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DJJgLI017457 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 14:19:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 091A6D7DE8; Wed, 13 Jan 2021 19:19:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0389CD7DE6
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 19:19:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B38F2101A53F
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 19:19:39 +0000 (UTC)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
	[209.85.218.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-254-yClJCbqaM7qNuM3Y-SwW8Q-1; Wed, 13 Jan 2021 14:19:37 -0500
X-MC-Unique: yClJCbqaM7qNuM3Y-SwW8Q-1
Received: by mail-ej1-f42.google.com with SMTP id q22so4704853eja.2
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=S/PHuWHTpBgQdNKFQVbdGCQEXvy7VZiLuqAEx0fTPmc=;
	b=lxELEJ+W+Q1RwoLG0otuc5lpv3+yPorTabli64YzZ4lXmH1QkPnq7eq0q1/RmYfcfp
	HBNVBPEck0YEDHwN6U6IMUMtCtLnqJVnF8tL9Z+TwyDW7zi+CNmD1HoSEGq6JZ57CX3q
	X1QmqiS7bKDUNPPD3Wncmtlu9xDygxOoKkcg5mS/aktn7q/1FzLYrStPxUJQkJAAqZlq
	tq6jzY2mROCF4jynGC3gr1uNEKSd/INOEXjRq9w2FOmSPmgZgP0903Yc+SDngZWeE6ai
	NcegekZwGb4AdqNK66/RWxE3KAMgvqk/s9W57ELrRdzZnDDGUHOsYihXZllKGX4ivO9e
	tFuA==
X-Gm-Message-State: AOAM532kXzHREVaBnSqe1WBNe6fyyr9ALvOPdetYbT1ZgGKLTarXvaCw
	05fjQH2TOlTKyCNWCPg1a8ORVEAdezpLkGgqOBL3
X-Google-Smtp-Source: ABdhPJzpy46FnrM89yDbgKYDTI8w6gf3C22HrHYgT3GZAYPhAuzSu+VXCuKNthgyqqXgSQ08rYGZHUwVDEZ9CXerKRc=
X-Received: by 2002:a17:907:4126:: with SMTP id
	mx6mr2618600ejb.91.1610565575830; 
	Wed, 13 Jan 2021 11:19:35 -0800 (PST)
MIME-Version: 1.0
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
	<20210108040708.8389-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSJk0wG=WzO3bwsueiy19mMi9m6MamTrQfH8C=gXUtvGw@mail.gmail.com>
	<97328fc71687a0e1c327f6821548be9ba35bb193.camel@linux.ibm.com>
In-Reply-To: <97328fc71687a0e1c327f6821548be9ba35bb193.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 13 Jan 2021 14:19:24 -0500
Message-ID: <CAHC9VhTzaQ_q8gJ0oeok_yJ54XLETNvOuhhKnyRwgqsqvpBLCw@mail.gmail.com>
To: Mimi Zohar <zohar@linux.ibm.com>
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
Cc: sashal@kernel.org, dm-devel@redhat.com, snitzer@redhat.com,
	nramas@linux.microsoft.com, selinux@vger.kernel.org,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com,
	Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	linux-integrity@vger.kernel.org, gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v10 8/8] selinux: include a consumer of the
 new IMA critical data hook
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 13, 2021 at 2:13 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> On Tue, 2021-01-12 at 11:27 -0500, Paul Moore wrote:
> > On Thu, Jan 7, 2021 at 11:07 PM Tushar Sugandhi
> > <tusharsu@linux.microsoft.com> wrote:
> > > From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> > >
> > > SELinux stores the active policy in memory, so the changes to this data
> > > at runtime would have an impact on the security guarantees provided
> > > by SELinux.  Measuring in-memory SELinux policy through IMA subsystem
> > > provides a secure way for the attestation service to remotely validate
> > > the policy contents at runtime.
> > >
> > > Measure the hash of the loaded policy by calling the IMA hook
> > > ima_measure_critical_data().  Since the size of the loaded policy
> > > can be large (several MB), measure the hash of the policy instead of
> > > the entire policy to avoid bloating the IMA log entry.
> > >
> > > To enable SELinux data measurement, the following steps are required:
> > >
> > > 1, Add "ima_policy=critical_data" to the kernel command line arguments
> > >    to enable measuring SELinux data at boot time.
> > > For example,
> > >   BOOT_IMAGE=/boot/vmlinuz-5.10.0-rc1+ root=UUID=fd643309-a5d2-4ed3-b10d-3c579a5fab2f ro nomodeset security=selinux ima_policy=critical_data
> > >
> > > 2, Add the following rule to /etc/ima/ima-policy
> > >    measure func=CRITICAL_DATA label=selinux
> > >
> > > Sample measurement of the hash of SELinux policy:
> > >
> > > To verify the measured data with the current SELinux policy run
> > > the following commands and verify the output hash values match.
> > >
> > >   sha256sum /sys/fs/selinux/policy | cut -d' ' -f 1
> > >
> > >   grep "selinux-policy-hash" /sys/kernel/security/integrity/ima/ascii_runtime_measurements | tail -1 | cut -d' ' -f 6
> > >
> > > Note that the actual verification of SELinux policy would require loading
> > > the expected policy into an identical kernel on a pristine/known-safe
> > > system and run the sha256sum /sys/kernel/selinux/policy there to get
> > > the expected hash.
> > >
> > > Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> > > Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > > Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> > > ---
> > >  Documentation/ABI/testing/ima_policy |  3 +-
> > >  security/selinux/Makefile            |  2 +
> > >  security/selinux/ima.c               | 64 ++++++++++++++++++++++++++++
> > >  security/selinux/include/ima.h       | 24 +++++++++++
> > >  security/selinux/include/security.h  |  3 +-
> > >  security/selinux/ss/services.c       | 64 ++++++++++++++++++++++++----
> > >  6 files changed, 149 insertions(+), 11 deletions(-)
> > >  create mode 100644 security/selinux/ima.c
> > >  create mode 100644 security/selinux/include/ima.h
> >
> > I remain concerned about the possibility of bypassing a measurement by
> > tampering with the time, but I appear to be the only one who is
> > worried about this so I'm not going to block this patch on those
> > grounds.
> >
> > Acked-by: Paul Moore <paul@paul-moore.com>
>
> Thanks, Paul.
>
> Including any unique string would cause the buffer hash to change,
> forcing a new measurement.  Perhaps they were concerned with
> overflowing a counter.

My understanding is that Lakshmi wanted to force a new measurement
each time and felt using a timestamp would be the best way to do that.
A counter, even if it wraps, would have a different value each time
whereas a timestamp is vulnerable to time adjustments.  While a
properly controlled and audited system could be configured and
monitored to detect such an event (I *think*), why rely on that if it
isn't necessary?

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

