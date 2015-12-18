From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 14:50:10 -0600
Message-ID: <56747182.2030404@gmail.com>
References: <n508c1$8dl$1@ger.gmane.org>
	<20151218185110.GA25064@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151218185110.GA25064@agk-dp.fab.redhat.com>
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

On 12/18/2015 12:51 PM, Alasdair G Kergon wrote:
> Did you try stacking LVM on top of itself first?

Honestly, no (although my initial testing of zodcache actually used
logical volumes as the origin and cache devices FWIW).

This exercise is as much about the "optics" as it is about the actual
technical merits of the solution.  The goal is provide something that
(at least on the surface) looks "simple".

With just a couple of obvious enhancements to the mkzc utility (clear
the metadata region and start the new device), creating a cached device
would literally take just a single command.

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
