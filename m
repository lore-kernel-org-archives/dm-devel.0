From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Re: [PATCH v2] expose dm-stripe target's topology I/O
	hints
Date: Thu, 27 Aug 2009 13:26:28 -0400
Message-ID: <yq11vmx88xn.fsf@sermon.lab.mkp.net>
References: <1250864238-4093-1-git-send-email-snitzer@redhat.com>
	<20090827131220.GN643@agk-dp.fab.redhat.com>
	<20090827141939.GB29894@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090827141939.GB29894@redhat.com> (Mike Snitzer's message of
	"Thu, 27 Aug 2009 10:19:39 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: martin.petersen@oracle.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Martin didn't expose such an interface because all existing code
Mike> (both DM and MD) does not require anything beyond a simple
Mike> assignment.  I worked with Martin to establish the
Mike> blk_queue_io_min() precisely because DM needed to avoid
Mike> duplicating the block layer's logic.  I think Martin stopped short
Mike> of adding a symmetric wrapper for setting io_opt because he felt
Mike> it was unnecessary.

Jens is a hardliner and refuses unused functions and wrappers in block.
Even when they are trivial/obvious/symmetric.

At the time I submitted the topology code there were no users of a
blk_limits_io_opt() call so I didn't wire it up.

If you need it now, then great.  Let's add it to be consistent.

-- 
Martin K. Petersen	Oracle Linux Engineering
