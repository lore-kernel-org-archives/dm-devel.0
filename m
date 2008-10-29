From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Check region size during dirty log creation
Date: Wed, 29 Oct 2008 15:43:57 +0000
Message-ID: <20081029154357.GI31233@agk.fab.redhat.com>
References: <1225285328.3974.5.camel@o>
	<20081029135607.GF31233@agk.fab.redhat.com>
	<1225292850.1196.4.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1225292850.1196.4.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 29, 2008 at 04:07:30PM +0100, Heinz Mauelshagen wrote:
> Am Mittwoch, den 29.10.2008, 13:56 +0000 schrieb Alasdair G Kergon:
> > On Wed, Oct 29, 2008 at 02:02:08PM +0100, Heinz Mauelshagen wrote:
> > The validation should be consistent between userspace and kernel.
> It should be sufficiently restrictive in the kernel to prevent
> programming errors causing oopses. It can be called via the kernel
> interface by any application anyway, so doesn't need to enforce our
> uspace restrictions (think direct IOCTL calls).
 
Surely the validation in the two places should match?
Why would userspace need a tighter restriction than the kernel?
One or the other is incorrect.
- E.g. Does kcopyd handle sub-page regions OK now?

Alasdair
-- 
agk@redhat.com
