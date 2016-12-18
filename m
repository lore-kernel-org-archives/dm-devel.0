From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: dm-cache: please check/repair metadata
Date: Sat, 17 Dec 2016 18:34:34 -0600
Message-ID: <o34lim$19u$1@blaine.gmane.org>
References: <o2adej$eaa$1@blaine.gmane.org>
	<2d776d72-744a-7aa7-a5ae-35192fe145d8@redhat.com>
	<efe12356-a132-c517-914d-4a4cf3a902fc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <efe12356-a132-c517-914d-4a4cf3a902fc@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/08/2016 08:53 AM, Ian Pilcher wrote:
> Running cache_repair against the metadata device gives me this error:
>
>   transaction_manager::new_block() couldn't allocate new block
>
> I strongly suspect that my metadata device is too small.  It was sized
> with the algorithm that I posted to this list about a year ago:
>
>   https://www.redhat.com/archives/dm-devel/2015-November/msg00221.html
>
> Looking at the source code for cache_metadata_size, I see that it adds
> additional space for "hints", which the old algorithm didn't account
> for.

I finally got around to testing my hypothesis, and I can confirm that
the size of the metadata device is indeed the problem.  With a larger
metadata device, cache_repair succeeds, and I am able to assemble the
cache device.

So I obviously need to change the formula that I'm using to calculate
the size of the metadata device, which begs the question ... what is the
CANONICAL formula for doing this?

lvmcache(7) says, "The size of this LV should be 1000 times smaller
than the cache data LV, with a minimum size of 8MiB."  But this is
definitely *not* the formula used by cache_metadata_size, and
cache_metadata_size seems to assume that hints will never be larger
than 4 bytes.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
