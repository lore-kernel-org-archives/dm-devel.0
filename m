From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] Add a set_era_counter config key to the
 dm-cache era policy shim
Date: Fri, 8 Nov 2013 11:38:46 +0000
Message-ID: <20131108113845.GA1894@debian>
References: <33A0129EBFD46748804DE81B354CA1B21C028E44@SACEXCMBX06-PRD.hq.netapp.com>
	<20131107155123.GA520@debian>
	<33A0129EBFD46748804DE81B354CA1B21C02AFF2@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C02AFF2@SACEXCMBX06-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Nov 07, 2013 at 09:24:44PM +0000, Mears, Morgan wrote:
> On Thurs, Nov 07, 2013 at 03:51PM +0000, Joe Thornber wrote:
> > On Wed, Nov 06, 2013 at 08:59:38PM +0000, Mears, Morgan wrote:
> > > Add the ability to set the era counter maintained by the dm-cache era
> > > policy shim to an arbitrary 32-bit value, to allow era rollback after
> > > the underlying device is restored from a snapshot.
> > 
> > I wonder if we should pass in the old value, and have the call fail if the old
> > value is incorrect.  This would allow applications to spot if they were
> > competing to set the era.  Some thing like:
> > 
> >      set_era_counter <old value>:<new value>
> 
> Yes, I like this.  My inclination is to make the <old value>: portion optional so that the counter value can be forced if desired (for example, to set it to a saved value during a create); objections?

In this case userspace should make a status request to get the current
era, then send the message in the <old value>:<new value> format.  If
it fails then clearly another process is interfering and you have big
issues.

> > In general alarm bells ring if you use one of smp_*() without the other.  See
> > linux/Documentation/memory-barriers.txt for lots of discussion.
> 
> Thanks Joe, will fix.

Already done in my cache-coherency-changes branch.  I've changed the
current_era counter to be an atomic64_t.

- Joe
