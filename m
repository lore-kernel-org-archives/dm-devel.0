From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/4] dm stats: support precise timestamps
Date: Mon, 27 Jul 2015 16:11:09 +0100
Message-ID: <20150727151108.GA18547@localhost.localdomain>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506091721180.1545@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, Coly Li <colyli@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jun 09, 2015 at 05:21:39PM -0400, Mikulas Patocka wrote:
>  	/*
>  	 * Input format:
> -	 *   <range> <step> [<program_id> [<aux_data>]]
> +	 *   <range> <step> [<extra_parameters> <parameters>] [<program_id> [<aux_data>]]
>  	 */

Rather than adding optional parameters would it make sense to add a new
create method? E.g. "@stats_create_precise".

In some ways this is easier to deal with in userspace and there's alrady
a precedent for it with @stats_print vs. @stats_print_clear.

It's not a huge deal either way though - just simplifies formatting of
the messages a little.

Regards,
Bryn.
