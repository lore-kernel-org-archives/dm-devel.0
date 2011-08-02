From: Joe Thornber <thornber@redhat.com>
Subject: Re: Review of dm-block-manager.c
Date: Tue, 2 Aug 2011 14:29:00 +0100
Message-ID: <20110802132859.GA28866@ubuntu>
References: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
	<20110802130755.GA26994@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110802130755.GA26994@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Aug 02, 2011 at 02:07:55PM +0100, Joe Thornber wrote:
> There isn't that degree of parallelism.  We can't have multiple
> threads pulling the cache in different directions for performance
> reasons.  So we have multiple threads that use this in a non-blocking
> mode.  ie. they use the try_lock variants, and only get the data if
> it's already available in the cache.  If the non-blocking requests
> failed then it gets passed across for a worker thread to deal with.
> This is the only thread that updates the cache.  There is no issue
> here.

In fact because we have only a single mutator the block recycling
concerns are not an issue for thinp, though they should still be
fixed.

- Joe
