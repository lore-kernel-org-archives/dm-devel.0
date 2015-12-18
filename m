From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 18:51:10 +0000
Message-ID: <20151218185110.GA25064@agk-dp.fab.redhat.com>
References: <n508c1$8dl$1@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <n508c1$8dl$1@ger.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ian Pilcher <arequipeno@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 18, 2015 at 12:16:32AM -0600, Ian Pilcher wrote:
>  * Is there a better way of doing this?

Did you try stacking LVM on top of itself first?

I.e. Create one cached LV consuming all your space, then create a new PV
and VG on top of that LV, and carve that stacked VG up into whatever LVs
you need?

Alasdair
