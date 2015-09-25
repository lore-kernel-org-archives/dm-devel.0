From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: v4.3-rc2 dm-mq bug
Date: Fri, 25 Sep 2015 08:37:26 -0700
Message-ID: <56056A36.8060900@sandisk.com>
References: <56044A6E.90900@sandisk.com> <20150924211804.GA16328@redhat.com>
	<20150925003755.GA5984@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150925003755.GA5984@xzibit.linux.bs1.fc.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 09/24/2015 05:42 PM, Junichi Nomura wrote:
> Since __dm_destroy() depends on monotonic decrease of md->holders,
> assertion check of !DMF_FREEING in dm_get() is a valid protection
> from use-after-free.  If we are to remove the check, __dm_destroy()
> should be changed to cope with the situation.
>
> I'm curious why there were pending I/Os after DMF_FEEING set.
> Can this problem be reproducible with non dm-mq setup or older kernels?
> How did you remove the dm device in your testing?

Hello Junichi,

Thanks for stepping in.

Sorry but I do not know whether or not this problem is reproducible 
without dm-mq or with older kernels.

The dm device was removed via the command "dmsetup remove_all".

Bart.
