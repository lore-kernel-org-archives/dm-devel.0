From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath uxsock patch
Date: Fri, 24 Jun 2005 14:42:22 +0200
Message-ID: <1119616942.1515.180.camel@zezette>
References: <20050624040401.GB14793@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050624040401.GB14793@phlogiston.msp.redhat.com>
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

Thanks, commited.

I also commited a previous patch which tries to add a pthread_cleanup
function. It unfortunately never gets called, and I clearly don't
understand why.

If you happen to have a little experience here, I'd appreciate if you
can look into it.

Regards,

On jeu, 2005-06-23 at 23:04 -0500, Benjamin Marzinski wrote:
> I was playing around with the CLI, and having some issues. Occasionally commands
> wouldn't work, which was because multipathd was using string functions on
> strings that weren't NULL terminated. Also, if you just typed in junk for the
> name of the map to remove, it would always remove dm-0, because atoi returned 0.
> I fixed those, added some moron-proofing checks, and made multipathd reply
> "fail" if the command failed.
> 
> Here's the patch
> 
> -Ben
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
