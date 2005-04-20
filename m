From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Thu, 21 Apr 2005 00:10:52 +0200
Message-ID: <1114035053.24817.168.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
	<1114030896.24817.145.camel@zezette>
	<20050420211000.GW29071@marowsky-bree.de>
	<1114033119.24817.161.camel@zezette>
	<20050420215213.GY29071@marowsky-bree.de>
	<1114034685.24817.165.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1114034685.24817.165.camel@zezette>
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

On jeu, 2005-04-21 at 00:04 +0200, christophe varoqui wrote:
> On mer, 2005-04-20 at 23:52 +0200, Lars Marowsky-Bree wrote:
> > On 2005-04-20T23:38:39, christophe varoqui <christophe.varoqui@free.fr> wrote:
> > 
> > > I can't reproduce that at OSDL :
> > > 
> > > * no config file
> > > * IBM 3542 (tur/group_by_serial/no hwh/no feature)
> > > * mp-tools 0.4.4-pre17
> > 
> > That means you're not using a priority callout, which is what the bug is
> > about, right?
> > 
> > Anyway, I'll try -pre17 (or maybe -pre18 by then ;-) tomorrow.
> > 
> oh, so you use the group_by_prio pgpolicy ?
> Indeed, the fallback prio to 1 is annoying in that scenario.
> 
> I'll see how to propagate the error to prevent a map reloading in case
> of prio callout error.
> 
In the mean time, you should check why your prio callout always errors
when run from multipathd. One obvious reason would be that the callout
was not copied into the ramfs ...

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
