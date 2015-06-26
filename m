From: Jens Axboe <axboe@fb.com>
Subject: Re: [GIT PULL] Core block IO bits for 4.2
Date: Fri, 26 Jun 2015 13:22:33 -0600
Message-ID: <558DA679.7000304@fb.com>
References: <20150625143716.GA13739@kernel.dk> <20150626061510.GA15036@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150626061510.GA15036@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, "torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/26/2015 12:15 AM, Junichi Nomura wrote:
> Hi Jens,
> 
> On 06/25/15 23:37, Jens Axboe wrote:
>>        block, dm: don't copy bios for request clones
> 
> this change should not be pushed to mainline yet.
> 
> Firstly, Christoph has a newer version of the patch that fixes silent
> data corruption problem:
>    https://www.redhat.com/archives/dm-devel/2015-May/msg00229.html
> 
> And the new version still depends on LLDDs to always complete requests
> to the end when error happens, while block API doesn't enforce such a
> requirement. If the assumption is ever broken, the inconsistency between
> request and bio (e.g. rq->__sector and rq->bio) will cause silent data
> corruption:
>    https://www.redhat.com/archives/dm-devel/2015-June/msg00022.html

Why was none of that sent to the block tree?

In any case, Linus, pick up Mike's pull request to fix this up.

-- 
Jens Axboe
