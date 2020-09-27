From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 13/21] libmultipath: provide defaults for
 {get, put}_multipath_config
Date: Sat, 26 Sep 2020 20:03:39 -0500
Message-ID: <20200927010339.GK3384@octiron.msp.redhat.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-14-mwilck@suse.com>
	<20200925043458.GO11108@octiron.msp.redhat.com>
	<e0637cd84ca36dbba00f8ff5b92ffcb8e81aa747.camel@suse.com>
	<20200925215739.GA3384@octiron.msp.redhat.com>
	<91ed445c926ecf1fae57b8b0d7478f6b3401460c.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <91ed445c926ecf1fae57b8b0d7478f6b3401460c.camel@suse.com>
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

On Sat, Sep 26, 2020 at 11:43:46AM +0200, Martin Wilck wrote:
> On Fri, 2020-09-25 at 16:57 -0500, Benjamin Marzinski wrote:
> > On Fri, Sep 25, 2020 at 10:00:10PM +0200, Martin Wilck wrote:
> > > 
> > > I suggest to track the verbosity independently in a different
> > > variable,
> > > and just set it from init_config() if it was actually set in the
> > > config file. Most of the time, we set it from the command line.
> > > This would have the additional benefit not to have to call
> > > get_multipath_config() in dlog().
> > 
> > Sure. That sounds like a much simpler solution than what I was
> > proposing.
> 
> I will do that in a separate patch. It will actually be a short
> series with logging fixes. Would you ack this patch then?
> In general it makes sense for get_multipath_config() to return NULL if
> the struct config is not initialized.
> 

Sure.
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


> Thanks,
> Martin
> 
