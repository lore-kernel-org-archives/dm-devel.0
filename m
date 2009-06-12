From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
Date: Fri, 12 Jun 2009 10:33:59 -0400
Message-ID: <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com>
References: <4A3075B2.9040208@ct.jp.nec.com>
	<20090611110903.GO11363@kernel.dk>
	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>
	<20090612133014.GK11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765288AbZFLOeX@vger.kernel.org>
In-Reply-To: <20090612133014.GK11363@kernel.dk> (Jens Axboe's message of "Fri,
	12 Jun 2009 15:30:14 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

Jens Axboe <jens.axboe@oracle.com> writes:

> On Thu, Jun 11 2009, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> Is blk_rq_unprep_clone really the best name?
>>           ^^^^^^
>
> Probably not, but I'm not very good at coming up with elegant names.
> Your email should have included a new suggestion :-)

Fair enough.  ;)

>  - blk_rq_unprep_clone(struct request *clone)
>      * Frees cloned bios from the clone request.

Why not blk_rq_free_clone?

-Jeff
