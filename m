From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 5/9] rqdm core: simplify suspend code
Date: Wed, 28 Oct 2009 16:21:18 +0000
Message-ID: <20091028162118.GQ25303@agk-dp.fab.redhat.com>
References: <4AD7FC11.7030009@ct.jp.nec.com> <4AD7FE16.6050907@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AD7FE16.6050907@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 16, 2009 at 02:01:10PM +0900, Kiyoshi Ueda wrote:
> In case of suspend with "--nolockfs" but without "--noflush",
> the semantics for bio-based dm has been changed in 2.6.30 as below:
>   before 2.6.30:   I/Os submitted before the suspend invocation
>                    are flushed
>   2.6.30 or later: I/Os submitted even before the suspend invocation
>                    may not be flushed
>   (*) We had no idea whether the semantics change hurt someone.
>       (For details, see http://marc.info/?t=123994433400003&r=1&w=2)
>       But it seems no hurt since there is no complaint against 2.6.30
>       or later.

See my new reply on that thread.
 
> Since the semantics of request-based dm committed in 2.6.31-rc1
> is still old one, change it to new one by this patch.

Do you agree that after applying this patch series here, we could
reinstate 'suspend with flush' by flushing before entering the guts of
the suspend code (i.e. sending a flush to the dm device, which would be
implemented using the barrier) and then suspending (--noflush)?

Alasdair
