From: "David Guyon Martin" <david.guyonmartin@gmail.com>
Subject: Re: device mapper integrated loops - and one more year !
Date: Tue, 10 Oct 2006 22:11:27 +0200
Message-ID: <2c53b31c0610101311x6bd97cd3n45d2d941f79c1d2a@mail.gmail.com>
References: <2c53b31c0610060238nef13171ma6f4a42ba755c3b0@mail.gmail.com>
	<950bd3ad1504b8fb03e73b6236a808bc@redhat.com>
	<20061010183745.GA7049@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061010183745.GA7049@redhat.com>
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
To: mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

2006/10/10, Heinz Mauelshagen <mauelshagen@redhat.com>:
> On Mon, Oct 09, 2006 at 05:36:40PM -0500, Jonathan E Brassow wrote:
> >
> > On Oct 6, 2006, at 4:38 AM, David Guyon Martin wrote:
> >
> > >On Thu, 5 Oct 2006 20:40:05 +0100 Alasdair G Kergon wrote:
> > >
> > >>Something like:
> > >>
> > >>http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/
> > >>editing/dm-loop.patch
> > >>now perhaps?
> > >
> > >>(And there are patches for dmsetup to become a drop-in losetup
> > >>replacement.)
> > >
> > >Yes! This patch add a new file to the kernel tree, dm-loop.c:
> > >"This implements a loopback target for device mapper allowing a regular
> > >file to be treated as a block device."
> > >
> > >Great !!! At last :)
> > >It seems this dm-loop is quite new, less than a month...
> > >As I understand it I need kernel 2.6.18-rc7 to use it, right ?
> > >
> > >I really thank you a lot for your quick answer and link.
> > >
> > >Does anyone has yet a feedback about this dm-loop ?
> > >
> >
> > I know Heinz Mauelshagen has been looking at it and already has some
> > performance improvements.  Perhaps he'll post the updated patches soon.
>
> Yes, I'm settling the changes, which optimize the linear search
> in the file extents table and the initial lookup of the extents
> in the file to create the table with the dm-loop author Bryn Reeves
> right now.
>
> First benchmarks show promissing results :-)
>
> We hope to post something shortly.
>
> Regards,
> Heinz    -- The LVM Guy --
>

Thanks a lot ! I stay tuned ( I can hardly wait the results ).
I think many sysadmins underestimate the power of loops, more loops
and greater performances will ease eyes opening.

From dm-loop, comes dm-stego. I didn't found anything similar in the dev tree.
Does anyone know if someone is working on a dm-stego filter ?

David G.M.

PS: Heinz, since you've written dm-delay, you may have a clue to
http://www.redhat.com/archives/dm-devel/2006-October/msg00048.html
