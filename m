From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: boolian logic bug in vgremove
Date: Wed, 31 Jan 2007 16:22:50 +0000
Message-ID: <20070131162250.GF21980@agk.surrey.redhat.com>
References: <20070131153006.GA19569@skl-net.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131153006.GA19569@skl-net.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andre Noll <maan@systemlinux.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 31, 2007 at 04:30:06PM +0100, Andre Noll wrote:
> In the argument checking code of vgreduce.c there are two occasions of
> '&' that really should be '&&'. Patch below.
 
Well-spotted - apparently it's been like that for 4 years!

Alasdair
-- 
agk@redhat.com
