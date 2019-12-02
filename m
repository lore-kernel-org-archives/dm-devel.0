From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: dm-thin: Several Questions on dm-thin performance.
Date: Mon, 2 Dec 2019 22:26:00 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1912022002210.11561@mx.ewheeler.net>
References: <35cf1ecf-5cd8-604b-ec4e-18c9fd4a4195@linux.alibaba.com>
	<20191122185530.pcrgmb655dkdbdcq@reti>
	<6b12137e-411e-0368-518e-41ae54e138e0@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-844282404-1390322935-1575316954=:11561"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6b12137e-411e-0368-518e-41ae54e138e0@linux.alibaba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>, JeffleXu <jefflexu@linux.alibaba.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---844282404-1390322935-1575316954=:11561
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Dec 2019, JeffleXu wrote:
> =E5=9C=A8 2019/11/23 =E4=B8=8A=E5=8D=882:55, Joe Thornber =E5=86=99=E9=81=
=93:
>=20
> > On Fri, Nov 22, 2019 at 11:14:15AM +0800, JeffleXu wrote:
> >
> > > The first question is what's the purpose of data cell? In thin_bio_ma=
p(),
> > > normal bio will be packed as a virtual cell and data cell. I can
> > > understand
> > > that virtual cell is used to prevent discard bio and non-discard bio
> > > targeting the same block from being processed at the same time. I fin=
d it
> > > was added in commit =C2=A0=C2=A0=C2=A0 e8088073c9610af017fd47fddd104a=
2c3afb32e8 (dm thin:
> > > fix race between simultaneous io and discards to same block), but I'm
> > > still
> > > confused about the use of data cell.
> > As you are aware there are two address spaces for the locks.  The 'virt=
ual'
> > one
> > refers to cells in the logical address space of the thin devices, and t=
he
> > 'data' one
> > refers to the underlying data device.  There are certain conditions whe=
re we
> > unfortunately need to hold both of these (eg, to prevent a data block b=
eing
> > reprovisioned
> > before an io to it has completed).
> >
> > > The second question is the impact of virtual cell and data cell on IO
> > > performance. If $data_block_size is large for example 1G, in multithr=
ead
> > > fio
> > > test, most bio will be buffered in cell->bios list and then be proces=
sed
> > > by
> > > worker thread asynchronously, even when there's no discard bio. Thus =
the
> > > original parallel IO is processed by worker thread serially now. As t=
he
> > > number of fio test threads increase, the single worker thread can eas=
ily
> > > get
> > > CPU 100%, and thus become the bottleneck of the performance since dm-=
thin
> > > workqueue is ordered unbound.
> > Yep, this is a big issue.  Take a look at dm-bio-prison-v2.h, this is t=
he
> > new interface that we need to move dm-thin across to use (dm-cache alre=
ady
> > uses it).
> > It allows concurrent holders of a cell (ie, read locks), so we'll be ab=
le to
> > remap
> > much more io without handing it off to a worker thread.  Once this is d=
one I
> > want
> > to add an extra field to cells that will cache the mapping, this way if=
 you
> > acquire a
> > cell that is already held then you can avoid the expensive btree lookup=
.
> > Together
> > these changes should make a huge difference to the performance.
> >
> > If you've got some spare coding cycles I'd love some help with this ;)

Hi Joe,

I'm not sure if I will have the time but thought I would start the=20
research and ask a few questions. I looked at the v1/v2 .h files and some=
=20
of the functions just change suffix to _v2 and maybe calling=20
convention/structure field changes.

However, there appear to be some design changes, too:

* dm_deferred_set - These appear to be used a bit in dm-thin.c. =20
The dm_deferred_set calls don't seem to reference anything prison-related,=
=20
but they are defined in dm-bio-prison-v1.h.  Can you provide direction on=
=20
how these would be refactored, or if they can just remain as-is?
  Call counts in dm-thin.c:
      2 dm_deferred_entry_dec
      2 dm_deferred_set_create
      3 dm_deferred_entry_inc
      3 dm_deferred_set_add_work
      4 dm_deferred_set_destroy

* dm_bio_detain - is this replaced by dm_cell_get_v2?
=09- It looks like dm_bio_detain() returns 1 if already held, but=20
=09  dm_cell_get_v2() returns true if the lock is granted.  How might=20
=09  this be handled?
=09- What are the lock_levels?
=09- What in dm-thin.c would then call dm_cell_put_v2?

* dm_cell_release(_no_holder) - is this replaced by dm_cell_unlock_v2?
=09- How would the _no_holder version be refactored?

* dm_cell_visit_release - This function uses a callback, but none of the=20
v2 functions have such a callback.  Do we need to write a helper function=
=20
with get/unlock(?) around the cell?


* dm_cell_error - no equivalent v2 implementation.  Suggestions?


What other considerations might there be in the v2 port?

Thanks!

--
Eric Wheeler


> >
> > - Joe
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
---844282404-1390322935-1575316954=:11561
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---844282404-1390322935-1575316954=:11561--
