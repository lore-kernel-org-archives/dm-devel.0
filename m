From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC PATCH 0/7] dm-mpath: Do not clone requests
Date: Fri, 6 Jun 2014 05:25:06 +0000
Message-ID: <11AF7C027C4C02408624617A498607840128BCC4@BPXM12GP.gisp.nec.co.jp>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
	<20140605133626.GA7149@infradead.org> <539076D1.9000704@suse.de>
	<20140605144432.GD4590@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140605144432.GD4590@infradead.org>
Content-Language: ja-JP
Content-ID: <2794E7D8265BEA40AF81B903358560E2@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 06/05/14 23:44, Christoph Hellwig wrote:
> If we'd didn't clone bios the workflow would look something like this:
> 
>  - allocate new clone request in dm-mpath
>  - point clone->bio and clone->biotail to the original bio, zero
>    them out in the original request
>  - the low level driver does one or more calls to blk_update_request

At this point, if blk_update_request is called with error code,
the error is returned straight up to submitter of original bio
before dm-mpath can try other paths.

>    until clone->bio is NULL, and then calls blk_finish_request (or
>    __blk_mq_end_io) once the request has been completed,
>  - This hands control back to dm-mpath, which can now call
>    __blk_mq_end_io without blk_update_request as the low level driver
>    took care of the bio completions.

Primary reason of cloning bios was to intercept lower-layer errors
in dm-mpath for path failover decision.
If we only cloned requests, original bios were already completed
at the time blk_finish_request was called for the clone.

Other implementations were discussed back then.

blk_update_request could skip completing bios until blk_finish_request
is called. But it would become inefficient in the case of partial completion.

A callback hook could be added to blk_update_request.
However such an additional hook was considered as bad approach.

-- 
Jun'ichi Nomura, NEC Corporation
