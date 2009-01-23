From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] crash in dm-io when signal is pending
Date: Fri, 23 Jan 2009 10:57:44 +0000
Message-ID: <20090123105744.GV9859@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0901212203090.31606@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901212203090.31606@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 21, 2009 at 10:04:39PM -0500, Mikulas Patocka wrote:
> If someone sends signal to a process performing synchronous dm-io call,
> the kernel may crash.
 
> There is no way to cancel in-progress IOs, so the best solution is to ignore
> signals at this point.
 
So what is the impact of this patch at a higher level?
- What userspace operations are there that you can interrupt now, but that
after this patch you won't be able to?
(Are there any situations where the io will not complete without a reboot,
that could actually be safe today?)

Alasdair
-- 
agk@redhat.com
