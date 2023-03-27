Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C591AC76195
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 06:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679984879;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kAWRBDSrCBY2M6Ha0XyobtpA9/prcFtIHDwvvNp4wKg=;
	b=O1ZSpMS79n2fAvizIxkpEvZwhlpqbcqgE4rPdrTCKFN97pTg0Fzpn3JNdcxgcKyVb3N1OQ
	U/hEzCSVhVGo21DR/kliUOjzl1mK78dXy+b56y/dObp3muuekHUx5HX7UwDFuVYgAdD7ao
	OEYgrJv/5IeDaW6lUmfhjo9pgmMaHYA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-Dwfaogi1PH6AWSEV2PK6kw-1; Tue, 28 Mar 2023 02:27:56 -0400
X-MC-Unique: Dwfaogi1PH6AWSEV2PK6kw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FBF1185A792;
	Tue, 28 Mar 2023 06:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69EB614171BE;
	Tue, 28 Mar 2023 06:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1143619465B6;
	Tue, 28 Mar 2023 06:27:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6C310194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 00:07:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED27C14171BC; Tue, 28 Mar 2023 00:07:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E50FF14171BB
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 00:07:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9D5085A5A3
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 00:07:44 +0000 (UTC)
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca
 [208.85.217.137]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-r091MH04NYO9JKzeU3s_pQ-1; Mon, 27 Mar 2023 20:07:41 -0400
X-MC-Unique: r091MH04NYO9JKzeU3s_pQ-1
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca
 [208.85.217.145])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 73AAF7595C;
 Mon, 27 Mar 2023 23:58:37 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
 by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 5A0EF60AA4;
 Mon, 27 Mar 2023 23:58:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
 by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new,
 port 10024)
 with ESMTP id iXSEOSz7t8G1; Mon, 27 Mar 2023 23:58:36 +0000 (UTC)
Received: from [192.168.48.17] (host-184-164-23-94.dyn.295.ca [184.164.23.94])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 (Authenticated sender: dgilbert@interlog.com)
 by mail.ca.inter.net (Postfix) with ESMTPSA id E861260256;
 Mon, 27 Mar 2023 23:58:35 +0000 (UTC)
Message-ID: <3f02a075-cc30-5584-704b-da88be1d6b31@interlog.com>
Date: Mon, 27 Mar 2023 19:58:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: mwilck@suse.com, Hannes Reinecke <hare@suse.de>
References: <20230327132459.29531-1-mwilck@suse.com>
From: Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230327132459.29531-1-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 28 Mar 2023 06:27:49 +0000
Subject: Re: [dm-devel] [RFC PATCH 0/3] sg3_utils: udev rules: restrict use
 of ambiguous device IDs
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
Reply-To: dgilbert@interlog.com
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Franck Bui <fbui@suse.de>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: interlog.com
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2023-03-27 09:24, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Most modern SCSI devices provide VPD page 83 with at least one highly
> reliable device identifier, like NAA Registered Extended or EUI-64, or
> the ata-id identifier. Other device identifier types have shown to be less
> reliable and possibly ambiguous. Ambiguity in particular is a problem with
> multipath-tools, which may group unrelated devices together in a multipath
> map, causing possible data corruption.
> 
> The device identifiers are used in two independent ways by the udev rules:
> a) to set ID_SERIAL for subsystems like multipath, and b) to create
> /dev/disk/by-id/scsi-... symlinks. Our udev rules have traditionally created
> symlinks for every device identifier obtained from either VPD 83 or 80. This
> may cause issues, especially on large installments with storage devices that
> exhibit the same identifier for many logical units. At the same time, these
> symlinks are rarely used.
> 
> Avoid using unreliable identifiers for setting ID_SERIAL, and don't create
> symlinks for these identifiers. Add a configuration method that allows
> users to easily re-enable these methods and symlinks if they need to
> (this might be the case on systems with legacy devices that are referenced
> in /etc/crypttab, lvm.conf, or the like). This is done by introducing
> environment variables .SCSI_ID_SERIAL_SRC and .SCSI_ID_SYMLINK_SRC, to
> control use of device identifiers for determining ID_SERIAL and for creating
> symlinks, respectively. Both variables can contain the letters "T", "L", "V",
> and "S" to enable T10-vendor ID, NAA local ID, vendor-specific ID, and VPD 80
> based ID, respectively.
> 
> Distributions can change the defaults for these environment variables
> to provide backward compatibility for their users, while offering users
> an easy way to change the settings.
> 
> I'm sending this as RFC, because I expect that not everyone will agree
> which identifiers should be enabled by default.

Lets see if anything happens. Applied as sg3_utils revision 1019 and
pushed to https://github.com/doug-gilbert/sg3_utils .

Didn't see any effect on an Ubuntu 22.10 when sg3_utils deb package
built and installed. No sign of 00-scsi-sg3_config.rules being placed
anywhere by Ubuntu. Does Suse install those rules?

Doug Gilbert

> Martin Wilck (3):
>    55-scsi-sg3_id.rules: don't set unreliable device ID by default
>    58-scsi-sg3_symlink.rules: don't create extra by-id symlinks by
>      default
>    udev: add 00-scsi-sg3_config.rules for user configuration
> 
>   Makefile.am                       |  1 +
>   scripts/00-scsi-sg3_config.rules  | 23 ++++++++++++++
>   scripts/55-scsi-sg3_id.rules      | 53 ++++++++++++++++++++++++++++---
>   scripts/58-scsi-sg3_symlink.rules | 46 +++++++++++++++++++++------
>   4 files changed, 109 insertions(+), 14 deletions(-)
>   create mode 100644 scripts/00-scsi-sg3_config.rules
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

