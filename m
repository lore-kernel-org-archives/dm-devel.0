From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] [device-mapper] Document the fact
	that	iterate_device method shouldn't block.
Date: Fri, 21 Oct 2011 18:28:52 +0100
Message-ID: <20111021172852.GA23945@agk-dp.fab.redhat.com>
References: <20111021092800.GB4393@ubuntu>
	<1319192375-5048-1-git-send-email-ejt@redhat.com>
	<Pine.LNX.4.64.1110211306560.5163@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110211306560.5163@hs20-bc2-1.build.redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 21, 2011 at 01:07:22PM -0400, Mikulas Patocka wrote:
> Ack.
 
> On Fri, 21 Oct 2011, Joe Thornber wrote:
> > +	/*
> > +	 * iterate_devices must not block.
> > +	 */
> >  	dm_iterate_devices_fn iterate_devices;

I'm leaving that one for now as I think singling out one function as
'must not block' may mislead people into thinking the other adjacent
ones there are allowed to block.

Alasdair
