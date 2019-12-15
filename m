From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: dm-thin: Several Questions on dm-thin performance.
Date: Sun, 15 Dec 2019 21:44:49 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912152140020.11561@mx.ewheeler.net>
References: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
	<20191122185530.pcrgmb655dkdbdcq@reti>
	<629bd851-8d89-00bd-0fea-d140961e8752@arrikto.com>
	<alpine.LRH.2.11.1912130129120.11561@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1912130129120.11561@mx.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: thornber@redhat.com
Cc: JeffleXu <jefflexu@linux.alibaba.com>, dm-devel@redhat.com, Nikos Tsironis <ntsironis@arrikto.com>
List-Id: dm-devel.ids

On Fri, 13 Dec 2019, Eric Wheeler wrote:
> On Fri, 6 Dec 2019, Nikos Tsironis wrote:
> > On 11/22/19 8:55 PM, Joe Thornber wrote:
> > > On Fri, Nov 22, 2019 at 11:14:15AM +0800, JeffleXu wrote:
> > > 
> > > > The first question is what's the purpose of data cell? In thin_bio_map(),
> > > > normal bio will be packed as a virtual cell and data cell. I can
> > > > understand
> > > > that virtual cell is used to prevent discard bio and non-discard bio
> > > > targeting the same block from being processed at the same time. I find it
> > > > was added in commit     e8088073c9610af017fd47fddd104a2c3afb32e8 (dm thin:
> > > > fix race between simultaneous io and discards to same block), but I'm
> > > > still
> > > > confused about the use of data cell.
> > > 
> > > As you are aware there are two address spaces for the locks.  The 'virtual'
> > > one
> > > refers to cells in the logical address space of the thin devices, and the
> > > 'data' one
> > > refers to the underlying data device.  There are certain conditions where we
> > > unfortunately need to hold both of these (eg, to prevent a data block being
> > > reprovisioned
> > > before an io to it has completed).
> > > 
> > > > The second question is the impact of virtual cell and data cell on IO
> > > > performance. If $data_block_size is large for example 1G, in multithread
> > > > fio
> > > > test, most bio will be buffered in cell->bios list and then be processed
> > > > by
> > > > worker thread asynchronously, even when there's no discard bio. Thus the
> > > > original parallel IO is processed by worker thread serially now. As the
> > > > number of fio test threads increase, the single worker thread can easily
> > > > get
> > > > CPU 100%, and thus become the bottleneck of the performance since dm-thin
> > > > workqueue is ordered unbound.
> > > 
> > > Yep, this is a big issue.  Take a look at dm-bio-prison-v2.h, this is the
> > > new interface that we need to move dm-thin across to use (dm-cache already
> > > uses it).
> > > It allows concurrent holders of a cell (ie, read locks), so we'll be able to
> > > remap
> > > much more io without handing it off to a worker thread.  Once this is done I
> > > want
> > > to add an extra field to cells that will cache the mapping, this way if you
> > > acquire a
> > > cell that is already held then you can avoid the expensive btree lookup.
> > > Together
> > > these changes should make a huge difference to the performance.
> > > 
> > > If you've got some spare coding cycles I'd love some help with this ;)
> > > 
> > 
> > Hi Joe,
> > 
> > I would be interested in helping you with this task. I can't make any
> > promises, but I believe I could probably spare some time to work on it.
> 
> 
> Hi Nikos, it would be great if you are able help with the 
> dm-thin port to dm-bio-prison-v2.  I'm glad to see you are interested in 
> dm-thin performance too.
> 
> These are the commits that implemented dm-bio-prison-v2 in dm-cache back 
> in ~4.12, maybe it can give you a good start on what the conversion might 
> look like:
> 
> b29d4986d dm cache: significant rework to leverage dm-bio-prison-v2
> 
> Here's a related bugfix:
> 
> d1260e2a3 dm cache: fix race condition in the writeback mode overwrite_bio optimisation

Hi Joe,

I was looking through the dm-bio-prison-v2 commit for dm-cache (b29d4986d) 
and it is huge, ~5k lines.  Do you still have a git branch with these 
commits in smaller pieces (not squashed) so we can find the bits that 
might be informative for converting lv-thin to use dm-bio-prison-v2?

For example, I think that, at least, the policy changes and 
btracker code is dm-cache specific and just a distraction when trying to 
understand the dm-bio-prison-v2 conversion.

--
Eric Wheeler


> 
> 
> 
> --
> Eric Wheeler
> 
> 
> > 
> > Nikos
> > 
> > > - Joe
> > > 
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> > 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 
