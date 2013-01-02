From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: How to force a snapshot status to valid when I
	know	very well it's valid?
Date: Wed, 2 Jan 2013 17:23:38 +0000
Message-ID: <20130102172338.GB18415@agk-dp.fab.redhat.com>
References: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
	<CAEcBt+UtiFrBw778r85JfZi7FegEgO6nXxkyoAUPRGXnvFXhmQ@mail.gmail.com>
	<CAM-w4HPxTMGQd76C_Dqt56vQ1WFA7KrG4o3fbQWU1x5y=XHm5Q@mail.gmail.com>
	<20121221231311.GD14851@agk-dp.fab.redhat.com>
	<CAM-w4HNV_eXMXmLKuHrAkvOT+wS15qzBUx1BEmW7CROKhJ1vUA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM-w4HNV_eXMXmLKuHrAkvOT+wS15qzBUx1BEmW7CROKhJ1vUA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg Stark <stark@mit.edu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 21, 2012 at 11:35:31PM +0000, Greg Stark wrote:
> I have another question while I'm here and people are being so
> helpful. Is there a way to grow the size of the actual snapshot
> device? Not the cow table but the device that the snapshot is
> presenting? If I change the size of the underlying device I don't
> think it changes the size of the snapshot and if I extend the snapshot
> it just changes the size of the cow table. It seems like it should be
> possible to add another dm mapping for the added space using a simple
> linear mapping.
 
We discused this sort of thing but never implemented it.

Perhaps we will offer more resizing options with the new thin snapshots.

Alasdair
