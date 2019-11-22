From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin: Several Questions on dm-thin performance.
Date: Fri, 22 Nov 2019 18:55:30 +0000
Message-ID: <20191122185530.pcrgmb655dkdbdcq@reti>
References: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: JeffleXu <jefflexu@linux.alibaba.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 22, 2019 at 11:14:15AM +0800, JeffleXu wrote:

> The first question is what's the purpose of data cell? In thin_bio_map(),
> normal bio will be packed as a virtual cell and data cell. I can understa=
nd
> that virtual cell is used to prevent discard bio and non-discard bio
> targeting the same block from being processed at the same time. I find it
> was added in commit =A0=A0=A0 e8088073c9610af017fd47fddd104a2c3afb32e8 (d=
m thin:
> fix race between simultaneous io and discards to same block), but I'm sti=
ll
> confused about the use of data cell.

As you are aware there are two address spaces for the locks.  The 'virtual'=
 one
refers to cells in the logical address space of the thin devices, and the '=
data' one
refers to the underlying data device.  There are certain conditions where w=
e=20
unfortunately need to hold both of these (eg, to prevent a data block being=
 reprovisioned
before an io to it has completed).

> The second question is the impact of virtual cell and data cell on IO
> performance. If $data_block_size is large for example 1G, in multithread =
fio
> test, most bio will be buffered in cell->bios list and then be processed =
by
> worker thread asynchronously, even when there's no discard bio. Thus the
> original parallel IO is processed by worker thread serially now. As the
> number of fio test threads increase, the single worker thread can easily =
get
> CPU 100%, and thus become the bottleneck of the performance since dm-thin
> workqueue is ordered unbound.

Yep, this is a big issue.  Take a look at dm-bio-prison-v2.h, this is the
new interface that we need to move dm-thin across to use (dm-cache already =
uses it).
It allows concurrent holders of a cell (ie, read locks), so we'll be able t=
o remap
much more io without handing it off to a worker thread.  Once this is done =
I want
to add an extra field to cells that will cache the mapping, this way if you=
 acquire a
cell that is already held then you can avoid the expensive btree lookup.  T=
ogether=20
these changes should make a huge difference to the performance.

If you've got some spare coding cycles I'd love some help with this ;)

- Joe
