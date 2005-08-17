From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: multipath-tools-0.4.4 on 3par unknown path failure
	issue
Date: Wed, 17 Aug 2005 15:08:21 -0500
Message-ID: <20050817200821.GA28881@www.ewilts.org>
References: <42FA7674.4070201@mail.communityconnect.com>
	<20050811195540.GA16665@thumper2>
	<42FBB2CC.2040508@mail.communityconnect.com>
	<4303923E.1000606@mail.communityconnect.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4303923E.1000606@mail.communityconnect.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 17, 2005 at 03:38:38PM -0400, Alan Kasindorf wrote:
> I have tried adjusting QLogic timeouts and any related parameters to see 
> if a higher or lower timeout would affect the issue at all, and it's 
> done nothing but make the problem worse.
> 
> I'm confident in what folks have said about 2.6.12 and later not 
> exhibiting this issue. However, I have a redhat kernel running Oracle, 
> and we need them to not drop our support. Currently redhat's support is 
> ignoring me as well. Should I talk with the QLogic maintainer at all? 
> 3par has no clue, unless they're hiding their "Linux guy" from me.

The current Red Hat qlogic driver doesn't support most of the adjustable
parameters.  However, the one you can download from qlogic does.  Red
Hat will include this driver in its next release (beta in about a week,
production in mid-September).  In addition, Red Hat will support
multipathing to at least same level as what SuSe supports today:
http://portal.suse.com/sdb/en/2005/04/sles_multipathing.html

> Does SuSE professional have this patched up? We might be able to switch 
> to their distro if they will actually support multipathing on a database 
> in their mainline kernel, vs not at all.

Red Hat is just a bit behind, but if you really need this in production,
I'd suggest you contact your support and/or sales rep to ask them to
support you with the beta release.  How much luck you'll have, I don't
know.

-- 
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
