From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Wed, 9 Mar 2011 21:49:28 +0000
Message-ID: <20110309214927.GI11312@agk-dp.fab.redhat.com>
References: <4D766199.4010307@gmail.com> <20110308174308.GP10767@agk-dp.fab.redhat.com> <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com> <20110309142325.GA11312@agk-dp.fab.redhat.com> <20110309213629.GV15097@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110309213629.GV15097@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Wendy Cheng <s.wendy.cheng@gmail.com>, Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Karel
List-Id: dm-devel.ids

On Thu, Mar 10, 2011 at 08:36:29AM +1100, Dave Chinner wrote:
> I can see how this would be advantageous from a management
> perspective for growing LVM pools, but I can see quite a few
> problems with extending that to automatically growing filesystems
> above LVM. e.g. The LUN resizes, the PV is expanded, the VG is
> expanded, but which LV in the VG is going to make use the new space?
 
You'd handle that by configuration settings under sysadmin control.
There are plenty of situations where there would be an 'obvious' LV 
to extend.

> Similarly, you can't safely shrink a filesystem from the bottom up -
> the filesystem has to empty the space first before it is safe to
> shrink it.  How would you handle this from a bottom-up driven
> change?
 
Obviously there are limits, and passing a message "Prepare to
be made smaller by X" up the stack probably isn't very feasible.

Alasdair

