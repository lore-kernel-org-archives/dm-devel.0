From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Wed, 17 Jun 2015 16:18:16 +0100
Message-ID: <20150617151816.GG27887@localhost.localdomain>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<20150616153345.GA1069@redhat.com>
	<alpine.LRH.2.02.1506161523430.30788@file01.intranet.prod.int.rdu2.redhat.com>
	<20150617014324.GA30214@redhat.com>
	<alpine.LRH.2.02.1506170908070.15768@file01.intranet.prod.int.rdu2.redhat.com>
	<20150617132033.GA3303@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150617132033.GA3303@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, Mikulas Patocka <mpatocka@redhat.com>, Coly Li <colyli@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 17, 2015 at 09:20:33AM -0400, Vivek Goyal wrote:
> I think it would be reasonable use "pid" as program_id when different
> instance of same program want to keep track of different regions of
> disk.

Nothing stops you from doing that; just pass e.g. "mylvmstat$PID" as
the program_id.

Regards,
Bryn.
