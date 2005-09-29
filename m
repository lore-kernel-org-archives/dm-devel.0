From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] multipath-tools/kpartx - fix endianes,
	undefined behaviour, cleanup
Date: Fri, 30 Sep 2005 00:19:25 +0200
Message-ID: <1128032365.6536.48.camel@zezette>
References: <20050929124115.GA8988@wavehammer.waldi.eu.org>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050929124115.GA8988@wavehammer.waldi.eu.org>
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

On jeu, 2005-09-29 at 14:41 +0200, Bastian Blank wrote:
> Hi Christophe
> 
> The following patches makes kpartx with dos partitions behave correctly
> on powerpc and makes it a little bit easier to read.
> 
Thanks.
Applied those 3.

Waiting for the dust to settle around the dev_t issue before the next 2
patches.

> 
> ---
> commit 2be146862254c9941cb0754fadd45cb34dd05694
> commit 6399c88650be9835b90bad91a7b6268db8db3303
> commit 1d586d3a1a998b64fa27e61777478d8735d4152a

Regards,
cvaroqui
