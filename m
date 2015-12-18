From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 20:01:22 +0000
Message-ID: <20151218200122.GB25064@agk-dp.fab.redhat.com>
References: <n508c1$8dl$1@ger.gmane.org>
	<20151218185110.GA25064@agk-dp.fab.redhat.com>
	<22132.25135.428253.845795@quad.stoffel.home>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <22132.25135.428253.845795@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Stoffel <john@stoffel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Ian Pilcher <arequipeno@gmail.com>
List-Id: dm-devel.ids

On Fri, Dec 18, 2015 at 02:44:47PM -0500, John Stoffel wrote:
> How deep can you stack things like this before you run into problems?
> And it does seem like it would put a bunch of stress on the UDEV setup
> to asseble it all reliably.

It should all work recursively to any reasonable level including udev.

If such use became more common, we'd to look at ways of optimising it:
We've considered allowing stacking within a single VG before, but
there hasn't really been enough demand to give it any priority.

If, as suggested here, there are now going to be common situations
where it makes sense, we can look again at introducing a more streamlined
approach.

Alasdair
