From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm mpath: fix passing integrity data
Date: Wed, 14 Mar 2018 11:46:21 -0400
Message-ID: <yq14llid5iq.fsf@oracle.com>
References: <20180314143306.98405-1-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180314143306.98405-1-maier@linux.vnet.ibm.com> (Steffen
	Maier's message of "Wed, 14 Mar 2018 15:33:06 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-s390@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Mike Snitzer <snitzer@redhat.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Fedor Loshakov <loshakov@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: dm-devel.ids


Steffen,

> After v4.12 commit e2460f2a4bc7 ("dm: mark targets that pass integrity
> data"), dm-multipath, e.g. on DIF+DIX SCSI disk paths, does not support
> block integrity any more. So add it to the whitelist.

Ugh.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
