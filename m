From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: blockdev --flushbufs required [was:
	parted	issue/question
Date: Wed, 18 Jan 2012 14:14:42 +0000
Message-ID: <20120118141442.GB11769@agk-dp.fab.redhat.com>
References: <4F13ADB3.5070806@redhat.com> <87lip6t157.fsf@rho.meyering.net>
	<20120118003802.GA11769@agk-dp.fab.redhat.com>
	<87haztruph.fsf_-_@rho.meyering.net> <4F16D19A.9030405@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F16D19A.9030405@redhat.com>
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
List-Id: dm-devel.ids

On Wed, Jan 18, 2012 at 03:05:14PM +0100, Zdenek Kabelac wrote:
> Just my wild guess it could be related to wrong assumption that close of  
> descriptor means automatic flush - this is only true in the case, there 
> is only one user for descriptor so it would be the last user - but if 
> e.g. the device is opened more then once, then close doesn't mean flush - 
> so I'd have assume some application is missing fsync(fd) before doing 
> close(fd).

Ref. http://www.redhat.com/archives/dm-devel/2012-January/msg00014.html
