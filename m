From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 2/8] dm thin: set flag when
 over the metadata low watermark threshold
Date: Fri, 21 Feb 2014 09:05:15 -0500
Message-ID: <20140221140515.GB4578@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-3-git-send-email-snitzer@redhat.com>
	<20140221135652.GA13298@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140221135652.GA13298@debian>
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

On Fri, Feb 21 2014 at  8:56am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> NACK

You can NACK all you want.  Old code doesn't work.  New code does.

> On Thu, Feb 20, 2014 at 09:55:59PM -0500, Mike Snitzer wrote:
> > The threshold boundary code in persistent-data/dm-space-map-metadata.c
> > was too racey and resulted in a flood of warnings and events.
> 
> This code never runs concurrently, so I don't see how it can be racey.
> Scanning the code it seems to work as advertised; it is an edge
> triggered threshold, activating every time the free space crosses the
> threshold from high to low.
> 
> - You haven't explained what your changes within
>   dm-space-map-metadata.c do.  Is the threshold no longer edge
>   triggered?

It is identical to data device's low water mark.

> - With your changes, how is the threshold reset?  For instance:
> 
>   i) we cross the lwm and issue an event
> 
>   ii) the admin deletes a ton of old snapshots to free up some
>       metadata space, taking us well above the lwm.
> 
>   iii) 3 months later we cross the lwm again.  Will the admin be notified?

It resets the same as the data low water mark, see change in
pool_resume.  So any limitation with this approach applies to data low
water mark too.

> I suspect the real issue is when the free space is near the threshold
> it 'bobbles', crossing back and forth and triggering often (not a
> race).  I suggest the correct way to fix this is to change the
> threshold code to introduce some hysteresis.  For example by saying it
> can't trigger unless free space has crossed another higher threshold
> first (lwm + FUDGE_FACTOR).  Fixes for this should remain within
> dm-space-map-metadata.c.

Yeah, I added tracing and a FUDGE_FACTOR could help.  But in the end I
saw no benefit to having 2 different mechanisms for low water mark.  I
went with the approach that has been proven with data's low water mark.
