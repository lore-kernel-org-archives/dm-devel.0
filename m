From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Thu, 21 Apr 2005 00:49:11 +0200
Message-ID: <1114037351.24817.176.camel@zezette>
References: <1114006824.24817.108.camel@zezette>
	<20050420201249.GS29071@marowsky-bree.de>
	<1114029597.24817.138.camel@zezette>
	<20050420205139.GU29071@marowsky-bree.de>
	<1114030896.24817.145.camel@zezette>
	<20050420211000.GW29071@marowsky-bree.de>
	<1114033119.24817.161.camel@zezette>
	<20050420215213.GY29071@marowsky-bree.de>
	<1114034685.24817.165.camel@zezette>
	<1114035053.24817.168.camel@zezette>
	<20050420224058.GA29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420224058.GA29071@marowsky-bree.de>
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

On jeu, 2005-04-21 at 00:40 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-21T00:10:52, christophe varoqui <christophe.varoqui@free.fr> wrote:
> 
> > In the mean time, you should check why your prio callout always errors
> > when run from multipathd. One obvious reason would be that the callout
> > was not copied into the ramfs ...
> 
> How can I check that? I don't see any ramfs/shmfs in mount, and
> multipathd also doesn't log anything about it.
> 
"multipathd -v3" will log what files it copies into the ramfs.

You don't see it in "mount" because its in a private namespace, but you
should see it listed in /proc/$(pidof multipathd)/mounts ... though it
won't help you see its content :/

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
