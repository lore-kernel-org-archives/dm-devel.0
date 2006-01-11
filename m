From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Re: Was: [patch 1/1] md/dm: Reduce stack usage with
	stacked block devices
Date: Wed, 11 Jan 2006 15:41:11 -0500
Message-ID: <1137012072.10270.113.camel@localhost.localdomain>
References: <62b0912f0601110445w34d480c4n56d8f02056baef26@mail.gmail.com>
	<20060111135301.GY4346@agk.surrey.redhat.com>
	<62b0912f0601111226q4732fc23qee79b7a2fc215fe9@mail.gmail.com>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f0601111226q4732fc23qee79b7a2fc215fe9@mail.gmail.com>
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
Cc: akpm@osdl.org, agk@redhat.com
List-Id: dm-devel.ids

On Wed, 2006-01-11 at 21:26 +0100, Molle Bestefich wrote:
> Alasdair G Kergon wrote:
> > There are several races.  The code makes some ordering assumptions
> > about the I/O but does nothing to enforce those assumptions.
> > So if you're unlucky and I/O happens to complete in the wrong order
> > or too soon you can see transient corruption in the snapshot or
> > reference memory that has been freed and perhaps reallocated to
> > something else.
> 
> Thanks a lot for the status report.
> 
> > Some references:
> [snip]
> 
> Thanks.  I opened a bug report myself at one point:
> https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=120937
> 
> > Not actively developed, no.  Long-term we want to replace it with
> > something better.

does this mean/confirm linux 2.6.x will not have a stable snapshot
support any time soon?

i believe tons of people want linux has a stable snapshot support.

> 
> That's really too bad :-(.
> There's a lot of people over in the Xen community that could *really*
> use something like dm-snapshot if it was stable and production mature.
> 
> > But at the moment I'm reviewing the existing code
> > and fixing as many problems as I can find.
> 
> Sounds great.  Shout out if you need help :-).
> (With testing or other monkey work, not C coding.  I'm not a good C coder.)
> 
> Thanks!
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
