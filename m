Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05FCBEB64D7
	for <dm-devel@archiver.kernel.org>; Mon, 26 Jun 2023 07:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687766021;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VskhYzUz54bPmmrSPl9PhgVixnmrDvrauYoN+7pB0Ws=;
	b=UEHSJUaUn9feREUmM3m2IHk/J/MZy1rNHV2pJJ08Pai8VYe6PdQmP5AAq+9ddyzLof38nd
	ITwxpafNXvO05P00I22gJbqxFJuP12ZBbogKVKz/YxFCwaFQhegJZdW6peB98d6+aqyL7I
	pZbfJVzJRl8hOfTu9a7ol1ag+hL7IKs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-kmQKf65sOcuuNN2kA4ntwg-1; Mon, 26 Jun 2023 03:53:40 -0400
X-MC-Unique: kmQKf65sOcuuNN2kA4ntwg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4819E1C03D9E;
	Mon, 26 Jun 2023 07:53:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D986E40D1A4;
	Mon, 26 Jun 2023 07:53:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 874751946588;
	Mon, 26 Jun 2023 07:53:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DF5A1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 26 Jun 2023 07:53:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED48240C2070; Mon, 26 Jun 2023 07:53:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E687840C2063
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 07:53:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC9293C11A02
 for <dm-devel@redhat.com>; Mon, 26 Jun 2023 07:53:33 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-uVs0yr1gOkiJayi_g3ptZA-1; Mon, 26 Jun 2023 03:53:30 -0400
X-MC-Unique: uVs0yr1gOkiJayi_g3ptZA-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 72B8C67373; Mon, 26 Jun 2023 09:53:25 +0200 (CEST)
Date: Mon, 26 Jun 2023 09:53:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20230626075325.GA26851@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-9-hch@lst.de>
 <c1391658-d785-4b2f-ba7e-01e4668685d7@roeck-us.net>
MIME-Version: 1.0
In-Reply-To: <c1391658-d785-4b2f-ba7e-01e4668685d7@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 08/24] init: pass root_device_name explicitly
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
Cc: Jens Axboe <axboe@kernel.dk>, Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 23, 2023 at 05:08:59PM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Wed, May 31, 2023 at 02:55:19PM +0200, Christoph Hellwig wrote:
> > Instead of declaring root_device_name as a global variable pass it as an
> > argument to the functions using it.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch results in the following build error when trying to build
> xtensa:tinyconfig.
> 
> WARNING: modpost: vmlinux: section mismatch in reference: strcpy.isra.0+0x14 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
> ERROR: modpost: Section mismatches detected.

I can reproduce these with gcc 13.1 on xtensa, but the report makes
no sense to me.  If I disable CONFIG_CC_OPTIMIZE_FOR_SIZE it now reports
a similar warning for put_page intead of strcpy which seems just as
arcance. 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

