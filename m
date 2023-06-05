Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A62FC7EE23
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685985734;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rt4d4Mp0hkj262xErgszH+NihPXR19aypd3DVhONV+c=;
	b=V4tt7LFo+bFAOxjCTHrBOi1jM90g4wp4I3XBcADs2hLkZthtQ8rGqVjL5aSTkYodOMlnDH
	6+A4ZPDzRg/aP1T6IopBoSSuV/vEr/h+l2Jcz7Dv7HIZm7QcfvsyRYAKOq2YrbsvKe6O1w
	5aCdeVopimrQqJKf6dzwpFgdxzbdOvg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-jxiG9tpgMcy2oMuiTNXy3w-1; Mon, 05 Jun 2023 13:22:13 -0400
X-MC-Unique: jxiG9tpgMcy2oMuiTNXy3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FADB1C08781;
	Mon,  5 Jun 2023 17:22:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A7674C1603B;
	Mon,  5 Jun 2023 17:22:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8272C19465A3;
	Mon,  5 Jun 2023 17:22:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9AD561946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 17:22:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 83731C16046; Mon,  5 Jun 2023 17:22:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79011C16044
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 17:22:08 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D4FB8007D9
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 17:22:08 +0000 (UTC)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
 [209.85.167.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-f20ftG8gNIuLLBybQAfwyw-1; Mon, 05 Jun 2023 13:22:05 -0400
X-MC-Unique: f20ftG8gNIuLLBybQAfwyw-1
Received: by mail-oi1-f181.google.com with SMTP id
 5614622812f47-39b349405d9so69722b6e.1
 for <dm-devel@redhat.com>; Mon, 05 Jun 2023 10:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685985725; x=1688577725;
 h=content-transfer-encoding:mime-version:date:message-id:subject
 :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=6XZ3PYFTW8wBOrcxa44gmTJZRL7p9p613s1N10mZMVY=;
 b=U7fMAXTeEVQP0Q9cA2Q4/NoxxG+6XQD/22/ohPATR/e4XVMXHeLxaATSgE4CU+38+I
 PJW5Y3hs9fUuQSw3AXgUAY9N6DA4Be0K0nJ8IHCdXR5apINU0w6YC/ZEuXzB3PQDWcFs
 7w7Wi3Jjx8cK3lodo6xskCds0raJjZLLSyRbZjkCfypiqI+qQh2irf7itMd6b2Zjue87
 fDVVzElrjOTUsExWhmRrjQzokRZp+bEtoC21iQ6kmNq4JcNvrJrmuJjWBf2WClH+DPIS
 fAjJxZVGteYwUw5GzbrmfYuIBNKHQz0kaL5gRErCshTtAroKEKn+oyvaK2LYrP0xA/yj
 KX3g==
X-Gm-Message-State: AC+VfDyaqOReAnCnp1J9xGNkYWwdkDRGRJJA14GbQeDvI1qc3LgeIe0Z
 jRkc9LOlytVzutGAZ0fsUDfajA==
X-Google-Smtp-Source: ACHHUZ55ijmtRxUtr2PJeE7u8S0QvWcKyGSmOe2wfBtgxRK6mvg8iopMfucIMuRB5AN9ZmOkwUXzHA==
X-Received: by 2002:a05:6358:c401:b0:127:6a3c:2280 with SMTP id
 ff1-20020a056358c40100b001276a3c2280mr4551121rwb.2.1685985724648; 
 Mon, 05 Jun 2023 10:22:04 -0700 (PDT)
Received: from [127.0.0.1] ([2600:380:c01c:32f0:eff8:7692:bf8a:abc6])
 by smtp.gmail.com with ESMTPSA id
 cl9-20020a17090af68900b0025643e5da99sm7993666pjb.37.2023.06.05.10.22.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 05 Jun 2023 10:22:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20230531125535.676098-2-hch@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-2-hch@lst.de>
Message-Id: <168598572280.2504.3952473013804137907.b4-ty@kernel.dk>
Date: Mon, 05 Jun 2023 11:22:02 -0600
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 01/24] driver core: return bool from
 driver_probe_done
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
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Wed, 31 May 2023 14:55:12 +0200, Christoph Hellwig wrote:
> bool is the most sensible return value for a yes/no return.  Also
> add __init as this funtion is only called from the early boot code.
> 
> 

Applied, thanks!

[01/24] driver core: return bool from driver_probe_done
        commit: aa5f6ed8c21ec1aa5fd688118d8d5cd87c5ffc1d
[02/24] PM: hibernate: factor out a helper to find the resume device
        commit: 02b42d58f3898134b900ff3030561099e38adb32
[03/24] PM: hibernate: remove the global snapshot_test variable
        commit: d6545e687271ab27472eebff770f2de6a5f1a464
[04/24] PM: hibernate: move finding the resume device out of software_resume
        commit: cc89c63e2fe37d476357c82390dfb12edcd41cdd
[05/24] init: remove pointless Root_* values
        commit: f5524c3fadba35c075a5131bad74e3041507a694
[06/24] init: rename mount_block_root to mount_root_generic
        commit: e3102722ffe77094ba9e7e46380792b3dd8a7abd
[07/24] init: refactor mount_root
        commit: a6a41d39c2d91ff2543d31b6cc6070f3957e3aea
[08/24] init: pass root_device_name explicitly
        commit: c8643c72bc42781fc169c6498a3902bec447099e
[09/24] init: don't remove the /dev/ prefix from error messages
        commit: 73231b58b1b496d631fa0ecf9fa7f64f5a07c6e3
[10/24] init: handle ubi/mtd root mounting like all other root types
        commit: 07d63cbb67cdb5e2a7720fdd8579b3be979c2d66
[11/24] init: factor the root_wait logic in prepare_namespace into a helper
        commit: 3701c600a3e735b9fbac6f7a73e4c086090c97ca
[12/24] init: move the nfs/cifs/ram special cases out of name_to_dev_t
        commit: c0c1a7dcb6f5db4500e6574294674213bc24940c
[13/24] init: improve the name_to_dev_t interface
        commit: cf056a43121559d3642419917d405c3237ded90a
[14/24] init: clear root_wait on all invalid root= strings
        commit: 079caa35f7863cd9958b4555ae873ea4d352a502
[15/24] block: move the code to do early boot lookup of block devices to block/
        commit: 702f3189e454b3c3c2f3c99dbf30acf41aab707c
[16/24] block: move more code to early-lookup.c
        commit: 7cadcaf1d82618852745e7206fffa2c72c17ce4b
[17/24] dm-snap: simplify the origin_dev == cow_dev check in snapshot_ctr
        commit: 26110d5afe8117d1b505fe735ac709bdf063f4da
[18/24] dm: open code dm_get_dev_t in dm_init_init
        commit: 49177377e910a8fd5cd1388c966d8fbb51075c3c
[19/24] dm: remove dm_get_dev_t
        commit: d4a28d7defe79006e59293a4b43d518ba8483fb0
[20/24] dm: only call early_lookup_bdev from early boot context
        commit: 7a126d5bf975f082281fb9b45d110cd49b7c3ee4
[21/24] PM: hibernate: don't use early_lookup_bdev in resume_store
        commit: 1e8c813b083c4122dfeaa5c3b11028331026e85d
[22/24] mtd: block2mtd: factor the early block device open logic into a helper
        commit: b2baa57475e3a24bb9ad27bb9047ea3be94627f5
[23/24] mtd: block2mtd: don't call early_lookup_bdev after the system is running
        commit: 8d03187ee7328af8e18ef1782289e0b034e75485
[24/24] block: mark early_lookup_bdev as __init
        commit: 2577f53f42947d8ca01666e3444bb7307319ea38

Best regards,
-- 
Jens Axboe



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

