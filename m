From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: factor out bio_check_eod()
Date: Wed, 18 Jul 2007 20:18:24 +0900
Message-ID: <469DF700.4030806@gmail.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070530093503.GA15559@kernel.dk>
	<20070718105655.GB22374@htj.dyndns.org>
	<20070718105946.GC22374@htj.dyndns.org>
	<20070718110619.GM11657@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070718110619.GM11657@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Phillip Susi <psusi@cfl.rr.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Jens Axboe wrote:
> On Wed, Jul 18 2007, Tejun Heo wrote:
>> End of device check is done twice in __generic_make_request() and it's
>> fully inlined each time.  Factor out bio_check_eod().
> 
> Tejun, yeah I should seperate the cleanups and put them in the upstream
> branch. Will do so and add your signed-off to both of them.
> 

Would they be different from the one I just posted?  No big deal either
way.  I'm just basing the zero-length barrier on top of these patches.
Oh well, the changes are trivial anyway.

-- 
tejun
