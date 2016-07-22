From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 2/2] mm, mempool: do not throttle PF_LESS_THROTTLE tasks
Date: Fri, 22 Jul 2016 19:04:25 +1000
Message-ID: <87lh0u59ie.fsf@notabene.neil.brown.name>
References: <1468831164-26621-1-git-send-email-mhocko@kernel.org> <1468831285-27242-1-git-send-email-mhocko@kernel.org> <1468831285-27242-2-git-send-email-mhocko@kernel.org> <87oa5q5abi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <87oa5q5abi.fsf@notabene.neil.brown.name>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
Cc: Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, David Rientjes <rientjes@google.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Michal Hocko <mhocko@suse.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain

On Fri, Jul 22 2016, NeilBrown wrote:

>
> Looking at the current code, __GFP_DIRECT_RECLAIM is disabled the first
> time through, but if the pool is empty, direct-reclaim is allowed on the
> next attempt.  Presumably this is where the throttling comes in ??  I
> suspect that it really shouldn't do that. It should leave kswapd to do
> reclaim (so __GFP_KSWAPD_RECLAIM is appropriate) and only wait in
> mempool_alloc where pool->wait can wake it up.

Actually, thinking about the kswapd connection, it might make sense
for mempool_alloc() to wait in the relevant pgdata->pfmemalloc_wait as
well as waiting on pool->wait.  What way it should be able to proceed as
soon as any memory is available.  I don't know what the correct 'pgdata'
is though.

Just a thought,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXkeGZAAoJEDnsnt1WYoG5yg4P/0OUJHSKniG6PislfnPKJR1v
WBvPb65TuUQwcZYOQXw072hD1gtT3MrLGSRd/38YmVGZX+0OxO1eVUpwMfwUAIl1
fDKTG8FBDutm/F9TvD3ff6V/0OxAxq32rq8xe45RULu7aIt4mxXMr0WwmAZ1+Lyk
2UdP9c26waHnToDtrz/tf8drLsnWWUWsJGSibPbjH+I5QZQNVdcGnQOpJ5X5LPN6
eWK+WeXblcmRNqBonf33O8h8jLp8c+O2YKD+wUSc50gZYpa0tjgWgy27vvcr7zpO
lSVY4mOLI+t2qbp2Vz27NqxgppSyeveKHa664/WMnyvkz2rk7ZsrL+zDR2oID/+A
/r4vHqklNga1zAbf5nBotBZJQtLWRpfPNZU8l82cFeMlmSoDvHTL1aIRBcKOMpzX
VWqLyGOkZ5TiOjxAzSgqwaLErj6kIYzzRtfTADuX3BmrBv0CYkuVsjNHskRSjOsC
whk8kwx6j+lXxuuNKry6Ft1su4qj0SWU3hVcTm9shc5lGRqFc76pAIJFY3SF1/Ru
PQpcuFK49t66woOJvpsYUl69ly5cdmxWUEVjs4n8YkA7kTdK5P02BqzmXbZW6zNE
WcijXYHTCqZPAJyV1u6PUTjSym3sAgz28FdQnrDUzmpn6Y8GVk28FnAF8vRDA4d1
YSfjZY2EKbJDUOOumsqY
=bNio
-----END PGP SIGNATURE-----
--=-=-=--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
