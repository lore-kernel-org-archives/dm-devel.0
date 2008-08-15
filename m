From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Fri, 15 Aug 2008 01:43:55 -0700
Message-ID: <200808150143.55776.phillips@phunq.net>
References: <Pine.LNX.4.64.0808111740520.14722@hs20-bc2-1.build.redhat.com>
	<200808131714.09311.phillips@phunq.net>
	<20080815171801N.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080815171801N.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: zumastor@googlegroups.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Friday 15 August 2008 01:17, FUJITA Tomonori wrote:
> On Wed, 13 Aug 2008 17:14:08 -0700
> Daniel Phillips <phillips@phunq.net> wrote:
> 
> > requests.  I could take care of designing and implementing a kernel
> > interface between your port and the rest of ddsnapd that does such
> > things as respond to control messages and generate block delta
> > lists.
> 
> As I said at the first submission, I plan to add such features to the
> new dm-snapshot code. Then we can have simple user-space code that
> focus on the replication.

Well, I suppose when you get it working we can always port it back to
ddsnap :-)

Ddsnap already has quite simple userspace code to do the replication,
or it would be simple if it were cleaned up a little.  There is
nothing complex about this.  But the kernel will have to generate the
block difference list because it needs access to the snapshot store
btree to do this.

> A daemon program requests delta from the 
> kernel, and sends it to another daemon program on the remote
> server. The daemon on the remote server asks the kernel to apply
> delta.

The downstream server just writes the delta to the origin, there is no
need to ask the kernel to do this.

> The advantage of this approach, the above replication program can work
> with any snapshot implementation, which could live in dm or file
> systems like btrfs. File systems could implement the snapshot features
> more efficiently than dm.

When you replicate a volume you can just send a list of changed blocks
as ddsnap does.  This is not the case with a filesystem delta, which
has to send the changed blocks of each filesystem object logically,
along with relevant metadata such as changed permissions, ownership,
file sizes etc.

> My question related with this issue is, any chance to modify
> Zumastor's ddsnapd in a such way. Well, I guess, it would be better to
> ask on Zumastor mailing list.

CC added.  Yes, it is planned to modify ddsnap to implement a redirect
on write strategy where you essentially use a snapshot as the origin.
This will be a lot more practical after we have snapshots of snapshots
using the versioned pointer code.  Versioned pointers by itself will
take a few months to go in and be stable.  Things do not move awfully
fast with this storage work, I think that is some kind of tradition.

There is a lot that can still be done to improve efficiency even before
going to redirect on write.  Probably another doubling of throughput is
possible by straightforward techniques such as batching up transfers
better and more improvements to the journalling code, or replacement
of the journal by a logging technique.

Regards,

Daniel
