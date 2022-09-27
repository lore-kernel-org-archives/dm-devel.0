Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A13C6FA83
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664292184;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VX9/0Pnln3YLi5WR4hFBELYjCqKibolJoyQOeRrp+Ns=;
	b=fmyzrdNaQpElEWyM7zb21SG0a3WL47bC+Ixa268WHOHaV5trBPhck6wOtMrSUxC8EjSNF4
	90kmCCjcNgiXXrA4oIITg4TSL6QgwAHMpCsYwMzbZcRB97CpvAdrgYQ6N1aF4HLAPYQS1T
	8c4oVrS1WytbHlUujEy8zTI2mBdxdEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-qdDHZw7eMMevfVFT_26_7w-1; Tue, 27 Sep 2022 11:23:01 -0400
X-MC-Unique: qdDHZw7eMMevfVFT_26_7w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36B34185A7A8;
	Tue, 27 Sep 2022 15:22:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED8DE2027062;
	Tue, 27 Sep 2022 15:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4555219465B1;
	Tue, 27 Sep 2022 15:22:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC1481946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 15:22:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1E1240C6EC3; Tue, 27 Sep 2022 15:22:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA2E340C6EC2
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 15:22:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E5FE8027ED
 for <dm-devel@redhat.com>; Tue, 27 Sep 2022 15:22:52 +0000 (UTC)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-260-fepPyRSDNaKfSxtqnpNwag-1; Tue, 27 Sep 2022 11:22:50 -0400
X-MC-Unique: fepPyRSDNaKfSxtqnpNwag-1
Received: by mail-ej1-f43.google.com with SMTP id sd10so21489576ejc.2;
 Tue, 27 Sep 2022 08:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=erSV/LQniRo494ECVW4U1bCw7qSOzHbBVNjiw4aEUwM=;
 b=inhkk+8gKo/7Pk6tRChbUp4p0mjxSodmE6shAqc11qSfN5tontahsBgJyjE3YocVWy
 OelY3OqQ+9S2K3xGK9+jCsoQBfdLyAeZz93ScTHYWKfDruzzy2fkE4OYD3zp2SX3GBrV
 v1ERnQt98JzP+fIsyjbBJZngV8s7LVbg1yI2V6r6m3G+oqgV8Mzwb32NCcZixcgQWSqi
 A9ZqGhJ9hogH/7RMlPW+N/QseXKW/PJN6v2mCgJ9crHF4GeDeAtZpDRxLodTF8KHH1/x
 UGk8S2nN6rf4GMYg9UcshgWWk6d73NBkCfAFWihIdH7LVvRep11diylc4psSL+7la6t1
 Kuhg==
X-Gm-Message-State: ACrzQf2oPzwJczLliZ/JjTmx9K6Gsn3pk/q+XzwFOVnUTwGYR0b5jxfj
 CEBDZmRIx1nFgGMxqBfzC3I=
X-Google-Smtp-Source: AMsMyM6ORwEPx17ooVtnAkD8sUM9hP3viynQDYDPUEMwUEn+64CkCaKPHB1Kn62qQ+5ltV+3woym6Q==
X-Received: by 2002:a17:907:2c75:b0:77c:2b6a:6b63 with SMTP id
 ib21-20020a1709072c7500b0077c2b6a6b63mr23937278ejc.702.1664292169261; 
 Tue, 27 Sep 2022 08:22:49 -0700 (PDT)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 l17-20020a1709060cd100b007417041fb2bsm913340ejh.116.2022.09.27.08.22.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 27 Sep 2022 08:22:48 -0700 (PDT)
Message-ID: <6c75a90d-3793-55fc-e525-eca14e562350@gmail.com>
Date: Tue, 27 Sep 2022 17:22:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <alpine.LRH.2.02.2209260418360.16612@file01.intranet.prod.int.rdu2.redhat.com>
 <YzGYFBv0pdt+DQg+@kroah.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YzGYFBv0pdt+DQg+@kroah.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com,
 "Rafael J. Wysocki" <rafael@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/26/22 14:16, Greg Kroah-Hartman wrote:
> On Mon, Sep 26, 2022 at 07:04:52AM -0400, Mikulas Patocka wrote:
>> There is a crash when running the cryptsetup testsuite on Fedora Rawhide.
>> It can be reproduced by installing Rawhide with the 6.0-rc6 kernel,
>> downloading and compiling the cryptsetup repository and running this test
>> in a loop for about 15 minuts:
>> 	while ./integrity-compat-test; do :; done
>>
>>   ------------[ cut here ]------------
>>   WARNING: CPU: 0 PID: 50087 at fs/kernfs/dir.c:504 __kernfs_remove.part.0+0x26f/0x2b0
>>   Modules linked in: crc32_generic loop dm_integrity async_xor async_tx tls isofs uinput snd_seq_dummy snd_hrtimer nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables nfnetlink qrtr sunrpc snd_hda_codec_generic ledtrig_audio snd_hda_intel iTCO_wdt snd_intel_dspcfg intel_pmc_bxt snd_intel_sdw_acpi iTCO_vendor_support snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device joydev snd_pcm i2c_i801 snd_timer pcspkr i2c_smbus virtio_balloon snd lpc_ich soundcore zram virtio_net net_failover virtio_blk serio_raw failover qxl virtio_console drm_ttm_helper ttm ip6_tables ip_tables fuse qemu_fw_cfg
>>   Unloaded tainted modules: crc32_pclmul():1 pcc_cpufreq():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 edac_mce_amd():1 acpi_cpufreq():1 pcc_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 edac_mce_amd():1 pcc_cpufreq():1 acpi_cpufreq():1 acpi_cpufreq():1
>>   CPU: 0 PID: 50087 Comm: integritysetup Not tainted 6.0.0-0.rc6.41.fc38.x86_64 #1
>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
>>   RIP: 0010:__kernfs_remove.part.0+0x26f/0x2b0

...

> Can you see if 4abc99652812 ("kernfs: fix use-after-free in
> __kernfs_remove") in linux-next fixes this for you or not?  It seems to
> be the same issue, as was also reported at:
> 	https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp


I tried it on system where cryptsetup testsuite almost immediately crashed in the integrity test.

With the patch in https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp
it now iterates for some time without any problems, so I think it is fixed.

Tested-by: Milan Broz <gmazyland@gmail.com>

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

