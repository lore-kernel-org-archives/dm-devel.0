From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 3/5] multipathd: add reclear_pp_from_mpp in
 ev_remove_path
Date: Tue, 18 Aug 2020 18:36:59 +0200
Message-ID: <fb04916036613edb59dfd470c449a1a199cd03ff.camel@suse.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<8fd64929-cb4b-5267-1899-15a82e2ff678@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8fd64929-cb4b-5267-1899-15a82e2ff678@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

On Tue, 2020-08-18 at 21:08 +0800, lixiaokeng wrote:
> Add reclear_pp_from_mpp in ev_remove_path to make sure that pp is
> cleared in mpp.
> 
> When multipathd del path xxx, multipathd -v2, multipathd add path xxx
> and multipath -U
> dm-x are executed simultaneously, multipath -U dm-x will case
> coredump.
> 
> The reason is that there are two paths with same dev_t in dm_table.
> The process
> is as follows:

Thanks for the report.

With which code have you tested this? I have reason to believe that 
it would behave differently with my last patch series (in particular,
part V "removed path handling") applied. I'm not sure if my series
would fix the issue, but it would probably need a different fix.

Regards,
Martin
