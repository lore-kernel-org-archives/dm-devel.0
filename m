From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: DM, Multipath, and LSI Disk Arrays
Date: Sun, 13 Mar 2005 01:41:19 +0100
Message-ID: <1110674480.6624.43.camel@zezette>
References: <111aefd050309062640c23eec@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <111aefd050309062640c23eec@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, penney@msu.edu
List-Id: dm-devel.ids

On Wed, 2005-03-09 at 09:26 -0500, Chris Penney wrote:
> Hi,
> 
> I'm not sure if this is the right list so apologies in advance if I'm
> in the wrong spot.  The search tool for this list doesn't seem to work
> either.
> 
> I have an Intel system with dual Qlogic HBAs (2340s) that talk to an
> STK D280 disk array (I see the generic multipath.conf lists a D280 as
> a device in the config file).  I'm using SLES 9 SP1 w/ multipath-tools
> 0.3.6-0.3.
> 
> They way the system is setup, hba1 talks to the A controller of the
> D280 and hba2 talks to the B controller (they are on seperate sans). 
> The box has four luns, two are active on port A and two are active on
> port B.  When I let multipath do it's thing it wants to use port B for
> everything and that triggers a fail over of the A luns to port B.
> 
> If I do the dmsetup commands by hand I can get what I want, but is
> there a way to do this automatically?  The thought of having a self
> made hack init script to do this seems highly suspect.
> 

Hello,

the priority framework is here to help .

You need a priority helper to hand a higher priority to the active
paths. I don't know if someone already developped such a prioritizer for
your hardware.

Hope it helps enough to get you a step forward.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
