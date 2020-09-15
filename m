From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3]  Fixes for bitfield unit tests
Date: Tue, 15 Sep 2020 11:52:18 -0500
Message-ID: <20200915165218.GQ11108@octiron.msp.redhat.com>
References: <20200821224224.13536-1-mwilck@suse.com>
	<1fea6ca4ce7221461ddec39f37f2216e8cdd4c33.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1fea6ca4ce7221461ddec39f37f2216e8cdd4c33.camel@suse.com>
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

On Tue, Sep 15, 2020 at 01:16:19PM +0200, Martin Wilck wrote:
> On Sat, 2020-08-22 at 00:42 +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Hi Christophe, hi Ben,
> > 
> > embarassingly, it turns out that my unit test code for the bitfield
> > code was broken in various ways, which at the same time shows that
> > I didn't test this as broadly as I should have before submitting.
> > The good news is that only the test code was broken, not the
> > implementation itself.
> > 
> > With these fixes, I successfully compiled it on both little and
> > big endian architectures, with and without glibc 2.27.
> > (https://build.opensuse.org/package/show/Base:System/multipath-tools)
> > 
> > Regards,
> > Martin
> > 
> > Martin Wilck (3):
> >   multipath-tools tests: fix bitfield tests for small fields
> >   multipath-tools tests: fix bitfield tests for big endian
> >   multipath-tools tests: fix small bitfield tests for big endian
> > 
> >  tests/util.c | 146 ++++++++++++++++++++++++++++++++++++++++++-------
> > --
> >  1 file changed, 120 insertions(+), 26 deletions(-)
> 
> @Ben: Gentle review reminder ...

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Cheers,
> Martin
> 
> 
