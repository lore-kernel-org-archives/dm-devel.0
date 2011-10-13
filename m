From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-bufio
Date: Thu, 13 Oct 2011 18:19:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110131817300.11120@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
	<20111013194001.GA12863@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111013194001.GA12863@redhat.com>
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
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> +static int dm_bufio_trylock(struct dm_bufio_client *c)
> +{
> +	return dm_bufio_trylock(c);
> +}
> +
> +static void dm_bufio_unlock(struct dm_bufio_client *c)
> +{
> +	dm_bufio_unlock(c);
> +}

These two functions are recursive nonsense :) There should be
"return mutex_trylock(&c->lock);" and "mutex_unlock(&c->lock);".

Mikulas
