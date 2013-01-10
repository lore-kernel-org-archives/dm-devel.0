From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath: change default configuration
	parameters
Date: Thu, 10 Jan 2013 18:33:59 +0100
Message-ID: <50EEFB87.1060707@gmail.com>
References: <20130108053459.GU19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130108053459.GU19059@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 01/08/2013 06:34 AM, Benjamin Marzinski wrote:

> This patch makes multipath devices default to setting fast_io_fail,
> switches the default selector to service-time and removes the
> round-robin setting of the builtin device configurations. The goal is
> to give multipath devices better performance "out of the box".
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c   |    1 
>  libmultipath/defaults.h |    2 -
>  libmultipath/hwtable.c  |   65 ------------------------------------------------
>  3 files changed, 2 insertions(+), 66 deletions(-)

These changes should also translate to the multipath.conf.defaults file.
