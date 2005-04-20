From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 16:24:34 +0200
Message-ID: <1114007074.24817.112.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<20050420140408.GX29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420140408.GX29071@marowsky-bree.de>
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

On mer, 2005-04-20 at 16:04 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-20T15:31:17, Lars Marowsky-Bree <lmb@suse.de> wrote:
> 
> > > A lot of fixes flowed in since that proposal.
> > > Now I propose pre16 as a 0.4.4 candidate.
> > > 
> > > Objections still welcome.
> > -pre16 /sbin/multipath doesn't create _any_ mapping for me.
> 
> The change to hwtable.c / config.c no longer can deal with store_hwe()
> not filling in _all_ details.
> 
> It does not differentiate between a parameter being NULL because memory
> couldn't be allocated and a parameter NULL (use default) being passed
> in.
> 
> Replacing the NULL entries with "/bin/false" is a temporary
> workaround...
> 
(*ashamed*) :/

NULL must remain a valid param value.

I'll make sure of that when I regain a SAN access. You can beat me to
it, too :)

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
