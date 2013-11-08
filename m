From: "Mears, Morgan" <Morgan.Mears@netapp.com>
Subject: Re: [PATCH] Add a set_era_counter config key to the
 dm-cache era policy shim
Date: Fri, 8 Nov 2013 15:00:23 +0000
Message-ID: <33A0129EBFD46748804DE81B354CA1B21C02BD8A@SACEXCMBX06-PRD.hq.netapp.com>
References: <33A0129EBFD46748804DE81B354CA1B21C028E44@SACEXCMBX06-PRD.hq.netapp.com>
	<20131107155123.GA520@debian>
	<33A0129EBFD46748804DE81B354CA1B21C02AFF2@SACEXCMBX06-PRD.hq.netapp.com>
	<20131108113845.GA1894@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131108113845.GA1894@debian>
Content-Language: en-US
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

On Fri, Nov 08, 2013 at 06:39:22AM -0500, Joe Thornber wrote:
> On Thu, Nov 07, 2013 at 09:24:44PM +0000, Mears, Morgan wrote:
> > On Thurs, Nov 07, 2013 at 03:51PM +0000, Joe Thornber wrote:
> > > On Wed, Nov 06, 2013 at 08:59:38PM +0000, Mears, Morgan wrote:
> > > > Add the ability to set the era counter maintained by the dm-cache
> > > > era policy shim to an arbitrary 32-bit value, to allow era
> > > > rollback after the underlying device is restored from a snapshot.
> > >
> > > I wonder if we should pass in the old value, and have the call fail
> > > if the old value is incorrect.  This would allow applications to
> > > spot if they were competing to set the era.  Some thing like:
> > >
> > >      set_era_counter <old value>:<new value>
> >
> > Yes, I like this.  My inclination is to make the <old value>: portion optional
> so that the counter value can be forced if desired (for example, to set it to a
> saved value during a create); objections?
> 
> In this case userspace should make a status request to get the current era,
> then send the message in the <old value>:<new value> format.  If it fails then
> clearly another process is interfering and you have big issues.

The use case I was concerned about is setting the initial era counter value
during cache creation.  In this case no status request is possible.   However
after more thought, this is not an issue (since the set_era_counter is
processed before the era counter value is recovered from the metadata), so
agreed, the old value should be required.
