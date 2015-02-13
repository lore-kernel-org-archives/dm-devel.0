From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/7] dm-crypt: avoid deadlock in mempools
Date: Fri, 13 Feb 2015 17:09:37 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502131708030.447@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1502130823540.6449@file01.intranet.prod.int.rdu2.redhat.com>
	<20150213211614.GA7180@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150213211614.GA7180@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Fri, 13 Feb 2015, Mike Snitzer wrote:

>   * In order to not degrade performance with excessive locking, we try
> - * non-blocking allocations without a mutex first and if it fails, we fallback
> + * non-blocking allocation without a mutex first and if it fails, we fallback
>   * to a blocking allocation with a mutex.
>   */
>  static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)

There are multiple allocations, so I would leave plural there.

Mikulas
