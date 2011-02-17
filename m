From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: What is the deal with the partition separator?
Date: Thu, 17 Feb 2011 16:58:43 +0000
Message-ID: <20110217165843.GA27449@agk-dp.fab.redhat.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com> <4D5CCE75.5090202@suse.de>
	<4D5D375F.9070106@cfl.rr.com> <4D5D3B34.4000005@suse.de>
	<4D5D3B0F.3050708@cfl.rr.com>
	<20110217165332.GE28729@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110217165332.GE28729@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Curtis Gedak <gedakc@gmail.com>, serge.hallyn@ubuntu.com, parted-devel@lists.alioth.debia
List-Id: dm-devel.ids

On Thu, Feb 17, 2011 at 04:53:32PM +0000, Alasdair G Kergon wrote:
> (Check by querying /sys/.../holders ?)
 
Actually, would it be sufficient for kpartx to attempt an exclusive
open?

Alasdair
