From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Forward SECDISCARD request within device mapper layer
Date: Fri, 16 Feb 2018 16:58:47 -0500
Message-ID: <20180216215847.GA9720@redhat.com>
References: <4411521518781080@web43j.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4411521518781080@web43j.yandex.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Semakin <insane79@yandex.ru>
Cc: k-ueda@ct.jp.nec.com, asi@seznam.cz, andmike@linux.vnet.ibm.com, christophe.varoqui@free.fr, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, agk@redhat.com
List-Id: dm-devel.ids

On Fri, Feb 16 2018 at  6:38am -0500,
Dennis Semakin <insane79@yandex.ru> wrote:

> Hello.
> 
> Recently I've submitted the patch https://patchwork.kernel.org/patch/10182691/
> about forwarding SECDISCARD request.
> May I know your thoughts about it? Is it so bad and ugly? Is it so unneeded to provide this request?
> I just want to know your opinion. 
> If it's not applicable then I could re-write it.
> I've successfully tested it for 3.10 and 3.18 kernels.

I'll take a closer look, but it wouldn't go upstream until the 4.17
merge window.

Mike
