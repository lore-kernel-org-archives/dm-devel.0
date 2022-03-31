Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1F6C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:48:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-2TlTTTqYOxyBaG--EKKkrg-1; Mon, 04 Apr 2022 02:48:43 -0400
X-MC-Unique: 2TlTTTqYOxyBaG--EKKkrg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78EBF100BAAD;
	Mon,  4 Apr 2022 06:48:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66121408110D;
	Mon,  4 Apr 2022 06:48:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F72A19451EC;
	Mon,  4 Apr 2022 06:48:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9588119451F3
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 16:37:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61C15400E132; Thu, 31 Mar 2022 16:37:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DF38400E42D
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 16:37:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4390C2A5954E
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 16:37:11 +0000 (UTC)
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com
 [129.46.98.28]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-NDnriGhtO1yKorxBehRYaA-1; Thu, 31 Mar 2022 12:37:07 -0400
X-MC-Unique: NDnriGhtO1yKorxBehRYaA-1
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
 by alexa-out.qualcomm.com with ESMTP; 31 Mar 2022 09:35:03 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 31 Mar 2022 09:35:02 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 31 Mar 2022 09:35:02 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 31 Mar
 2022 09:34:58 -0700
Date: Thu, 31 Mar 2022 12:34:56 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YkXYMGGbk/ZTbGaA@qian>
References: <20220308061551.737853-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: Re: [dm-devel] cleanup bio_kmalloc v2
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 linux-bcache@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 08, 2022 at 07:15:46AM +0100, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series finishes off the bio allocation interface cleanups by dealing
> with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
> for the bio and bio_vecs with a hidden bio_init call and magic cleanup
> semantics.
> 
> This series moves a few callers away from bio_kmalloc and then turns
> bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
> inline biovecs.  The callers need to manually call bio_init instead with
> all that entails and the magic that turns bio_put into a kfree goes away
> as well, allowing for a proper debug check in bio_put that catches
> accidental use on a bio_init()ed bio.

Reverting this series fixed boot crashes.

 WARNING: CPU: 1 PID: 2622 at block/bio.c:229 bio_free
 Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cpufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce drm_ttm_helper mlx5_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas xhci_pci nvme_core raid_class drm xhci_pci_renesas
 CPU: 1 PID: 2622 Comm: mount Not tainted 5.17.0-next-20220331 #50
 pstate: 10400009 (nzcV daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : bio_free
 lr : bio_put
 sp : ffff8000371b7760
 x29: ffff8000371b7760 x28: 0000000000000000 x27: dfff800000000000
 x26: ffff08028f93a600 x25: 0000000000000000 x24: ffff08028f92f600
 x23: 1ffff00006e36f10 x22: ffff08028fa18510 x21: 1fffe10051f430a2
 x20: 0000000000000000 x19: ffff08028fa18500 x18: ffffde03db3e7d2c
 x17: ffffde03d55f8bc4 x16: 1fffe10051e75129 x15: 1fffe106cfcfbb46
 x14: 1fffe10051e7511c x13: 0000000000000004 x12: ffff700006e36eab
 x11: 1ffff00006e36eaa x10: ffff700006e36eaa x9 : ffffde03d5cb9fec
 x8 : ffff8000371b7557 x7 : 0000000000000001 x6 : ffff700006e36eaa
 x5 : 1ffff00006e36ea9 x4 : 1ffff00006e36ebe x3 : 1fffe10051f430a2
 x2 : 1fffe10051f430ae x1 : 0000000000000000 x0 : ffff08028fa18570
 Call trace:
  bio_free
  bio_put
  squashfs_read_data
  squashfs_read_table
  squashfs_fill_super
  get_tree_bdev
  squashfs_get_tree
  vfs_get_tree
  do_new_mount
  path_mount
  __arm64_sys_mount
  invoke_syscall
  el0_svc_common.constprop.0
  do_el0_svc
  el0_svc
  el0t_64_sync_handler
  el0t_64_sync
 irq event stamp: 33146
 hardirqs last  enabled at (33145):  free_unref_page
 hardirqs last disabled at (33146):  el1_dbg
 softirqs last  enabled at (33122):  __do_softirq
 softirqs last disabled at (33111):  __irq_exit_rcu
 ---[ end trace 0000000000000000 ]---
 Unable to handle kernel paging request at virtual address dfff800000000001
 KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
 Mem abort info:
   ESR = 0x96000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x04: level 0 translation fault
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 [dfff800000000001] address between user and kernel address ranges
 Internal error: Oops: 96000004 [#1] PREEMPT SMP
 Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cpufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce
drm_ttm_helper mlx5_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas xhci_pci nvme_core raid_class drm xhci_pci_renesas
 CPU: 1 PID: 2622 Comm: mount Tainted: G        W         5.17.0-next-20220331 #50
 pc : bio_free
 lr : bio_free
 sp : ffff8000371b7760
 x29: ffff8000371b7760 x28: 0000000000000000 x27: dfff800000000000
 x26: ffff08028f93a600 x25: 0000000000000000 x24: ffff08028f92f600
 x23: 1ffff00006e36f10 x22: ffff08028fa18548 x21: 00000000000000d0
 x20: 0000000000000000 x19: ffff08028fa18500 x18: ffffde03db3e7d2c
 x17: ffffde03d55f8bc4 x16: 1fffe10051e75129 x15: 1fffe106cfcfbb46
 x14: 1fffe10051e7511c x13: 0000000000000004 x12: ffff700006e36eab
 x11: 1ffff00006e36eaa x10: ffff700006e36eaa x9 : ffffde03d5cb9c78
 x8 : ffff8000371b7557 x7 : 0000000000000001 x6 : ffff700006e36eaa
 x5 : 1ffff00006e36ea9 x4 : 1fffe10051f430ac x3 : 0000000000000001
 x2 : 0000000000000003 x1 : dfff800000000000 x0 : 0000000000000008
 Call trace:
  bio_free
  bio_put
  squashfs_read_data
  squashfs_read_table
  squashfs_fill_super
  get_tree_bdev
  squashfs_get_tree
  vfs_get_tree
  do_new_mount
  path_mount
  __arm64_sys_mount
  invoke_syscall
  el0_svc_common.constprop.0
  do_el0_svc
  el0_svc
  el0t_64_sync_handler
  el0t_64_sync
 Code: d2d00001 f2fbffe1 52800062 d343fc03 (38e16861)
 ---[ end trace 0000000000000000 ]---
 SMP: stopping secondary CPUs
 Kernel Offset: 0x5e03ccd70000 from 0xffff800008000000
 PHYS_OFFSET: 0x80000000
 CPU features: 0x000,00085c0d,19801c82
 Memory Limit: none
 ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> 
> Changes since v1:
>  - update a pre-existing comment per maintainer suggestion
> 
> Diffstat:
>  block/bio.c                        |   47 ++++++++++++++-----------------------
>  block/blk-crypto-fallback.c        |   14 ++++++-----
>  block/blk-map.c                    |   42 +++++++++++++++++++++------------
>  drivers/block/pktcdvd.c            |   34 +++++++++++---------------
>  drivers/md/bcache/debug.c          |   10 ++++---
>  drivers/md/dm-bufio.c              |    9 +++----
>  drivers/md/raid1.c                 |   12 ++++++---
>  drivers/md/raid10.c                |   21 +++++++++++-----
>  drivers/target/target_core_pscsi.c |   36 ++++------------------------
>  fs/btrfs/disk-io.c                 |    8 +++---
>  fs/btrfs/volumes.c                 |   11 --------
>  fs/btrfs/volumes.h                 |    2 -
>  fs/squashfs/block.c                |   14 +++--------
>  include/linux/bio.h                |    2 -
>  14 files changed, 116 insertions(+), 146 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

