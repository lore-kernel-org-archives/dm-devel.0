From: Joe Thornber <thornber@redhat.com>
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
Date: Tue, 1 Oct 2013 09:26:54 +0100
Message-ID: <20131001082654.GA10326@debian>
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com>
 <20130926034325.GO26872@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20130926034325.GO26872@dastard>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Dave Chinner <david@fromorbit.com>
Cc: devel@driverdev.osuosl.org, snitzer@redhat.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Akira Hayakawa <ruby.wktk@gmail.com>, dm-devel@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, dan.carpenter@oracle.com, ejt@redhat.com, cesarb@cesarb.net, m.chehab@samsung.com
List-Id: dm-devel.ids

On Thu, Sep 26, 2013 at 01:43:25PM +1000, Dave Chinner wrote:
> On Tue, Sep 24, 2013 at 09:20:50PM +0900, Akira Hayakawa wrote:
> > * Deferring ACK for barrier writes
> > Barrier flags such as REQ_FUA and REQ_FLUSH are handled lazily.
> > Immediately handling these bios badly slows down writeboost.
> > It surveils the bios with these flags and forcefully flushes them
> > at worst case within `barrier_deadline_ms` period.
> 
> That rings alarm bells.
> 
> If the filesystem is using REQ_FUA/REQ_FLUSH for ordering reasons,
> delaying them to allow other IOs to be submitted and dispatched may
> very well violate the IO ordering constraints the filesystem is
> trying to acheive.

If the fs is using REQ_FUA for ordering they need to wait for
completion of that bio before issuing any subsequent bio that needs to
be strictly ordered.  So I don't think there is any issue here.

> Alternatively, delaying them will stall the filesystem because it's
> waiting for said REQ_FUA IO to complete. For example, journal writes
> in XFS are extremely IO latency sensitive in workloads that have a
> signifincant number of ordering constraints (e.g. O_SYNC writes,
> fsync, etc) and delaying even one REQ_FUA/REQ_FLUSH can stall the
> filesystem for the majority of that barrier_deadline_ms.

Yes, this is a valid concern, but I assume Akira has benchmarked.
With dm-thin, I delay the REQ_FUA/REQ_FLUSH for a tiny amount, just to
see if there are any other FUA requests on my queue that can be
aggregated into a single flush.  I agree with you that the target
should never delay waiting for new io; that's asking for trouble.

- Joe
