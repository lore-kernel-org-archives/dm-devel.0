From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V3 05/14] multipathd: use MALLOC and check
 return value in cli_getprkey func
Date: Tue, 08 Sep 2020 16:32:28 +0200
Message-ID: <ca471cce2d6801dde59fd9d8e8d191f3b89ef407.camel@suse.com>
References: <2fb59aa1-eafa-49b6-08aa-a279565ec234@huawei.com>
	<fd8cdf1e-3a56-e904-21e1-eb6258f78d79@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fd8cdf1e-3a56-e904-21e1-eb6258f78d79@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Tue, 2020-09-08 at 16:49 +0800, lixiaokeng wrote:
> In cli_getprkey func, we use MALLOC instead of malloc, and check
> the return value of MALLOC.
> 
> V1->V2: turn back MALLOC to malloc and reomve error message

Ok, but now you need to change the patch subject as well...

Also, please don't include v1->v2 changes in the commit message itself.
Once this is committed, it's not interesting how it differs from
earlier versions of the patch. Put it below the "---" marker,
or just mention the version history in the cover letter.

Please see
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html

Regards,
Martin
