From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: your mail
Date: Thu, 20 Oct 2011 01:57:25 +0100
Message-ID: <20111020005725.GV24527@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1110192014570.24440@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110192014570.24440@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, thornber@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 19, 2011 at 08:17:37PM -0400, Mikulas Patocka wrote:
> The next one adds a conditional resched (Alasdair 
> agreed on it --- it should be later put into general Linux headers).
 
Indeed, this part:

> +#ifdef CONFIG_PREEMPT_VOLUNTARY
> +#define dm_bufio_cond_resched()                	\
> +do {						\
> +	if (unlikely(need_resched()))		\
> +		_cond_resched();		\
> +} while (0)
> +#else
> +#define dm_bufio_cond_resched()                do { } while (0)
> +#endif

doesn't really belong in a dm file.

Alasdair
