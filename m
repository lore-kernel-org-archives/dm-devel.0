From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 05/14] multipathd: check return value of
 malloc in cli_getprkey func
Date: Thu, 10 Sep 2020 18:20:02 +0200
Message-ID: <7e508a1be34a5639711717d9936a121d33eb2b8a.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<4a43f1ca-c756-ed8f-c69d-a388b0911a61@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4a43f1ca-c756-ed8f-c69d-a388b0911a61@huawei.com>
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

On Thu, 2020-09-10 at 18:49 +0800, lixiaokeng wrote:
> In cli_getprkey func, we check the return value of malloc.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
