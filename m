From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: Missing DM event ?
Date: Tue, 02 Aug 2005 22:45:59 +0200
Message-ID: <1123015559.20148.15.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB9B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB9B@SRMANNING.eng.emc.com>
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

On mar, 2005-08-02 at 15:37 -0400, goggin, edward wrote:
> On Thu, 28 Jul 2005 16:25:33 +0200
> Christophe Varoqui <christophe.varoqui@free.fr> wrote
> 
> > I played with the "rename" multipath feature in 
> > /sbin/multipath and noticed it doesn't trigger a DM event to 
> > the old devmap listeners. Which is quite annoying if we want 
> > the daemon to rely on this event to catch a rename initiated 
> > by /sbin/multipath.
> > 
> > Don't know if it is expected behaviour ...
> > Anyway, I finaly went the easy way and did the thing with a 
> > remove/add sequence.
> 
> I missed this when I submitted the patch for the dmsetup remove
> and remove_all subcommands.  This is definitely a problem since
> the device-mapper user space utilities like multipath use the
> dm device name to identify a particular mapped device.
>   
> I think the fix is for dm_hash_rename to be calling dm_table_event.
> I don't have a working host now so I can't include a tested patch.
> I will later this week.
> 
> Do you want to change multipathd to recognize that a simple name
> change occurred to a map for which it already knows about or simply
> have it do an implicit remove/add sequence as I suspect it is already
> doing in this case?
> 
I was close to handle the rename events in the daemon when I realised
the events weren't delivered, so it might be doable. But franckly, I was
just toying with the idea, as I'm still not sure how we should
"socially" handle alias changing ...

Indeed, "map rename" is not an operation we should ease as it may have
subtle side-effects (for one, what about mounted FS). Or should we ?

For now I feel rather safe with the add/remove sequence, but have no
strong feelings.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
