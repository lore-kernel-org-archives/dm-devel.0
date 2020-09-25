From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Fri, 25 Sep 2020 16:15:12 -0400
Message-ID: <20200925201512.GA6025@redhat.com>
References: <20200924012732.GA10766@redhat.com>
	<20200924051419.GA16103@sol.localdomain>
	<252587bb-c0b7-47c9-a97b-91422f8f9c47@default>
	<alpine.LRH.2.02.2009241314280.28814@file01.intranet.prod.int.rdu2.redhat.com>
	<7b6fdfd5-0160-4bcf-b7ed-d0e51553c678@default>
	<alpine.LRH.2.02.2009241345370.4229@file01.intranet.prod.int.rdu2.redhat.com>
	<fd512a7d-c064-4812-a794-5274c10687db@default>
	<alpine.LRH.2.02.2009241421170.8544@file01.intranet.prod.int.rdu2.redhat.com>
	<eb43742e-bdfe-4567-8240-1d8e083d76a2@default>
	<MWHPR04MB37588DF8C3FFF4BD0C3CD543E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <MWHPR04MB37588DF8C3FFF4BD0C3CD543E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
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
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc: linux-block@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>, "ssudhakarp@gmail.com" <ssudhakarp@gmail.com>, Martin Petersen <martin.petersen@oracle.com>, mst@redhat.com, "dm-crypt@saout.de" <dm-crypt@saout.de>, Eric Biggers <ebiggers@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "agk@redhat.com" <agk@redhat.com>, linux-scsi@vger.kernel.org, Shirley Ma <shirley.ma@oracle.com>, Milan Broz <gmazyland@gmail.com>, Mike Christie <michael.christie@oracle.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2020 at  9:09pm -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2020/09/25 4:14, Sudhakar Panneerselvam wrote:
> >>
> >> On Thu, 24 Sep 2020, Sudhakar Panneerselvam wrote:
> >>
> >>>> By copying it to a temporary aligned buffer and issuing I/O on this
> >>>> buffer.
> >>>
> >>> I don't like this idea. Because, you need to allocate additional pages
> >>> for the entire I/O size(for the misaligned case, if you think through
> >>
> >> You can break the I/O to smaller pieces. You can use mempool for
> >> pre-allocation of the pages.
> > 
> > Assuming we do this, how is this code simpler(based on your
> > comment below) than the fix in dm-crypt? In fact, this approach 
> > would make the code change look bad in vhost, at the same time
> > having performance penalty. By doing this, we are just moving the 
> > responsibility to other unrelated component.
> 
> Because vhost is at the top of the block-io food chain. Fixing the unaligned
> segments there will ensure that it does not matter what device is under it. It
> will work.

Right, I agree. This should be addressed in vhost-scsi.  And vhost-scsi
probably needs to be interfacing through block core to submit IO that
respects the limits of its underlying block device.

So please lift your proposed dm-crypt changes to vhost-scsi:
https://patchwork.kernel.org/patch/11781207/
https://patchwork.kernel.org/patch/11781053/

Maybe work with vhost-scsi maintainers to see about making the code
reusable in block core; so that any future unaligned application IO is
dealt in other drivers using the same common code.

But I'm not interested in taking these changes into dm-crypt:

NAK

> I am still baffled that the unaligned segments go through in the first place...
> Do we have something missing in the BIO code ?

Cc'ing linux-block, could be.

Thanks,
Mike
