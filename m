From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 7/7] dm: optimize clone_rq() when
 track_peak_rq_based_ios is disabled
Date: Thu, 12 Sep 2013 19:53:46 -0400
Message-ID: <20130912235346.GF31577@redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-8-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1309121857440.31794@file01.intranet.prod.int.rdu2.redhat.com>
	<20130912230646.GA31577@redhat.com>
	<alpine.LRH.2.02.1309121928140.3245@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1309121928140.3245@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

On Thu, Sep 12 2013 at  7:30pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Thu, 12 Sep 2013, Mike Snitzer wrote:
> 
> > On Thu, Sep 12 2013 at  7:00pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > 
> > > 
> > > On Thu, 12 Sep 2013, Mike Snitzer wrote:
> > > 
> > > > Make use of static keys to eliminate the relevant branch in clone_rq()
> > > > when dm_mod's 'track_peak_rq_based_ios' paramter is set to 0 (disabled).
> > > > 
> > > > Even if 'track_peak_rq_based_ios' is set to 0 it will not take effect
> > > > until the next request-based table reload.  Once it is disabled the
> > > > 'peak_rq_based_ios' parameter will be reset to 0.
> > > 
> > > This patch changes it so that the value track_peak_rq_based_ios is sampled 
> > > only when reloading a table. I think it will be confusing to the user if 
> > > he changes the value, but the change doesn't take effect until something 
> > > reloads some table.
> > 
> > Well we need to be able to notice the change but I do not wish to do so
> > in a performance critical path (which clone_rq is).
> 
> I think one condition isn't that bad so there is no need to use static 
> keys.

Considering we're talking about the IO path I'd rather avoid it given
'track_peak_rq_based_ios' will almost always be disabled.

> If you want to use static keys, you need to refresh them in some place 
> that it called regularly.

No you don't.  I'm assuming if someone enables 'track_peak_rq_based_ios'
they know what they are doing.

But I'm open to suggestions on a more appropriate hook to be catching
the update to track_peak_rq_based_ios.
