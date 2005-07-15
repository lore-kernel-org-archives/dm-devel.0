From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: queue_if_no_paths timeout handling
Date: Sat, 16 Jul 2005 01:06:14 +0200
Message-ID: <1121468774.26998.139.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB74@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB74@SRMANNING.eng.emc.com>
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

ok, reverted.

On ven, 2005-07-15 at 10:34 -0400, goggin, edward wrote:
> On Tue, 12 Jul 2005 22:28:09 -0400
> goggin, edward" <egoggin@emc.com> wrote
>  
> > Christophe, could you remove this attribute from the 
> > hwtable.c entry for the
> > EMC CLARiiON?  Its the one with the vendor string of "DGC".  
> > The feature
> > is no longer needed.
> > 
> 
> My mistake here.  We still need this attribute in order to deal
> with the possibility of having a transient period of time during
> a ucode upgrade where all paths to a SCSI LU may appear to be
> failed.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
