From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v4 02/19] libmultipath: fix tur checker
	double locking
Date: Wed, 10 Oct 2018 09:08:09 +0200
Message-ID: <e00d536f4958723d40b82b8e75590115fc1606e7.camel@suse.de>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
	<1539126196-28926-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-3-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-10-09 at 18:02 -0500, Benjamin Marzinski wrote:
> tur_devt() locks ct->lock. However, it is ocassionally called while
> ct->lock is already locked. In reality, there is no reason why we
> need
> to lock all the accesses to ct->devt. The tur checker only needs to
> write to this variable one time, when it first gets the file
> descripter
> that it is checking. This patch sets ct->devt in libcheck_init() when
> it
> is first initializing the checker context. After that, ct->devt is
> only
> ever read.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
