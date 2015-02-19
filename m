From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: raid1 round-robin scheduler
Date: Thu, 19 Feb 2015 16:02:20 +0100
Message-ID: <54E5FAFC.3010800@redhat.com>
References: <54E58F6A.9040108@clodo.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54E58F6A.9040108@clodo.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids



dm-mirror (i.e. "lvcreate --type mirror" or respective "dmsetup create 
--table ...",
which is not the recommended raid1 layout any more) provides read 
round-robin since long time.
You'd need an ancient kernel not to have it supported.

"raid1"/"raid10" (the recommended targets) , i.e. the md-raid based 
mappings accessible via the dm-raid target
do read optimizations as well. Use "lvcreate --type raid1/raid10 ..." or 
a respective dm table to set
those up. The former ("raid1") is the default in modern distributions 
and configurable via setting
'mirror_segtype_default = "raid1"' in /etc/lvm/lvm.conf.

Heinz




On 02/19/2015 08:23 AM, konstantin wrote:
> What version of the kernel should I use to get a round-robin read 
> implementation on LV raid1?
>
