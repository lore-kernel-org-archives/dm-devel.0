From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v2] multipath -u: test socket connection in
 non-blocking mode
Date: Thu, 16 May 2019 08:44:56 +0200
Message-ID: <e5abf79650733d4035bac4c01168802e2ce71389.camel@suse.de>
References: <20190424090759.29796-1-mwilck@suse.com>
	<fa3ea599bf6424587fec45b5eb3549b3200ac5e9.camel@suse.com>
	<20190429213837.GC5210@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190429213837.GC5210@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, mwilck+gmail@suse.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2019-04-29 at 16:38 -0500, Benjamin Marzinski wrote:
> On Thu, Apr 25, 2019 at 09:33:03PM +0200, Martin Wilck wrote:
> > 
> > @Ben, I'd be grateful if you could try it (or have the user try it)
> > in your problem case as well.
> 
> Unfortunately, I don't have a 129+ path system handy that the person
> who
> does isn't around right now.  The code makes sense, and assuming that
> I
> can verify that it fixes the problem I'm seeing, I'm fine with going
> this route.

Thanks, Ben. As noted earlier, we've had several customers who reported
this, and they're all happy with this patch. 

Martin
