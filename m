From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: Multipath on STK OPENStorage D240
Date: Thu, 4 May 2006 18:13:44 +0200
Message-ID: <20060504161344.GA23550@bogon.ms20.nix>
References: <20060504074119.GB17730@bogon.ms20.nix>
	<20060504123523.GA9269@vienna.egenera.com>
	<20060504133753.GA22657@bogon.ms20.nix>
	<20060504145544.GA23460@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060504145544.GA23460@bogon.ms20.nix>
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
List-Id: dm-devel.ids

On Thu, May 04, 2006 at 04:55:44PM +0200, Guido Guenther wrote:
> On Thu, May 04, 2006 at 03:37:53PM +0200, Guido Guenther wrote:
> > On Thu, May 04, 2006 at 08:35:23AM -0400, Philip R. Auld wrote:
> > > Hi,
> > > 
> > > Rumor has it that on Thu, May 04, 2006 at 09:41:20AM +0200 Guido Guenther said:
> > > > Hi,
> > > > when using path_checker readsector0 on the above machine the box stalls
> > > > every 5 seconds when checking the currently nonactive path. Same for
> > > > path_checker tur. Is there a way to avoid this? I'd consider writing a
> > > > specific checker but am lacking any documentation.
> > > 
> > > This thing is a preferred path array. I can see how readsector0
> > > is probably the wrong choice of checker. I imagine it causes 
> > > a cache flush from the preferred controller. Odd that the tur
> > > checker has the same behavior. If you want to code something 
> > Well, can I check which check is really being used, if not I'll hack
> > that into the daemon next week? I noticed that typos in multipath.conf
> > are being silently ignored. 
> ...replying to myself: using "path_checker tur" in the defaults section
> of multipath.conf indeed _does_ seem to work. I've put it to the
> individual paths before (as shown in several example configs) but this
> seems to be silently ignored. I'll try to find some time to dig into
> this next week.
...monologue mode off: it should have been in the device section from
the very beginning, not in the multipath section. Silly me - works fine
now. Simple user error.
Cheers and sorry for the noise,
 -- Guido
