Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.145.221.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41628C54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664293068;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=enA5+PRzIiUE28Wn3KQOChk9BeMtA5EBcCPLH0t17hw=;
	b=YHzoV1OAuJWHkRM70F6K3nwAnGIpHnLqlo+VHooLLLsiBrBKEllVowKD5oCJ4Ijn6ELg/m
	C1wJalWS6KhzdZ4jK8xdRpbUkvsaB4DUwOnzJEqXQYab7zO+x7G+bbMoT3tQmyyHzJgV6B
	zNNgm0zjUMKngTVF0kPJdng41mLLkf8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-7VU8Ew83NHeniiQJR_nWVQ-1; Tue, 27 Sep 2022 11:37:44 -0400
X-MC-Unique: 7VU8Ew83NHeniiQJR_nWVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 386C53C0D84B;
	Tue, 27 Sep 2022 15:37:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0CB340C6EC2;
	Tue, 27 Sep 2022 15:37:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A961119465B1;
	Tue, 27 Sep 2022 15:37:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C87B61946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 15:37:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60D502027061; Tue, 27 Sep 2022 15:37:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 599792027062
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 15:37:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3797D2999B24
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 15:37:39 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-sqrA-jsHN6G0SQEGCH7VSg-1; Tue, 27 Sep 2022 11:37:35 -0400
X-MC-Unique: sqrA-jsHN6G0SQEGCH7VSg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 15982B81C4A;
 Tue, 27 Sep 2022 15:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD2C433D7;
 Tue, 27 Sep 2022 15:37:31 +0000 (UTC)
Date: Tue, 27 Sep 2022 17:37:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <YzMYuAaHRpydr7Fy@kroah.com>
References: <alpine.LRH.2.02.2209260418360.16612@file01.intranet.prod.int.rdu2.redhat.com>
 <YzGYFBv0pdt+DQg+@kroah.com>
 <6c75a90d-3793-55fc-e525-eca14e562350@gmail.com>
MIME-Version: 1.0
In-Reply-To: <6c75a90d-3793-55fc-e525-eca14e562350@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] kernfs: fix a crash when two processes
 delete the same directory
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
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 27, 2022 at 05:22:46PM +0200, Milan Broz wrote:
> On 9/26/22 14:16, Greg Kroah-Hartman wrote:
> > On Mon, Sep 26, 2022 at 07:04:52AM -0400, Mikulas Patocka wrote:
> > > There is a crash when running the cryptsetup testsuite on Fedora Rawhide.
> > > It can be reproduced by installing Rawhide with the 6.0-rc6 kernel,
> > > downloading and compiling the cryptsetup repository and running this test
> > > in a loop for about 15 minuts:
> > > 	while ./integrity-compat-test; do :; done
> > > 
> > >   ------------[ cut here ]------------
> > >   WARNING: CPU: 0 PID: 50087 at fs/kernfs/dir.c:504 __kernfs_remove.part.0+0x26f/0x2b0
> > >   Modules linked in: crc32_generic loop dm_integrity async_xor async_tx tls isofs uinput snd_seq_dummy snd_hrtimer nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables nfnetlink qrtr sunrpc snd_hda_codec_generic ledtrig_audio snd_hda_intel iTCO_wdt snd_intel_dspcfg intel_pmc_bxt snd_intel_sdw_acpi iTCO_vendor_support snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device joydev snd_pcm i2c_i801 snd_timer pcspkr i2c_smbus virtio_balloon snd lpc_ich soundcore zram virtio_net net_failover virtio_blk serio_raw failover qxl virtio_console drm_ttm_helper ttm ip6_tables ip_tables fuse qemu_fw_cfg
> > >   Unloaded tainted modules: crc32_pclmul():1 pcc_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 acpi_cpufreq():1
> > >   CPU: 0 PID: 50087 Comm: integritysetup Not tainted 6.0.0-0.rc6.41.fc38.x86_64 #1
> > >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> > >   RIP: 0010:__kernfs_remove.part.0+0x26f/0x2b0
> 
> ...
> 
> > Can you see if 4abc99652812 ("kernfs: fix use-after-free in
> > __kernfs_remove") in linux-next fixes this for you or not?  It seems to
> > be the same issue, as was also reported at:
> > 	https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp
> 
> 
> I tried it on system where cryptsetup testsuite almost immediately crashed in the integrity test.
> 
> With the patch in https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp
> it now iterates for some time without any problems, so I think it is fixed.
> 
> Tested-by: Milan Broz <gmazyland@gmail.com>

Wait, what about the patch that is in linux-next that I pointed to, not
the one in the email?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

