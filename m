From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: device mapper cleanup
Date: Thu, 6 Apr 2006 23:19:57 +0100
Message-ID: <20060406221957.GK4197@agk.surrey.redhat.com>
References: <OF16134823.26AB83BB-ON87257148.0076840B-87257148.0077352B@seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF16134823.26AB83BB-ON87257148.0076840B-87257148.0077352B@seagate.com>
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

On Thu, Apr 06, 2006 at 03:42:23PM -0600, Dale.R.Fowle@seagate.com wrote:
> devices sitting under /dev/mapper that do not get cleaned up after a
> reboot. These devices no longer exist on my storage, yet they still show
> up. 

Should run 'dmsetup mknodes' during early startup.

Alasdair
-- 
agk@redhat.com
