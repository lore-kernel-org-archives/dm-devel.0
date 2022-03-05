Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 340B6C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  5 Mar 2022 02:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646446101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QZ/lyjmqDF097nQgCHKPkmxjhfLX04MkBDVQJk9ZEXw=;
	b=IFMCr0R2t97FqKoR9s/LVVpjkZLyg5szP22EgIXrg8W659WV9PLtcsfjliIb4ogNgCDsg5
	60lZF9LFaCfonxj+sv1AOEL5cX4Vmbqa7f8uzOT/x0wR5vWUOrZePDZnMNR+V5BifWyjZB
	66ifhy4DMTxlaB1T07yHA+Rs4EibG0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-PND6fagYPIuByogar5kQLw-1; Fri, 04 Mar 2022 21:08:17 -0500
X-MC-Unique: PND6fagYPIuByogar5kQLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C58B7104;
	Sat,  5 Mar 2022 02:08:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8E101B5C0;
	Sat,  5 Mar 2022 02:08:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 840E41809CB2;
	Sat,  5 Mar 2022 02:08:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 22528But029098 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 21:08:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4C0B12026D64; Sat,  5 Mar 2022 02:08:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4712B2026D4D
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:08:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0109A811E75
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:08:08 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-445-MkuHTnBHOX6Z_5lIm-ugOw-1; Fri, 04 Mar 2022 21:08:06 -0500
X-MC-Unique: MkuHTnBHOX6Z_5lIm-ugOw-1
Received: by mail-qv1-f71.google.com with SMTP id
	kj16-20020a056214529000b00435218e0f0dso7999942qvb.3
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 18:08:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=7Vaf+WRoHUeVQYxK6EsnFI2WrQxqipTtcjN+TM8yHuc=;
	b=l9dkkyHAu+LjLuNBemqRTBIGb6qpdAKVQLF4PPTJIVxs3r8JlTTMpgHKYmAJRnw8Wh
	/wwW02ybxe2FD7ciO/9HkU22AVmu2PvgT8gIFphO4BDX0RwonBoSNMZpxMWPXUhZzl4G
	jMFPxA2QAT6IrWzshkSattlSq1aJW/XDwCiGZwcbvVeLcP+PwFqehO54j5oHD6hEEt4j
	jUaRyWp05ICzsCrRphZzI8e2LSJzs5UBe7f03Yt2xJ2Dbfkl5VwBCc7SW6DuXAvLOz78
	jZuLKs/jGsZMrISkxFjgCizvUG/2AC2z22iosJTM6LwCI8+C/ay3a25sXoUQ3+ZSWVG5
	+K0g==
X-Gm-Message-State: AOAM533DXdK8arhpVywzflV+6DnpGd5yBLYbOBko5awVsuAcDGpqDXX9
	ixQcvEMjvf8CmiprWsCWnVWNL1Ui9dS8+A2BUJI2Aq9FC/mBh1Eu+78Gpea+fL2/O6a4InXRxKn
	vl2OrimYSZudLZQ==
X-Received: by 2002:a37:80b:0:b0:507:58e:5dd4 with SMTP id
	11-20020a37080b000000b00507058e5dd4mr1023439qki.130.1646446086188;
	Fri, 04 Mar 2022 18:08:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwuVdv+qlbXOmiw3bwdmjzHCnJrDeVZSnG1NopvMLz5BfsVPwJmSlt7WCIb+H7b05F7asBDhw==
X-Received: by 2002:a37:80b:0:b0:507:58e:5dd4 with SMTP id
	11-20020a37080b000000b00507058e5dd4mr1023431qki.130.1646446085950;
	Fri, 04 Mar 2022 18:08:05 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	t22-20020a05622a181600b002dd4f62308dsm4387054qtc.57.2022.03.04.18.08.05
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 18:08:05 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri,  4 Mar 2022 21:08:02 -0500
Message-Id: <20220305020804.54010-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: [dm-devel] [PATCH v5 0/2] block/dm: support bio polling
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I've rebased Ming's latest [1] ontop of dm-5.18 [2] (which is based on
for-5.18/block). End result available in dm-5.18-biopoll branch [3]

These changes add bio polling support to DM.  Tested with linear and
striped DM targets.

IOPS improvement was ~5% on my baremetal system with a single Intel
Optane NVMe device (555K hipri=1 vs 525K hipri=0).

Ming has seen better improvement while testing within a VM:
 dm-linear: hipri=1 vs hipri=0 15~20% iops improvement
 dm-stripe: hipri=1 vs hipri=0 ~30% iops improvement

I'd like to merge these changes via the DM tree when the 5.18 merge
window opens.  The first block patch that adds ->poll_bio to
block_device_operations will need review so that I can take it
through the DM tree.  Reason for going through the DM tree is there
have been some fairly extensive changes queued in dm-5.18 that build
on for-5.18/block.  So I think it easiest to just add the block
depenency via DM tree since DM is first consumer of ->poll_bio

FYI, Ming does have another DM patch [4] that looks to avoid using
hlist but I only just saw it.  bio_split() _is_ involved (see
dm_split_and_process_bio) so I'm not exactly sure where he is going
with that change.  But that is DM-implementation detail that we'll
sort out. Big thing is we need approval for the first block patch to
go to Linus via the DM tree ;)

Thanks,
Mike

[1] https://github.com/ming1/linux/commits/my_v5.18-dm-bio-poll
[2] https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18
[3] https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.18-biopoll
[4] https://github.com/ming1/linux/commit/c107c30e15041ac1ce672f56809961406e2a3e52

v5: remove WARN_ONs in ->poll_bio interface patch. Fixed comment typo
    along the way (found while seeing how other
    block_device_operations are referenced in block's code comments).

Ming Lei (2):
  block: add ->poll_bio to block_device_operations
  dm: support bio polling

 block/blk-core.c       |  14 +++--
 block/genhd.c          |   4 ++
 drivers/md/dm-core.h   |   2 +
 drivers/md/dm-table.c  |  27 +++++++++
 drivers/md/dm.c        | 150 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |   2 +
 6 files changed, 191 insertions(+), 8 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

