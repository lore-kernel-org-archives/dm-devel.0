From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath-tools: reorder vendors in hwtable
Date: Mon, 18 Mar 2019 10:42:37 +0100
Message-ID: <e78daeb2e723cca91c248cb2de7c0d8a2a428280.camel@suse.de>
References: <20181219212357.21076-1-xose.vazquez@gmail.com>
	<74dbe64aabf33700924e57bcbe249a02c027ff29.camel@suse.de>
	<b450ce2f-72fe-6a06-f46d-f93ecf600d2d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b450ce2f-72fe-6a06-f46d-f93ecf600d2d@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, 2019-03-17 at 00:04 +0100, Xose Vazquez Perez wrote:
> On 12/21/18 12:51 AM, Martin Wilck wrote:
> > On Wed, 2018-12-19 at 22:23 +0100, Xose Vazquez Perez wrote:
> > > Xio was acquired by Violin, and add FlashSystem 9100 to Storwize
> > > in
> > > comments.
> > > 
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > >  libmultipath/hwtable.c | 50 ++++++++++++++++++++--------------
> > > ----
> > > ----
> > >  1 file changed, 24 insertions(+), 26 deletions(-)
> > > 
> > How important is it to reflect this kind of company-A-owns-company-
> > B
> > information in multipath-tools source code? IMO it makes it harder
> > to
> > track code changes, for no obvious technical reason.
> 
> Keep the file consistent with the real world.
> There is no more Xiotech company, now their products are sold by
> Violin.
> The same happened in the past with:
> XIV : RamSan -> IBM
> LSI_RDAC : SolidFir -> NetApp
> DEC -> Compaq : 3PAR : LEFTHAND : Nimble : SGI -> HPE
> DGC : XtremIO -> EMC : Compellent -> DELL

Fine with me, in general. But I dislike the "reordering vendors" type
of patch, leading to 22 insertions and 22 deletions without changing
any actual code. Sorting the hw entries by comments also makes little
sense to me. IMO we should switch using the actual .vendor/.product
strings for sorting, and perhaps move the "maintainers" information
into a separate file.

The fact that we did it in the past doesn't mean it's the right thing
to do. Anyone who needs to look up properties for a specific device in
hwtable.c will likely use the "search" functionality of her text editor
of choice, rather than rely on the alphabetic sorting of the entries;
and again it's usually the vendor/product string that matters for this
lookup rather than the comment on top of it. Therefore the benefit of
keeping the order is low. But following the history of changes (in
order to figure out when and with what rationale a certain setting was
added) is made significantly harder by patches of this kind.

Martin
