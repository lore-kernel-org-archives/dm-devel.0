From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 23:01:36 +0200
Message-ID: <1114030896.24817.145.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420205139.GU29071@marowsky-bree.de>
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

On mer, 2005-04-20 at 22:51 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-20T22:39:56, christophe varoqui <christophe.varoqui@free.fr> wrote:
> 
> > Multipathd *never* decides to change a map. All it does is exec
> > multipath, which means two runs of multipath gave 2 differents maps :
> > very bad, but nothing to do with code divergence between daemon and
> > tool.
> 
> But it _always_ happens when multipath is called from multipathd.
> 
> It _never_ happens when multipath is called manually by root.
> 
> It didn't with -pre14, but does with -pre16.
> 
> What could have caused this?
> 
Don't forget the binaries caching in a ramfs.
If you don't restart the daemon, it may still use a WIP multipath
version as a callout.

I'll try and reproduce this at OSDL.

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
