From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] [PATCH] lvm2: mirroredlog support
Date: Wed, 30 Sep 2009 22:46:10 +0100
Message-ID: <20090930214610.GX5351@agk-dp.fab.redhat.com>
References: <20090923030331.GA26449@us.ibm.com>
	<F5472B5D-59E5-4A38-948B-6055886E75A8@redhat.com>
	<20090930163519.GV5351@agk-dp.fab.redhat.com>
	<61B37279-E0E3-4AF6-81AB-82EEE65C1A09@redhat.com>
	<20090930211826.GW5351@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090930211826.GW5351@agk-dp.fab.redhat.com>
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

On Wed, Sep 30, 2009 at 10:18:26PM +0100, Alasdair G Kergon wrote:
> or perhaps break it into two independent allocations at that point,
> one for the data and then one for the log?
 
Perhaps that's the solution: a new lvm.conf/cmdline parm that permits
independent log placement.

Allocation is initially performed the same as currently.
But if it fails and this new setting was chosen, then the allocation is
re-attempted without the log, and if that succeeds, an independent
attempt is made to allocate the log.

Alasdair
