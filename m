From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Wed, 17 Jun 2015 15:54:15 +0100
Message-ID: <20150617145414.GF27887@localhost.localdomain>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<20150616153345.GA1069@redhat.com>
	<alpine.LRH.2.02.1506161523430.30788@file01.intranet.prod.int.rdu2.redhat.com>
	<20150617014324.GA30214@redhat.com>
	<alpine.LRH.2.02.1506170908070.15768@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506170908070.15768@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, "Alasdair G. Kergon" <agk@redhat.com>, Coly Li <colyli@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 17, 2015 at 09:17:40AM -0400, Mikulas Patocka wrote:
> There are no existing programs that use numbers as program_id.

Right; even the earliest lvmstat prototypes were using "lvmstat1" for this.

Regards,
Bryn.
