From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: [Multipath] Round-robin performance limit
Date: Tue, 03 May 2011 06:12:41 -0400
Message-ID: <1304417561.25728.16.camel@denise.theartistscloset.com>
References: <BANLkTikyCtPX8L=7h94hTm4TjOYDyb7nxQ@mail.gmail.com>
	<20110502072528.GW32595@reaktio.net>
	<BANLkTi=h0AwEy0S4Miv-SYTEu3jF0DXXJQ@mail.gmail.com>
	<1304375238.3134.23.camel@denise.theartistscloset.com>
	<20110503050406.GA11442@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110503050406.GA11442@us.ibm.com>
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
Cc: pmdaws@pacifera.com
List-Id: dm-devel.ids

On Mon, 2011-05-02 at 22:04 -0700, Malahal Naineni wrote:
> John A. Sullivan III [jsullivan@opensourcedevel.com] wrote:
> > I'm also very curious about your findings on rr_min_io.  I cannot find
> > my benchmarks but we tested various settings heavily.  I do not recall
> > if we saw more even scaling with 10 or 100.  I remember being surprised
> > that performance with it set to 1 was poor.  I would have thought that,
> > in a bonded environment, changing paths per iSCSI command would give
> > optimal performance.  Can anyone explain why it does not?
> 
> rr_min_io of 1 will give poor performance if your multipath kernel
> module doesn't support request based multipath. In those BIO based
> multipath, multipath receives 4KB requests. Such requests can't be
> coalesced if they are sent on different paths.
<snip>
Ah, that makes perfect sense and why 3 seems to be the magic number in
Linux (4000 / 1460 (or whatever IP payload is)).  Does that change with
Jumbo frames? In fact, how would that be optimized in Linux?

9KB seems to be a reasonable common jumbo frame value for various
vendors and that should contain two pages but, I would guess, Linux
can't utilize it as each block must be independently acknowledged. Is
that correct? Thus a frame size of a little over 4KB would be optimal
for Linux?

Would that mean that rr_min_io of 1 would become optimal? However, if
each block needs to be acknowledged before the next is sent, I would
think we are still latency bound, i.e., even if I can send four requests
down four separate paths, I cannot send the second until the first has
been acknowledged and since I can easily place four packets on the same
path within the latency period of four packets, multibus gives me
absolutely no performance advantage for a single iSCSI stream and only
proves useful as I start multiplexing multiple iSCSI streams.

Is that analysis correct? If so, what constitutes a separate iSCSI
stream? Are two separate file requests from the same file systems to the
same iSCSI device considered two iSCSI streams and thus can be
multiplexed and benefit from multipath or are they considered all part
of the same iSCSI stream? If they are considered one, do they become two
if they reside on different partitions and thus different file systems?
If not, then do we only see multibus performance gains between a single
file system host and a single iSCSI host when we use virtualization each
with their own iSCSI connection (as opposed to using iSCSI connections
in the underlying host and exposing them to the virtual machines as
local storage)?

I hope I'm not hijacking this thread and realize I've asked some
convoluted questions but optimizing multibus through bonded links for
single large hosts is still a bit of a mystery to me.  Thanks - John
