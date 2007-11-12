From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [Kernel PATCH] emit change on devmapper devices
Date: Mon, 12 Nov 2007 21:34:18 +0000
Message-ID: <20071112213418.GS22843@agk.fab.redhat.com>
References: <1194454207.6273.5.camel@wing-commander>
	<4738C3B4.8020504@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4738C3B4.8020504@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Mon, Nov 12, 2007 at 04:20:52PM -0500, Phillip Susi wrote:
> When they are renamed?  Don't you want a change event when you modify 
> the table?
 
Yes of course - the code already has that, but rename avoids that code path.

Alasdair
-- 
agk@redhat.com
