From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: bio's bi_size bug also be founded at dm-stripe.c and
	dm-snap.c (resend in correct charset)
Date: Wed, 29 Jun 2005 06:30:57 -0500
Message-ID: <200506290630.57441.kevcorry@us.ibm.com>
References: <00a501c57c92$c3041020$1f000064@polaris>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <00a501c57c92$c3041020$1f000064@polaris>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Zhao Qian <zhaoqian@aaastor.com>
List-Id: dm-devel.ids

Hi Zhao,

On Wed June 29 2005 5:10 am, Zhao Qian wrote:
> As i had written here before, sometimes bio which dispatched to the dm's
> target, it's bi_size could exceed region size in dm-mirror.c, i also found
> similar problem in dm-stripe.c and dm-snap.c,

Have you specifically seen this problem happen during testing?

> in such situation, bio's 
> bi_size could exceed strip target's chunk size and snap target's chunk
> size, but in current code, we never care about this. so in strip target we
> could read/write bad position after stripe_map() function, and cause same
> effect in dm-snap.c.

I'm quite certain there is code in dm.c to prevent bio's from spanning the 
internal boundaries in the mirror, snapshot, and stripe targets. Have you 
read through the code starting in dm.c::dm_request()? The targets specify 
where their internal boundaries are, and the core driver is responsible for 
splitting up bio's so the targets never get a request that span those 
boundaries.

> I think such bugs are very dangerous then kernel panic or cracsh becasue it
> may destroy your data in silence. we'd better to annonuce our linux users
> don't use thus dm-targets before we correct it.

If you've seen a case of actual corruption due to this, please let us know and 
we'll investigate to see if something accidentally has been broken. But as I 
mentioned above, I don't think this should really be a problem.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
