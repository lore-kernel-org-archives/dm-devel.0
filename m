From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v2 8/9] libmultipath: check_rdac(): pre-check
 in hwtable
Date: Mon, 18 Mar 2019 11:06:22 +0100
Message-ID: <2a0f49b46a2aebebce517b69e9304611964df417.camel@suse.de>
References: <20190315171930.28335-1-mwilck@suse.com>
	<20190315171930.28335-9-mwilck@suse.com>
	<c4c50690-714e-7350-34cd-cab69876c765@suse.com>
	<8aca1a5b7bdb79f369ac3ec395b3f81c4987e488.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8aca1a5b7bdb79f369ac3ec395b3f81c4987e488.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.com>, mwilck+gmail@suse.de
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, dm-devel@redhat.com, Steve.Schremmer@netapp.com
List-Id: dm-devel.ids

On Mon, 2019-03-18 at 10:52 +0100, Martin Wilck wrote:
> On Mon, 2019-03-18 at 08:10 +0100, Hannes Reinecke w
> > *origin? dummy for do_set_from_hwe()?
> > What funky interface is that?
> > 
> > Please redesign do_set_from_hwe() so as _not_ to require 'magic'
> > variables.
> 
> It's the truly "funky" way the macros are written in dict.c :-/
> (Admittedly I wrote that one myself, but I was following the style of
> the file).
> 
> But you're right, I don't like this "dummy" stuff either. As this
> patch
> set is meant as a bug fix and not a major redesign of dict.c, I guess
> I'll rather not use the do_set_from_hwe() macro there. And put the
> redesign on my to-do list.

... I meant propsel.c, of course. Sorry.

Martin
