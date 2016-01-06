From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: Never mind (was [RFC] zodcache - auto-start dm-cache
	devices)
Date: Wed, 6 Jan 2016 09:49:21 -0600
Message-ID: <n6jd21$33m$1@ger.gmane.org>
References: <n508c1$8dl$1@ger.gmane.org> <n529r6$4si$1@ger.gmane.org>
	<22132.47234.331074.708465@quad.stoffel.home>
	<20160104155251.GB3007@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160104155251.GB3007@rh-vpn>
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

On 01/04/2016 09:52 AM, Joe Thornber wrote:
> I looked through the code and thought this was a good tool that does
> something that LVM currently doesn't support very well.

Well now I'm totally confused.

The feedback I received when I initially posted this led me to believe
that there was zero (or less) interest in a non-LVM interface to
dm-cache.  That was the reason that I initially pulled the repo, since
I didn't want someone to stumble upon it and unknowingly trust their
data to something that is essentially an unsupported dead end.

(It's back up by the way, with warnings that I hope are sufficiently
strong -- https://github.com/ipilcher/zodcache.)

So I'm back to the question that I asked in my original note ... Is this
approach (i.e. not LVM cache but more "bcache-like" for lack of a
better term) something that is worth pursuing?

If so, I'm happy to fix/enhance/maintain this code going forward, and I
hope that this community will be willing to provide suggestions, answer
the odd question, etc.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
