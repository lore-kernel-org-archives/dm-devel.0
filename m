From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Tue, 10 Nov 2009 00:24:45 +0000
Message-ID: <20091110002445.GF17055@agk-dp.fab.redhat.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
	<20091109085142.GA4432@linux.vnet.ibm.com>
	<20091109175730.GA12556@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091109175730.GA12556@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, Nov 09, 2009 at 09:57:30AM -0800, malahal@us.ibm.com wrote:
> Why do we need dm_get() and dm_put() in dm_copy_name_and_uuid()?
> dm_copy_name_and_uuid() already has access to md and there shouldn't be
> any need to hold a reference. 

As Mike points out, struct dm_uevent holds a reference without incrementing the
ref count.

dm_path_uevent() already takes a reference - can everything get simplified
if we move this code there (and replace the new mutex with a spinlock of
course)?  Then dm_send_uevents won't need to use 'md'.

Alasdair
