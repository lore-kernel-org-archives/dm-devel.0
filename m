From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Device removal handling
Date: Wed, 13 Jul 2011 11:53:29 -0400
Message-ID: <4E1DBF79.2090401@cfl.rr.com>
References: <4E1A079A.9060901@cfl.rr.com>	<20110710220330.GA7857@agk-dp.fab.redhat.com>	<4E1B11D5.8050603@cfl.rr.com>
	<4E1BE8AC.3090503@suse.de>
	<20110712105826.GH7857@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110712105826.GH7857@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 7/12/2011 6:58 AM, Alasdair G Kergon wrote:
> We already have dmsetup remove -f which replaced a device by the error
> target then attempts to remove it (which will fail if it is still in
> use).
>
> You have a need for this without the removal attempt?

The question is, how do you get udev to invoke this when the underlying 
device is removed?  It has no idea what dm device was using the disk. 
Further, if it was a mirror, then you don't want to try to kill the 
mirror if the other leg is still good, you just want the mirror to fail 
and release the removed disk.
