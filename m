From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: DM configuration
Date: Wed, 12 Oct 2005 07:16:12 +0200
Message-ID: <1129094172.20114.53.camel@zezette>
References: <20051005134505.GB6195@free.fr>
	<20051006.131418.71083514.k-ueda@ct.jp.nec.com>
	<1128718450.18441.21.camel@zezette>
	<20051011.201745.115903307.k-ueda@ct.jp.nec.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051011.201745.115903307.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


> OK.
> I extended the scope of the "no_path_retry" option to the multipath
> command so that we can phase out the "features" option, because
> the multipath command also sees the "features" option.
> 
> And fixed some bugs of the patch.
>   o Initialization issue of retry_tick.
>   o Missing status update of retry_tick in waiteventloop and reconfigure.
> 
> The new patch is below.
> This patch doesn't change current behavior of multipath command by default.
> The "no_path_option" option overrides the "features" option.
> 
Thanks,

I already merged the previous patch, with a little renaming.
Can you rebase this one on korg git tree ?

Regards,
cvaroqui
