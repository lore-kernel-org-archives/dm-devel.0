Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93A4C56201
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:55:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F27A42073C
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:54:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F27A42073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-SHnleTNKNBCtOAs_DNFM5Q-1; Tue, 24 Nov 2020 03:54:57 -0500
X-MC-Unique: SHnleTNKNBCtOAs_DNFM5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA836100C617;
	Tue, 24 Nov 2020 08:54:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B93E919C66;
	Tue, 24 Nov 2020 08:54:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8B2211809CA1;
	Tue, 24 Nov 2020 08:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ANJbuEP015059 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Nov 2020 14:37:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AA8A42166B2C; Mon, 23 Nov 2020 19:37:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A25AE2166B2B
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 19:37:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F1D3858299
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 19:37:53 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-559-PF9HxLXRMKKGXE_JoFHe_g-1;
	Mon, 23 Nov 2020 14:37:50 -0500
X-MC-Unique: PF9HxLXRMKKGXE_JoFHe_g-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 999C720B717A;
	Mon, 23 Nov 2020 11:37:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 999C720B717A
To: James Morris <jmorris@namei.org>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201119232611.30114-9-tusharsu@linux.microsoft.com>
	<alpine.LRH.2.21.2011211301340.18334@namei.org>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <33718d39-a3a2-595b-46b0-f1a195348000@linux.microsoft.com>
Date: Mon, 23 Nov 2020 11:37:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2011211301340.18334@namei.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 24 Nov 2020 03:53:49 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 8/8] selinux: measure state and hash of
 the policy using IMA
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi James,

On 2020-11-20 6:05 p.m., James Morris wrote:
> On Thu, 19 Nov 2020, Tushar Sugandhi wrote:
> 
>> an impact on the security guarantees provided by SELinux. Measuring
>> such in-memory data structures through IMA subsystem provides a secure
>> way for a remote attestation service to know the state of the system
>> and also the runtime changes in the state of the system.
> 
> I think we need better clarity on the security model here than just "a
> secure way...".  Secure how and against what threats?
> 
Thanks for taking a look at this patch series.

Here is the overall threat model:

For a given device inside an organization, various services/
infrastructure tools owned by the org interact with the device. These
services/tools can be external to the device. They can interact with the
device both during setup and rest of the device lifetime. These
interactions may involve sharing the org sensitive data and/or running
business critical workload on that device. Before sharing data/running
workload on that device - the org would want to know the security
profile of the device. E.g. SELinux is enforced (with the policy that is
expected by the org), disks are encrypted with a certain configuration,
secure boot is enabled etc. If the org requirements are satisfied, then
only the external services will start interacting with the device.

For the org, extracting that information from the device is tricky.
The services could look for some markers on the device necessary to
satisfy the org requirements. But the device could already be
compromised with some malware, and could simply lie to the external
services by putting false markers on the device. For instance, the
malware can put a random SELinux policy file at the expected location
even when SELinux is not even enabled on the device.

If the org trusts these false markers, the compromised device could go
undetected - and can do further damage once it has access to the org
sensitive data / business critical processes.

This is the threat we are trying to address.

For the org, to address this threat - at least three things are needed:

(1) Producers of the markers are as close to the source as possible:
The source that does the work of actually protecting the device.
E.g. SELinux state reported from the SELinux kernel LVM itself, rather
than some user mode process extracting that information).
This will make it harder for the bad actors to mimic the information -
thus reducing the ROI for them.

(2) Extracting the information from the device in a tamper resistant
way:
Even if the information is produced by the expected source, it can still
get altered by attackers. This can happen before the info reaches the
external services - the services that make the decision whether to trust
the device with org sensitive info or not.
The IMA measurement infrastructure, with TPM extend and quoting,
provides the necessary assurance to those services - that the
information coming from the device is not tampered with.

(3) Tracking the state change during the lifetime of the device:
The device may start in a good configuration. But over the lifetime,
that configuration may deteriorate. E.g. SELinux stores the
current operating mode, in memory, which could be "enforce" or "audit".
Changes to this data at runtime impacts the security guarantees provided
by SELinux. Such changes could be made inadvertently or by malware
running on the device.


The IMA hook plus policies in the first 7/8 patches provide the
necessary functionality to achieve (2).

The last SELinux 8/8 patch helps achieve (1).

And the patches in the series overall work together to achieve (3).

> This looks to me like configuration assurance, i.e. you just want to know
> that systems have been configured correctly, not to detect a competent
> attack. Is that correct?

The attestation service would look at various measurements coming from
the device. And there could be a discrepancy between the measurements,
or the measurements won't match the expected predetermined values. In
that case, the attestation service may conclude that not only the device
is misconfigured, but also that misconfiguration is a result of
potentially compromised device. Then the necessary action can be taken
for the device (removing it from the network, not sharing data/workload
with it etc.)

~Tushar

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

