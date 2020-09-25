From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 10/11] libmpathpersist: add linker version
	script
Date: Fri, 25 Sep 2020 17:10:22 -0500
Message-ID: <20200925221022.GB3384@octiron.msp.redhat.com>
References: <20200924133644.14034-1-mwilck@suse.com>
	<20200924133644.14034-11-mwilck@suse.com>
	<20200925040034.GN11108@octiron.msp.redhat.com>
	<d41328cd56bc65f9506d9a7f7548593aa07d775a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d41328cd56bc65f9506d9a7f7548593aa07d775a.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 25, 2020 at 09:52:51PM +0200, Martin Wilck wrote:
> On Thu, 2020-09-24 at 23:00 -0500, Benjamin Marzinski wrote:
> > On Thu, Sep 24, 2020 at 03:36:43PM +0200, mwilck@suse.com wrote:
> > > 
> > > --- /dev/null
> > > +++ b/libmpathpersist/libmpathpersist.version
> > > @@ -0,0 +1,20 @@
> > > +LIBMPATHPERSIST_0.8.4.0 {
> > 
> > I have a question about this version. Do you plan on bumping this
> > each
> > time a new release is tagged? It seems like we only ever want to
> > change
> > the version if we actually change the ABI. Or is 0.8.4 just because
> > that's the relesae where we started this?
> 
> That was the idea, yes. And the last digit is because we'll have to
> bump it between releases from Christophe. It makes sense for
> libmultipath's rapidly changing ABI; much less so for libmpathcmd and
> libmpathpersist, which are meant to be stable. I am open for discussing
> these numbers; if you prefer, we might as well use LIBMPATHPERSIST_1.0.
> 
> I admit I haven't thought about what would happen once Christophe makes
> a new release. Probably, nothing - afaics it's impossible to add a new
> version without any new symbols, and *renaming* an existing version is
> bad; it would introduce artificial incompatibility. 
> 
> So libmultipath from multipath-tools 0.8.5 would still have a 0.8.4.x
> ABI; only the first change after 0.8.5 would get a 0.8.5.1 number. Hm.
> 
> Again, I'm open for discussion here. We might as well choose to not tie
> the ABI version to the libmultipath version at all, and simply start at
> 0.1 or whatevever for libmultipath. After all, looking up the ABI
> version in the commit history will be simple enough.

Since the ABI version isn't always going to match the release version, I
think it makes more sense to decouple them, so it's not sometimes
matching and sometimes not. We could go with a MAJOR.MINOR versioning
scheme, where we bump MINOR whenever we change the interface in a
backwards compatible way (like by adding a new symbol), and bump the
MAJOR and reset the MINOR whenever we change the interface in a
non-backwards compatible way (like by changing the parameters an
interface function takes, or removing a symbol). Although I'm not sure
we need to be so careful for libmultipath, since that library isn't for
external consumption.

-Ben
 
> Martin
> 
