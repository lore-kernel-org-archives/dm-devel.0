From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 84/84] libmultipath: add consistency check
 for alias settings
Date: Tue, 18 Aug 2020 11:42:26 +0200
Message-ID: <99ad20088de1afe913f628a043a7374670894eff.camel@suse.com>
References: <20200812113601.26658-1-mwilck@suse.com>
	<20200812113601.26658-5-mwilck@suse.com>
	<20200818003055.GM19233@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200818003055.GM19233@octiron.msp.redhat.com>
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

On Mon, 2020-08-17 at 19:30 -0500, Benjamin Marzinski wrote:
> On Wed, Aug 12, 2020 at 01:36:01PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > A typo in a config file, assigning the same alias to multiple
> > WWIDs,
> > can cause massive confusion and even data corruption. Check and
> > if possible fix the bindings file in such cases.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/alias.c | 257
> > +++++++++++++++++++++++++++++++++++++++++++
> >  libmultipath/alias.h |   3 +
> >  multipath/main.c     |   3 +
> >  multipathd/main.c    |   3 +
> >  4 files changed, 266 insertions(+)
> > 
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 0759c4e..d328f77 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > 
> > +static int _check_bindings_file(const struct config *conf, FILE
> > *file,
> > +				 Bindings *bindings)
> > +{
> > +	int rc = 0;
> > +	unsigned int linenr = 0;
> > +	char *line = NULL;
> > +	size_t line_len = 0;
> > +	ssize_t n;
> > +
> > +	pthread_cleanup_push(free, line);
> > +	while ((n = getline(&line, &line_len, file)) >= 0) {
> > +		char *c, *alias, *wwid;
> > +		const char *mpe_wwid;
> > +
> > +		linenr++;
> > +		c = strpbrk(line, "#\n\r");
> > +		if (c)
> > +			*c = '\0';
> > +		alias = strtok(line, " \t");
> 
> I realize that your patch is just copying the existing code and I
> think
> our locking will save us here, but strtok isn't thread safe. We
> should
> consider changing all these to strtok_r().

I'll change this to strtok_r. I'll send a cumulative patch fixing the
other users as well.

I guess we'll also need to protect access to the bindings file. All
current accesses seem to be protected by the vecs lock (even
check_alias_settings(), called from reconfigure()), but we shouldn't
rely only on that. Also, multipath and multipathd could access the file
in parallel. Let's consider that later.

Btw, the vector holding the bindings in memory could obviously also
be used as a cache for looking up aliases at runtime. That would be
another item for later improvement. Actually, I thought we might
replace the vector here by some sort of hash map for even quicker
lookup. But I wanted to keep the already large patch series within
limits.

I'll send a v3 with your issues fixed.

Thanks,
Martin
