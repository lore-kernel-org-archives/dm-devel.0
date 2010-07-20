From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [BUG] multipath-tools: uuid has become meaningless
Date: Mon, 19 Jul 2010 23:54:10 -0700
Message-ID: <20100720065410.GA3166@us.ibm.com>
References: <20100719224528.GA23414@us.ibm.com>
	<1279604124.2841.5.camel@Nokia-N900-42-11>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1279604124.2841.5.camel@Nokia-N900-42-11>
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

Christophe Varoqui [christophe.varoqui@gmail.com] wrote:
>    > 3. We could rename the devices instead of reload -- really fixing this!
>    >
> 
>    This one seems safe.

This is where I was heading. I did some investigation and found that we
really need to rename to wwid based names before we finally rename to
the intended name. So we may actually have two passes just to rename
(first to wwid based names and then to actual names).  Also the current
code doesn't do rename followed by reload even if it is needed. Someone
sets friendly name and some other defaults that need reload like path
grouping policy etc, we just rename! Probably a bug in itself.

Two pass based coalesce may be fix the latter bug too.

Thanks, Malahal.
PS: I will probably post a patch and that may invite people to suggest a
better and easier method!
