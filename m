From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [Consult] multipath-tools: will the community accept a
 new vendor specific path group prioritizer in libmultipath/prioritizers
Date: Mon, 11 Dec 2017 20:50:57 +0800
Message-ID: <059786fc-8f63-766f-bab7-ed1c064565e9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: guanjunxiong@huawei.com, "dm-devel@redhat.com" <dm-devel@redhat.com>, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids

Hi Christophe, Hannes, Martin, Xose and Benjamin,

It is beneficial for our customers if we integrate a new path group prioritizer into the multipath-tools.
But this prioritizer is vendor-specific and it only works for Huawei storage system. Will the community
accept such new vendor specific path group prioritizer in libmultipath/prioritizers?

I know that the multipath-tools accepted some vendor specific prioritizer such as emc.c , hp_sw.c, ontap.c and
so on in the libmultipath/prioritizer in 2008~2010 and there were no newer vendor specific prioritizer.
Before I get down to writing a new Huawei prioritizer, I want to hear your thoughts.

If it is convenient for some of you , please let me know your ideas. Thanks.

Best wishes.

Guan Junxiong
