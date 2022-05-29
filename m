Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DBDC433EF
	for <dm-devel@archiver.kernel.org>; Sun, 29 May 2022 12:46:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-HrcmoXJDOwmtZVfN94nBYg-1; Sun, 29 May 2022 08:46:19 -0400
X-MC-Unique: HrcmoXJDOwmtZVfN94nBYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCA72811E75;
	Sun, 29 May 2022 12:46:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 42D931678F;
	Sun, 29 May 2022 12:46:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE625196676E;
	Sun, 29 May 2022 12:46:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 376D919659F4
 for <dm-devel@listman.corp.redhat.com>; Sun, 29 May 2022 12:46:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 188791121315; Sun, 29 May 2022 12:46:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14A711121314
 for <dm-devel@redhat.com>; Sun, 29 May 2022 12:46:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC4581C05133
 for <dm-devel@redhat.com>; Sun, 29 May 2022 12:46:13 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-6QGOMHpPO9GNyjYyHHlKcQ-1; Sun, 29 May 2022 08:46:11 -0400
X-MC-Unique: 6QGOMHpPO9GNyjYyHHlKcQ-1
Received: by mail-pf1-f180.google.com with SMTP id f21so8292735pfa.3
 for <dm-devel@redhat.com>; Sun, 29 May 2022 05:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1bBJWSTUiyfHNK7FQhaPe/oksFT5TKrH8PiMxbsBDOI=;
 b=56KQqDEaaqEWP6wqHHlY95vgW0YTfaf4w/C5rJAQMZXTDapu5DalfEZNtheRk71oLP
 KFiejWzz3s5sWhVmZ/5rpgsK6/XSkP3audpSr21OmSsogY0PH3Iln3zIkWcFNBY+N5Ba
 8Ds7LOLAatu6Y0n64z2JyJzODEJGjopFYU0EiyaVDY3NgyE73YXDjv2NWbgY55/mQ2j9
 ziVvnwopkYlb17+fMS/SJ+ufBeoHGNWY0ixR1NxKdkmfc3OwDhd9p+QmUmZVbDLz9fJy
 Rdx7aswACBtAl5ZDjvFmHJCtnDdVBH4eScXp40cQObA7ZSLbsv5uAw4suQoL5MOUFKde
 +seQ==
X-Gm-Message-State: AOAM530DlcOwwBDtj+PdeiBh9ZXZddODy4hAn1FYOLh/uvUsiLHV5oB1
 wl2ORltFoyTBASdvaGmjFSnJt/AgPvt4UA==
X-Google-Smtp-Source: ABdhPJzkIAKMr+Yw1Qa6FI1T39Q35FKtN9mAfTXkfeYKjPSdGF4f5nWldUrdxmUCilBKht/uffk7qw==
X-Received: by 2002:a65:47ca:0:b0:3fa:e914:9643 with SMTP id
 f10-20020a6547ca000000b003fae9149643mr18161566pgs.430.1653828368083; 
 Sun, 29 May 2022 05:46:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 y7-20020a17090a644700b001e2f53e1042sm463343pjm.7.2022.05.29.05.46.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 29 May 2022 05:46:07 -0700 (PDT)
Message-ID: <2523e5b0-d89c-552e-40a6-6d414418749d@kernel.dk>
Date: Sun, 29 May 2022 06:46:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Matthew Wilcox <willy@infradead.org>, dm-devel@redhat.com,
 linux-block@vger.kernel.org
References: <YpK7m+14A+pZKs5k@casper.infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YpK7m+14A+pZKs5k@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] bioset_exit poison from dm_destroy
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/28/22 6:17 PM, Matthew Wilcox wrote:
> Not quite sure whose bug this is.  Current Linus head running xfstests
> against ext4 (probably not ext4's fault?)
> 
> 01818 generic/250	run fstests generic/250 at 2022-05-28 23:48:09
> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
> 01818 EXT4-fs (dm-0): unmounting filesystem.
> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
> 01818 EXT4-fs (dm-0): unmounting filesystem.
> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
> 01818 Buffer I/O error on dev dm-0, logical block 3670000, async page read
> 01818 EXT4-fs (dm-0): unmounting filesystem.
> 01818 EXT4-fs (dm-0): mounted filesystem with ordered data mode. Quota mode: none.
> 01818 EXT4-fs (dm-0): unmounting filesystem.
> 01818 general protection fault, probably for non-canonical address 0xdead000000000122: 0000 [#1] PREEMPT SMP NOPTI
> 01818 CPU: 0 PID: 1579117 Comm: dmsetup Kdump: loaded Not tainted 5.18.0-11049-g1dec3d7fd0c3-dirty #262
> 01818 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> 01818 RIP: 0010:__cpuhp_state_remove_instance+0xf0/0x1b0
> 01818 Code: a0 f8 d7 81 42 3b 1c 28 7f d9 4c 89 e1 31 d2 89 de 89 7d dc e8 01 fd ff ff 8b 7d dc eb c5 49 8b 04 24 49 8b 54 24 08 48 85 c0 <48> 89 02 74 04 48 89 50 08 48 b8 00 01 00 00 00 00 ad de 48 c7 c7
> 01818 RSP: 0018:ffff888101fcfc60 EFLAGS: 00010286
> 01818 RAX: dead000000000100 RBX: 0000000000000017 RCX: 0000000000000000
> 01818 RDX: dead000000000122 RSI: ffff8881233b0ae8 RDI: ffffffff81e3b080
> 01818 RBP: ffff888101fcfc88 R08: 0000000000000008 R09: 0000000000000003
> 01818 R10: 0000000000000000 R11: 00000000002dc6c0 R12: ffff8881233b0ae8
> 01818 R13: 0000000000000000 R14: ffffffff81e38f58 R15: ffff88817b5a3c00
> 01818 FS:  00007ff56daec280(0000) GS:ffff888275800000(0000) knlGS:0000000000000000
> 01818 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 01818 CR2: 00005591ad94f198 CR3: 000000017b5a0004 CR4: 0000000000770eb0
> 01818 PKRU: 55555554
> 01818 Call Trace:
> 01818  <TASK>
> 01818  ? kfree+0x66/0x250
> 01818  bioset_exit+0x32/0x210
> 01818  cleanup_mapped_device+0x34/0xf0
> 01818  __dm_destroy+0x149/0x1f0
> 01818  ? table_clear+0xc0/0xc0
> 01818  dm_destroy+0xe/0x10
> 01818  dev_remove+0xd9/0x120
> 01818  ctl_ioctl+0x1cb/0x420
> 01818  dm_ctl_ioctl+0x9/0x10
> 01818  __x64_sys_ioctl+0x89/0xb0
> 01818  do_syscall_64+0x35/0x80
> 01818  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 01818 RIP: 0033:0x7ff56de3b397
> 01818 Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a9 da 0d 00 f7 d8 64 89 01 48
> 01818 RSP: 002b:00007ffe55367ef8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
> 01818 RAX: ffffffffffffffda RBX: 00007ff56df31a8e RCX: 00007ff56de3b397
> 01818 RDX: 000055daad7cab30 RSI: 00000000c138fd04 RDI: 0000000000000003
> 01818 RBP: 00007ffe55367fb0 R08: 00007ff56df81558 R09: 00007ffe55367d60
> 01818 R10: 00007ff56df808a2 R11: 0000000000000206 R12: 00007ff56df808a2
> 01818 R13: 00007ff56df808a2 R14: 00007ff56df808a2 R15: 00007ff56df808a2
> 01818  </TASK>
> 01818 Modules linked in: crct10dif_generic crct10dif_common [last unloaded: crc_t10dif]

I suspect dm is calling bioset_exit() multiple times? Which it probably
should not.

The reset of bioset_exit() is resilient against this, so might be best
to include bio_alloc_cache_destroy() in that.


diff --git a/block/bio.c b/block/bio.c
index a3893d80dccc..be3937b84e68 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -722,6 +722,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 		bio_alloc_cache_prune(cache, -1U);
 	}
 	free_percpu(bs->cache);
+	bs->cache = NULL;
 }
 
 /**

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

