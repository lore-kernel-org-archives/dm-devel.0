Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D090BC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657225807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dnI7QEOQ5U8D4wz+wxI3khKqxPVJEPeXBWiRqhrq+eY=;
	b=Yo1G0rH7uDusgpyCvOSc0D62KC2tuEJbuzOzRkvj/nbHVf6TsDBFsmjKnWCblcXJhSWDBw
	uyDI38L4TGdhxCK+UIHHHQp3RyAPgJnRpYZpBieDjXcBYAl9IA7bSy8mjpECkMBmk5WuTw
	4sFCZvBWXF8slKjg73rAUTdLMhvW3KA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-mNilFJoFPGmpOTWTgciUww-1; Thu, 07 Jul 2022 16:30:03 -0400
X-MC-Unique: mNilFJoFPGmpOTWTgciUww-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E95CD29324A2;
	Thu,  7 Jul 2022 20:30:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6A49492C3B;
	Thu,  7 Jul 2022 20:30:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 970381947076;
	Thu,  7 Jul 2022 20:30:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C05E71947069
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Jul 2022 14:03:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD7DD18EB5; Thu,  7 Jul 2022 14:03:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A92862EF9F
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 14:03:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 877C695A794
 for <dm-devel@redhat.com>; Thu,  7 Jul 2022 14:03:03 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-QTaOm-3zNDyREhF4_C-fBA-1; Thu, 07 Jul 2022 10:03:01 -0400
X-MC-Unique: QTaOm-3zNDyREhF4_C-fBA-1
Received: by mail-pf1-f171.google.com with SMTP id d10so5792843pfd.9
 for <dm-devel@redhat.com>; Thu, 07 Jul 2022 07:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition:in-reply-to;
 bh=afbiyF16Fd4Ewaaf3EKKCpvpR7aHAsNAQp7K3TuQXs4=;
 b=XmDdUrNd6iwnbfxu2rcl2iJo/yBoUjuMIdTDt6eiQRKZhbFYpRb421dVeDe7owlp9N
 WhuDjnZxRyMFd01zfOZNoyhVxAjt9bYTtCKcc8+wKHqRi8yqJ4t4jcMHSlwf5ptMc635
 zaDh/pxJ794kw4MayAszCjydyJgSpaSe1Rmqi966mkYhDN4x3hvTAazSoCj1PW+iVtBn
 nbGdFzCitFfmfXNtxfloqWWKQt80RSNDq81Sz3MHnCfxiPjOA25ElqlopPlMCO77z1L+
 GsW0Uxd/btuKRM6Lm4j3zyRr18d/ZcioBmBbUK1DpY0/IHTHiQhX+PqLWYrm5TdQN7OM
 nRDg==
X-Gm-Message-State: AJIora9xDRhSLOetLYzyvOQE3Op/XrktILKDQPIVcQlrQyl9L1vMP8YG
 noFiFTmbDUUgFYFWrfxqtWY=
X-Google-Smtp-Source: AGRyM1uGEg1zRLKU3mt/8yK/HfEqKFBdv1eoQpzxhqHLW6DjIp1gLh6JEsU/RWRdBfoHFypH/TfaNQ==
X-Received: by 2002:a17:90b:4c8f:b0:1ec:cdd0:41b7 with SMTP id
 my15-20020a17090b4c8f00b001eccdd041b7mr5420238pjb.119.1657202580508; 
 Thu, 07 Jul 2022 07:03:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id
 k127-20020a632485000000b004148cbdd4e5sm1215293pgk.57.2022.07.07.07.02.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Jul 2022 07:02:59 -0700 (PDT)
Date: Thu, 7 Jul 2022 07:02:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20220707140258.GA3492673@roeck-us.net>
References: <62c683a2.g1VSVt6BrQC6ZzOz%lkp@intel.com>
 <YsaUgfPbOg7WuBuB@kroah.com>
MIME-Version: 1.0
In-Reply-To: <YsaUgfPbOg7WuBuB@kroah.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Thu, 07 Jul 2022 20:29:55 +0000
Subject: Re: [dm-devel] [linux-next:master] BUILD REGRESSION
 088b9c375534d905a4d337c78db3b3bfbb52c4a0
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
Cc: nvdimm@lists.linux.dev, legousb-devel@lists.sourceforge.net,
 dri-devel@lists.freedesktop.org, linux-sctp@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-samsung-soc@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-pm@vger.kernel.org,
 usbb2k-api-dev@nongnu.org, linux-omap@vger.kernel.org,
 megaraidlinux.pdl@broadcom.com, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-perf-users@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-wpan@vger.kernel.org, linux-fbdev@vger.kernel.org,
 linux-parport@lists.infradead.org, linux-doc@vger.kernel.org,
 samba-technical@lists.samba.org, linux-cxl@vger.kernel.org,
 virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
 target-devel@vger.kernel.org, dev@openvswitch.org, linux-cifs@vger.kernel.org,
 kernel test robot <lkp@intel.com>, linux-clk@vger.kernel.org,
 linux-rockchip@lists.infradead.org, iommu@lists.linux.dev,
 coreteam@netfilter.org, linux-media@vger.kernel.org,
 linux-watchdog@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, greybus-dev@lists.linaro.org,
 linux-amlogic@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-iio@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-fpga@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-mtd@lists.infradead.org, cgroups@vger.kernel.org,
 linux-phy@lists.infradead.org, sound-open-firmware@alsa-project.org,
 linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
 amd-gfx@lists.freedesktop.org, isdn4linux@listserv.isdn4linux.de,
 linux-input@vger.kernel.org, linux-ext4@vger.kernel.org,
 ath11k@lists.infradead.org, mjpeg-users@lists.sourceforge.net,
 openipmi-developer@lists.sourceforge.net, linux-hwmon@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-mmc@vger.kernel.org, iommu@lists.linux-foundation.org,
 keyrings@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
 damon@lists.linux.dev, linux-mm@kvack.org,
 accessrunner-general@lists.sourceforge.net,
 linux1394-devel@lists.sourceforge.net, linux-leds@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-x25@vger.kernel.org, dccp@vger.kernel.org,
 intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org,
 devicetree@vger.kernel.org, linux-nfc@lists.01.org,
 osmocom-net-gprs@lists.osmocom.org, apparmor@lists.ubuntu.com,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-scsi@vger.kernel.org, patches@opensource.cirrus.com,
 linux-unionfs@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 ntb@lists.linux.dev, tipc-discussion@lists.sourceforge.net,
 linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 07, 2022 at 10:08:33AM +0200, Greg KH wrote:

[ ... ]
> > 
> > Unverified Error/Warning (likely false positive, please contact us if interested):
> > 
> > arch/x86/events/core.c:2114 init_hw_perf_events() warn: missing error code 'err'
> > drivers/android/binder.c:1481:19-23: ERROR: from is NULL but dereferenced.
> > drivers/android/binder.c:2920:29-33: ERROR: target_thread is NULL but dereferenced.
> > drivers/android/binder.c:353:25-35: ERROR: node -> proc is NULL but dereferenced.
> > drivers/android/binder.c:4888:16-20: ERROR: t is NULL but dereferenced.
> > drivers/base/regmap/regmap.c:1996:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/char/random.c:869:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/firmware/arm_scmi/clock.c:394:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/firmware/arm_scmi/powercap.c:376:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/gpu/drm/amd/amdgpu/../pm/powerplay/hwmgr/vega10_powertune.c:1214:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/gpu/drm/amd/display/dc/os_types.h: drm/drm_print.h is included more than once.
> > drivers/gpu/drm/bridge/ite-it66121.c:1398:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> > drivers/greybus/operation.c:617:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:9637
> 
> <snip>
> 
> When the compiler crashes, why are you blaming all of these different
> mailing lists?  Perhaps you need to fix your compiler :)
> 

To be fair, it says above "likely false positive, please contact us
if interested". Also, the 32-bit build errors _are_ real, and the NULL
dereferences in the binder driver are at the very least suspicious.

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

