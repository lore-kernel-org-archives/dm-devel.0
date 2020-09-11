From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 11/14] mpathpersist: check whether malloc
 paramp->trnptid_list fails in handle_args func
Date: Fri, 11 Sep 2020 08:29:15 +0200
Message-ID: <fa0924fb650fddb1fbf53226bd79f2c207f1ea0b.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<3f34cd14-17a0-f7a4-6cdb-7a37aa5c31b4@huawei.com>
	<8ecf7f972b83be7fba3797327046c7cedf1179c8.camel@suse.com>
	<aceb50c7-ddf5-b00e-1d05-4294c5650127@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <aceb50c7-ddf5-b00e-1d05-4294c5650127@huawei.com>
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

Hi Lixiaokeng,

On Fri, 2020-09-11 at 09:34 +0800, lixiaokeng wrote:
> 
> Hi Martin,
>   When I compile it, I add a patch thats changes int to unsigned int.
> But I don't think it is an error. It is  just a warning and becomes
> an
> error with [-Werror]. Anyway,

What do you think, why did we add -Werror?

Disabling the warning options when working on the code is strongly
discouraged.

> > I will change int to unsigned it and send
> it again. Thanks.

Thank you.

Martin
