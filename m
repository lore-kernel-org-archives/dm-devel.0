From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Read-Only devices, multipath and more
Date: Tue, 20 May 2008 15:48:07 +0100
Message-ID: <20080520144807.GC10723@agk.fab.redhat.com>
References: <1210966544.12901.51.camel@plop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1210966544.12901.51.camel@plop>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Fri, May 16, 2008 at 09:35:44PM +0200, christophe varoqui wrote:
> fact: device-mapper refuse to load a RW multipath table on these paths
> (ie without libdevmapper:set_task_set_ro())
> question: should change this behaviour to allow to load a RW multipath
> table on these paths and let the IO be failed by the storage hardware ?

Yes.  But relax this *only* for multipath targets, where the whole idea
is to "hide" path problems from the layer above.  It would not make sense 
in my view to do this for other DM targets.
 
> Alasdair proposed to add more explicit table loading ioctl return code
> when the failure is due to this ready-only paths issue (E_ROFS for
> example).

I think this should be done too (for non-multipath and other errors).

Alasdair
-- 
agk@redhat.com
