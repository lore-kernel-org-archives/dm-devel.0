From: Greg Stark <stark@mit.edu>
Subject: Re: How to force a snapshot status to valid when I know
 very well it's valid?
Date: Fri, 21 Dec 2012 23:35:31 +0000
Message-ID: <CAM-w4HNV_eXMXmLKuHrAkvOT+wS15qzBUx1BEmW7CROKhJ1vUA@mail.gmail.com>
References: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
	<CAEcBt+UtiFrBw778r85JfZi7FegEgO6nXxkyoAUPRGXnvFXhmQ@mail.gmail.com>
	<CAM-w4HPxTMGQd76C_Dqt56vQ1WFA7KrG4o3fbQWU1x5y=XHm5Q@mail.gmail.com>
	<20121221231311.GD14851@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121221231311.GD14851@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg Stark <stark@mit.edu>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 21, 2012 at 11:13 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, Dec 21, 2012 at 10:54:21PM +0000, Greg Stark wrote:
>> took about 30 minutes. I don't know why or what happened there. But it
>
> Big snapshots take a long time to load - the whole cow area has to be
> scanned to generate the list of blocks represented on it.

Hm. I didn't remember this happening previously but I had just doubled
the size of the cow and I might be wrong about it too.

I have another question while I'm here and people are being so
helpful. Is there a way to grow the size of the actual snapshot
device? Not the cow table but the device that the snapshot is
presenting? If I change the size of the underlying device I don't
think it changes the size of the snapshot and if I extend the snapshot
it just changes the size of the cow table. It seems like it should be
possible to add another dm mapping for the added space using a simple
linear mapping.

[btw Alasdair, Hi! We met at FOSDEM and discussed filesystem/dm synchronization
primitives that would help Postgres have more lightweight checkpoints]

-- 
greg
