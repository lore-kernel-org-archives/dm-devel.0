Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A8AC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 10:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643712924;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=97txYVgrvwUH9ekE1jK1RtwwC94+Yla1QMgOjMnBb6Y=;
	b=akvZctncMmAXLc/PX3eIfV5kjWFXnS1j8MRANbXfwnN3NgSm1hg3JP0fNrasoF4OUgzLFm
	BcGyCLmQr3yiRec7WiICsuVyoNtPY8V/N2lyCsb7NN+b7k4vr8BAT0mIpzT69i4j5VjSxU
	XOFLs0ue0RBfE+cUoDbS6FFiUH8u5Co=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-BV37eD9kPVW3WbUsTGJJ8w-1; Tue, 01 Feb 2022 05:55:21 -0500
X-MC-Unique: BV37eD9kPVW3WbUsTGJJ8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 605A68143EA;
	Tue,  1 Feb 2022 10:55:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED9306D036;
	Tue,  1 Feb 2022 10:55:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9CE331809C88;
	Tue,  1 Feb 2022 10:55:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211AtEHT027781 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 05:55:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F44DC01783; Tue,  1 Feb 2022 10:55:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BE11C159F6
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 10:55:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 012C2811E81
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 10:55:14 +0000 (UTC)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
	[209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-592-tbSSLGwFP2epdGGhx7r_pA-1; Tue, 01 Feb 2022 05:55:13 -0500
X-MC-Unique: tbSSLGwFP2epdGGhx7r_pA-1
Received: by mail-ej1-f71.google.com with SMTP id
	i21-20020a1709063c5500b006b4c7308c19so6354382ejg.14
	for <dm-devel@redhat.com>; Tue, 01 Feb 2022 02:55:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Bs5qVdvwBUGV9CbX2iAF3QdXaAuh/sgKRHE7W/lrxX8=;
	b=b2PPpY3DztNVBeSOG98O5D1V+cmt9OqmbRH2Z1kgi1CFFpkmOn706GwjA2wOQEgCLI
	EePEM5YCGgG5u7JxgSQ/cZgw2bEvlkyzWewlpg9EN8bWlRkqtMCgwMqrIEbJ4/po2F4k
	/08IEJ9hqBfJe4Jit704dxIql7mLVma+f7BSbNBknXpu9XSBu5fDLmvwgaxZ2gRWL3Fk
	QAuQvvrDshJM1AZbLJhm16fYvSnBFt1bSY9vcgz2A0Ea4mI/F2aOozd1s4oBPJ5vF/TA
	mUwfrFVThILY5ysYfLQu2MKkUgsTTlz+gwP5zIQjzXOGvwtCcL9sg7SexfL0ebFZRwoM
	ffKQ==
X-Gm-Message-State: AOAM5315HXzdZFjMqte3CNncbCDHgzqUKDAJZaDs6lOm9G0nEZedC/Ti
	5b6t2OUK7H0ZYFudW++38Exo/qdiHR1+ByxPQGoY3sw/2TKQh3zhfkE75gqA1OmBK8apnc/PDft
	1o2SqlD0DyFWW7ng=
X-Received: by 2002:aa7:d312:: with SMTP id p18mr23852767edq.49.1643712911774; 
	Tue, 01 Feb 2022 02:55:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRMUUOXDPMlHVqm5AitAuaZvw7/An3bOUNSoYbhJBW/XYtn0bCIUbc7YkChUH/SN+vtLfTDw==
X-Received: by 2002:aa7:d312:: with SMTP id p18mr23852758edq.49.1643712911546; 
	Tue, 01 Feb 2022 02:55:11 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[213.175.37.10]) by smtp.gmail.com with ESMTPSA id
	gh14sm14342005ejb.38.2022.02.01.02.55.11
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 01 Feb 2022 02:55:11 -0800 (PST)
Date: Tue, 1 Feb 2022 11:55:07 +0100
From: Peter Rajnoha <prajnoha@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220201105507.rq7rll4qjhxonzu6@alatyr-rpi.brq.redhat.com>
References: <a1f472a89e9825f90a4104bea535086f0cde6b93.camel@suse.com>
	<d0d0d8f39257bcddf480524f01faae1f15ac2c42.camel@suse.com>
	<e85bd660-0c50-df5d-35de-2fd5b16cc47f@gmail.com>
	<0a55dd1393df2c125f8cb443daaeb7d1b7162bcc.camel@suse.com>
	<aba2f6dd-f4cf-6af4-e2b6-965f5de06cd8@redhat.com>
	<92de9eff521e2702e364f7aa3cce6927d9d9c03c.camel@suse.com>
	<1b20e88f-2714-3c61-73a6-2f34f6a34edc@gmail.com>
	<712b54a06fa1b13f9ac92a00d7b121979c43d31c.camel@suse.com>
	<20220131133354.vfomn5gdlgrhue4g@alatyr-rpi.brq.redhat.com>
	<3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <3f7f5039c4529912970f21fe699ad204dfbe5be3.camel@suse.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: Franck Bui <fbui@suse.de>, lvm-devel@redhat.com, dm-devel@redhat.com,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev: create symlinks and watch even in
	suspended state
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue 01 Feb 2022 09:40, Martin Wilck wrote:
> On Mon, 2022-01-31 at 14:33 +0100, Peter Rajnoha wrote:
> > (just discussed this with Zdenek too)
> > 
> > The patch makes sense to me!
> > 
> > We added all the DM_UDEV_PRIMARY_SOURCE_FLAG and related for exactly
> > such cases where we need to take the existing values already scanned
> > in previous event, main use-case being the trigger at boot. We just
> > didn't cover the 13-dm-disk.rules with the same logic regarding the
> > suspended state to keep the symlinks - I didn't think it would cause
> > issues (because, usually, after suspend, we anticipate incoming
> > resume where the device is scanned again).
> > 
> > But yes, if temporarily losing the symlink causes issues, your patch
> > solves that (Zdenek will push that upstream).
> 
> Thank you very much! It occured to me that if we want to solve my use
> case with minimal risk, we could make the the case in which the
> symlinks are preserved conditional on ACTION=="add" (i.e. true coldplug
> events). Tell me if you'd prefer that, I can re-submit.

I'd keep it for both actions ("add" and "change") because:

  - we won't be creating special case where only "add" is processed in
    13-dm-disk.rules,

  - there's also a chance that someone might call "udevadm trigger
    --action=change" which should also work.

I've just been playing with this change a bit and noticed we forgot to
"IMPORT{db}" the blkid values. I tried this with an fs on top of <dm_dev>
so there should be ID_FS_UUID_END based on which the /dev/disk/by-uuid/<UUID>
should be present:

   1) "udevadm info --name=<dm_dev>"
      (ID_FS_UUID_ENC is there and included in DEVLINKS)

   2) "dmsetup suspend <dm_dev>"

   3) "echo add > /sys/block/<dm_dev>/uevent"
      (to simulate the trigger)

   4) "udevadm info --name=<dm_dev>"
      (ID_FS_UUID_ENV should still be there and included in DEVLINKS)

   5) "dmsetup resume <dm_dev>"
      (ID_FS_UUID_ENV + DEVLINKS still correct)

Thing is, we only restore DM_* values in 10-dm.rules, but we need to do
the same for blkid values. That would be a patch like this on top of yours:

 udev/13-dm-disk.rules.in | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
index 5cc08121e..9b1a0b562 100644
--- a/udev/13-dm-disk.rules.in
+++ b/udev/13-dm-disk.rules.in
@@ -17,12 +17,22 @@ ENV{DM_UDEV_DISABLE_DISK_RULES_FLAG}=="1", GOTO="dm_end"
 SYMLINK+="disk/by-id/dm-name-$env{DM_NAME}"
 ENV{DM_UUID}=="?*", SYMLINK+="disk/by-id/dm-uuid-$env{DM_UUID}"
 
-ENV{DM_SUSPENDED}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_link"
-ENV{DM_NOSCAN}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_link"
+ENV{DM_SUSPENDED}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_blkid_restore"
+ENV{DM_NOSCAN}=="1", ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="dm_blkid_restore"
 ENV{DM_SUSPENDED}=="1", GOTO="dm_end"
 ENV{DM_NOSCAN}=="1", GOTO="dm_watch"
 
 (BLKID_RULE)
+GOTO="dm_link"
+
+LABEL="dm_blkid_restore"
+IMPORT{db}="ID_FS_USAGE"
+IMPORT{db}="ID_FS_UUID_ENC"
+IMPORT{db}="ID_FS_LABEL_ENC"
+IMPORT{db}="ID_PART_ENTRY_UUID"
+IMPORT{db}="ID_PART_ENTRY_SCHEME"
+IMPORT{db}="ID_PART_ENTRY_NAME"
+IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
 
 LABEL="dm_link"
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}=="1", OPTIONS="link_priority=-100"

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

