From: Mike Snitzer <snitzer@redhat.com>
Subject: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]
Date: Tue, 27 Jan 2015 13:42:58 -0500
Message-ID: <20150127184258.GB2078@redhat.com>
References: <54B3EB4A.9090404@kernel.dk> <54B3F255.5080802@sandisk.com>
	<54B3F78D.2020704@kernel.dk> <54B3FE89.200@sandisk.com>
	<54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54B532EE.20700@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Hey Jens,

I _think_ we've resolved the issues Bart raised for request-based DM's
support for blk-mq devices (anything remaining seems specific to iSER's
blk-mq support which is in development).  Though Keith did have that one
additional patch for that block scatter gather attribute that we still
need to review closer.

Anyway, I think what we have is a solid start and see no reason to hold
these changes back further.  So I've rebased the 'dm-for-3.20' branch of
linux-dm.git ontop of 3.19-rc6 and reordered the required block changes
to be at the front of the series, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20

(these changes have been in Linux next for a month, via linux-dm.git
'for-next')

With your OK, I'd be happy to carry the required block changes and
ultimately request Linus pull them for 3.20 (I can backfill your Acks if
you approve).  BUT I also have no problem with you picking up the block
changes to submit via your block tree (I'd just have to rebase ontop of
your 3.20 branch once you pull them in).

Let me know what you think, thanks.
Mike
