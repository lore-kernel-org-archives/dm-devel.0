Return-Path: <SRS0=F0YI=IP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FCFC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 19:39:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B2B8064EEC
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 19:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2B8064EEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=purestorage.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-AEMuIe8_Nfm2MexZ3X1YRw-1; Wed, 17 Mar 2021 15:39:34 -0400
X-MC-Unique: AEMuIe8_Nfm2MexZ3X1YRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F12D10866A0;
	Wed, 17 Mar 2021 19:39:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EA0D50AC6;
	Wed, 17 Mar 2021 19:39:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7399C1809C83;
	Wed, 17 Mar 2021 19:39:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12HJdPOO016733 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Mar 2021 15:39:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 51AD7F5677; Wed, 17 Mar 2021 19:39:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C068F5587
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 19:39:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D27E85A5BA
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 19:39:22 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
	[209.85.219.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-417-J4w31oW3NvWjyVDbW7WgHw-1; Wed, 17 Mar 2021 15:39:20 -0400
X-MC-Unique: J4w31oW3NvWjyVDbW7WgHw-1
Received: by mail-qv1-f46.google.com with SMTP id q9so1975932qvm.6
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 12:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:content-transfer-encoding:mime-version
	:subject:message-id:date:to;
	bh=dl24h6rvUnlGzkqonk3cydn40MXkH1vG2xIqeXvOik8=;
	b=NXgt5lR68MQrHApdd4h97HmSFfyAxIP9w7gSGqAmHjqYSSUjzgJyb99LbA4kjug7yd
	gK/sroI/Ov/kTmIDDj87u2R1B67jZwVHk+rktjR7H3kGkfPxbIwfCRmXP/a2O6ImlimZ
	5vs7a0/tNA/kNigOlXtjSB85VTRT6FgtjaiahpRQMfgd4iCwjUxe/UIkEgFlGT7YseuZ
	8AZRwwQIh9+tZGIMxmKhuoga8XwafDC57MdtA1GQfcjMJzdm1VJcPAL9V5sP3ujeMgN4
	Y+2C2Cn8tbR1zMWbNQ9E56HZY6/EDC4pBBvFlSKFvVmlYeqJJrYuQZSkwN6j9WJxNnd0
	Hxhw==
X-Gm-Message-State: AOAM531lkbOYWzWDDVu7ZS/Tk84fPUKctS0/CBW2fR8hc7JkNfhkJn85
	KF72P2iYI1Ul3aQOJYbyEAsxnUCWEoSicIrgi403bQeUT3/8hmyohMfTDqqe55YfvlrDuH0Wbs6
	eiHHcmxH6pc4Uc4h1HtUDyJUKOnYBEHPOXOu/BVDAkTklobidR7IZoEvqsYJdZ5F9P/E=
X-Google-Smtp-Source: ABdhPJx4n4G9IcPHfV9u+qCimI79xIYcHarXvNAqt3OrPiVXij4j/yv1Ek5bTvxlNt6ofjhMxPH2Hg==
X-Received: by 2002:a0c:fa48:: with SMTP id k8mr749405qvo.19.1616009958859;
	Wed, 17 Mar 2021 12:39:18 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:6970:bea0:15ce:9be6:f7c3:fb2d])
	by smtp.gmail.com with ESMTPSA id
	s24sm18216653qks.127.2021.03.17.12.39.17 for <dm-devel@redhat.com>
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 17 Mar 2021 12:39:18 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Message-Id: <7D803042-0316-4C64-A273-D35CFFEC7D78@purestorage.com>
Date: Wed, 17 Mar 2021 12:39:16 -0700
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12HJdPOO016733
X-loop: dm-devel@redhat.com
Subject: [dm-devel] ALUA state unavailable and device discovery
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello All,

There seems to be an incompatibility in the Linux SCSI code between SCSI disk
discovery and the ALUA state unavailable. From the SPC specification if you use
ALUA state unavailable you also set the peripheral qualifier for that path.

While in the unavailable primary target port asymmetric access state, the device
server shall support those of the following commands that it supports while in the 
active/optimized state:
a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to 001b)
...

The problem with that is that it limits when the host can discover disks or reboot.
In order for an sd device to be created, the PQ must be 0. This seems to come from the
scsi_bus_match function in scsi_sysfs.c.

return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;

So it only will return 1, if the PQ is 0. 

As a result if a SCSI device is discovered while the ALUA state for that path is
in the unavailable state, an sd device will not be created. An sg device will but
not an sd one. As a result multipath will not create a dm device. Or, if an existing
dm device exists, a path for this newly discovered device will not be created. This
means when the device moves out of unavailable to an active ALUA state, or even
standby, there is no device, so no path to change the state of in multipath's dm
device.

For this reason the ALUA state standby looks attractive since it doesn't have
the PQ requirement. But looking at the commands required for support in the standby
ALUA state, there are some that are difficult to support in the disconnected peer
state, most notably persistent reservations, where not having access to a peer
can result in an inability to keep a consistent state when and if the path again
becomes available. The unavailable ALUA state has the right command list to support
in being disconnected from the source of truth, but the PQ requirement is the
trade off.

Is the PQ check here because of INQUIRY requests sent to non-existent LUNs leading
to sd devices being created?

In response to an INQUIRY command received by an incorrect logical unit, the SCSI
target device shall return the INQUIRY data with the peripheral qualifier set to the
value defined in 6.6.2.

As a test, I changed this line to this to allow sd to create devices where the
peripheral qualifier is not 011b as opposed to needing to be 000b.

return (sdp->inq_periph_qual != SCSI_INQ_PQ_NOT_CAP)? 1: 0;

This does allow an sd device to be created and multipath to create a path for it
in a dm device.

3624a93706a10c27f300a496100011010 dm-2 PURE    ,FlashArray      
size=2.0T features='0' hwhandler='1 alua' wp=rw
`-+- policy='service-time 0' prio=0 status=enabled
 `- 7:0:0:1 sdb 8:16 failed undef running

It is in the failed state, but when it comes back to an online ALUA state, the path
will return to active. There is an inconsistency since if the device was in any other
state than unavailable when it was discovered and then transitions to the unavailable
state, the device is already created so it can be transitioned in multipath and all
is good.

Is there a way to handle both unintended consequence and the ALUA unavailable state?

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

