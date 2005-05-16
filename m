From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [Patch] kpartx to accept device map name
Date: Tue, 17 May 2005 00:50:39 +0200
Message-ID: <1116283839.9352.48.camel@zezette>
References: <4288F2B6.9070808@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4288F2B6.9070808@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I applied Kiyoshi"s patch.

Can you elaborate on the problems you see with the asynchronous hotplug
model ?

I would like to express my reluctance to add a devmap special case to
kpartx.

Regards,
cvaroqui

On lun, 2005-05-16 at 15:21 -0400, Jun'ichi Nomura wrote:
> Hello Christophe,
> 
> Attached patch adds '-m' option which makes kpartx
> to accept device map name.
> 
> Using with the cvs version of libdevmapper or with the
> patch suggested by Kiyoshi Ueda today, we don't need
> to depend on asynchronous nature of hotplug when it's
> not necessary.
> 
> For example, we can do this for initialization:
>   multipath
>   dmsetup info -c --noheadings -o name | xargs -l1 kpartx -a -m
> otherwise we had to insert adhoc length of sleep to wait for
> the completion of hotplug events.
> 
> Please consider to apply.
> 
> Thanks,
> Jun'ichi Nomura
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
