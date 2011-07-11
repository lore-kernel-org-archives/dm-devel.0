From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Device removal handling
Date: Mon, 11 Jul 2011 11:08:05 -0400
Message-ID: <4E1B11D5.8050603@cfl.rr.com>
References: <4E1A079A.9060901@cfl.rr.com>
	<20110710220330.GA7857@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110710220330.GA7857@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 7/10/2011 6:03 PM, Alasdair G Kergon wrote:
> (But devices should be removed from the top down, obviously, and if
> it's your main filesystem, you could e.g. set up a ramdisk do do
> this from.)

I disagree.  Right now dmraid relies on doing this, but this is not 
possible if it is not aware of the higher level mappings because they 
were created by kpartx.  LVM and multipath will have the same problem if 
kpartx recognizes partitions contained within an LV.

Hardware removal also necessitates bottom up removal, since the initial 
event comes from unplugging the hardware at the bottom of the stack. 
The system needs to propagate notification of that up the stack so that 
the higher layers can react appropriately and release the removed lower 
layer device.
