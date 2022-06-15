Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24330C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 06:27:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-bhM1R-GJMX6m0xvoIOVwJw-1; Wed, 15 Jun 2022 02:27:40 -0400
X-MC-Unique: bhM1R-GJMX6m0xvoIOVwJw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 864CE811E81;
	Wed, 15 Jun 2022 06:27:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2850A492CA5;
	Wed, 15 Jun 2022 06:27:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DBA4B1947B82;
	Wed, 15 Jun 2022 06:27:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB02F1947B81
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 06:27:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B82082026D07; Wed, 15 Jun 2022 06:27:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B40242026D64
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 06:27:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DAAC811E75
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 06:27:35 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-Si44wJYePmGTpoGhG9cREw-1; Wed, 15 Jun 2022 02:27:33 -0400
X-MC-Unique: Si44wJYePmGTpoGhG9cREw-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 37EB767373; Wed, 15 Jun 2022 08:27:30 +0200 (CEST)
Date: Wed, 15 Jun 2022 08:27:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20220615062729.GA22728@lst.de>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-5-hch@lst.de>
 <4b846753-bb89-c123-2813-bcb587fdcaaf@acm.org>
MIME-Version: 1.0
In-Reply-To: <4b846753-bb89-c123-2813-bcb587fdcaaf@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 4/6] block: cleanup variable naming in
 get_max_io_size
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 14, 2022 at 09:50:00AM -0700, Bart Van Assche wrote:
> On 6/14/22 02:09, Christoph Hellwig wrote:
>> get_max_io_size has a very odd choice of variables names and
>> initialization patterns.  Switch to more descriptive names and more
>> clear initialization of them.
>
> Hmm ... what is so odd about the variable names? I have done my best to 
> chose clear and descriptive names when I introduced these names.

Major confusion:

 - we have a local variable to hold the queue max sectors value,
   but it is callled sectors
 - while we have a variable the holds the rounded end of the I/O
   range that is called max_sectors

Minor confusion:

 - a variable that hold that rounded start of the range has a random
   _offset suffix despite not really being an offset

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

