From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: LVM2, RHEL 4 update 2: can't remove logical volume
Date: Thu, 27 Oct 2005 15:16:02 +0100
Message-ID: <20051027141602.GD11086@agk.surrey.redhat.com>
References: <013350FE9CC8AC4EB602045723F47222B9A304@xmb-rtp-215.amer.cisco.com>
	<OF29A33E0B.95E7850F-ONC12570A7.002EDB85-C12570A7.0031344E@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF29A33E0B.95E7850F-ONC12570A7.002EDB85-C12570A7.0031344E@de.ibm.com>
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

On Thu, Oct 27, 2005 at 10:58:22AM +0200, Stefan Bader wrote:
> We got something similar here. Try to change the filter rules to exclude 
> the
> volume group devices. What you want is the devices created by the
> multipath-tools included but not the devices created by lvm2.
> Otherwise the tools will have the lv open at the time they should be
> removed.
 
Thanks - I've reproduced this now and I'll look for a fix.

Alasdair
-- 
agk@redhat.com
