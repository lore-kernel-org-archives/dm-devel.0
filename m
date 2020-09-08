From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 09/14] libmultipath: check whether
 mp->features is NULl in, assemble_map
Date: Tue, 8 Sep 2020 11:44:10 -0500
Message-ID: <20200908164410.GL11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<40cf77df-eaa3-fb72-69fd-9f865d12dc34@huawei.com>
	<20200904213048.GE11108@octiron.msp.redhat.com>
	<8dd72a70-991a-cb7d-3279-3d5036df1b9d@huawei.com>
	<20200908154540.GK11108@octiron.msp.redhat.com>
	<c50b9997b3c4a55d6a2858cd6b931bea93b14bfe.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c50b9997b3c4a55d6a2858cd6b931bea93b14bfe.camel@suse.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Tue, Sep 08, 2020 at 06:35:45PM +0200, Martin Wilck wrote:
> On Tue, 2020-09-08 at 10:45 -0500, Benjamin Marzinski wrote:
> > On Mon, Sep 07, 2020 at 08:21:28PM +0800, lixiaokeng wrote:
> > > > > @@ -86,9 +86,12 @@ assemble_map (struct multipath * mp, char *
> > > > > params, int len)
> > > > >  	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
> > > > >  		add_feature(&mp->features, retain_hwhandler);
> > > > > 
> > > > > -	f = STRDUP(mp->features);
> > > > 
> > > > clearly strdup()ing without checking if mp->features NULL is
> > > > incorrect.
> > > > However, I'm not sure that we need to fail if mp->features is
> > > > NULL.
> > > > instead, int the APPEND call, we could use the gcc ternary
> > > > operator
> > > > extension
> > > > 
> > > > (mp->features)?: "0"
> > > > 
> > > > to use "0" if mp->features is NULL.
> > > > 
> > > > Also, have you seen this actually occur?  Or is this just a
> > > > theoretical
> > > > issue that you've found from reading the code.  It seems like
> > > > setup_map() will always call select_features() before calling
> > > > assemble_map(), which should mean that mp->features will always
> > > > be set
> > > > in this case. Perhaps I'm missing something here.
> > > > 
> > > > -Ben
> > > > 
> > > Hi Ben,
> > >   This just a theoretical issue and I did not see it. But it's not
> > > necessary
> > > to call strdup. In your opinion, need multipath be checked?  I will
> > > make new
> > > patch with your suggestion.
> > 
> > Since we don't believe it's possible for mp->features (or mp-
> > >hwhandler)
> > to be set to NULL here, it makes sense to print an error if it is
> > NULL.
> > So, I guess my suggestion would be to print an error message if
> > mp->features or mp->hwhandler are NULL, but to assemble the map
> > anyway,
> > using the default value of "0" if they are NULL. That's how
> > assemble_map() currently handles failures in add_feature().
> > add_feature() will print an error, but assemble_map() will go ahead
> > with
> > assembling the map.
> > 
> > I'm willing to be convinced that there is a better solution, however.
> 
> What about this:
> 
> assemble_map() is only called from setup_map(), which sets mp->features 
> in select_features(). So what we should do is check for NULL after
> select_features(), or have that function return an error code if strdup
> fails, and bail out early in setup_map() in that case.
> 
> Then we simply need to add a comment in assemble_map() saying that 
> mp->features must be non-null when this function is called.
> 
> As I said earlier, I'm of course not against checking function
> parameters, but here we should fail to setup a "struct multipath" in
> the first place in setup map(), rather than returning an incompletely
> initialized one. If we handle it this way, we don't need to check the
> fields of struct multipath over and over again. Similar arguments hold
> for other structs.
> 
> Of course this kind of assumption needs to be better documented in the
> code.

I'm fine with that.

-Ben

> Regards
> Martin
> 
