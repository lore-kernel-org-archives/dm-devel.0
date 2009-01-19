From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [dm-devel] dm-crypt low performance
Date: Mon, 19 Jan 2009 11:23:00 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901191120370.25401-100000@netrider.rowland.org>
References: <200901191604.21584.rrs@researchut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <200901191604.21584.rrs@researchut.com>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-pm@lists.linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, 19 Jan 2009, Ritesh Raj Sarraf wrote:

> I've been testing the same hardware but unfortunately wasn't able to see the 
> issue back again. One thing to notice is that the laptop has 4 USB ports out 
> of which 3 are 1.1 and only 1 is 2.0.
> The suspected faulty USB HDD Enclosure has 2 cables that I was connecting to, 
> thus ending up connecting them to a 2.0 and 1.1 USB port.

You should have mentioned this before!

One of those cables is for data and power, and the other cable is for 
power only (probably the thinner of the two).  For your drive to work 
correctly you should first plug in the power-only cable to a 1.1 port 
and then plug in the data/power cable to the 2.0 port.

If you mix things up and plug the data cable to a 1.1 port then of 
course the drive will operate only at 1.1 speed.

> I tried with just 1 port connected to USB 2.0 port and haven't been able to 
> reproduce the issue back again yet. :-(
> I also wasn't able to reproduce back the old issue with the pattern I 
> mentioned in the previous post (1 cable connected to 1.1 and the other 
> connected to 2.0 port)
> 
> I'll keep testing and post to this thread if I find something useful.

See if this doesn't clarify the matter.

Alan Stern
