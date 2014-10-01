From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: break out of both loops when freeing data
Date: Wed, 1 Oct 2014 14:42:31 -0400
Message-ID: <20141001184231.GA13947@redhat.com>
References: <alpine.LRH.2.02.1410011329050.25573@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1410011334210.25573@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1410011334210.25573@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 01 2014 at  1:35pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 1 Oct 2014, Mikulas Patocka wrote:
> 
> > When we free the required number of entries (nr_to_scan becomes zero), we
> > must break out of both loops. The code exited only the inner loop and
> > continued in the outer loop.
> > 
> > Also, move dm_bufio_cond_resched to the inner loop, so that scanning the
> > list doesn't result in scheduling latency.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> I forgot to add:
> 
> Cc: stable@vger.kernel.org	# 3.2+

I tweaked the header, used a return rather than goto, and staged in
linux-next for 3.18.  See:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=04c308f43a90a9b3b84c344b324d6af29288da05
