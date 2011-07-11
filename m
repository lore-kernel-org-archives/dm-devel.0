From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Device removal handling
Date: Mon, 11 Jul 2011 16:31:18 -0400
Message-ID: <4E1B5D96.9090402@cfl.rr.com>
References: <4E1A079A.9060901@cfl.rr.com>	<20110710220330.GA7857@agk-dp.fab.redhat.com>	<4E1B11D5.8050603@cfl.rr.com>
	<20110711152343.GG7857@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110711152343.GG7857@agk-dp.fab.redhat.com>
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

On 7/11/2011 11:23 AM, Alasdair G Kergon wrote:
> That's back-to-front!  You stop using a device first, then you remove it.
> You really don't want to be removing devices while they are in use if you
> can avoid it.

That is a pre plug and play world view.  These days the kernel needs to 
be able to handle surprise removal as well.  Also when you do want to 
remove a device, polluting user space tools with all kinds of hacks to 
try and figure out what the higher layers are and clean them up is very 
error prone and often is not done correctly.  It would be preferable to 
use the same mechanism to request the removal of a device, and let the 
kernel worry about notifying any higher layers to clean up.

> If something goes wrong and a device disappears, then yes, that disappearance
> should propagate up the stack to be handled as best it can by each layer.

The question then is, how should that work?  I can't believe the block 
layer does not already have some kind of mechanism for this.  It isn't 
much different than handling medium ejection.  If it does, then dm just 
needs to use it.
