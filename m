From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: LVM2, RHEL 4 update 2: can't remove logical volume
Date: Thu, 27 Oct 2005 18:49:41 +0100
Message-ID: <20051027174941.GE11086@agk.surrey.redhat.com>
References: <013350FE9CC8AC4EB602045723F47222B9A304@xmb-rtp-215.amer.cisco.com>
	<OF29A33E0B.95E7850F-ONC12570A7.002EDB85-C12570A7.0031344E@de.ibm.com>
	<20051027141602.GD11086@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051027141602.GD11086@agk.surrey.redhat.com>
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

On Thu, Oct 27, 2005 at 03:16:02PM +0100, Alasdair G Kergon wrote:
> Thanks - I've reproduced this now and I'll look for a fix.
 
Fix applied to lvm2 CVS, to be picked up in the next release.

(NB Not a good idea to use the CVS version at present because
it's undergoing lots of change and several things don't work.)

Alasdair
-- 
agk@redhat.com
