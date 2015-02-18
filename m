From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mirror: do not degrade the mirror on discard error
Date: Wed, 18 Feb 2015 13:21:19 -0500
Message-ID: <20150218182119.GA3029@redhat.com>
References: <alpine.LRH.2.02.1502121007010.24282@file01.intranet.prod.int.rdu2.redhat.com>
	<1423967994.19864.9.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502160742030.14038@file01.intranet.prod.int.rdu2.redhat.com>
	<1424096844.2089.2.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502171455140.13128@file01.intranet.prod.int.rdu2.redhat.com>
	<1424272616.2122.12.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1502181109020.32036@file01.intranet.prod.int.rdu2.redhat.com>
	<20150218171016.GA2032@redhat.com>
	<1424282047.2122.54.camel@HansenPartnership.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1424282047.2122.54.camel@HansenPartnership.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 18 2015 at 12:54pm -0500,
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2015-02-18 at 12:10 -0500, Mike Snitzer wrote:
> > 
> > Let's please set this thread to one side.  I already offered my thoughts
> > in this thread, see: 
> > https://www.redhat.com/archives/dm-devel/2015-February/msg00076.html
> > 
> > I'm not interested in wiring up the actual error return for dm-mirror's
> > benefit.  If/when other dm-io consumers have a need to differentiate
> > between error codes we'll fix dm-io as needed.
> 
> Yep, concur ... the point I've been obviously failing to make is that
> all the world is not an SSD.

I agree, and am aware.  The layers that have needed to worry about
properly differentiating between these higher level returns from SCSI do
(e.g. dm-mpath).  But it is pretty rare for bio-based DM targets to
differentiate between error codes.  Not saying that is right, just that
is how things stand.  Could be there is room for improvement in places.
