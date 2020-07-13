From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [lvm-devel] master - multipathd: fix fd leak when
 iscsi device logs in
Date: Mon, 13 Jul 2020 11:56:29 +0200
Message-ID: <b482dfdb-a40b-e523-1dcc-d37ddc4fc399@redhat.com>
References: <6eb10725-456f-de68-e927-1f5a9771c16c@huawei.com>
	<86d8307c-1747-2254-4f87-fac36f0d51ca@redhat.com>
	<0d26c9f6-4379-f201-a9a5-839bddef3f25@huawei.com>
	<92db2c49d0ddbbc385c6a14ef3d99a54457b908e.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <92db2c49d0ddbbc385c6a14ef3d99a54457b908e.camel@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong@huawei.com, dm-devel@redhat.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
List-Id: dm-devel.ids

Dne 13. 07. 20 v 11:21 Martin Wilck napsal(a):
> Hi Lixiaokeng,
> 
>
> @Zdenek, do we have to protect every libdm call, or is it sufficient
> to protect only dm_task_run(), as lixiaokeng suggested?
>

Hi

It's actually hard to answer it in a simple way.
Several properties are held in library static variables. So converting libdm
into a fully threaded 'version' would basically require to duplicate all API 
functions with extended 'context' structure passed in - where all buffers can 
be maintained properly (and it's getting more complicated with signal handling 
and debug logging).

ATM it doesn't look like there is a big need for threaded support of DM usage
as majority of tools spends most of their time outside thus 'serialization'
of lvm2 or dmeventd on libdm access look doesn't look like a big issue
(let's say there are far bigger fishes to hunt).

As for the issue of keeping control_fd open - there should be a synchronized 
call of dm_hold_control_dev(0/1) -  see the codebase of  dmeventd.c in lvm2 
code base - how we solve the control_fd handling.

Zdenek
