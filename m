From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: factor out bio_check_eod()
Date: Wed, 18 Jul 2007 13:06:19 +0200
Message-ID: <20070718110619.GM11657@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk> <20070718105655.GB22374@htj.dyndns.org> <20070718105946.GC22374@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070718105946.GC22374@htj.dyndns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Wed, Jul 18 2007, Tejun Heo wrote:
> End of device check is done twice in __generic_make_request() and it's
> fully inlined each time.  Factor out bio_check_eod().

Tejun, yeah I should seperate the cleanups and put them in the upstream
branch. Will do so and add your signed-off to both of them.

-- 
Jens Axboe

