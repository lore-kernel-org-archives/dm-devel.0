From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Another cache target
Date: Tue, 18 Dec 2012 02:31:59 +0000
Message-ID: <20121218023159.GQ3408@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<20121214021918.GA29561@redhat.com>
	<20121214023425.GG9453@blackbox.djwong.org>
	<20121214102443.GB3022@raspberrypi>
	<20121214121143.GD3022@raspberrypi>
	<20121214215119.GJ9453@blackbox.djwong.org>
	<20121215082309.GA5330@reti.lambda.co.uk>
	<20121218014951.GA4878@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121218014951.GA4878@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 17, 2012 at 05:49:51PM -0800, Darrick J. Wong wrote:
> <nod> I was rather hoping there'd be a label to avoid all that above blkid
> drama. :/
 
We had debates about that.
When managed by LVM we hope the problems will be avoided.
(E.g. Raw devices will have LVM identifiers; dm devices will have dm UUIDs 
in /sys identifying them as private.)
But we might yet revisit this.

Alasdair
