From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipathd ignoring dev_loss_tmo setting
Date: Tue, 12 Mar 2019 17:32:16 -0500
Message-ID: <20190312223216.GC13295@octiron.msp.redhat.com>
References: <d915601a3472d7448e57f968e2ec3a63c627a35e.camel@cgi.com>
	<20190228195330.GQ3023@octiron.msp.redhat.com>
	<69ee893dda390f614c78f49b55ea99c7c7f6583a.camel@cgi.com>
	<20190301173512.GR3023@octiron.msp.redhat.com>
	<1379896535dccc69dc07bf16a8be7696392261a3.camel@cgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1379896535dccc69dc07bf16a8be7696392261a3.camel@cgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martins, Bruno O" <bruno.martins@cgi.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 04, 2019 at 09:48:59AM +0000, Martins, Bruno O wrote:
> On Fri, 2019-03-01 at 11:35 -0600, Benjamin Marzinski wrote:
> > On Fri, Mar 01, 2019 at 10:04:52AM +0000, Martins, Bruno O wrote:
> > > On Thu, 2019-02-28 at 13:53 -0600, Benjamin Marzinski wrote:
> > > > On Thu, Feb 28, 2019 at 11:38:22AM +0000, Martins, Bruno O wrote:
> > > > > Hello guys,
> > > > > 
> > > > > I am trying to modify /etc/multipath.conf on my system so that
> > > > > the
> > > > > parameter 'dev_loss_tmo' is changed from the default value.
> > > > > 
> > > > > However, when checking the value currently in use I am getting
> > > > > the
> > > > > wrong value (which is '30') for some of the remote ports:
> > > > > 
> > > > 
> > > > Are you sure those rports are used by multipath devices?
> > > > multipath
> > > > only
> > > > changes dev_loss_tmo for rports associated with a multipath path
> > > > device.
> > > > 
> > > > -Ben
> > > >  
> 
> Hello Ben,
> 
> Then I believe this rport's with wrong dev_loss_tmo are part of
> multipathd. Is this correct?

yeah, that looks correct. If you run

# multipath -r

does that correct the issue?  If not, can you attach the result of
running

# multipath -rv 3

-Ben

> 
> Best regards,
> 
> Bruno
