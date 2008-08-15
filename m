From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Fri, 15 Aug 2008 18:25:34 +0900
Message-ID: <20080815182608B.fujita.tomonori@lab.ntt.co.jp>
References: <200808131714.09311.phillips@phunq.net>
	<20080815171801N.fujita.tomonori@lab.ntt.co.jp>
	<200808150143.55776.phillips@phunq.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200808150143.55776.phillips@phunq.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: zumastor@googlegroups.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, 15 Aug 2008 01:43:55 -0700
Daniel Phillips <phillips@phunq.net> wrote:

> > A daemon program requests delta from the 
> > kernel, and sends it to another daemon program on the remote
> > server. The daemon on the remote server asks the kernel to apply
> > delta.
> 
> The downstream server just writes the delta to the origin, there is no
> need to ask the kernel to do this.
> 
> > The advantage of this approach, the above replication program can work
> > with any snapshot implementation, which could live in dm or file
> > systems like btrfs. File systems could implement the snapshot features
> > more efficiently than dm.
> 
> When you replicate a volume you can just send a list of changed blocks
> as ddsnap does.  This is not the case with a filesystem delta, which
> has to send the changed blocks of each filesystem object logically,
> along with relevant metadata such as changed permissions, ownership,
> file sizes etc.

What I think about is...

User-space replication programs don't know anything about delta. Delta
might be a list of changed blocks, or something more complicated. So
the downstream server can't simply write the delta to the origin. It
always asks the kernel.

User-space replication programs don't care about the format of
delta. A file system can give user-space programs whatever as
delta. All a file system needs to do is applying the delta that it
gave to user space.
