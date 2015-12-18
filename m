From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 22:06:32 +0100
Message-ID: <56747558.7030507@redhat.com>
References: <n508c1$8dl$1@ger.gmane.org>
	<20151218185110.GA25064@agk-dp.fab.redhat.com>
	<56747182.2030404@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56747182.2030404@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Dne 18.12.2015 v 21:50 Ian Pilcher napsal(a):
> On 12/18/2015 12:51 PM, Alasdair G Kergon wrote:
>> Did you try stacking LVM on top of itself first?
>
> Honestly, no (although my initial testing of zodcache actually used
> logical volumes as the origin and cache devices FWIW).
>
> This exercise is as much about the "optics" as it is about the actual
> technical merits of the solution.  The goal is provide something that
> (at least on the surface) looks "simple".
>
> With just a couple of obvious enhancements to the mkzc utility (clear
> the metadata region and start the new device), creating a cached device
> would literally take just a single command.
>

Sure - as long as you do not need to solve any 'security/safety' points,
you can do things in a simple way.

But how do you plan to support any power-failures and recoveries ?

When someone pick drive to other system - what is going to happen ?

Are you going to write your own 'lvm2-like' tools to do the job ?

Are you going to maintain this over long time period ?

You really should have started from RFE on lvm2 enhancements to better suite
your needs -  since IMHO there are no SIMPLE things when we talk about devices...

Regards

Zdenek
