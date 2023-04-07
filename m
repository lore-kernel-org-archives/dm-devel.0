Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7137DC7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IEZDw72vGvYHKP/R+sD5/qYG6BWWi5cA0JdvPF3AoGU=;
	b=dfCIpG+0OjQdTQAI9+bfAVmAogiFeYJNUcw48swrHy6m372qlQJ6XDxXJCG6qAvPdULHVy
	ii0CvDkcceaWyyz1iYHM+giwXZ2haeXO0Wicvv02IoKCox7foLqcT3O3Jm/LPFcK4BFxIy
	hMTqpVJgxj+2Ej5h+wkgCkeOvQ9tbbE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-Yz5M0cEeO9-sK5zs1pfReQ-1; Tue, 11 Apr 2023 02:44:15 -0400
X-MC-Unique: Yz5M0cEeO9-sK5zs1pfReQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A34338996E7;
	Tue, 11 Apr 2023 06:44:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C882C15BB8;
	Tue, 11 Apr 2023 06:44:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3386D1946A7E;
	Tue, 11 Apr 2023 06:44:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 461BA19465B5
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Apr 2023 20:06:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 33B081121315; Fri,  7 Apr 2023 20:06:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BE861121314
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:06:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09D7A380610A
 for <dm-devel@redhat.com>; Fri,  7 Apr 2023 20:06:19 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
 [205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-_AIxQPKQNUOfN5sW_LoiZQ-1; Fri, 07 Apr 2023 16:06:17 -0400
X-MC-Unique: _AIxQPKQNUOfN5sW_LoiZQ-1
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 337FwobR017328; Fri, 7 Apr 2023 20:05:56 GMT
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcnd5wu4-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:05:56 +0000
Received: from pps.filterd
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19)
 with ESMTP id 337J0UK9034219; Fri, 7 Apr 2023 20:05:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3pptjxeec5-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Fri, 07 Apr 2023 20:05:55 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5tqq010228;
 Fri, 7 Apr 2023 20:05:55 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com
 [10.154.128.1])
 by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3pptjxeeam-1; Fri, 07 Apr 2023 20:05:54 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@kernel.org,
 axboe@kernel.dk, linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
 kbusch@kernel.org, target-devel@vger.kernel.org
Date: Fri,  7 Apr 2023 15:05:33 -0500
Message-Id: <20230407200551.12660-1-michael.christie@oracle.com>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304070180
X-Proofpoint-GUID: iHg0PBtxfmh4W4-XsTYDZ3rbexyC2Cq0
X-Proofpoint-ORIG-GUID: iHg0PBtxfmh4W4-XsTYDZ3rbexyC2Cq0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 00/18] Use block pr_ops in LIO
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: oracle.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patches in this thread allow us to use the block pr_ops with LIO's
target_core_iblock module to support cluster applications in VMs. They
were built over Linus's tree. They also apply over linux-next and
Martin's tree and Jens's trees.

Currently, to use windows clustering or linux clustering (pacemaker +
cluster labs scsi fence agents) in VMs with LIO and vhost-scsi, you have
to use tcmu or pscsi or use a cluster aware FS/framework for the LIO pr
file. Setting up a cluster FS/framework is pain and waste when your real
backend device is already a distributed device, and pscsi and tcmu are
nice for specific use cases, but iblock gives you the best performance and
allows you to use stacked devices like dm-multipath. So these patches
allow iblock to work like pscsi/tcmu where they can pass a PR command to
the backend module. And then iblock will use the pr_ops to pass the PR
command to the real devices similar to what we do for unmap today.

The patches are separated in the following groups:
Patch 1 - 2:
- Add block layer callouts for reading reservations and rename reservation
  error code.
Patch 3 - 5:
- SCSI support for new callouts.
Patch 6:
- DM support for new callouts.
Patch 7 - 13:
- NVMe support for new callouts.
Patch 14 - 18:
- LIO support for new callouts.

This patchset has been tested with the libiscsi PGR ops and with window's
failover cluster verification test. Note that for scsi backend devices we
need this patchset:

https://lore.kernel.org/linux-scsi/20230123221046.125483-1-michael.christie@oracle.com/T/#m4834a643ffb5bac2529d65d40906d3cfbdd9b1b7

to handle UAs. To reduce the size of this patchset that's being done
separately to make reviewing easier. And to make merging easier this
patchset and the one above do not have any conflicts so can be merged
in different trees.

v6:
- Drop dm use comment.
- Move scsi pr type conversion code to scsi_common.c/.h.
- Fix le NVME_EXTENDED_DATA_STRUCT use.
- Fix sparse warnings like sense_reason_t use.

v5:
- Use []/struct_size with nvme reservation structs
- Add Keith's copywrite to pr.c
- Drop else in nvme_send_pr_command
- Fix PR_EXCLUSIVE_ACCESS_ALL_REGS use in block_pr_type_from_nvme

v4:
- Pass read_keys number of keys instead of array len
- Keep the switch use when converting between block and scsi/nvme PR
types. Drop default case so compiler spits out warning if in the future
a new value is added.
- Add helper for handling
nvme_send_ns_head_pr_command/nvme_send_ns_pr_command
- Use void * instead of u8* for passing data buffer.
- Rename status variable to rs.
- Have caller init buffer/structs instead of nvme/scsi callouts.
- Drop blk_status to err code.

v3:
- Fix patch subject formatting.
- Fix coding style.
- Rearrange patches so helpers are added with users to avoid compilation
errors.
- Move pr type conversion to array and add nvme_pr_type.
- Add Extended Data Structure control flag enum and use in code for checks.
- Move nvme pr code to new file.
- Add more info to patch subjects about why we need to add blk_status
to pr_ops.
- Use generic SCSI passthrough error handling interface.
- Fix checkpatch --strict errors. Note that I kept the existing coding
style that it complained about because it looked like it was the preferred
style for the code and I didn't want a mix and match.

v2:
- Drop BLK_STS_NEXUS rename changes. Will do separately.
- Add NVMe support.
- Fixed bug in target_core_iblock where a variable was not initialized
mentioned by Christoph.
- Fixed sd pr_ops UA handling issue found when running libiscsi PGR tests.
- Added patches to allow pr_ops to pass up a BLK_STS so we could return
a RESERVATION_CONFLICT status when a pr_ops callout fails.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

