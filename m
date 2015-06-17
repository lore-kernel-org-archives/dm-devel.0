From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] Integrate dm-latency functionality to
 dm-statistics
Date: Wed, 17 Jun 2015 09:22:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506170918210.15768@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<557C6214.4010506@gmail.com>
	<alpine.LRH.2.02.1506150729150.7275@file01.intranet.prod.int.rdu2.redhat.com>
	<557EE2C0.2070003@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <557EE2C0.2070003@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Coly Li <colyli@gmail.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 15 Jun 2015, Coly Li wrote:

> >> 2, There should be a maximum latency histogram boundaries limitation. 
> >> Maybe you do it in the patch and I missed it, that's should be my fault.
> > There is no maximum - and there doesn't need to be any maximum because the 
> > array is allocated dynamically.
> Maybe I am too paranoid, IMHO dynamically allocated object should have a
> maximum limitation, in case of it occupies too much system resource (e.g
> memory here).

There is already that limitation of 1/4 total physical memory.

Mikulas
