From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: don't access bio->bi_error after bio_put()
Date: Tue, 11 Aug 2015 11:32:55 -0600
Message-ID: <55CA31C7.6040004@kernel.dk>
References: <1439247918-12599-1-git-send-email-sasha.levin@oracle.com> <20150811112820.GA1493@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150811112820.GA1493@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sasha Levin <sasha.levin@oracle.com>
Cc: martin.petersen@oracle.com, neilb@suse.de, bo.li.liu@oracle.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 08/11/2015 05:28 AM, Christoph Hellwig wrote:
> Hi Sasha,
>
> thanks for the report.  I actually sent a similar patch to Jens
> a couple days ago, but it seems he's on vacation currently asI haven't seen him
> reply to this or other patches.

I'm back now, just going over emails. I'll get to it shortly.

-- 
Jens Axboe
