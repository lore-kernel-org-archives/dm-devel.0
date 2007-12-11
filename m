From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 19:43:25 +0000
Message-ID: <20071211194325.GY22311@agk.fab.redhat.com>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
	<1197391333.25082.31.camel@quest>
	<20071211170352.GS22311@agk.fab.redhat.com>
	<1197393526.25082.36.camel@quest>
	<3ae72650712110951h477d1fc0hd9abd39f069da105@mail.gmail.com>
	<20071211180829.GW22311@agk.fab.redhat.com>
	<1197397532.2579.26.camel@lov.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1197397532.2579.26.camel@lov.site>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Tue, Dec 11, 2007 at 07:25:32PM +0100, Kay Sievers wrote:
> So we would need to strip the upper 32 bit of the numbers we see from
> udev, and handle the case where the 32 bit number wraps around.
 
Should be OK I think.  Otherwise we can append a 64-bit field to the 
struct - with care, this can be done without breaking compatibility.

Alasdair
-- 
agk@redhat.com
