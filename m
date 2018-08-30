From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] add a cmd to display the topology links
Date: Thu, 30 Aug 2018 19:57:20 +0200
Message-ID: <757a21e2-6d4a-318c-8a7e-c9c23ed015c0@gmail.com>
References: <1533611004-18376-1-git-send-email-guanjunxiong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533611004-18376-1-git-send-email-guanjunxiong@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: guanjunxiong 00401709 <guanjunxiong@huawei.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com
Cc: wangzhoumengjian@huawei.com, dingwenyi@huawei.com, shenhong09@huawei.com, chengjike.cheng@huawei.com
List-Id: dm-devel.ids

On 08/07/2018 05:03 AM, guanjunxiong 00401709 wrote:

> This patch adds a new parameter which named -k to display links information in the multipath command.
> Command 'multipath -k' display paths with the same host wwn and target wwn as one link information.
> The cmd display the following information to quickly and easily find the host and target information.
> [root@localhost mp]# ./multipath -k
> link host_wwnn=0x20000024ff2e8092 host_wwpn=0x21000024ff2e8092 target_wwnn=0x2100333435363738 target_wwpn=0x2201333435363738
> link host_wwnn=0x20000024ff2e8092 host_wwpn=0x21000024ff2e8092 target_wwnn=0x2100333435363738 target_wwpn=0x2211333435363738


This info, in plain text, and a lot more can be extracted from /sys.


There is a tool, systool, to beautify the output:

systool -v -c fc_host
systool -v -c fc_remote_ports
systool -v -c fc_transport
systool -v -c scsi_host
systool -v -c scsi_disk
systool -v -b scsi
systool -v -m lpfc # emulex
systool -v -m qla2xxx # qlogic
