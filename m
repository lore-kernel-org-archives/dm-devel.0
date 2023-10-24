Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F031F1FA1
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 06:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FzDb41My"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698130035;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=C6mwY0ffgRplHCuxfu65SRL9jF2mw15o/M8OO4SKNVw=;
	b=FzDb41MySzVxt2MXDWayeruHYYRN7igrC7O4RYqA4s47ysLLNo80JsI+X8SaNVMUQLU4FP
	AyXpv1bzxHIHo67ekeVE6nFfbE506cyJcNj6e2Y9AY6gkh95q1vGRHX6LHAGlFcSyTt7tE
	Kah0u8JJ3C5fvxVyRN5zXhA+smYeu54=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-aq2EXUPSMmyFZjx9yoic7g-1; Tue,
 24 Oct 2023 02:47:14 -0400
X-MC-Unique: aq2EXUPSMmyFZjx9yoic7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7163638117E9
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 06:47:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6935B2026D4C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 06:47:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 281D3194658C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 06:47:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 520401946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 06:47:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DB4925C2; Tue, 24 Oct 2023 06:47:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16D5625C0
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 06:47:12 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECF3285C1A7
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 06:47:11 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-WI742ByNNqq8EAy1rI9O1g-1; Tue, 24 Oct 2023 02:47:10 -0400
X-MC-Unique: WI742ByNNqq8EAy1rI9O1g-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id D77296732D; Tue, 24 Oct 2023 08:39:27 +0200 (CEST)
Date: Tue, 24 Oct 2023 08:39:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm: error: Add support for zoned block devices
Message-ID: <20231024063927.GD8472@lst.de>
References: <20231023224513.344380-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231023224513.344380-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
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
Cc: Naohiro Aota <naohiro.aota@wdc.com>, Mike Snitzer <snitzer@redhat.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, fstests@vger.kernel.org,
 dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thanks, this looks good to me and fixes the problems I've seen

Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>

FTI, this is the xfstests change we need to use dm-error for zoned
devices in xfstests:

diff --git a/common/rc b/common/rc
index 741579af..9e07d79d 100644
--- a/common/rc
+++ b/common/rc
@@ -2174,12 +2174,10 @@ _require_dm_target()
 		_notrun "This test requires dm $target support"
 	fi
 
-	# dm-error cannot handle the zone information
-	#
 	# dm-snapshot and dm-thin-pool cannot ensure sequential writes on
 	# the backing device
 	case $target in
-	error|snapshot|thin-pool)
+	snapshot|thin-pool)
 		_require_non_zoned_device ${SCRATCH_DEV}
 		;;
 	esac

