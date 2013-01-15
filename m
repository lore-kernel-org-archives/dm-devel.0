From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: change default configuration
 parameters
Date: Tue, 15 Jan 2013 22:02:45 +0100
Message-ID: <1358283765.3854.1.camel@lapoo.opensvc.com>
References: <20130108053459.GU19059@ether.msp.redhat.com>
	<50EEFB87.1060707@gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50EEFB87.1060707@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On jeu., 2013-01-10 at 18:33 +0100, Xose Vazquez Perez wrote:
> On 01/08/2013 06:34 AM, Benjamin Marzinski wrote:
> 
> > This patch makes multipath devices default to setting fast_io_fail,
> > switches the default selector to service-time and removes the
> > round-robin setting of the builtin device configurations. The goal is
> > to give multipath devices better performance "out of the box".
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.c   |    1 
> >  libmultipath/defaults.h |    2 -
> >  libmultipath/hwtable.c  |   65 ------------------------------------------------
> >  3 files changed, 2 insertions(+), 66 deletions(-)
> 
> These changes should also translate to the multipath.conf.defaults file.

I pushed a patch to resync the multipath.conf.defaults using the
"multipathd show config" output.

Best regards,
Christophe Varoqui
