From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] libmultipath: simplify failed wwid code
Date: Fri, 8 May 2020 19:25:42 +0000
Message-ID: <8de715fa759f8f28bb0e5321201d7f34cdd3ae4e.camel@suse.com>
References: <1588372766-21317-1-git-send-email-bmarzins@redhat.com>
	<55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986.camel@suse.com>
	<20200508163200.GQ5907@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200508163200.GQ5907@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <CABC766099B7B44BA16F5007AA283D4E@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-05-08 at 11:32 -0500, Benjamin Marzinski wrote:
> On Fri, May 08, 2020 at 09:15:32AM +0000, Martin Wilck wrote:
> > 
> > Please consider adding the attached patch on top, which switches
> > back
> > to atomic creation of the failed_wwids file, with just a little bit
> > more compexity. I prefer the creation of the file to be atomic on
> > the
> > file system level. IMO that's how "flag" files like this should be
> > handled in principle, and doing it correctly makes me feel better,
> > even
> > though I have to concur that an actual race is hardly possible.
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Or where you looking for me to respin with this included? Either way
> is
> fine.

Please respin, to have a clean patch set on the ML.

Regards,
Martin
