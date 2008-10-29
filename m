From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] Check region size during dirty log creation
Date: Wed, 29 Oct 2008 16:53:42 +0100
Message-ID: <1225295622.1196.12.camel@o>
References: <1225285328.3974.5.camel@o>
	<20081029135607.GF31233@agk.fab.redhat.com> <1225292850.1196.4.camel@o>
	<20081029154357.GI31233@agk.fab.redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081029154357.GI31233@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Am Mittwoch, den 29.10.2008, 15:43 +0000 schrieb Alasdair G Kergon:
> On Wed, Oct 29, 2008 at 04:07:30PM +0100, Heinz Mauelshagen wrote:
> > Am Mittwoch, den 29.10.2008, 13:56 +0000 schrieb Alasdair G Kergon:
> > > On Wed, Oct 29, 2008 at 02:02:08PM +0100, Heinz Mauelshagen wrote:
> > > The validation should be consistent between userspace and kernel.
> > It should be sufficiently restrictive in the kernel to prevent
> > programming errors causing oopses. It can be called via the kernel
> > interface by any application anyway, so doesn't need to enforce our
> > uspace restrictions (think direct IOCTL calls).
>  
> Surely the validation in the two places should match?

I'm arguing, that the kernel should only restrict to prevent against
programming errors.

> Why would userspace need a tighter restriction than the kernel?

Because of specific application requirements.
Why shouldn't we support 2 sector dirty log region sizes for any
application who wants them ?

> One or the other is incorrect.
> - E.g. Does kcopyd handle sub-page regions OK now?

kcopyd allows copying io regions of single sectors.

Heinz

> 
> Alasdair
