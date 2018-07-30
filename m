From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] multipath-tools: check for C compiler
 option -Werror=discarded-qualifiers
Date: Mon, 30 Jul 2018 20:00:21 +0000
Message-ID: <ffde2ed386002cab3eebb2110f047a147a2d6b1e.camel@wdc.com>
References: <20180730193745.21775-1-mfo@canonical.com>
	<20180730193745.21775-3-mfo@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180730193745.21775-3-mfo@canonical.com>
Content-Language: en-US
Content-ID: <9E7BC37164D7484684DCDF9B70B5FB40@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mfo@canonical.com" <mfo@canonical.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2018-07-30 at 16:37 -0300, Mauricio Faria de Oliveira wrote:
> The -Werror=discarded-qualifiers option is not supported on GCC 4.8
> (ships in Ubuntu 14.04 at least). Use TEST_CC_OPTION to detect that
> and fix a build failure.

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
