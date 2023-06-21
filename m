Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBAF4EB64D8
	for <dm-devel@archiver.kernel.org>; Wed, 21 Jun 2023 21:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687381671;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YLeU8aG0g+FItIvz+kjBJh5eTpE55HFUosxa086XN/4=;
	b=H2uMMTFs/o1bacXicmELDy4OeXw+VED8cEzeteA8ubRVtvUMO40We6Ba0kCZB7cnho2BIq
	khQoRKDMGgAbTCurD7S5HSuU254iJvaPDLyBAmglIkeZEf4+h+du3TVq7NEerQXaskHXWj
	dFxBMMDN68h8KULR12T+1C9bNPDJHwE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-h4sq-XfFP5WTbxTDezTAqw-1; Wed, 21 Jun 2023 17:07:48 -0400
X-MC-Unique: h4sq-XfFP5WTbxTDezTAqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CBA58C5866;
	Wed, 21 Jun 2023 21:07:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02B422017DE2;
	Wed, 21 Jun 2023 21:07:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA2E41946587;
	Wed, 21 Jun 2023 21:07:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 064341946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Jun 2023 21:07:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6F5C14682FA; Wed, 21 Jun 2023 21:07:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CFA2114682F8
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 21:07:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B495B38117E1
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 21:07:20 +0000 (UTC)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-c8rW5tmLPhqIu2Vs5KCLbg-1; Wed, 21 Jun 2023 17:07:17 -0400
X-MC-Unique: c8rW5tmLPhqIu2Vs5KCLbg-1
Received: by mail-pf1-f172.google.com with SMTP id
 d2e1a72fcca58-66872d4a141so2465776b3a.1
 for <dm-devel@redhat.com>; Wed, 21 Jun 2023 14:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687381636; x=1689973636;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=zxmHl6BRr4PCuqTmBRiO+tAEIgtNXslvgtPUDDYEk5g=;
 b=QX/oaPA7BCMmyRrH/2HY2G/w9yzFl/vOuIWU88qaUzF1iujpu9vSv+3pb2/G1teUuD
 u3hRP8mBPQUKsWlTw9B7hqlitVo4TgBAUDcLTY288iVO8z0Pnf3ZZ0TR+/8V8fMV2Aqu
 oh7kdSVfarSaHKR2yR/XLUrjdXnFkHJG6271YQu787XIZPm0qbqKYrd2nDo+4KnwBxPm
 3vG6yuDgDXLsV648tCj1GHxK2A1gAgJZ5CU0liSY9Pi2EyOE3COQEQXOjap/Wnktsjzh
 a9Odpu73muXO/8OFp/WfWBtglMUssfXmwHkEiHMtASrAwgKcLpTvT3w30Pk6UZ2oGujf
 v7qQ==
X-Gm-Message-State: AC+VfDyyUgPwldVdgzQ7fgAOv7JesOLFVqtFuxcTWtqcqvBy+pOVVIg4
 NCN3ukTBdx04/3ymK4PRapI=
X-Google-Smtp-Source: ACHHUZ7UDAN/DUH7d080Yzd19oIbDx6FPfqIcDrxG092wrfQR3eJP0wA81oUirDnxYC5Jt9r4xQd0w==
X-Received: by 2002:a05:6a20:3d88:b0:10e:96b5:45fa with SMTP id
 s8-20020a056a203d8800b0010e96b545famr13704285pzi.43.1687381635960; 
 Wed, 21 Jun 2023 14:07:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 g7-20020a635207000000b00528db73ed70sm3529775pgb.3.2023.06.21.14.07.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jun 2023 14:07:15 -0700 (PDT)
Date: Wed, 21 Jun 2023 14:07:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <8c1992bc-110a-4dad-8643-766c14bf6fd4@roeck-us.net>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-15-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230523074535.249802-15-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 14/24] init: clear root_wait on all invalid
 root= strings
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: roeck-us.net
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On Tue, May 23, 2023 at 09:45:25AM +0200, Christoph Hellwig wrote:
> Instead of only clearing root_wait in devt_from_partuuid when the UUID
> format was invalid, do that in parse_root_device for all strings that
> failed to parse.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

In linux-next, almost all of my boot tests from usb drives as well
as a few others fail with "Disabling rootwait; root= is invalid."
in the log. Bisect points to this patch.

It can not easily be reverted, but the following change fixes the problem.

--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -413,10 +413,12 @@ static dev_t __init parse_root_device(char *root_device_name)
 
        error = early_lookup_bdev(root_device_name, &dev);
        if (error) {
+#if 0
                if (error == -EINVAL && root_wait) {
                        pr_err("Disabling rootwait; root= is invalid.\n");
                        root_wait = 0;
                }
+#endif
                return 0;
        }
        return dev;

Debugging shows that early_lookup_bdev() indeed returns -EINVAL.
Looking into it further, it turns out that devt_from_devname() returns
-EINVAL for root devices such as
	root=/dev/sda
if the device is not found, making it impossible to rootwait for such
a device (this might for example be a raw USB drive without partitions,
or any qemu drive with format=raw).

Guenter

---
# bad: [15e71592dbae49a674429c618a10401d7f992ac3] Add linux-next specific files for 20230621
# good: [45a3e24f65e90a047bef86f927ebdc4c710edaa1] Linux 6.4-rc7
git bisect start 'HEAD' 'v6.4-rc7'
# good: [e867e67cd55ae460c860ffd896c7fc96add2821c] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git bisect good e867e67cd55ae460c860ffd896c7fc96add2821c
# bad: [0ab4015a11182e2a19c3dd52db85418f370cef39] Merge branch 'for-next' of git://git.kernel.dk/linux-block.git
git bisect bad 0ab4015a11182e2a19c3dd52db85418f370cef39
# good: [901bdf5ea1a836400ee69aa32b04e9c209271ec7] Merge tag 'amd-drm-next-6.5-2023-06-09' of https://gitlab.freedesktop.org/agd5f/linux into drm-next
git bisect good 901bdf5ea1a836400ee69aa32b04e9c209271ec7
# good: [07164956fbc26eff280f3a044a489460ae36413c] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
git bisect good 07164956fbc26eff280f3a044a489460ae36413c
# good: [3067e020d361ed346957eb5e253911f7a3e18f59] add snd_soc_{of_}get_dlc()
git bisect good 3067e020d361ed346957eb5e253911f7a3e18f59
# bad: [0dbbd269fb6a8799f312dfc9b1ae1244a144cfc6] Merge branch 'for-6.5/block' into for-next
git bisect bad 0dbbd269fb6a8799f312dfc9b1ae1244a144cfc6
# good: [6c500000af037f74b66dd01b565c8ee1b501cc1b] block: mark bio_add_folio as __must_check
git bisect good 6c500000af037f74b66dd01b565c8ee1b501cc1b
# bad: [1a0ddd56e545b743af510b5a1b8dbdfe7d35cd3b] pktcdvd: replace sscanf() by kstrtoul()
git bisect bad 1a0ddd56e545b743af510b5a1b8dbdfe7d35cd3b
# good: [e3102722ffe77094ba9e7e46380792b3dd8a7abd] init: rename mount_block_root to mount_root_generic
git bisect good e3102722ffe77094ba9e7e46380792b3dd8a7abd
# bad: [d4a28d7defe79006e59293a4b43d518ba8483fb0] dm: remove dm_get_dev_t
git bisect bad d4a28d7defe79006e59293a4b43d518ba8483fb0
# good: [c0c1a7dcb6f5db4500e6574294674213bc24940c] init: move the nfs/cifs/ram special cases out of name_to_dev_t
git bisect good c0c1a7dcb6f5db4500e6574294674213bc24940c
# bad: [702f3189e454b3c3c2f3c99dbf30acf41aab707c] block: move the code to do early boot lookup of block devices to block/
git bisect bad 702f3189e454b3c3c2f3c99dbf30acf41aab707c
# bad: [079caa35f7863cd9958b4555ae873ea4d352a502] init: clear root_wait on all invalid root= strings
git bisect bad 079caa35f7863cd9958b4555ae873ea4d352a502
# good: [cf056a43121559d3642419917d405c3237ded90a] init: improve the name_to_dev_t interface
git bisect good cf056a43121559d3642419917d405c3237ded90a
# first bad commit: [079caa35f7863cd9958b4555ae873ea4d352a502] init: clear root_wait on all invalid root= strings

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

