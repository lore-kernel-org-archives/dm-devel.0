From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/1] dm-zoned: Zoned block device target
Date: Fri, 10 Feb 2017 10:09:47 +0900
Message-ID: <0342cba2-6745-fddd-e318-db0adf6f1ca4@wdc.com>
References: <20170209041849.30964-1-damien.lemoal@wdc.com>
	<20170209152745.GA10638@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170209152745.GA10638@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

On 2/10/17 00:27, Mike Snitzer wrote:
> Looks like this work has come a long way.  While I am _still_ not
> hearing from any customers (or partners) that SMR is a priority I do
> acknowledge that that obviously isn't the case for WDC and others.
> 
> So, I'll sign up for reviewing this DM target, with a focus on DM
> interface and implementation details, _after_ I get some technical
> review (e.g. Reviewed-by) from people like Hannes and others more
> invested in the SMR technologies.  Basically I don't know enough about
> the constraints of these devices to fully appreciate and catch some
> issue in the particulars of the algorithms used to mitigate SMR's
> quirks.

Fair enough. I understand.

I would also like to let you know that I worked closely with Hannes and
Martin and also Shaun Tauncheff (Seagate) to put together the final
patches of the ZBC support for 4.10. I also contributed to part of the
f2fs support for these devices, which also was included in 4.10.
(And I also maintain the libzbc project in github)

> I'd also like to understand how invested WDC is in maintaining this DM
> target for years and years if/when I were to merge this DM target into
> mainline.

We are fully invested. I am part of the system software group in WD
Research and one of our mission is to support Linux kernel and open
source software in general. Bart (Van Assche), who I believe you know,
is also a member of our group now that Sandisk and WD merger completed.

Hannes and Christoph already sent some comments regarding the code. I
will make appropriate changes and re-post the patch for review.

Thank you.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
