From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [GIT PULL] Core block IO bits for 4.2
Date: Fri, 26 Jun 2015 06:15:12 +0000
Message-ID: <20150626061510.GA15036@xzibit.linux.bs1.fc.nec.co.jp>
References: <20150625143716.GA13739@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150625143716.GA13739@kernel.dk>
Content-Language: ja-JP
Content-ID: <9435C87A9B9A0B4A84F5D31022C095BF@gisp.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, "torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Jens,

On 06/25/15 23:37, Jens Axboe wrote:
>       block, dm: don't copy bios for request clones

this change should not be pushed to mainline yet.

Firstly, Christoph has a newer version of the patch that fixes silent
data corruption problem:
  https://www.redhat.com/archives/dm-devel/2015-May/msg00229.html

And the new version still depends on LLDDs to always complete requests
to the end when error happens, while block API doesn't enforce such a
requirement. If the assumption is ever broken, the inconsistency between
request and bio (e.g. rq->__sector and rq->bio) will cause silent data
corruption:
  https://www.redhat.com/archives/dm-devel/2015-June/msg00022.html

-- 
Jun'ichi Nomura, NEC Corporation
