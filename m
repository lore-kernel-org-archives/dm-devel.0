Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7425CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 05:56:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-3ClzhmQ-N7qKXjMzxtXHvg-1; Tue, 23 Nov 2021 00:56:37 -0500
X-MC-Unique: 3ClzhmQ-N7qKXjMzxtXHvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 301311030C20;
	Tue, 23 Nov 2021 05:56:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14C482B0B2;
	Tue, 23 Nov 2021 05:56:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A32AD4A703;
	Tue, 23 Nov 2021 05:56:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN5uRCY021354 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 00:56:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A02E22026D69; Tue, 23 Nov 2021 05:56:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BF9A2026D67
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 05:56:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A44E4811E7A
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 05:56:24 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-175-5OLLa9_zPRaelU_Hqf1KOA-1; Tue, 23 Nov 2021 00:56:20 -0500
X-MC-Unique: 5OLLa9_zPRaelU_Hqf1KOA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 97B5168AFE; Tue, 23 Nov 2021 06:56:16 +0100 (CET)
Date: Tue, 23 Nov 2021 06:56:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <20211123055616.GA13711@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-3-hch@lst.de>
	<CAPcyv4iPOcD8OsimpSZMnbTEsGZKj-GqSY=cWC0tPvoVs6DE1Q@mail.gmail.com>
	<20211119065457.GA15524@lst.de>
	<CAPcyv4iDujo8ZZp=8xNEhB3u6Vyc6nzq_THGiGRON7x3oi9enw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iDujo8ZZp=8xNEhB3u6Vyc6nzq_THGiGRON7x3oi9enw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 02/29] dm: make the DAX support dependend on
 CONFIG_FS_DAX
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 22, 2021 at 06:54:09PM -0800, Dan Williams wrote:
> On Thu, Nov 18, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Wed, Nov 17, 2021 at 09:23:44AM -0800, Dan Williams wrote:
> > > Applied, fixed the spelling of 'dependent' in the subject and picked
> > > up Mike's Ack from the previous send:
> > >
> > > https://lore.kernel.org/r/YYASBVuorCedsnRL@redhat.com
> > >
> > > Christoph, any particular reason you did not pick up the tags from the
> > > last posting?
> >
> > I thought I did, but apparently I've missed some.
> 
> I'll reply with the ones I see missing that need carrying over and add
> my own reviewed-by then you can send me a pull request when ready,
> deal?

Ok.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

