From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: make
 vector_foreach_slot_backwards work as expected
Date: Tue, 28 May 2019 10:16:18 -0500
Message-ID: <20190528151618.GE7630@octiron.msp.redhat.com>
References: <1558737674-22335-1-git-send-email-bmarzins@redhat.com>
	<478097e8086d85ba6d0785e825a8ef9b05d21554.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <478097e8086d85ba6d0785e825a8ef9b05d21554.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, May 27, 2019 at 12:03:59PM +0200, Martin Wilck wrote:
> On Fri, 2019-05-24 at 17:41 -0500, Benjamin Marzinski wrote:
> > All of the code that uses vector_foreach_slot_backwards() treats "i"
> > as
> > the index of the entry "p", but the way it was coded, that wasn't the
> > case. "i" was the number of the entry counting from 1, not 0.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/vector.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> Let's add that there was only one caller that actually used
> "i"("multipath -W"). So the harm done by this bug was not as bad as one
> might think.
>  

Actually, it caused _find_controllers() to delete the wrong slot from
map->pgvec, which caused a crash on a future _find_controllers() call
because we don't check for a NULL path between

path = nvme_pg_to_path(pg);

and

path->seen = false;

Since there should never be a NULL path, I don't think we need to add
that check, but this happens in more than multipath -W. We use "i" in
_cleanup_foreign(), cleanup_nvme_map(), _delete_all(), and
_find_controllers(). 

-Ben
