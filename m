From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snapshot for system updates in Android
Date: Fri, 8 Nov 2019 07:31:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1911080723130.3392@file01.intranet.prod.int.rdu2.redhat.com>
References: <20191025101624.GA61225@google.com>
	<alpine.LRH.2.02.1910290957220.25731@file01.intranet.prod.int.rdu2.redhat.com>
	<20191104164900.GA10934@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191104164900.GA10934@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alessio Balsini <balsini@android.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, elsk@google.com, dm-devel@redhat.com, dvander@google.com, kernel-team@android.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 4 Nov 2019, Alessio Balsini wrote:

> > > -- Alignment
> > >=20
> > > Our approach follows the solution proposed by Mikulas [1].
> > > Being the block alignment of file extents automatically managed by th=
e
> > > filesystem, using FIEMAP should have no alignment-related performance=
 issue.
> > > But in our implementation we hit a misalignment [2] branch which lead=
s to
> > > dmwarning messages [3, 4].
> > >=20
> > > I have a limited experience with the block layer and dm, so I'm still
> > > struggling in finding the root cause for this, either in user space o=
r kernel
> > > space.
> >=20
> > I don't know. What is the block size of the filesystem? Are all mapping=
s=20
> > aligned to this block size?
>=20
> Here follows a just generated warning coming from a Pixel 4 kernel (4.14)=
:
>=20
> [ 3093.443808] device-mapper: table: 253:16: adding target device dm-15
> caused an alignment inconsistency: physical_block_size=3D4096,
> logical_block_size=3D4096, alignment_offset=3D61440, start=3D0
>=20
> Does this contain all the info you asked for?

Look at the function blk_stack_limits - it has various checks that make it=
=20
return -1. Insert some debugging printk's there and find out which check=20
made the function return -1.

Based on this, we can find out which of the limits triggered the error=20
message.

> I started investigating this issue, but since we didn't notice any
> performance degradation, I prioritized other things. I'll be hopefully
> able to get back to this warning in the next months.
> Please let me know if I can help you with that or if you need additional
> information.

Mikulas
