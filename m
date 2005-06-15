From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: StorageWorks multipath support
Date: Wed, 15 Jun 2005 15:45:36 +0200
Message-ID: <20050615134536.GC16446@averon.dyndns.org>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050615131520.GC11423@marowsky-bree.de>
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
List-Id: dm-devel.ids

On Wed, Jun 15, 2005 at 03:15:20PM +0200, Lars Marowsky-Bree wrote:
> On 2005-06-15T10:56:34, Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> 
> > Hello,
> > 
> > here is a note describing the lego blocks needed to have a fully
> > operational multipath stack with StorageWorks and Qlogic hardware.
> 
> Christophe, is the "ghost" denomination there to stay?
> 
> If so, the passive paths (ie, to the non-active Service Processor) of
> the EMC CLARiiON also might wish to use this...
> 
I'm not attached to the ghost term, but what it describes is here to stay.

This state has a special treatment in the daemon : paths in this state are kept in active state in the DM, instead of proactively being failed. This is for the hwhandler to be given a chance to activate a PG with only ghost paths in it.

If you come with a better term, I'll sure consider it. Maybe "spare" ?

Regards,
cvaroqui
