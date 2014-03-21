From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
Date: Fri, 21 Mar 2014 08:37:49 -0700
Message-ID: <20140321153749.GA17155@infradead.org>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
 <1395383538-18019-2-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1395383538-18019-2-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Matias Bj??rling <m@bjorling.me>
Cc: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Just curious:  why do you think implementing this as a block remapper
inside device mapper is a better idea than as a blk-mq driver?

At the request layer you already get a lot of infrastucture for all the
queueing infrastructure for free, as well as all kinds of other helpers.
And the driver never remaps bios anyway but always submits new ones as
far as I can tell.

Does it even make sense to expose the underlying devices as block
devices?  It surely would help to send this together with a driver
that you plan to use it on top of.
