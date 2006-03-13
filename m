From: egoggin@emc.com
Subject: RE: path group failback
Date: Mon, 13 Mar 2006 11:44:23 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B0E5@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Christophe Varoqui
> Sent: Monday, March 13, 2006 11:27 AM
> To: device-mapper development
> Cc: christophe.varoqui@free.fr
> Subject: Re: [dm-devel] path group failback
> 
> > > > 
> > > I'm still strugling to understand what this new mode does.
> > > If you can help with an example, I'd appreciate :/
> > 
> > I'm sorry for the confusion.  I was not clear as to the purpose.
> > The purpose is to only do "automatic" failback when the active path
> > group was "automatically" changed from the highest priority path
> > group.
> > 
> In such a scenario, wouldn't the priorizer catch priority changes ?

No, not necessarily, and certainly not for CLARiiON.  None of these
3 use cases involves changing which path group is the highest priority
path group so each path in the 2 groups continue to have the same
priority as before the externally initiated change of the active path
group.  For each use case, only the identity of the active path group
has been changed.

> 
> ie, paths to owning SP are heavier than paths to not owning SP, so
> changing the owning SP in navisphere would shuffle the path group
> priorites.

CLARiiON path priority is dependent solely on 2 factors -- (1) the
path must be active (or ghost) and (2) the path must connect to its
logical unit's "default" (not necessarily active) owning service
processor.

> 
> If it is the case I would imagine the failback target to be the
> externally designated one, which seems right.

No.  The CLARiiON's highest priority path group is defined to be
the default owning service processor instead of the active service
processor (they may or may not be the same at any given instant)
in order to maintain the manually established distribution of
logical units across the 2 service processors.

> 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
