From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
Date: Wed, 5 May 2010 18:39:17 -0700
Message-ID: <20100506013917.GA9298@linux.vnet.ibm.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
 <E463DF2B2E584B4A82673F53D62C2EF498E060CB@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF498E060CB@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

Moger, Babu <Babu.Moger@lsi.com> wrote:
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Mike Anderson
> > Sent: Monday, May 03, 2010 11:01 PM
> > To: dm-devel@redhat.com
> > Cc: linux-scsi@vger.kernel.org
> > Subject: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
> > 
> > This patch series contains two patches.
> > 
> > 1.) The first patch adds a feature flags bit field to the multipath
> > structure for selected features.
> > 
> > 2.) The second patch allows a user to set a feature flag for a dm-mpath
> > device of "no_abort_q" to indicate that deactivate_path should not call
> > blk_abort_queue. I tried to select a short feature name to feature
> > output
> > listed with multipath -l would not be too long "features='2
> > queue_if_no_path
> > no_abort_q'
> 
> Mike, 
>  In what special circumstances you recommend to use this feature? It would be great if you could add that explanation in your patch descriptions. 

Yes I will update the descriptions.

To answer your question in general it would be circumstance where the
block_abort_queue during failover is leading to longer recovery instead of
shorter. This could be because of aborting / transport / device
interactions (the work by others in the iSCSI and FC transports have made
things better here).

While there are case where abort makes a big difference (being able to
failover in less than max_retries * IO timeout value). The latency numbers
for simple RDAC initiator failover show only small improvements on my
configurations (others may have better data). A assumption would be that
there could be combinations of transports and devices out there where this
might not give the fastest failover so the user may want control.

On a historically note the call to block_abort_queue came in somewhat
sideways by me linked to the timeout movement from SCSI to blk so it could
have integrated better. I should have had a way to disable / enable it
then and I am trying to provide that now so that the user has some
control.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
