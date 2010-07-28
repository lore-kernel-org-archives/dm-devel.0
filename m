From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: BIO_RW_SYNCIO
Date: Wed, 28 Jul 2010 08:35:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007280834400.31386@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
	<20090417063615.GE4593@kernel.dk>
	<Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
	<20090421072903.GY4593@kernel.dk>
	<Pine.LNX.4.64.1007261747560.12939@hs20-bc2-1.build.redhat.com>
	<20100727020919.GC18940@redhat.com>
	<Pine.LNX.4.64.1007271452180.1954@hs20-bc2-1.build.redhat.com>
	<20100727230950.GI7347@redhat.com> <20100728013345.GB12642@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100728013345.GB12642@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> One more thing. Have you change the "quantum" tunable of CFQ? Looking
> at the traces of SYNC case, CFQ seems to be allowing up to 65 requests
> from a single cfq queue. But that does not happen. It is limited to 8
> requests max from a cfq queue.
> 
> Which kernel version are you using?
> 
> Thanks
> Vivek

I haven't changed it. It's 8 --- the default. I'm using 2.6.34.

Mikulas
