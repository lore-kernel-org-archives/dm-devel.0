From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm core: remove dead codes
Date: Mon, 18 Feb 2008 12:34:03 +0000
Message-ID: <20080218123403.GJ1788@agk.fab.redhat.com>
References: <20080215.175505.34761653.k-ueda@ct.jp.nec.com>
	<20080218122148.GI1788@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080218122148.GI1788@agk.fab.redhat.com>
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

On Mon, Feb 18, 2008 at 12:21:48PM +0000, Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 05:55:05PM -0500, Kiyoshi Ueda wrote:
> > This patch removes dead codes for the noflush suspend.
> I've been sent (unfinished) patches for 2.6.26 (or even 2.6.25 if people
> consider the reinstatement of flushing support important enough) that
> build on this one.
 
That was ambiguous:-(  I meant that code has only just got added to the
kernel and there are patches waiting to be finished that use it - it's
not dead code.

Alasdair
-- 
agk@redhat.com
