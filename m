From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 2/8] dm thin: set flag when
 over the metadata low watermark threshold
Date: Fri, 21 Feb 2014 09:10:41 -0500
Message-ID: <20140221141041.GC4578@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-3-git-send-email-snitzer@redhat.com>
	<20140221135652.GA13298@debian> <20140221140515.GB4578@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140221140515.GB4578@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Feb 21 2014 at  9:05am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Feb 21 2014 at  8:56am -0500,
> Joe Thornber <thornber@redhat.com> wrote:
> 
> > NACK
> 
> You can NACK all you want.  Old code doesn't work.  New code does.
> 
> > On Thu, Feb 20, 2014 at 09:55:59PM -0500, Mike Snitzer wrote:
> > > The threshold boundary code in persistent-data/dm-space-map-metadata.c
> > > was too racey and resulted in a flood of warnings and events.
> > 
> > This code never runs concurrently, so I don't see how it can be racey.
> > Scanning the code it seems to work as advertised; it is an edge
> > triggered threshold, activating every time the free space crosses the
> > threshold from high to low.
> > 
> > - You haven't explained what your changes within
> >   dm-space-map-metadata.c do.  Is the threshold no longer edge
> >   triggered?
> 
> It is identical to data device's low water mark.

To be clear, it is still edge triggered from the metadata sm -- it makes
the same upcall to t->fn(t->context).

Only difference dm-thin.c:metadata_low_callback controls the throttle on
the event and warning.
