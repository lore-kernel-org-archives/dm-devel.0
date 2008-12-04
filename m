From: "Balasubramanian, Vijayakumar (STSD)" <vijayakumar@hp.com>
Subject: RE: [patch] leastpending_io load balancing policy
Date: Thu, 4 Dec 2008 11:42:50 +0000
Message-ID: <2118D41AB77C214BBF7D2330CD977BCF1BB45B0A3B@GVW1162EXB.americas.hpqcorp.net>
References: <20081203220819.GO26097@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081203220819.GO26097@agk.fab.redhat.com>
Content-Language: en-US
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

Hi Alasdair,
I have inserted the response in the below mail. Let us know if it is OK, =
we can modify the patch accordingly.

Thanks,
Vijay


> -----Original Message-----
> From: Alasdair G Kergon [mailto:agk@redhat.com]
> Sent: Thursday, December 04, 2008 3:38 AM
> To: Balasubramanian, Vijayakumar (STSD)
> Cc: device-mapper development
> Subject: Re: [dm-devel] [patch] leastpending_io load balancing policy
>
> On Wed, Nov 12, 2008 at 02:17:05PM +0000, Balasubramanian,
> Vijayakumar (STSD) wrote:
> > Attached patch provides "Least pending IO" dynamic load balancing
> > policy for bio based device mapper multipath. This load balancing
> > policy considers the number of unserviced requests pending
> on a path
> > and selects the path with least count for pending service request.
>
> repeat_count is still accepted but does nothing so I've removed it.
> (And how did it work with a default of (unsigned) -1 anyway -
> never switch path?)
>
From multipath.conf user can set rr_min_io to 1 and that would be the de=
fault value [-1 needs to be replaced with 1]. However we could still prov=
ide the flexibility for user to change in case selector need to home on t=
o a path for rr_min_io(s).

> However, it might improve performance by reducing the amount
> of splitting of consecutive contiguous I/Os, so I think you
> should consider putting it back in and implementing it
> (either internally or by extending the ps interface to
> separate choice of path from use of path).
>
Yes, It would be better to have repeat_count and have it user configurabl=
e.

> Another alternative might be to use thresholds, and only
> switch path, for example, when the amount of I/O outstanding
> down the current path is X more than the amount down the
> least path or the amount down the least path falls below Y.
>
> There is useful status information (io_count) not returned to
> userspace, so I've added that to lpp_status().
>
As we would be retaining repeat_count can we have the ":" separated infor=
mation about repeat_count also.

> The wrapper function lpp_select_path call adds nothing so
> I've collapsed it.
>
This is fine.

> Is there some locking missing from the end_io function
> because it manipulates io_count?  E.g. io_count atomic with
> memory barrier, or caller takes the lock?  How does it
> interact with fail_path() in do_end_io() and the way that the
> io_count can get reset to 0 when a path is reinstated (and in
> general there could still be outstanding I/O down it)?  For
> now, I've removed that resetting.  (I'm concerned that there
> may be some races in this code.)
>
I guess we could have io_count as atomic_t and use atomic_* interfaces to=
 avoid race conditions.

> Also, now that there is more than one path selector, Kconfig
> should be updated to make them separate modules and to
> require at least one to be included.
>
Kconfig can be modified to include the new path selector and leave the ro=
und-robin as default.

> Alasdair
> --
> agk@redhat.com
>
