From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC] dm-userspace
Date: Thu, 20 Apr 2006 12:50:44 -0500
Message-ID: <a4e6962a0604201050h44d2e8e0r5a96d763f53328e7@mail.gmail.com>
References: <87lku18hy0.fsf@caffeine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87lku18hy0.fsf@caffeine.beaverton.ibm.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 4/19/06, Dan Smith <danms@us.ibm.com> wrote:
>
> A generic dm-userspace target would allow for testing of new
> algorithms (RAID, CoW, etc) from a userspace application, as well as
> some more interesting things involving distributed applications.  Just
> like FUSE allows for some neat (although not necessarily
> high-performance) tricks, dm-userspace could allow the same thing for
> block devices.
>
> Would the device-mapper maintainers be interested in accepting
> something like dm-userspace upstream?
>

It seems like this would be really useful for prototyping and
debugging new device mapper modules (like the dm-cache ideas I posted
about a few weeks back).  At the very least, I'd be interested in
using it?

A couple of questions:

1) how would you handle permissions?  IIRC FUSE allows normal users to
bind their own FUSE userspace file systems, would something similar
happen for dm-userspace or would even binding a userspace
device-mapper module require root?

2) How close would the userspace API be to the kernel device-mapper
API?  It'd be nice to have something close so that userspace code
could easily be migrated into the kernel (for performance reasons) as
appropriate.

3) When do you think you'll be able to post a patch for RFC?

           -eric
