Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401CBC4321E
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648136097;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=8+ZoGtwkqc6vaZmvK8NNPgZ/B9N8mEzY1y1IR7WAWzw=;
	b=AhuNxdLevm4WSSaSWmTXeYSQHrqOYpitMQnkm3Y5b7KV3d8ZSq7cLslHQh2QwYcYkIvF2N
	6Xp3sTZNjlOIJadbIqqu1ZafXuTVBnGoNnSCj1ZDsKMUPmal3mVXiwCEGhyvXrxW2If70G
	ia/VZn1B1HmrYEhjWUNiQI8SCS1IrcI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-csBJKOEzN6qpCRumasiQKw-1; Thu, 24 Mar 2022 11:34:54 -0400
X-MC-Unique: csBJKOEzN6qpCRumasiQKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BB921C0B04B;
	Thu, 24 Mar 2022 15:34:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 69F41C15D7B;
	Thu, 24 Mar 2022 15:34:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 696EB1940374;
	Thu, 24 Mar 2022 15:34:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D4024194035D
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 15:34:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD297417E37; Thu, 24 Mar 2022 15:34:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5254401476
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 15:34:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7178C811E76
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 15:34:44 +0000 (UTC)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-iVyKeAfmOyyHmIny8lRsmg-1; Thu, 24 Mar 2022 11:34:40 -0400
X-MC-Unique: iVyKeAfmOyyHmIny8lRsmg-1
Received: by mail-ed1-f71.google.com with SMTP id
 f2-20020a50d542000000b00418ed3d95d8so3246110edj.11
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 08:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent
 :content-language:to:cc:from:subject;
 bh=B++z3Xmy/QetMjT/NWMUD2jf/5sKTtNUZIpffJ2tYvs=;
 b=Oiz/Gw2aOwL9JXldeyV5q5a8Z7HCpt2LDy+05ZYm4+v/AGR+1HTE7TmgCqssZOOP7l
 JaUj5agZxiD6t4UJ+Jeb5mhGxvlpiOHNKy2d/c4Zh9HSvqWpd6cNLOqJtseNz39MmWbU
 +8L4y1PZCEc+iXZr8JaZMBeq+gtlSMRJG7uWeyyZdVUpBACZ5A+vWVkkaJbPHTF265bG
 3nC1AvSv3AdASOsQ+pY4qiv+NUfhnR8v9A5CHJlszuhxv4nRVEfxx+NhzNpdmwCITzl+
 nqkM8y/H00N7lI/sK/6JteEHhNGwbzDnToWIe0c6P/U6vlxf0Kw4nIZAz1taLqFFWRWq
 TICA==
X-Gm-Message-State: AOAM533pAwe6uceRWpEE44GCvAfFxHj3LdDILxMNbt7E0jUjoeyL9E+D
 A/ZYU6mqoKjBRL8HDxxpV8VG8qtxWSUnSFCbuSoeyzwlvRl2gJgSkpLlUKoFXCD7WYPgjjXtcE6
 C/tX7Gqq+5bqiHvMaIFnEFn+zx8tTbN3z55B9XVXtN61Y7z4p9y74BPRqFoTgSPDB
X-Received: by 2002:a50:f19a:0:b0:418:f94c:fc24 with SMTP id
 x26-20020a50f19a000000b00418f94cfc24mr7407039edl.34.1648136078798; 
 Thu, 24 Mar 2022 08:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGBj+df595ZxSoOjZ/iXxHy9QaxxPbcpKSRncUVCccnqWmDxlINyo6EuWrgZqiXOtCX/JH5Q==
X-Received: by 2002:a50:f19a:0:b0:418:f94c:fc24 with SMTP id
 x26-20020a50f19a000000b00418f94cfc24mr7406995edl.34.1648136078411; 
 Thu, 24 Mar 2022 08:34:38 -0700 (PDT)
Received: from [10.43.17.42] (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id
 kw5-20020a170907770500b006db075e5358sm1238569ejc.66.2022.03.24.08.34.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Mar 2022 08:34:37 -0700 (PDT)
Message-ID: <4ed29ab9-5cbc-2185-d87d-9a6dbe82a460@redhat.com>
Date: Thu, 24 Mar 2022 16:34:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: dm-devel@redhat.com
From: Ondrej Kozina <okozina@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] dm-integrity resize crashes kernel
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
Cc: Daniel Zatovic <dzatovic@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 gmazyland@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="------------njf61JPDlCDq0hI9uCRml0AE"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------njf61JPDlCDq0hI9uCRml0AE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've hit a dm-integrity crash when re-extending dm-integrity device. The 
trick is that underlying device needs to change its size as well. 
There's reproducer attached which I have tested on top of scsi_debug 
device but it's not limited to scsi_debug.

Tested kernel version: 5.17.0, My minimal tested device size was 128MB, 
but it can be reproduced with larger devices as well.

See the attached test.sh script but basically:

1) create 1:1 dm linear mapping (to be able to resize it online later)
2) format dm-linear with integritysetup
3) activate dm-integrity on top of dm-linear
4) write whole dm-integrity
5) shrink dm-integrity
6) shrink dm-linear mapping
7) re-extend dm-integrity over dm-linear again
8) write dm-linear
9) kernel crashes with:

[  158.771518] kernel BUG at drivers/md/dm-integrity.c:2168!
[  158.772175] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  158.772749] CPU: 1 PID: 1053 Comm: dd Not tainted 
5.17.0-128.fc37.x86_64 #1
[  158.773448] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  158.773997] RIP: 0010:dm_integrity_map_continue+0x6e8/0xa40 
[dm_integrity]
[  158.774662] Code: a8 00 00 00 e8 79 db ff ff 84 c0 0f 85 b0 fd ff ff 
4c 89 ff e8 99 e2 ff ff e9 b6 fd ff ff 48 8b 4c 24 08 31 c0 e9 bd fa ff 
ff <0f> 0b 31 db e9 e4 fa ff ff 80 7c 24 1a 00 0f 85 05 03 00 00 83 fb
[  158.776404] RSP: 0018:ffffa95a00c67a38 EFLAGS: 00010013
[  158.776900] RAX: ffff8ee4e9de7000 RBX: 0000000000000001 RCX: 
0000000000000018
[  158.777574] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff8ee4c35b8000
[  158.778229] RBP: 0000000000000000 R08: 000000000000000b R09: 
00000000000000b0
[  158.778822] R10: 0000000000000000 R11: 0000000000000002 R12: 
0000000000000000
[  158.779446] R13: 0000000000000000 R14: ffff8ee4c43f5000 R15: 
ffff8ee4c3eace00
[  158.780080] FS:  00007f361d61c740(0000) GS:ffff8ee4fbc80000(0000) 
knlGS:0000000000000000
[  158.780798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  158.781286] CR2: 00007f3610062000 CR3: 0000000103e96003 CR4: 
0000000000370ee0
[  158.781881] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  158.782482] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  158.783081] Call Trace:
[  158.783291]  <TASK>
[  158.783457]  ? mempool_alloc+0x4f/0x170
[  158.783753]  dm_integrity_map+0x1bf/0x330 [dm_integrity]
[  158.784163]  __map_bio+0x62/0x210
[  158.784427]  __split_and_process_non_flush+0x1cb/0x240
[  158.784818]  dm_submit_bio+0x115/0x360
[  158.785110]  __submit_bio+0xaf/0x180
[  158.785391]  submit_bio_noacct+0xbd/0x2a0
[  158.785696]  __blkdev_direct_IO_simple+0x198/0x290
[  158.786069]  ? folio_add_lru+0x83/0x100
[  158.786364]  ? _raw_spin_unlock+0x16/0x30
[  158.786670]  ? __handle_mm_fault+0x1109/0x13f0
[  158.787010]  ? __blkdev_direct_IO_simple+0x290/0x290
[  158.787389]  generic_file_direct_write+0x9b/0x1d0
[  158.787748]  __generic_file_write_iter+0x91/0x190
[  158.788119]  blkdev_write_iter+0xbc/0x140
[  158.788412]  new_sync_write+0xff/0x180
[  158.788692]  vfs_write+0x209/0x2a0
[  158.788944]  ksys_write+0x53/0xd0
[  158.789191]  do_syscall_64+0x37/0x80
[  158.789457]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  158.789828] RIP: 0033:0x7f361d7247e7
[  158.790101] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 
1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  158.792087] RSP: 002b:00007fff3413fa68 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[  158.792962] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007f361d7247e7
[  158.793811] RDX: 0000000000100000 RSI: 00007f360ff63000 RDI: 
0000000000000001
[  158.794665] RBP: 0000000000100000 R08: 00000000ffffffff R09: 
0000000000000000
[  158.795515] R10: 0000000000000022 R11: 0000000000000246 R12: 
00007f360ff63000
[  158.796389] R13: 0000000000000000 R14: 0000000000100000 R15: 
0000000000000000
[  158.797237]  </TASK>
[  158.797732] Modules linked in: dm_integrity async_xor async_tx 
scsi_debug rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd 
grace fscache netfs intel_rapl_msr intel_rapl_common kvm_intel sunrpc 
kvm binfmt_misc snd_hda_codec_generic ledtrig_audio snd_hda_intel 
irqbypass snd_intel_dspcfg snd_intel_sdw_acpi rapl snd_hda_codec 
snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm virtio_net 
snd_timer joydev snd net_failover failover soundcore virtio_balloon 
i2c_piix4 cfg80211 rfkill fuse dm_crypt xfs crct10dif_pclmul 
crc32_pclmul crc32c_intel qxl ata_generic drm_ttm_helper ttm virtio_scsi 
pata_acpi serio_raw qemu_fw_cfg ghash_clmulni_intel virtio_console
[  158.803972] ---[ end trace 0000000000000000 ]---
[  158.804669] RIP: 0010:dm_integrity_map_continue+0x6e8/0xa40 
[dm_integrity]
[  158.805554] Code: a8 00 00 00 e8 79 db ff ff 84 c0 0f 85 b0 fd ff ff 
4c 89 ff e8 99 e2 ff ff e9 b6 fd ff ff 48 8b 4c 24 08 31 c0 e9 bd fa ff 
ff <0f> 0b 31 db e9 e4 fa ff ff 80 7c 24 1a 00 0f 85 05 03 00 00 83 fb
[  158.807657] RSP: 0018:ffffa95a00c67a38 EFLAGS: 00010013
[  158.808427] RAX: ffff8ee4e9de7000 RBX: 0000000000000001 RCX: 
0000000000000018
[  158.809322] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
ffff8ee4c35b8000
[  158.810227] RBP: 0000000000000000 R08: 000000000000000b R09: 
00000000000000b0
[  158.811137] R10: 0000000000000000 R11: 0000000000000002 R12: 
0000000000000000
[  158.812043] R13: 0000000000000000 R14: ffff8ee4c43f5000 R15: 
ffff8ee4c3eace00
[  158.812940] FS:  00007f361d61c740(0000) GS:ffff8ee4fbc80000(0000) 
knlGS:0000000000000000
[  158.813932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  158.814747] CR2: 00007f3610062000 CR3: 0000000103e96003 CR4: 
0000000000370ee0
[  158.815654] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  158.816559] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  158.817489] note: dd[1053] exited with preempt_count 1
[  158.818287] ------------[ cut here ]------------
[  158.819279] WARNING: CPU: 1 PID: 1053 at kernel/exit.c:738 
do_exit+0x35/0xad0
[  158.820207] Modules linked in: dm_integrity async_xor async_tx 
scsi_debug rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd 
grace fscache netfs intel_rapl_msr intel_rapl_common kvm_intel sunrpc 
kvm binfmt_misc snd_hda_codec_generic ledtrig_audio snd_hda_intel 
irqbypass snd_intel_dspcfg snd_intel_sdw_acpi rapl snd_hda_codec 
snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm virtio_net 
snd_timer joydev snd net_failover failover soundcore virtio_balloon 
i2c_piix4 cfg80211 rfkill fuse dm_crypt xfs crct10dif_pclmul 
crc32_pclmul crc32c_intel qxl ata_generic drm_ttm_helper ttm virtio_scsi 
pata_acpi serio_raw qemu_fw_cfg ghash_clmulni_intel virtio_console
[  158.826988] CPU: 1 PID: 1053 Comm: dd Tainted: G      D 
--------- ---  5.17.0-128.fc37.x86_64 #1
[  158.828156] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  158.829064] RIP: 0010:do_exit+0x35/0xad0
[  158.829892] Code: 41 54 49 89 fc 55 53 65 48 8b 1c 25 c0 fb 01 00 48 
83 ec 20 48 8b 83 10 0d 00 00 48 85 c0 74 0c 48 83 38 00 0f 84 ab 04 00 
00 <0f> 0b 48 8b bb 28 0c 00 00 e8 cd 35 c3 00 83 4b 2c 08 48 8b 83 20
[  158.832312] RSP: 0018:ffffa95a00c67ee8 EFLAGS: 00010002
[  158.833220] RAX: ffffa95a00c67e10 RBX: ffff8ee4c21a8000 RCX: 
0000000000000000
[  158.834288] RDX: 0000000000000001 RSI: ffffffffb6665155 RDI: 
000000000000000b
[  158.835330] RBP: ffff8ee4c21a8000 R08: 0000000000000000 R09: 
ffffa95a00c67d88
[  158.836365] R10: ffffa95a00c67d80 R11: ffffffffb6f45588 R12: 
000000000000000b
[  158.837392] R13: 0000000000000004 R14: ffff8ee4c21a8000 R15: 
ffffa95a00c67988
[  158.838416] FS:  00007f361d61c740(0000) GS:ffff8ee4fbc80000(0000) 
knlGS:0000000000000000
[  158.839502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  158.840433] CR2: 00007f3610062000 CR3: 0000000103e96003 CR4: 
0000000000370ee0
[  158.841459] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  158.842487] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  158.843520] Call Trace:
[  158.844235]  <TASK>
[  158.844896]  make_task_dead+0x51/0x60
[  158.845661]  rewind_stack_and_make_dead+0x17/0x17
[  158.846509] RIP: 0033:0x7f361d7247e7
[  158.847261] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 
1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  158.849550] RSP: 002b:00007fff3413fa68 EFLAGS: 00000246 ORIG_RAX: 
0000000000000001
[  158.850587] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007f361d7247e7
[  158.851574] RDX: 0000000000100000 RSI: 00007f360ff63000 RDI: 
0000000000000001
[  158.852559] RBP: 0000000000100000 R08: 00000000ffffffff R09: 
0000000000000000
[  158.853572] R10: 0000000000000022 R11: 0000000000000246 R12: 
00007f360ff63000
[  158.854535] R13: 0000000000000000 R14: 0000000000100000 R15: 
0000000000000000
[  158.855498]  </TASK>
[  158.856112] ---[ end trace 0000000000000000 ]---
--------------njf61JPDlCDq0hI9uCRml0AE
Content-Type: application/x-shellscript; name="test.sh"
Content-Disposition: attachment; filename="test.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmZ1bmN0aW9uIGZhaWwoKSB7CgllY2hvICJTb21ldGhpbmcgd2VudCB3cm9u
Zy4iCglleGl0IDEKfQoKaWYgWyAkIyAtbHQgMSBdOyB0aGVuCgllY2hvICIuL3Rlc3Quc2ggPERF
Vj4iCglleGl0IDEKZmkKCmlmIFsgISAtYiAkMSBdOyB0aGVuCgllY2hvICIkMSBpcyBub3QgYmRl
diIKCWV4aXQgMQpmaQoKIyBjcmVhdGUgbGluZWFyIG1hcHBpbmcgJ2EnIHRoYXQgd2lsbCBiZSB1
c2VkIHRvIGNoYW5nZSBkZXZpY2Ugc2l6ZQpkbXNldHVwIGNyZWF0ZSBhIC0tdGFibGUgIjAgYGJs
b2NrZGV2IC0tZ2V0c3ogJDFgIGxpbmVhciAvZGV2L3NkYyAwIiB8fCBmYWlsCmludGVncml0eXNl
dHVwIGZvcm1hdCAtcSAvZGV2L21hcHBlci9hIHx8IGZhaWwKaW50ZWdyaXR5c2V0dXAgb3BlbiAv
ZGV2L21hcHBlci9hIGludGcgfHwgZmFpbAoKIyB3cml0ZSB0aGUgZGV2aWNlIGFnYWluIChpdCBm
aWxscyBqb3VybmFsPykKZGQgaWY9L2Rldi96ZXJvIG9mPS9kZXYvbWFwcGVyL2ludGcgYnM9MU0g
b2ZsYWc9ZGlyZWN0CgojIHNocmluayBkbS1pbnRlZ3JpdHkgdG8gMS80IG9yaWdpbmFsIHNpemUK
c2l6ZT1gZG1zZXR1cCB0YWJsZSBpbnRnIHwgY3V0IC1mIDIgLWQgJyAnYApzdHI9InMvXCgwIFsw
LTldXCtcKSBcKC4qXCkvMCAkKChzaXplLzQpKSBcMi8iCmVjaG8gIm9sZCBpbnRnIHRhYmxlOiIK
ZG1zZXR1cCB0YWJsZSBpbnRnCmRtc2V0dXAgdGFibGUgaW50ZyB8IHNlZCAtZSAiJHN0ciIgfCBk
bXNldHVwIGxvYWQgaW50ZyAmJiBkbXNldHVwIHJlc3VtZSBpbnRnIHx8IGZhaWwKZWNobyAibmV3
IGludGcgdGFibGU6IgpkbXNldHVwIHRhYmxlIGludGcKCiMgc2hyaW5rIGRtLWxpbmVhciB0byAx
LzIgb3JpZ2luYWwgc2l6ZQpzaXplPWBkbXNldHVwIHRhYmxlIGEgfCBjdXQgLWYgMiAtZCAnICdg
CnN0cj0icy9cKDAgWzAtOV1cK1wpIFwoLipcKS8wICQoKHNpemUvMikpIFwyLyIKZWNobyAib2xk
IGEgdGFibGU6IgpkbXNldHVwIHRhYmxlIGEKZG1zZXR1cCB0YWJsZSBhIHwgc2VkIC1lICIkc3Ry
IiB8IGRtc2V0dXAgbG9hZCBhICYmIGRtc2V0dXAgcmVzdW1lIGEgfHwgZmFpbAplY2hvICJuZXcg
YSB0YWJsZToiCmRtc2V0dXAgdGFibGUgYQoKIyByZWZyZXNoIGRtLWludGVncml0eSBzdXBlcmJs
b2NrIHdpdGggbmV3IHByb3ZpZGVkIGRhdGEgc2VjdG9ycwpkbXNldHVwIHRhYmxlIGludGcgfCBk
bXNldHVwIGxvYWQgaW50ZyAmJiBkbXNldHVwIHJlc3VtZSBpbnRnIHx8IGZhaWwKCm5ld19zaXpl
PWBpbnRlZ3JpdHlzZXR1cCBkdW1wIC9kZXYvbWFwcGVyL2EgfCBncmVwIHByb3ZpZGVkX2RhdGFf
c2VjdG9ycyB8IGN1dCAtZiAyIC1kICcgJ2AKCmRtc2V0dXAgbG9hZCBpbnRnIC0tdGFibGUgIjAg
JG5ld19zaXplIGBkbXNldHVwIHRhYmxlIGludGcgfCBjdXQgLWYgMS0yIC0tY29tcGxlbWVudCAt
ZCAnICdgIiAmJiBkbXNldHVwIHJlc3VtZSBpbnRnIHx8IGZhaWwKZWNobyAicmUtZXh0ZW5kZWQg
aW50ZyB0YWJsZToiCmRtc2V0dXAgdGFibGUgaW50ZwoKI3RoaXMgd3JpdGUgY3Jhc2hlcyBrZXJu
ZWwKZGQgaWY9L2Rldi96ZXJvIG9mPS9kZXYvbWFwcGVyL2ludGcgYnM9MU0gb2ZsYWc9ZGlyZWN0
Cg==
--------------njf61JPDlCDq0hI9uCRml0AE
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--------------njf61JPDlCDq0hI9uCRml0AE--

