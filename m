From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 14/16] libmutipath: deprecate delay_*_checks
Date: Fri, 16 Aug 2019 21:51:36 +0000
Message-ID: <0e8350a968aa3fdfeeaa41bc4aaafcea26d238c2.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-15-git-send-email-bmarzins@redhat.com>
	<af2c96e14df9aad64dbeded65e6e0c02c9ff45cf.camel@suse.com>
	<20190816204734.GG25414@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190816204734.GG25414@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <4F9E3684A610D1499603181ED3AB2454@namprd18.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-16 at 15:47 -0500, Benjamin Marzinski wrote:
> 
> Err.. This patch does do the remapping in code (in propsel.c) just as
> you suggest..  right?

I'm truly sorry. It was late when I looked at this patch, and obviously
I got it all wrong.

So, I almost ACK this patch; but I'd like to simplify the logic by
using the delay_* parameters only if _none_ of the san_path_ parameters
have been set by the user (and also, of course, if no marginal_path
parameters have been set); similar to the logic of c8775cf "multipathd:
marginal_path overrides san_path_err". 

Users should IMO not be able to mix these parameters.

Cheers,
Martin
