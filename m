From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: libdevmapper version question
Date: Thu, 24 Aug 2006 19:10:24 +0100
Message-ID: <20060824181024.GJ13859@agk.surrey.redhat.com>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1373@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1373@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 24, 2006 at 01:52:25PM -0400, goggin, edward wrote:
> Do you know the version of libdevmapper which first supported the
> interface to specify disabling the device mapper's call to lock_fs for
> the DM_DEVICE_RESUME ioctl?

See the WHATS_NEW file:

  Version 1.02.00 - 10 Nov 2005
    Added dmsetup --nolockfs support for suspend/reload.

However, note that LVM2 hasn't always used it correctly:
  Version 2.02.08 - 15th August 2006
    Fix missing lockfs on first snapshot creation.
 
Alasdair
-- 
agk@redhat.com
