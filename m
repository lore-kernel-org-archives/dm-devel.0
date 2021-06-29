Return-Path: <SRS0=7Rox=LX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F11C11F66
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 07:01:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B521161DC7
	for <dm-devel@archiver.kernel.org>; Tue, 29 Jun 2021 07:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B521161DC7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-MW2rZvRiP_OFyyAkVnC6dg-1; Tue, 29 Jun 2021 03:00:52 -0400
X-MC-Unique: MW2rZvRiP_OFyyAkVnC6dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDA741084F5C;
	Tue, 29 Jun 2021 07:00:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE8845DD68;
	Tue, 29 Jun 2021 07:00:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36AF61809C99;
	Tue, 29 Jun 2021 07:00:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15T70aUZ014967 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Jun 2021 03:00:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 42B63112D409; Tue, 29 Jun 2021 07:00:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E13E112D403
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 07:00:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5871B8037A1
	for <dm-devel@redhat.com>; Tue, 29 Jun 2021 07:00:33 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-82-rE36OXY3OAuqSbZeQki9lQ-1; Tue, 29 Jun 2021 03:00:28 -0400
X-MC-Unique: rE36OXY3OAuqSbZeQki9lQ-1
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	15T6qCkD017030; Tue, 29 Jun 2021 07:00:24 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 39f7uu2nkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jun 2021 07:00:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	15T6xoeU055836; Tue, 29 Jun 2021 07:00:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3020.oracle.com with ESMTP id 39dv251ms8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jun 2021 07:00:23 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15T70Mw2058603;
	Tue, 29 Jun 2021 07:00:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserp3020.oracle.com with ESMTP id 39dv251mrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jun 2021 07:00:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15T70J6g020274;
	Tue, 29 Jun 2021 07:00:19 GMT
Received: from kadam (/102.222.70.252) by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 29 Jun 2021 00:00:19 -0700
Date: Tue, 29 Jun 2021 10:00:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@lists.01.org, mwilck@suse.com, Mike Snitzer <snitzer@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
Message-ID: <202106282356.dKNkiTUO-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <20210628095210.26249-3-mwilck@suse.com>
Message-ID-Hash: IRD7CG4UZAG2EYZJ7F52EJJBUWZF7ZWB
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: DqxcFkkAexUvoS_yb1Y_fZ6GTTM60I3y
X-Proofpoint-GUID: DqxcFkkAexUvoS_yb1Y_fZ6GTTM60I3y
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	kbuild-all@lists.01.org, lkp@intel.com, Daniel Wagner <dwagner@suse.de>
Subject: [dm-devel] [kbuild] Re: [PATCH v4 2/3] scsi: scsi_ioctl: add
 sg_io_to_blk_status()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

url:    https://github.com/0day-ci/linux/commits/mwilck-suse-com/scsi-dm-dm_blk_ioctl-implement-failover-for-SG_IO-on-dm-multipath/20210628-175410 
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git  for-next
config: xtensa-randconfig-s032-20210628 (attached as .config)
compiler: xtensa-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.3-341-g8af24329-dirty
        # https://github.com/0day-ci/linux/commit/259453ca972ae531cfdca07cbf4d6bb09b8f8c9f 
        git remote add linux-review https://github.com/0day-ci/linux 
        git fetch --no-tags linux-review mwilck-suse-com/scsi-dm-dm_blk_ioctl-implement-failover-for-SG_IO-on-dm-multipath/20210628-175410
        git checkout 259453ca972ae531cfdca07cbf4d6bb09b8f8c9f
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=xtensa SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> block/scsi_ioctl.c:937:24: sparse: sparse: dubious: !x & y

vim +937 block/scsi_ioctl.c

259453ca972ae5 Martin Wilck 2021-06-28  932  blk_status_t sg_io_to_blk_status(struct sg_io_hdr *hdr)
259453ca972ae5 Martin Wilck 2021-06-28  933  {
259453ca972ae5 Martin Wilck 2021-06-28  934  	int result;
259453ca972ae5 Martin Wilck 2021-06-28  935  	blk_status_t sts;
259453ca972ae5 Martin Wilck 2021-06-28  936  
259453ca972ae5 Martin Wilck 2021-06-28 @937  	if (!hdr->info & SG_INFO_CHECK)
                                                    ^
Should be if (!(hdr->info & SG_INFO_CHECK))

259453ca972ae5 Martin Wilck 2021-06-28  938  		return BLK_STS_OK;
259453ca972ae5 Martin Wilck 2021-06-28  939  
259453ca972ae5 Martin Wilck 2021-06-28  940  	result = hdr->status |
259453ca972ae5 Martin Wilck 2021-06-28  941  		(hdr->msg_status << 8) |
259453ca972ae5 Martin Wilck 2021-06-28  942  		(hdr->host_status << 16) |
259453ca972ae5 Martin Wilck 2021-06-28  943  		(hdr->driver_status << 24);
259453ca972ae5 Martin Wilck 2021-06-28  944  
259453ca972ae5 Martin Wilck 2021-06-28  945  	sts = __scsi_result_to_blk_status(&result, result);
259453ca972ae5 Martin Wilck 2021-06-28  946  	hdr->host_status = host_byte(result);
259453ca972ae5 Martin Wilck 2021-06-28  947  
259453ca972ae5 Martin Wilck 2021-06-28  948  	return sts;
259453ca972ae5 Martin Wilck 2021-06-28  949  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org 

_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

