From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 12/14] libmultipathpersist: use
 update_multipath_table/status, in get_mpvec
Date: Thu, 10 Sep 2020 20:45:10 +0200
Message-ID: <88423b3abc494756f96313036a72604707118053.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<29dcdbb2-8154-cb13-a48e-1379200a6814@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <29dcdbb2-8154-cb13-a48e-1379200a6814@huawei.com>
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

On Thu, 2020-09-10 at 18:53 +0800, lixiaokeng wrote:
> The return values of dm_get_map, disassemble_map in get_mpvec
> were not checked. Use update_multipath_table/status to instead
> of them. If these function fail, call remove_map
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
