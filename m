From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [lvm-devel] Allow $DM_DEVDIR envvar to override
	default of "/dev".
Date: Tue, 9 Oct 2007 12:56:37 +0100
Message-ID: <20071009115637.GT10006@agk.fab.redhat.com>
References: <87przp1psr.fsf@rho.meyering.net>
	<20071009020040.GR10006@agk.fab.redhat.com>
	<87wstwy0md.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87wstwy0md.fsf@rho.meyering.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jim Meyering <jim@meyering.net>
Cc: device-mapper development <dm-devel@redhat.com>, LVM <lvm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 09, 2007 at 01:43:22PM +0200, Jim Meyering wrote:
> I can do that, but then the diagnostic can no longer say that
> the DM_DEV_DIR envvar is at fault.  

Then do the 'stack' or 'return_0' macro thing - or log the
detailed error with log_debug so people will normally just
see the 'clean' error.

Alasdair
-- 
agk@redhat.com
