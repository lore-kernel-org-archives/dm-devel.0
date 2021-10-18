Return-Path: <SRS0=X4js=PG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2BFC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 20:32:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D3ED608FB
	for <dm-devel@archiver.kernel.org>; Mon, 18 Oct 2021 20:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D3ED608FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-z-H1ZKP1PUaoqAsvTt-YKw-1; Mon, 18 Oct 2021 16:32:26 -0400
X-MC-Unique: z-H1ZKP1PUaoqAsvTt-YKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C226180FCA7;
	Mon, 18 Oct 2021 20:32:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83409100763D;
	Mon, 18 Oct 2021 20:32:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 910234A703;
	Mon, 18 Oct 2021 20:32:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19IKW9PQ028249 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 18 Oct 2021 16:32:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BFE20DEE7D; Mon, 18 Oct 2021 20:32:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA5DCDAF27
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 20:32:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F986800B26
	for <dm-devel@redhat.com>; Mon, 18 Oct 2021 20:32:05 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-352-ICMcEzuCPzGbdcUOm_fPyg-1; Mon, 18 Oct 2021 16:32:03 -0400
X-MC-Unique: ICMcEzuCPzGbdcUOm_fPyg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mcZIX-00HDlV-C4; Mon, 18 Oct 2021 20:31:53 +0000
Date: Mon, 18 Oct 2021 13:31:53 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk
Message-ID: <YW3ZuQv1qpIXkd5b@bombadil.infradead.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
	<20211015233028.2167651-2-mcgrof@kernel.org>
	<yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
In-Reply-To: <yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, vigneshr@ti.com, snitzer@redhat.com,
	linux-m68k@vger.kernel.org, dm-devel@redhat.com,
	haris.iqbal@ionos.com, miquel.raynal@bootlin.com,
	krisman@collabora.com, Christoph Hellwig <hch@lst.de>,
	agk@redhat.com, anton.ivanov@cambridgegreys.com,
	sstabellini@kernel.org, linux-scsi@vger.kernel.org,
	richard@nod.at, kent.overstreet@gmail.com, geert@linux-m68k.org,
	xen-devel@lists.xenproject.org, jinpu.wang@ionos.com,
	jdike@addtoit.com, johannes.berg@intel.com, jejb@linux.ibm.com,
	linux-um@lists.infradead.org, colyli@suse.de,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	boris.ostrovsky@oracle.com, jgross@suse.com,
	linux-kernel@vger.kernel.org, thehajime@gmail.com, tj@kernel.org,
	linux-mtd@lists.infradead.org, chris.obbard@collabora.com,
	zhuyifei1999@gmail.com, roger.pau@citrix.com
Subject: Re: [dm-devel] [PATCH 1/9] scsi/sd: add error handling support for
	add_disk()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Oct 16, 2021 at 10:51:48PM -0400, Martin K. Petersen wrote:
> 
> Luis,
> 
> > We never checked for errors on add_disk() as this function returned
> > void. Now that this is fixed, use the shiny new error handling.
> >
> > As with the error handling for device_add() we follow the same logic
> > and just put the device so that cleanup is done via the
> > scsi_disk_release().
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks, would you like Jens to pick this up and the other scsi/sr patch
or are you taking it through your tree?

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

