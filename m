From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/2] dm-band: The I/O bandwidth controller:
	Overview
Date: Wed, 23 Jan 2008 14:47:17 +0000
Message-ID: <20080123144717.GS8075@agk.fab.redhat.com>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080123.215350.193721890.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> Dm-band gives bandwidth to each job according to its weight, 
> which each job can set its own value to.
> At this time, a job is a group of processes with the same pid or pgrp or uid.

It seems to rely on 'current' to classify bios and doesn't do it until the map
function is called, possibly in a different process context, so it won't
always identify the original source of the I/O correctly: people need to take
this into account when designing their group configuration and so this should
be mentioned in the documentation.

I've uploaded it here while we consider ways we might refine the architecture and
interfaces etc.:

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-add-band-target.patch

Alasdair
-- 
agk@redhat.com
