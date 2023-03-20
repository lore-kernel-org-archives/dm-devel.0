Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EF0C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679321930;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GuljeJ/4poceRqnuLKTs+7W6Kpt+57fN8zm5ACLn6GQ=;
	b=TZBY51Dte19OsM4dFGv/4NNcoH0lpROt2mLt+QQE45aDsFlvyCmaB2b3JoqvAKs9bns8uN
	Y2R696m6b2rQVr1bjZBRKv0wpucsREnmj43VGhyqBpWANjzf4yYJWZJY/BsDIuTbDR746R
	IO1IbTfaWz21LkL6BfUSkJHP560zYcc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-ygvSnjnENi6vgCxZYXQQAQ-1; Mon, 20 Mar 2023 10:18:47 -0400
X-MC-Unique: ygvSnjnENi6vgCxZYXQQAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B48100F7FA;
	Mon, 20 Mar 2023 14:18:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF33A40C6E67;
	Mon, 20 Mar 2023 14:18:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CECF319465A2;
	Mon, 20 Mar 2023 14:18:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 862EC1946594
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Mar 2023 14:18:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 774B440C6E68; Mon, 20 Mar 2023 14:18:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70AD340C6E67
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 14:18:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 546BB855304
 for <dm-devel@redhat.com>; Mon, 20 Mar 2023 14:18:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-EvUIFjZ9OUGZHc12I6GmdQ-1; Mon,
 20 Mar 2023 10:18:39 -0400
X-MC-Unique: EvUIFjZ9OUGZHc12I6GmdQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 6AE8621A8F;
 Mon, 20 Mar 2023 14:18:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F76A13A00;
 Mon, 20 Mar 2023 14:18:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id nH+ZDT5rGGTmHQAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 20 Mar 2023 14:18:38 +0000
Message-ID: <a85c4b5a6603be979ddb9aa0909808519a03fa3e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, device-mapper development
 <dm-devel@redhat.com>
Date: Mon, 20 Mar 2023 15:18:37 +0100
In-Reply-To: <CD5EC3B3-9A64-416A-A04C-C68EDB82F4C6@purestorage.com>
References: <CD5EC3B3-9A64-416A-A04C-C68EDB82F4C6@purestorage.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] multipath-tools Consider making 'smart' the
 default
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2023-03-16 at 14:47 -0700, Brian Bunker wrote:
> As a target vendor, it is nice to be able control initiator
> behavior from the target without relying on user intervention
> on the initiator. There could be a very large number of initiators
> at a site.
> 
> When ACLs are first added for a volume on our array, we use the
> transport layer, so that the initiator will discover the volumes
> without any manual intervention.
> 
> kernel: scsi 8:0:0:1: Direct-Access PURE Flash Array
> 8888 PQ: 0 ANSI: 6
> kernel: scsi 9:0:0:1: Direct-Access PURE Flash Array
> 8888 PQ: 0 ANSI: 6
> kernel: scsi 6:0:0:1: Direct-Access PURE Flash Array
> 8888 PQ: 0 ANSI: 6
> kernel: scsi 7:0:0:1: Direct-Access PURE Flash Array
> 8888 PQ: 0 ANSI: 6
> ...
> kernel: sd 6:0:0:1: [sdd] Attached SCSI disk
> kernel: sd 8:0:0:1: [sdb] Attached SCSI disk
> kernel: sd 9:0:0:1: [sdc] Attached SCSI disk
> kernel: sd 7:0:0:1: [sde] Attached SCSI disk
> 
> Subsequent volumes after the first one are discovered via unit
> attentions triggering the udev rule which calls scan-scsi-target.
> The SCSI devices being discovered without creating the corresponding
> multipath devices seems to be a bad default. We would like to
> control as much as possible from the target side to dictate initiator
> behavior. This comes as a regression to how it previously worked.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>

I'm fine with this, but keep in mind that distributions will probably
override this anyway. Red Hat and SUSE have had different defaults for
this basically forever. At least enterprise distros won't risk
regressions because of changing defaults.

Ben, what's your opinion wrt the patch?

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

