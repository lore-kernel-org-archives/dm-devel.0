From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/12] fs: don't reassign dirty inodes to
	default_backing_dev_info
Date: Tue, 24 Mar 2015 07:53:25 +0100
Message-ID: <20150324065325.GC3159@lst.de>
References: <1421228561-16857-1-git-send-email-hch@lst.de> <1421228561-16857-12-git-send-email-hch@lst.de> <CAMM=eLe6Tt+g7dLcnn5a1fQboDknkasazsMiOFBziWPZemnYtg@mail.gmail.com> <20150323224012.GA29505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150323224012.GA29505@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, linux-nfs@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-mtd@lists.infradead.org, Tejun Heo <tj@kernel.org>, ceph-devel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 23, 2015 at 06:40:13PM -0400, Mike Snitzer wrote:
> FYI, here is the DM fix I've staged for 4.0-rc6.  I'll continue testing
> the various DM targets before requesting Linus to pull.

Yeah, from looking at the bugzilla it seemed like dm was releasing the
dev_t before the queue has been freed.

I don't know this code to well, so this isn't a full review, but it looks like
the right fix to me.
