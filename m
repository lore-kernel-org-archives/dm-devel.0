From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 12/35] libmultipath: strlcpy()/strlcat(): use
 restrict qualifier
Date: Tue, 04 Aug 2020 17:36:31 +0200
Message-ID: <246f58856cdc0c5d80046ca7d740ff92f91b0f87.camel@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
	<20200709101620.6786-13-mwilck@suse.com>
	<20200716221848.GN11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200716221848.GN11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2020-07-16 at 17:18 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:15:57PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Also remove the redundant local variables. It's not necessary to
> > make "restrict" work, but it makes the intention more clear.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/util.c | 28 ++++++++++++----------------
> >  libmultipath/util.h |  4 ++--
> >  2 files changed, 14 insertions(+), 18 deletions(-)
> > 
> > diff --git a/libmultipath/util.c b/libmultipath/util.c
> > index 957fb97..f965094 100644
> > --- a/libmultipath/util.c
> > +++ b/libmultipath/util.c
> > 
> > -size_t strlcat(char *dst, const char *src, size_t size)
> > +size_t strlcat(char * restrict dst, const char * restrict src,
> > size_t size)
> >  {
> >  	size_t bytes = 0;
> > -	char *q = dst;
> > -	const char *p = src;
> >  	char ch;
> >  
> > -	while (bytes < size && *q) {
> > -		q++;
> > +	while (bytes < size && *dst) {
> > +		dst++;
> >  		bytes++;
> >  	}
> >  	if (bytes == size)
> 
> this should return the strlen(dst) + strlen(src). It wouldn't in the
> admittedly weird case where size isn't large enough to fit dst.

Are you sure?

https://linux.die.net/man/3/strlcat

"Note, however, that if strlcat() traverses size characters without
finding a NUL, the length of the string is considered to be size and
the destination string will not be NUL-terminated (since there was no
space for the NUL)."

The way I understand this is that the current code is actually correct
in returning bytes + strlen(src).

This is also consistent with what I see elsewhere

https://github.com/ffainelli/uClibc/blob/master/libc/string/strlcat.c
https://github.com/freebsd/freebsd/blob/master/crypto/heimdal/lib/roken/strlcat.c

Regards
Martin
