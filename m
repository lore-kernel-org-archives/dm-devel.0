From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: don't access bio->bi_error after bio_put()
Date: Tue, 11 Aug 2015 13:28:20 +0200
Message-ID: <20150811112820.GA1493@lst.de>
References: <1439247918-12599-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439247918-12599-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: hch@lst.de, axboe@kernel.dk, martin.petersen@oracle.com, neilb@suse.de, bo.li.liu@oracle.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Sasha,

thanks for the report.  I actually sent a similar patch to Jens
a couple days ago, but it seems he's on vacation currently asI haven't seen him
reply to this or other patches.
