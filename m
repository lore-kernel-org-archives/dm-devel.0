From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: path group failback
Date: Mon, 13 Mar 2006 17:26:46 +0100
Message-ID: <20060313162646.GF6902@pundit>
References: <C2EEB4E538D3DC48BF57F391F422779321B0E4@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321B0E4@SRMANNING.eng.emc.com>
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

> > > 
> > I'm still strugling to understand what this new mode does.
> > If you can help with an example, I'd appreciate :/
> 
> I'm sorry for the confusion.  I was not clear as to the purpose.
> The purpose is to only do "automatic" failback when the active path
> group was "automatically" changed from the highest priority path
> group.
> 
In such a scenario, wouldn't the priorizer catch priority changes ?

ie, paths to owning SP are heavier than paths to not owning SP, so
changing the owning SP in navisphere would shuffle the path group
priorites.

If it is the case I would imagine the failback target to be the
externally designated one, which seems right. 

Regards,
cvaroqui
