Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD6DC77B6D
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 05:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680240172;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6YMnk09nOB31SG78J69JJxFytMXCsaQbAnqTQ7ZLN18=;
	b=fjIFuDAgCr/uX9KrGA7w33Ju7l1HhS8/rXsW6A0dneip4exSbHIPOdE2CfLKe17X1tjZe+
	xAsQQ7V8wf/42+7DsQ6POJ/hVLwy4yFENnZKr/A/SQWpeUyDt9AK9IH2o4is+qk0/cqIUw
	gSINdUbX5MT7a/LMgUpaPvqA1FUU174=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-G0VBR9XgNDifOxsYPn5FOA-1; Fri, 31 Mar 2023 01:22:49 -0400
X-MC-Unique: G0VBR9XgNDifOxsYPn5FOA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B961E80A093;
	Fri, 31 Mar 2023 05:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 13ADF492B03;
	Fri, 31 Mar 2023 05:22:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 35E4A1946A4C;
	Fri, 31 Mar 2023 05:22:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 086231946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 19:31:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DACDA4042AC5; Thu, 30 Mar 2023 19:31:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D358A4042AC0
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 19:31:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5D268533DC
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 19:31:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-apkN88IPP1y1-shfCNMdNA-1; Thu,
 30 Mar 2023 15:31:21 -0400
X-MC-Unique: apkN88IPP1y1-shfCNMdNA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 96F501FE07;
 Thu, 30 Mar 2023 19:31:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 200FE133E0;
 Thu, 30 Mar 2023 19:31:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 77P7BobjJWQBRQAAMHmgww
 (envelope-from <dsterba@suse.cz>); Thu, 30 Mar 2023 19:31:18 +0000
Date: Thu, 30 Mar 2023 21:25:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20230330192503.GT10580@twin.jikos.cz>
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
 <20230330154529.GS10580@twin.jikos.cz>
 <9835fc72-18b4-517d-0861-b5b413252eb9@wdc.com>
MIME-Version: 1.0
In-Reply-To: <9835fc72-18b4-517d-0861-b5b413252eb9@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 31 Mar 2023 05:22:41 +0000
Subject: Re: [dm-devel] [PATCH v2 00/19] bio: check return values of
 bio_add_page
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
Reply-To: dsterba@suse.cz
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>, Song Liu <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Bob Peterson <rpeterso@redhat.com>, David Sterba <dsterba@suse.com>,
 Jens Axboe <axboe@kernel.dk>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Damien Le Moal <Damien.LeMoal@wdc.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "dsterba@suse.cz" <dsterba@suse.cz>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.cz
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 30, 2023 at 04:41:58PM +0000, Johannes Thumshirn wrote:
> On 30.03.23 17:52, David Sterba wrote:
> > On Thu, Mar 30, 2023 at 03:43:42AM -0700, Johannes Thumshirn wrote:
> >> We have two functions for adding a page to a bio, __bio_add_page() which is
> >> used to add a single page to a freshly created bio and bio_add_page() which is
> >> used to add a page to an existing bio.
> >>
> >> While __bio_add_page() is expected to succeed, bio_add_page() can fail.
> >>
> >> This series converts the callers of bio_add_page() which can easily use
> >> __bio_add_page() to using it and checks the return of bio_add_page() for
> >> callers that don't work on a freshly created bio.
> >>
> >> Lastly it marks bio_add_page() as __must_check so we don't have to go again
> >> and audit all callers.
> >>
> >> Changes to v1:
> >> - Removed pointless comment pointed out by Willy
> >> - Changed commit messages pointed out by Damien
> >> - Colledted Damien's Reviews and Acks
> >>
> >> Johannes Thumshirn (19):
> > 
> >>   btrfs: repair: use __bio_add_page for adding single page
> >>   btrfs: raid56: use __bio_add_page to add single page
> > 
> > The btrfs patches added to misc-next, thanks.
> > 
> 
> Thanks but wouldn't it make more sense for Jens to pick up all of them?
> The last patch in the series flips bio_add_pages() over to
> __must_check and so it'll create an interdependency between the
> btrfs and the block tree.

I'd rather take it via btrfs tree, this avoids future merge conflicts.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

