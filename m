Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80557C05027
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 18:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675363679;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fh2EoAeXL6ZPyPGdlBT1ZFTxV6smumBlgw+/djSzmZU=;
	b=hK5El6GNZGl7cKIAJlwooCi2TZ/qKG18GVuAws0syC9EdQRBLm4lrE6H6//s1itlCkGYXY
	Yp6RCCrK2edebjzxTDtOCPsdBUEJSXnuXlKDHf1VqFF3XC6zgNUwWCrGgrOc6DhPvXzXcg
	VEvAanzLpiwAEcjOuGXQHHY16MMn13k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-38_WJK6vOwG_jVd5d9pbtw-1; Thu, 02 Feb 2023 13:47:56 -0500
X-MC-Unique: 38_WJK6vOwG_jVd5d9pbtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A95F938123D4;
	Thu,  2 Feb 2023 18:47:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5651CC15BA0;
	Thu,  2 Feb 2023 18:47:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 40EA3194658C;
	Thu,  2 Feb 2023 18:47:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CEBBD1946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 18:47:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 977772026D76; Thu,  2 Feb 2023 18:47:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 905772026D68
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:47:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13525281DE91
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 18:47:14 +0000 (UTC)
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-5kYoV1cuMIaaKMVybjvwuQ-1; Thu, 02 Feb 2023 13:47:03 -0500
X-MC-Unique: 5kYoV1cuMIaaKMVybjvwuQ-1
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ms.lwn.net (Postfix) with ESMTPSA id A8666739;
 Thu,  2 Feb 2023 18:46:55 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A8666739
From: Jonathan Corbet <corbet@lwn.net>
To: Bart Van Assche <bvanassche@acm.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
 <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
Date: Thu, 02 Feb 2023 11:46:54 -0700
Message-ID: <87o7qbvra9.fsf@meer.lwn.net>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
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
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>,
 Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
 Vishal Verma <vishal.l.verma@intel.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 dmaengine@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Vinod Koul <vkoul@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Bart Van Assche <bvanassche@acm.org> writes:

> On 2/2/23 10:33, Randy Dunlap wrote:
>> On 2/2/23 10:09, Jonathan Corbet wrote:
>>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>>   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>>>   [PATCH 7/9] Documentation: scsi: correct spelling
>>>
>>> I've left these for the SCSI folks for now.  Do we *really* want to be
>>> fixing spelling in ChangeLog files from almost 20 years ago?
>> 
>> That's why I made it a separate patch -- so the SCSI folks can decide that...
>
> How about removing the Documentation/scsi/ChangeLog.* files? I'm not 
> sure these changelogs are still useful since these duplicate information 
> that is already available in the output of git log ${driver_directory}.

Actually, the information in those files mostly predates the git era, so
you won't find it that way.  I *still* question their value, though...

jon

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

