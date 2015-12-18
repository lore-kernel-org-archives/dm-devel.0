From: "John Stoffel" <john@stoffel.org>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 14:44:47 -0500
Message-ID: <22132.25135.428253.845795@quad.stoffel.home>
References: <n508c1$8dl$1@ger.gmane.org>
	<20151218185110.GA25064@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Ian Pilcher <arequipeno@gmail.com>
List-Id: dm-devel.ids

>>>>> "Alasdair" == Alasdair G Kergon <agk@redhat.com> writes:

Alasdair> On Fri, Dec 18, 2015 at 12:16:32AM -0600, Ian Pilcher wrote:
>> * Is there a better way of doing this?

Alasdair> Did you try stacking LVM on top of itself first?

Alasdair> I.e. Create one cached LV consuming all your space, then create a new PV
Alasdair> and VG on top of that LV, and carve that stacked VG up into whatever LVs
Alasdair> you need?

How deep can you stack things like this before you run into problems?
And it does seem like it would put a bunch of stress on the UDEV setup
to asseble it all reliably.

John
