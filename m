Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7D5C54EED
	for <dm-devel@archiver.kernel.org>; Mon, 30 Jan 2023 00:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675039186;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WO1g5YipqwymtaHCTl7MEBhcxpeO4H7JCTp4OUmUVL4=;
	b=KtbGebYA4ZVoLLXKK9M/OcDlPQsZNzkClW/nn0ll622Ps7/o/ctkeDYM0jlarVvuvD1Sc0
	njtdT6FlUTMyEW3Zpl2MHKpOe6S+78oR4yXur9OttHh1e6J41hOHCpn/trCkdz77GK1YkG
	v58bk6jqjK1HgiQ5XLIsBk1VNJXRzyc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-za7Ueq_FN5mRqfPXk9nTlA-1; Sun, 29 Jan 2023 19:39:42 -0500
X-MC-Unique: za7Ueq_FN5mRqfPXk9nTlA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F4C3802C18;
	Mon, 30 Jan 2023 00:39:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD828492B05;
	Mon, 30 Jan 2023 00:39:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79CBC1946588;
	Mon, 30 Jan 2023 00:39:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 875071946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 00:39:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68A44C15BAE; Mon, 30 Jan 2023 00:39:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60C60C15BAD
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 00:39:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E50E3813F20
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 00:39:37 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-3nw4yxMeOYm15RbY1xivVQ-1; Sun, 29 Jan 2023 19:39:34 -0500
X-MC-Unique: 3nw4yxMeOYm15RbY1xivVQ-1
Received: from [2601:1c2:d00:6a60::9526] (helo=bombadil.infradead.org)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1pMGp5-0020M2-Rb; Sun, 29 Jan 2023 23:10:55 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Date: Sun, 29 Jan 2023 15:10:44 -0800
Message-Id: <20230129231053.20863-1-rdunlap@infradead.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Cc: nvdimm@lists.linux.dev, linux-usb@vger.kernel.org,
 linux-doc@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 netdev@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
 sparclinux@vger.kernel.org, Neeraj Upadhyay <quic_neeraju@quicinc.com>,
 Alasdair Kergon <agk@redhat.com>, Dave Jiang <dave.jiang@intel.com>,
 linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Eric Dumazet <edumazet@google.com>,
 Vinod Koul <vkoul@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Maintainers of specific kernel subsystems are only Cc-ed on their
respective patches, not the entire series. [if all goes well]

These patches are based on linux-next-20230127.


 [PATCH 1/9] Documentation: admin-guide: correct spelling
 [PATCH 2/9] Documentation: driver-api: correct spelling
 [PATCH 3/9] Documentation: hwmon: correct spelling
 [PATCH 4/9] Documentation: networking: correct spelling
 [PATCH 5/9] Documentation: RCU: correct spelling
 [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
 [PATCH 7/9] Documentation: scsi: correct spelling
 [PATCH 8/9] Documentation: sparc: correct spelling
 [PATCH 9/9] Documentation: userspace-api: correct spelling


 Documentation/RCU/Design/Expedited-Grace-Periods/Expedited-Grace-Periods.rst         |    6 -
 Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.rst                |    2 
 Documentation/RCU/RTFP.txt                                                           |   10 +-
 Documentation/RCU/UP.rst                                                             |    4 
 Documentation/RCU/lockdep.rst                                                        |    2 
 Documentation/RCU/torture.rst                                                        |    4 
 Documentation/admin-guide/bcache.rst                                                 |    2 
 Documentation/admin-guide/cgroup-v1/blkio-controller.rst                             |    2 
 Documentation/admin-guide/cgroup-v2.rst                                              |   10 +-
 Documentation/admin-guide/cifs/usage.rst                                             |    4 
 Documentation/admin-guide/device-mapper/cache-policies.rst                           |    2 
 Documentation/admin-guide/device-mapper/dm-ebs.rst                                   |    2 
 Documentation/admin-guide/device-mapper/dm-zoned.rst                                 |    2 
 Documentation/admin-guide/device-mapper/unstriped.rst                                |   10 +-
 Documentation/admin-guide/dynamic-debug-howto.rst                                    |    2 
 Documentation/admin-guide/gpio/gpio-sim.rst                                          |    2 
 Documentation/admin-guide/hw-vuln/mds.rst                                            |    4 
 Documentation/admin-guide/kernel-parameters.txt                                      |    8 -
 Documentation/admin-guide/laptops/thinkpad-acpi.rst                                  |    2 
 Documentation/admin-guide/md.rst                                                     |    2 
 Documentation/admin-guide/media/bttv.rst                                             |    2 
 Documentation/admin-guide/media/building.rst                                         |    2 
 Documentation/admin-guide/media/si476x.rst                                           |    2 
 Documentation/admin-guide/media/vivid.rst                                            |    2 
 Documentation/admin-guide/mm/hugetlbpage.rst                                         |    2 
 Documentation/admin-guide/mm/numa_memory_policy.rst                                  |    4 
 Documentation/admin-guide/perf/hns3-pmu.rst                                          |    2 
 Documentation/admin-guide/pm/amd-pstate.rst                                          |    2 
 Documentation/admin-guide/spkguide.txt                                               |    4 
 Documentation/admin-guide/sysctl/vm.rst                                              |    4 
 Documentation/admin-guide/sysrq.rst                                                  |    2 
 Documentation/driver-api/dma-buf.rst                                                 |    2 
 Documentation/driver-api/dmaengine/client.rst                                        |    2 
 Documentation/driver-api/dmaengine/dmatest.rst                                       |    2 
 Documentation/driver-api/hsi.rst                                                     |    4 
 Documentation/driver-api/io-mapping.rst                                              |    4 
 Documentation/driver-api/md/md-cluster.rst                                           |    2 
 Documentation/driver-api/md/raid5-cache.rst                                          |    2 
 Documentation/driver-api/media/drivers/vidtv.rst                                     |    2 
 Documentation/driver-api/media/dtv-demux.rst                                         |    2 
 Documentation/driver-api/media/v4l2-subdev.rst                                       |    4 
 Documentation/driver-api/mei/nfc.rst                                                 |    2 
 Documentation/driver-api/nfc/nfc-hci.rst                                             |    2 
 Documentation/driver-api/nvdimm/nvdimm.rst                                           |    2 
 Documentation/driver-api/nvdimm/security.rst                                         |    2 
 Documentation/driver-api/pin-control.rst                                             |    2 
 Documentation/driver-api/pldmfw/index.rst                                            |    2 
 Documentation/driver-api/serial/driver.rst                                           |    2 
 Documentation/driver-api/surface_aggregator/ssh.rst                                  |    2 
 Documentation/driver-api/thermal/intel_powerclamp.rst                                |    2 
 Documentation/driver-api/usb/dwc3.rst                                                |    2 
 Documentation/driver-api/usb/usb3-debug-port.rst                                     |    2 
 Documentation/hwmon/aht10.rst                                                        |    2 
 Documentation/hwmon/aspeed-pwm-tacho.rst                                             |    2 
 Documentation/hwmon/corsair-psu.rst                                                  |    2 
 Documentation/hwmon/gsc-hwmon.rst                                                    |    6 -
 Documentation/hwmon/hwmon-kernel-api.rst                                             |    4 
 Documentation/hwmon/ltc2978.rst                                                      |    2 
 Documentation/hwmon/max6697.rst                                                      |    2 
 Documentation/hwmon/menf21bmc.rst                                                    |    2 
 Documentation/hwmon/pmbus-core.rst                                                   |    2 
 Documentation/hwmon/sht4x.rst                                                        |    2 
 Documentation/hwmon/smm665.rst                                                       |    2 
 Documentation/hwmon/stpddc60.rst                                                     |    2 
 Documentation/hwmon/vexpress.rst                                                     |    2 
 Documentation/hwmon/via686a.rst                                                      |    2 
 Documentation/networking/af_xdp.rst                                                  |    4 
 Documentation/networking/arcnet-hardware.rst                                         |    2 
 Documentation/networking/can.rst                                                     |    2 
 Documentation/networking/can_ucan_protocol.rst                                       |    2 
 Documentation/networking/cdc_mbim.rst                                                |    2 
 Documentation/networking/device_drivers/atm/iphase.rst                               |    2 
 Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst                  |    4 
 Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg              |    4 
 Documentation/networking/device_drivers/ethernet/3com/vortex.rst                     |    2 
 Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst               |    6 -
 Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst |    2 
 Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst               |    2 
 Documentation/networking/device_drivers/ethernet/pensando/ionic.rst                  |    2 
 Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst     |    2 
 Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst               |    2 
 Documentation/networking/device_drivers/wwan/iosm.rst                                |    2 
 Documentation/networking/devlink/ice.rst                                             |    4 
 Documentation/networking/devlink/netdevsim.rst                                       |    2 
 Documentation/networking/devlink/prestera.rst                                        |    2 
 Documentation/networking/dsa/configuration.rst                                       |    2 
 Documentation/networking/ethtool-netlink.rst                                         |    6 -
 Documentation/networking/gtp.rst                                                     |    2 
 Documentation/networking/ieee802154.rst                                              |    2 
 Documentation/networking/ip-sysctl.rst                                               |    6 -
 Documentation/networking/ipvlan.rst                                                  |    2 
 Documentation/networking/j1939.rst                                                   |    2 
 Documentation/networking/net_failover.rst                                            |    2 
 Documentation/networking/netconsole.rst                                              |    2 
 Documentation/networking/page_pool.rst                                               |    6 -
 Documentation/networking/phonet.rst                                                  |    2 
 Documentation/networking/phy.rst                                                     |    2 
 Documentation/networking/regulatory.rst                                              |    4 
 Documentation/networking/rxrpc.rst                                                   |    2 
 Documentation/networking/snmp_counter.rst                                            |    4 
 Documentation/networking/sysfs-tagging.rst                                           |    2 
 Documentation/scsi/ChangeLog.lpfc                                                    |   36 ++++----
 Documentation/scsi/ChangeLog.megaraid                                                |    8 -
 Documentation/scsi/ChangeLog.megaraid_sas                                            |    4 
 Documentation/scsi/ChangeLog.ncr53c8xx                                               |   16 +--
 Documentation/scsi/ChangeLog.sym53c8xx                                               |   14 +--
 Documentation/scsi/ChangeLog.sym53c8xx_2                                             |   10 +-
 Documentation/scsi/ncr53c8xx.rst                                                     |    4 
 Documentation/scsi/sym53c8xx_2.rst                                                   |    2 
 Documentation/scsi/tcm_qla2xxx.rst                                                   |    2 
 Documentation/scsi/ufs.rst                                                           |    2 
 Documentation/sparc/adi.rst                                                          |    4 
 Documentation/sparc/oradax/dax-hv-api.txt                                            |   44 +++++-----
 Documentation/userspace-api/iommufd.rst                                              |    2 
 Documentation/userspace-api/media/drivers/st-vgxy61.rst                              |    2 
 Documentation/userspace-api/media/rc/lirc-set-wideband-receiver.rst                  |    2 
 Documentation/userspace-api/media/rc/rc-protos.rst                                   |    2 
 Documentation/userspace-api/media/rc/rc-tables.rst                                   |    2 
 Documentation/userspace-api/media/v4l/dev-sliced-vbi.rst                             |    2 
 Documentation/userspace-api/media/v4l/ext-ctrls-codec-stateless.rst                  |    2 
 Documentation/userspace-api/media/v4l/ext-ctrls-jpeg.rst                             |    2 
 Documentation/userspace-api/media/v4l/hist-v4l2.rst                                  |    4 
 Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst                            |    2 
 Documentation/userspace-api/media/v4l/vidioc-cropcap.rst                             |    2 
 Documentation/userspace-api/seccomp_filter.rst                                       |    2 
 Documentation/userspace-api/sysfs-platform_profile.rst                               |    2 
 126 files changed, 232 insertions(+), 232 deletions(-)


Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: rcu@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: sparclinux@vger.kernel.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

