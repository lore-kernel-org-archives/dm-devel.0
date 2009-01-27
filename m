From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Could device-mapper offer multi-tier storage?
Date: Tue, 27 Jan 2009 16:40:15 -0500
Message-ID: <20090127214015.GB557@infradead.org>
References: <496E4063.5070502@nrel.colostate.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <496E4063.5070502@nrel.colostate.edu>
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

On Wed, Jan 14, 2009 at 12:43:31PM -0700, Ty! Boyack wrote:
> 1)  Is device-mapper the right layer to look at applying this?
>
> 2)  If so, any ideas on how hard it would be to implement?
>
> 3)  If device-mapper is not the right place, any idea where this  
> functionality should go, or if it is already out there in another form?

The right way to do it is in the filesystem.  There's already something
like this in XFS although you need the out of tree version.  dmapi
is designed to work with really slow media like tapes and can migrate
data fully out to it.

There's something else under development which allows to assign
different regions of the filesystem to files and hiearchies based
on various criteria.  This is called dynamic allocation policies and
will initially use dm for creating the underlying device hiearchy,
although we'd eventually want the raid/volume manager algorithms tied
more tightly directly into the fs control.  The exact way to do that
is still a little bit under discussion.
