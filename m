From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Wed, 17 Jun 2015 15:52:35 +0100
Message-ID: <20150617145235.GE27887@localhost.localdomain>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<20150616153345.GA1069@redhat.com>
	<alpine.LRH.2.02.1506161523430.30788@file01.intranet.prod.int.rdu2.redhat.com>
	<20150617014324.GA30214@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150617014324.GA30214@redhat.com>
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

On Tue, Jun 16, 2015 at 09:43:24PM -0400, Vivek Goyal wrote:
> There does not seem to be any restriction that program_id has to be
> a valid program name. It could be any string. I used a program id
> of 25 and it works.

That's always been the case - program_id (and aux_data) are just opaque
strings that the kernel stores for userspace.
 
> [root@tiger ~]# dmsetup message docker-docker--pool 0 @stats_create - /1
> 25
> 0

> May be we can introduce a new message to handle this new number of
> arguments syntax. Say "stats_create_v2". That way existing programs
> will not be broken, if any.

If we introduce new messages it would be good to make them extensible,
i.e. something like the form used for table constructor arguments: a
field indicating the number of arguments and arguments either describing
themselves or fitting a structure that can be expanded as needed.

> @stats_create [program_id=<program_id>] [aux_data=<aux_data>]
> 
> That way we know what arguments are coming. There is no guessing and 
> handling optional parameters is easy too.

Just that it's more string munging in the kernel. This is why e.g.
multipath's first argument is the number of feature arguments etc.

Regards,
Bryn.
