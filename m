Return-Path: <SRS0=X5vH=D3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50B5C433E7
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AFF32225F
	for <dm-devel@archiver.kernel.org>; Tue, 20 Oct 2020 08:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AFF32225F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-d56ANhx6NMSSUpZG9ziZPw-1; Tue, 20 Oct 2020 04:22:53 -0400
X-MC-Unique: d56ANhx6NMSSUpZG9ziZPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B17E8049D8;
	Tue, 20 Oct 2020 08:22:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B02975132;
	Tue, 20 Oct 2020 08:22:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E19EF18199F8;
	Tue, 20 Oct 2020 08:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JHQWhI012601 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 13:26:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 69F3D11558B7; Mon, 19 Oct 2020 17:26:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6630A11558B6
	for <dm-devel@redhat.com>; Mon, 19 Oct 2020 17:26:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAF8A102F1E1
	for <dm-devel@redhat.com>; Mon, 19 Oct 2020 17:26:29 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-11-CX9vnjyzPui41IV2STfSJA-1;
	Mon, 19 Oct 2020 13:26:25 -0400
X-MC-Unique: CX9vnjyzPui41IV2STfSJA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6544920B4905;
	Mon, 19 Oct 2020 10:26:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6544920B4905
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com
Date: Mon, 19 Oct 2020 10:26:05 -0700
Message-Id: <20201019172607.16714-1-tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Tue, 20 Oct 2020 04:22:11 -0400
Cc: sashal@kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, dm-devel@redhat.com,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v4 0/2] dm-devel:dm-crypt: infrastructure for
	measurement of DM target data using IMA
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are several device-mapper targets which contribute to verify
the integrity of the mapped devices e.g. dm-integrity, dm-verity,
dm-crypt etc.

But they do not use the capabilities provided by kernel integrity
subsystem (IMA). For instance, the IMA capability that measures several
in-memory constructs and files to detect if they have been accidentally
or maliciously altered. IMA also has the capability to include these
measurements in the IMA measurement list and use them to extend a TPM
PCR so that they can be quoted. These TPM PCR extend operations ensure
that the tampering with the order of constructs being measured, and
tampering with the measured constructs themselves - doesn't go
undetected. In general, this capability is used for remote attestation
of in-memory constructs and files of interest. As of today,device-mapper
targets don't use the benefits of extended TPM PCR quotes and ultimately
the benefits of remote attestation.

This series bridges this gap, so that all device-mapper targets
could take advantage of IMA's measuring and quoting abilities - thus
ultimately enabling remote attestation for device-mapper targets.

This series is based on the following repo/branch:
 repo: https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 branch: next-integrity
 commit aa662fc04f5b ("ima: Fix NULL pointer dereference in ima_file_hash")

This series also has a dependency on the following patch series and
should be applied in the following order:
 1. https://patchwork.kernel.org/patch/11795559/
 2. https://patchwork.kernel.org/patch/11801525/


Change Log v4:
Incorporated feedback from Milan Broz <gmazyland@gmail.com> on v3 series.
 - Added device name of both base disk and target device for
   measurement, along with their major:minor.
 - Introduced a function get_devname_from_maj_min() in dm-ima.c, to
   get the device name from device major:minor. Currently it is used
   for dm-crypt measurements, but it would be helpful for measuring 
   other device-mapper targets as well.
 - Added dm_target members - len and begin - to measurement list. 
 - Taken dependency on the updated base series v4 (1. above)
 - Taken dependency on the updated early boot measurement series v3
   (2. above).

Change Log v3:
 - Added dm-crypt as a supported data source to measure in ima.h.
 - Taken dependency on the updated base series v3 (2. above)
 - Taken dependency on the updated early boot measurement series v2
   (3. above).

Change Log v2:
 - Removed the references to "local" measurement from the description -
   as this series only support remote attestation, and not local
   integrity enforcement.
 - Taken dependency on the updated base series (2. above), which 
   introduced a boolean parameter measure_buf_hash as per community
   feedback to support measuring hash of the buffer, instead of the
   buffer itself.
 - Taken dependency on the updated early boot measurement series
   (3. above).

Tushar Sugandhi (2):
  dm-devel: collect target data and submit to IMA to measure
  dm-crypt: collect data and submit to DM to measure

 block/genhd.c                           |   2 +
 drivers/md/Makefile                     |   1 +
 drivers/md/dm-crypt.c                   | 217 ++++++++++++++
 drivers/md/dm-ima.c                     | 378 ++++++++++++++++++++++++
 include/linux/device-mapper.h           |  67 +++++
 include/linux/genhd.h                   |   1 +
 security/integrity/ima/ima.h            |   1 +
 security/integrity/ima/ima_queue_data.c |   3 +-
 8 files changed, 669 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-ima.c

-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

