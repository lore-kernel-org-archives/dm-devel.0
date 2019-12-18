From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: dm-thin: Several Questions on dm-thin performance.
Date: Wed, 18 Dec 2019 20:27:26 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912182024550.26683@mx.ewheeler.net>
References: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
	<20191122185530.pcrgmb655dkdbdcq@reti>
	<629bd851-8d89-00bd-0fea-d140961e8752@arrikto.com>
	<alpine.LRH.2.11.1912130129120.11561@mx.ewheeler.net>
	<alpine.LRH.2.11.1912152140020.11561@mx.ewheeler.net>
	<20191218131334.pngvyqoebsdmicun@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191218131334.pngvyqoebsdmicun@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: JeffleXu <jefflexu@linux.alibaba.com>, dm-devel@redhat.com, Nikos Tsironis <ntsironis@arrikto.com>
List-Id: dm-devel.ids

On Wed, 18 Dec 2019, Joe Thornber wrote:

> On Sun, Dec 15, 2019 at 09:44:49PM +0000, Eric Wheeler wrote:
> > I was looking through the dm-bio-prison-v2 commit for dm-cache (b29d4986d) 
> > and it is huge, ~5k lines.  Do you still have a git branch with these 
> > commits in smaller pieces (not squashed) so we can find the bits that 
> > might be informative for converting lv-thin to use dm-bio-prison-v2?
> > 
> > For example, I think that, at least, the policy changes and 
> > btracker code is dm-cache specific and just a distraction when trying to 
> > understand the dm-bio-prison-v2 conversion.
> 
> To be honest I would hold off for a couple of months.  I've been working
> on the design for thinp 2 and have got to the point where I need to write
> a userland proof of concept implementation.  In particular I've focussed on
> packing more into btree nodes, and separating transactions so IO to different
> thins has no locking contention.  The proof of concept will tell me just how
> small I can get the metadata.  If the level of metadata compression is ~1/10th
> we'll plug the new btrees into the existing design and switch to bio prison v2.
> If it's greater, say 1/50th, then I'll rewrite the whole target to
> use write-ahead logging for transactionality and ditch all metadata sharing altogether.
> When the metadata is that small we can copy entire btrees to implement snapshots.


Sounds great, looking forward to it.  The thinp target has worked great 
for us over the years.  Packing metadata and reducing lock contention will 
make it even better.

--
Eric Wheeler



> 
> - Joe
> 
> 
