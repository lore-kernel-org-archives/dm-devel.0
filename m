From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 01/14] multipathd: initialize major and
 minor in cli_add_map
Date: Thu, 10 Sep 2020 18:18:54 +0200
Message-ID: <87da73ad25a87eca49bcdda86057aaffedb4f689.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<0ce971f0-582e-88dd-0fcd-77edaa6d74ed@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0ce971f0-582e-88dd-0fcd-77edaa6d74ed@huawei.com>
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

On Thu, 2020-09-10 at 18:46 +0800, lixiaokeng wrote:
> If dm_get_major_minor failed, log with major and minor should not
> be printed to avoid major and minor used before initialization.
> 
> Here, we set major and minor to -1 at begining
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
