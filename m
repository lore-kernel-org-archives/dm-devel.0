Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7BCC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 22:10:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 695BF23136
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 22:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 695BF23136
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-DLn8cm47PUCgSekJ060b-g-1; Wed, 13 Jan 2021 17:10:46 -0500
X-MC-Unique: DLn8cm47PUCgSekJ060b-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71EFB806662;
	Wed, 13 Jan 2021 22:10:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19E7410016F4;
	Wed, 13 Jan 2021 22:10:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1CA9180954D;
	Wed, 13 Jan 2021 22:10:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DMAaQf032268 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 17:10:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5FAC62026D35; Wed, 13 Jan 2021 22:10:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AEB22026D16
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 22:10:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF374101A560
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 22:10:33 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
	[209.85.218.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-586-tAKy-rsdO_K-NS-4qf2LVg-1; Wed, 13 Jan 2021 17:10:31 -0500
X-MC-Unique: tAKy-rsdO_K-NS-4qf2LVg-1
Received: by mail-ej1-f54.google.com with SMTP id g12so5293486ejf.8
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 14:10:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=cHpWTw6lcPxz7z8H8yQJbwdU01y9cP5VFlHIAcOYlIE=;
	b=ol0s2a+4Pr5N3YYBoCT7382ONFmjp9of/IuvGW76EI7U4NAXfIgKGyY1W3Ru0lvuLG
	ht8mZJp9XjHzi5G2xok4Z2lzrUpwlZYyD+dSFIG1qs9r29IDU8xdl/lS4l24MOftRGL6
	8ceUxiG1VUu4r0iSDis6SfSwpq/8Dj4AL5/iajaS69I/rl58k32ETQm23PTSqgL60HUh
	Lk/jjotf8Cfh7OXv0WUr+80rcrz0GhZhsmJwo/Ykm1i/At1gSlCuZbz6MBkM6zttkEqR
	viT8VQYUFasa8FC4wFDOwWfJENam7PBmEJGdTQ4OTl7QXWjeo5aJSZPBfIwLDrhEGmGM
	zBaA==
X-Gm-Message-State: AOAM530NizTIioONhvFiPTYisHKMzj//H9UgCY7dMS6TxtdS7ejrSiz7
	he3t5+kCNiHpOiU5594wsDtPbFUru5TWvetE5bYZ
X-Google-Smtp-Source: ABdhPJyQ+Tv7FzDHXgquLSuHzkUCDHhbnr+LMfzfd+uUbDk6LddmjJQuH97q0w+D3HgxnXmUDLfKkBaytbA3dCAnK58=
X-Received: by 2002:a17:906:3712:: with SMTP id
	d18mr3206433ejc.178.1610575829813; 
	Wed, 13 Jan 2021 14:10:29 -0800 (PST)
MIME-Version: 1.0
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
	<20210108040708.8389-9-tusharsu@linux.microsoft.com>
	<CAHC9VhSJk0wG=WzO3bwsueiy19mMi9m6MamTrQfH8C=gXUtvGw@mail.gmail.com>
	<97328fc71687a0e1c327f6821548be9ba35bb193.camel@linux.ibm.com>
	<CAHC9VhTzaQ_q8gJ0oeok_yJ54XLETNvOuhhKnyRwgqsqvpBLCw@mail.gmail.com>
	<71cddb6c8676ccd63c89364d805cfca76d32cb6e.camel@linux.ibm.com>
In-Reply-To: <71cddb6c8676ccd63c89364d805cfca76d32cb6e.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 13 Jan 2021 17:10:18 -0500
Message-ID: <CAHC9VhRhYWEcK7TepZ=LK1m=9Zn_gtOZyAYfamP-TFU3rRH+zw@mail.gmail.com>
To: Mimi Zohar <zohar@linux.ibm.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 13, 2021 at 4:11 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> On Wed, 2021-01-13 at 14:19 -0500, Paul Moore wrote:
> > On Wed, Jan 13, 2021 at 2:13 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > > On Tue, 2021-01-12 at 11:27 -0500, Paul Moore wrote:
> > > > On Thu, Jan 7, 2021 at 11:07 PM Tushar Sugandhi
> > > > <tusharsu@linux.microsoft.com> wrote:
> > > > > From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> > > > >
> > > > > SELinux stores the active policy in memory, so the changes to this data
> > > > > at runtime would have an impact on the security guarantees provided
> > > > > by SELinux.  Measuring in-memory SELinux policy through IMA subsystem
> > > > > provides a secure way for the attestation service to remotely validate
> > > > > the policy contents at runtime.
> > > > >
> > > > > Measure the hash of the loaded policy by calling the IMA hook
> > > > > ima_measure_critical_data().  Since the size of the loaded policy
> > > > > can be large (several MB), measure the hash of the policy instead of
> > > > > the entire policy to avoid bloating the IMA log entry.
> > > > >
> > > > > To enable SELinux data measurement, the following steps are required:
> > > > >
> > > > > 1, Add "ima_policy=critical_data" to the kernel command line arguments
> > > > >    to enable measuring SELinux data at boot time.
> > > > > For example,
> > > > >   BOOT_IMAGE=/boot/vmlinuz-5.10.0-rc1+ root=UUID=fd643309-a5d2-4ed3-b10d-3c579a5fab2f ro nomodeset security=selinux ima_policy=critical_data
> > > > >
> > > > > 2, Add the following rule to /etc/ima/ima-policy
> > > > >    measure func=CRITICAL_DATA label=selinux
> > > > >
> > > > > Sample measurement of the hash of SELinux policy:
> > > > >
> > > > > To verify the measured data with the current SELinux policy run
> > > > > the following commands and verify the output hash values match.
> > > > >
> > > > >   sha256sum /sys/fs/selinux/policy | cut -d' ' -f 1
> > > > >
> > > > >   grep "selinux-policy-hash" /sys/kernel/security/integrity/ima/ascii_runtime_measurements | tail -1 | cut -d' ' -f 6
> > > > >
> > > > > Note that the actual verification of SELinux policy would require loading
> > > > > the expected policy into an identical kernel on a pristine/known-safe
> > > > > system and run the sha256sum /sys/kernel/selinux/policy there to get
> > > > > the expected hash.
> > > > >
> > > > > Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> > > > > Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > > > > Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> > > > > ---
> > > > >  Documentation/ABI/testing/ima_policy |  3 +-
> > > > >  security/selinux/Makefile            |  2 +
> > > > >  security/selinux/ima.c               | 64 ++++++++++++++++++++++++++++
> > > > >  security/selinux/include/ima.h       | 24 +++++++++++
> > > > >  security/selinux/include/security.h  |  3 +-
> > > > >  security/selinux/ss/services.c       | 64 ++++++++++++++++++++++++----
> > > > >  6 files changed, 149 insertions(+), 11 deletions(-)
> > > > >  create mode 100644 security/selinux/ima.c
> > > > >  create mode 100644 security/selinux/include/ima.h
> > > >
> > > > I remain concerned about the possibility of bypassing a measurement by
> > > > tampering with the time, but I appear to be the only one who is
> > > > worried about this so I'm not going to block this patch on those
> > > > grounds.
> > > >
> > > > Acked-by: Paul Moore <paul@paul-moore.com>
> > >
> > > Thanks, Paul.
> > >
> > > Including any unique string would cause the buffer hash to change,
> > > forcing a new measurement.  Perhaps they were concerned with
> > > overflowing a counter.
> >
> > My understanding is that Lakshmi wanted to force a new measurement
> > each time and felt using a timestamp would be the best way to do that.
> > A counter, even if it wraps, would have a different value each time
> > whereas a timestamp is vulnerable to time adjustments.  While a
> > properly controlled and audited system could be configured and
> > monitored to detect such an event (I *think*), why rely on that if it
> > isn't necessary?
>
> Why are you saying that even if the counter wraps a new measurement is
> guaranteed.   I agree with the rest of what you said.

I was assuming that the IMA code simply compares the passed
"policy_event_name" value to the previous value, if they are different
a new measurement is taken, if they are the same the measurement
request is ignored.  If this is the case the counter value is only
important in as much as that it is different from the previous value,
even simply toggling a single bit back and forth would suffice in this
case.  IMA doesn't keep a record of every previous "policy_event_name"
value does it?  Am I misunderstanding how
ima_measure_critical_data(...) works?

-- 
paul moore
www.paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

